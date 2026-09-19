import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/services/service_locator.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_balances/leave_balances_cubit.dart';
import 'package:workwise/features/leave/presentation/cubit/leave_history/leave_history_cubit.dart';
import 'package:workwise/features/leave/presentation/widget/leave_balances_card.dart';
import 'package:workwise/features/leave/presentation/widget/leave_history_list.dart';
import 'package:workwise/features/leave/presentation/widget/leave_history_title.dart';
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
        BlocProvider(create: (_) => sl<LeaveBalancesCubit>()..getBalances()),
        BlocProvider(create: (_) => sl<LeaveHistoryCubit>()..getHistory()),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const LeaveTitle(),

                  const LeaveSubtitle(),

                  const Gap(AppSpacing.space16),

                  const LeaveBalancesCard(),

                  const Gap(AppSpacing.space8),

                  const RequestLeaveTitle(),

                  const Gap(AppSpacing.space8),

                  const LeaveRequestForm(),

                  const Gap(AppSpacing.space16),

                  const LeaveHistoryTitle(),

                  const Gap(AppSpacing.space4),

                  const LeaveHistoryList(),

                  const Gap(AppSpacing.space8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
