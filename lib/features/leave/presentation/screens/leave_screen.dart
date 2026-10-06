import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_error_state.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_snack_bar.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/services/service_locator.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_balances/leave_balances_cubit.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_balances/leave_balances_state.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_history/leave_history_cubit.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_history/leave_history_state.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_request/leave_request_cubit.dart';
import 'package:workwise/features/leave/presentation/widget/leave_balances_card.dart';
import 'package:workwise/features/leave/presentation/widget/leave_history_list.dart';
import 'package:workwise/features/leave/presentation/widget/leave_history_title.dart';
import 'package:workwise/features/leave/presentation/widget/leave_loading_view.dart';
import 'package:workwise/features/leave/presentation/widget/leave_request_form.dart';
import 'package:workwise/features/leave/presentation/widget/leave_subtitle.dart';
import 'package:workwise/features/leave/presentation/widget/leave_title.dart';
import 'package:workwise/features/leave/presentation/widget/request_leave_title.dart';

class Leavescreen extends StatelessWidget {
  const Leavescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<LeaveBalancesCubit>()..getLeaveBalances(),
        ),
        BlocProvider(create: (_) => sl<LeaveHistoryCubit>()..getLeaveHistory()),
        BlocProvider(create: (_) => sl<LeaveRequestCubit>()),
      ],
      child: SafeArea(
        bottom: false,
        child: MultiBlocListener(
          listeners: [
            // Leave Balances Error
            BlocListener<LeaveBalancesCubit, LeaveBalancesState>(
              listener: (context, state) {
                if (state is LeaveBalancesFailure) {
                  AppSnackBar.error(context, message: state.message);
                }
              },
            ),

            // Leave History Error
            BlocListener<LeaveHistoryCubit, LeaveHistoryState>(
              listener: (context, state) {
                if (state is LeaveHistoryFailure) {
                  AppSnackBar.error(context, message: state.message);
                }
              },
            ),
          ],
          child: BlocBuilder<LeaveBalancesCubit, LeaveBalancesState>(
            builder: (context, balancesState) {
              // Balances Loading

              if (balancesState is LeaveBalancesLoading) {
                return LeaveLoadingView.build(context);
              }

              // Balances Failure

              if (balancesState is LeaveBalancesFailure) {
                return AppErrorState(
                  message: balancesState.message,
                  onRetry: () {
                    context.read<LeaveBalancesCubit>().getLeaveBalances();

                    context.read<LeaveHistoryCubit>().getLeaveHistory();
                  },
                );
              }

              // Balances Success

              if (balancesState is LeaveBalancesSuccess) {
                final balances = balancesState.balances;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.space16),
                    child: Column(
                      children: [
                        const LeaveTitle(),

                        const LeaveSubtitle(),

                        const Gap(AppSpacing.space16),

                        // Leave Balances
                        SizedBox(
                          height: 160,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: balances.length,
                            separatorBuilder: (_, __) {
                              return const Gap(AppSpacing.space8);
                            },
                            itemBuilder: (context, index) {
                              return LeaveBalancesCard(
                                balance: balances[index],
                              );
                            },
                          ),
                        ),

                        const Gap(AppSpacing.space8),

                        // Leave Request
                        const RequestLeaveTitle(),

                        const Gap(AppSpacing.space8),

                        const LeaveRequestForm(),

                        const Gap(AppSpacing.space16),

                        // Leave History
                        const LeaveHistoryTitle(),

                        const Gap(AppSpacing.space4),

                        BlocBuilder<LeaveHistoryCubit, LeaveHistoryState>(
                          builder: (context, historyState) {
                            // History Loading

                            if (historyState is LeaveHistoryInitial ||
                                historyState is LeaveHistoryLoading) {
                              return const SizedBox.shrink();
                            }

                            // History Failure

                            if (historyState is LeaveHistoryFailure) {
                              return AppErrorState(
                                message: historyState.message,
                                onRetry: () {
                                  context
                                      .read<LeaveHistoryCubit>()
                                      .getLeaveHistory();
                                },
                              );
                            }

                            // History Success

                            if (historyState is LeaveHistorySuccess) {
                              final leaveHistory =
                                  [...historyState.leaveRequests]..sort((a, b) {
                                    final dateA = DateTime.tryParse(
                                      a.createdAt,
                                    );
                                    final dateB = DateTime.tryParse(
                                      b.createdAt,
                                    );

                                    if (dateA == null && dateB == null) {
                                      return 0;
                                    }

                                    if (dateA == null) {
                                      return 1;
                                    }

                                    if (dateB == null) {
                                      return -1;
                                    }

                                    return dateB.compareTo(dateA);
                                  });

                              if (leaveHistory.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return LeaveHistoryList(
                                leaveHistory: leaveHistory.take(2).toList(),
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),

                        const Gap(AppSpacing.space8),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
