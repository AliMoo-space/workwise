// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gap/gap.dart';

// import 'package:workwise/core/design_system/spacing/app_spacing.dart';
// import 'package:workwise/core/design_system/widgets/feedback/app_error_state.dart';
// import 'package:workwise/core/design_system/widgets/feedback/app_snack_bar.dart';
// import 'package:workwise/core/services/service_locator.dart';
// import 'package:workwise/core/storage/local_storage.dart';

// import 'package:workwise/features/AIAssistant/presentation/cubit/career_coach_cubit.dart';
// import 'package:workwise/features/AIAssistant/presentation/cubit/career_coach_state.dart';
// import 'package:workwise/features/AIAssistant/presentation/widget/action_plan_card.dart';
// import 'package:workwise/features/AIAssistant/presentation/widget/action_plan_title.dart';
// import 'package:workwise/features/AIAssistant/presentation/widget/development_area_card.dart';
// import 'package:workwise/features/AIAssistant/presentation/widget/development_areas_title.dart';
// import 'package:workwise/features/AIAssistant/presentation/widget/strength_card.dart';
// import 'package:workwise/features/AIAssistant/presentation/widget/strengths_title.dart';

// class CareerCoach extends StatelessWidget {
//   const CareerCoach({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final employeeId = sl<LocalStorage>().getEmployeeCode();

//     return BlocProvider(
//       create: (_) =>
//           sl<CareerCoachCubit>()
//             ..getCareerCoachData({'employee_id': employeeId}),
//       child: Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         body: SafeArea(
//           child: BlocListener<CareerCoachCubit, CareerCoachState>(
//             listener: (context, state) {
//               if (state is CareerCoachFailure) {
//                 AppSnackBar.error(context, message: state.message);
//               }
//             },
//             child: BlocBuilder<CareerCoachCubit, CareerCoachState>(
//               builder: (context, state) {
//                 if (state is CareerCoachFailure) {
//                   return AppErrorState(
//                     message: state.message,
//                     onRetry: () {
//                       context.read<CareerCoachCubit>().getCareerCoachData({
//                         'employee_id': employeeId,
//                       });
//                     },
//                   );
//                 }

//                 if (state is CareerCoachLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (state is CareerCoachSuccess) {
//                   final careerCoach = state.careerCoach;

//                   return SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.all(AppSpacing.space16),
//                       child: Column(
//                         children: [
//                           const StrengthsTitle(),

//                           const Gap(AppSpacing.space12),

//                           ...careerCoach.strengths.map(
//                             (strength) => Padding(
//                               padding: const EdgeInsets.only(
//                                 bottom: AppSpacing.space12,
//                               ),
//                               child: StrengthCard(strength: strength),
//                             ),
//                           ),

//                           const Gap(AppSpacing.space8),

//                           const DevelopmentAreasTitle(),

//                           const Gap(AppSpacing.space12),

//                           ...careerCoach.developmentAreas.map(
//                             (developmentArea) => Padding(
//                               padding: const EdgeInsets.only(
//                                 bottom: AppSpacing.space12,
//                               ),
//                               child: DevelopmentAreaCard(
//                                 developmentArea: developmentArea,
//                               ),
//                             ),
//                           ),

//                           const Gap(AppSpacing.space8),

//                           const ActionPlanTitle(),

//                           const Gap(AppSpacing.space12),
//                           ...careerCoach.developmentPlan.asMap().entries.map(
//                             (entry) => Padding(
//                               padding: const EdgeInsets.only(
//                                 bottom: AppSpacing.space12,
//                               ),
//                               child: ActionPlanCard(
//                                 plan: entry.value,
//                                 index: entry.key,
//                               ),
//                             ),
//                           ),

//                           const Gap(AppSpacing.space8),
//                         ],
//                       ),
//                     ),
//                   );
//                 }

//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_error_state.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_snack_bar.dart';
import 'package:workwise/core/services/service_locator.dart';
import 'package:workwise/core/storage/local_storage.dart';

import 'package:workwise/features/AIAssistant/presentation/cubit/career_coach_cubit.dart';
import 'package:workwise/features/AIAssistant/presentation/cubit/career_coach_state.dart';
import 'package:workwise/features/AIAssistant/presentation/widget/action_plan_card.dart';
import 'package:workwise/features/AIAssistant/presentation/widget/action_plan_title.dart';
import 'package:workwise/features/AIAssistant/presentation/widget/career_coach_loading_view.dart';
import 'package:workwise/features/AIAssistant/presentation/widget/development_area_card.dart';
import 'package:workwise/features/AIAssistant/presentation/widget/development_areas_title.dart';
import 'package:workwise/features/AIAssistant/presentation/widget/strength_card.dart';
import 'package:workwise/features/AIAssistant/presentation/widget/strengths_title.dart';

class CareerCoach extends StatelessWidget {
  const CareerCoach({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeId = sl<LocalStorage>().getEmployeeCode();

    return BlocProvider(
      create: (_) =>
          sl<CareerCoachCubit>()
            ..getCareerCoachData({'employee_id': employeeId}),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: BlocListener<CareerCoachCubit, CareerCoachState>(
            listener: (context, state) {
              if (state is CareerCoachFailure) {
                AppSnackBar.error(context, message: state.message);
              }
            },
            child: BlocBuilder<CareerCoachCubit, CareerCoachState>(
              builder: (context, state) {
                if (state is CareerCoachFailure) {
                  return AppErrorState(
                    message: state.message,
                    onRetry: () {
                      context.read<CareerCoachCubit>().getCareerCoachData({
                        'employee_id': employeeId,
                      });
                    },
                  );
                }

                if (state is CareerCoachLoading) {
                  return const CareerCoachShimmer();
                }

                if (state is CareerCoachSuccess) {
                  final careerCoach = state.careerCoach;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const StrengthsTitle(),

                        const Gap(AppSpacing.space12),

                        ...careerCoach.strengths.map(
                          (strength) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.space12,
                            ),
                            child: StrengthCard(strength: strength),
                          ),
                        ),

                        const Gap(AppSpacing.space8),

                        const DevelopmentAreasTitle(),

                        const Gap(AppSpacing.space12),

                        ...careerCoach.developmentAreas.map(
                          (developmentArea) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.space12,
                            ),
                            child: DevelopmentAreaCard(
                              developmentArea: developmentArea,
                            ),
                          ),
                        ),

                        const Gap(AppSpacing.space8),

                        const ActionPlanTitle(),

                        const Gap(AppSpacing.space12),

                        ...careerCoach.developmentPlan.asMap().entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.space12,
                            ),
                            child: ActionPlanCard(
                              plan: entry.value,
                              index: entry.key,
                            ),
                          ),
                        ),

                        const Gap(AppSpacing.space8),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
