import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_snack_bar.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_text_field.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/services/service_locator.dart';
import 'package:workwise/features/AIAssistant/data/models/chat_message.dart';
import 'package:workwise/features/AIAssistant/domain/usecases/ask_policy_question_use_case.dart';
import 'package:workwise/features/AIAssistant/presentation/cubit/chat_policy/policy_assistant_cubit.dart';
import 'package:workwise/features/AIAssistant/presentation/cubit/chat_policy/policy_assistant_state.dart';

class PolicyAssistant extends StatelessWidget {
  const PolicyAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => PolicyAssistantCubit(
        askPolicyQuestionUseCase: sl<AskPolicyQuestionUseCase>(),
        welcomeMessage: l10n.policyAssistantWelcome,
        employeeIdNotAvailableMessage: l10n.employeeIdNotAvailable,
        noAnswerMessage: l10n.policyAssistantNoAnswer,
        unexpectedErrorMessage: l10n.policyAssistantUnexpectedError,
      )..loadMessages(),
      child: const PolicyAssistantView(),
    );
  }
}

class PolicyAssistantView extends StatelessWidget {
  const PolicyAssistantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onError,
      body: SafeArea(
        child: BlocConsumer<PolicyAssistantCubit, PolicyAssistantState>(
          listener: (context, state) {
            if (state is PolicyAssistantFailure) {
              AppSnackBar.error(context, message: state.message);
            }
          },
          builder: (context, state) {
            final cubit = context.read<PolicyAssistantCubit>();

            if (state.isRestoringMessages) {
              return const Center(child: CircularProgressIndicator());
            }

            final messages = state.messages;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: false,
                    padding: EdgeInsets.only(
                      left: AppSpacing.space16.w,
                      right: AppSpacing.space16.w,
                      top: 0,
                      bottom: AppSpacing.space8.h,
                    ),
                    itemCount: messages.length + (state.isSending ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (state.isSending && index == messages.length) {
                        return Padding(
                          padding: EdgeInsets.only(top: AppSpacing.space12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppCard(
                                padding: EdgeInsets.all(AppSpacing.space4.r),
                                height: 25.h,
                                width: 25.w,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.outlineVariant,
                                borderRadius: AppRadius.radius8.r,
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: 0,
                                ),
                                boxShadow: const [],
                                child: Icon(
                                  Icons.smart_toy_outlined,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Gap(AppSpacing.space8.w),
                              Expanded(
                                child: AppCard(
                                  padding: EdgeInsets.all(AppSpacing.space16.r),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onError,
                                  borderRadius: AppRadius.radius16.r,
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
                                  ),
                                  boxShadow: const [],
                                  child: AppText(
                                    context.l10n.policyAssistantThinking,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final ChatMessage message = messages[index];

                      if (message.isUser) {
                        return GestureDetector(
                          onLongPress: message.failed
                              ? () async {
                                  final shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (dialogContext) {
                                      return AlertDialog(
                                        title: Text(
                                          context.l10n.deleteMessageTitle,
                                        ),
                                        content: Text(
                                          context
                                              .l10n
                                              .deleteFailedMessageConfirmation,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(
                                                dialogContext,
                                              ).pop(false);
                                            },
                                            child: Text(context.l10n.cancel),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(
                                                dialogContext,
                                              ).pop(true);
                                            },
                                            child: Text(
                                              context.l10n.delete,
                                              style: const TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (shouldDelete == true && context.mounted) {
                                    await cubit.deleteMessage(index);
                                  }
                                }
                              : null,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: index == 0 ? 0 : AppSpacing.space12.h,
                            ),
                            child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AppCard(
                                    padding: EdgeInsets.all(
                                      AppSpacing.space16.r,
                                    ),
                                    margin: EdgeInsets.zero,
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.73,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    borderRadius: AppRadius.radius16.r,
                                    border: Border.all(
                                      color: message.failed
                                          ? Colors.red
                                          : Theme.of(
                                              context,
                                            ).colorScheme.outlineVariant,
                                      width: message.failed ? 1.5 : 1,
                                    ),
                                    boxShadow: const [],
                                    child: AppText(
                                      message.text,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onError,
                                    ),
                                  ),
                                  if (message.failed) ...[
                                    Gap(AppSpacing.space4.h),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                        Gap(AppSpacing.space4.w),
                                        Text(
                                          context
                                              .l10n
                                              .policyMessageNotSentLongPress,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: EdgeInsets.only(
                          top: index == 0 ? 0 : AppSpacing.space12.h,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppCard(
                              padding: EdgeInsets.all(AppSpacing.space4.r),
                              height: 25.h,
                              width: 25.w,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                              borderRadius: AppRadius.radius8.r,
                              border: Border.all(
                                color: Colors.transparent,
                                width: 0,
                              ),
                              boxShadow: const [],
                              child: Icon(
                                Icons.smart_toy_outlined,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Gap(AppSpacing.space8.w),
                            Expanded(
                              child: AppCard(
                                padding: EdgeInsets.all(AppSpacing.space16.r),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.onError,
                                borderRadius: AppRadius.radius16.r,
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant,
                                ),
                                boxShadow: const [],
                                child: AppText(message.text),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Gap(AppSpacing.space8.h),
                AppCard(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.space16.w,
                    vertical: AppSpacing.space12.h,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.onError,
                  borderRadius: AppRadius.radius8.r,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  boxShadow: const [],
                  child: Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: cubit.messageController,
                          hintText: context.l10n.askAboutPolicyOrBalance,
                          fillColor: Theme.of(context).colorScheme.surface,
                          borderRadius: AppRadius.radius24.r,
                          onSubmitted: (_) {
                            if (!state.isSending) {
                              cubit.sendCurrentMessage();
                            }
                          },
                        ),
                      ),
                      Gap(AppSpacing.space8.w),
                      AppCard(
                        padding: EdgeInsets.zero,
                        width: 48.w,
                        height: 48.h,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        borderRadius: AppRadius.radius24.r,
                        border: Border.all(color: Colors.transparent, width: 0),
                        boxShadow: const [],
                        child: IconButton(
                          onPressed: state.isSending
                              ? null
                              : cubit.sendCurrentMessage,
                          tooltip: context.l10n.sendMessage,
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context).colorScheme.onError,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
