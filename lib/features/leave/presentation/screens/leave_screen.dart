// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const LeaveTitle(),

                const LeaveSubtitle(),

                const Gap(15),

                const LeaveBalancesCard(),

                const Gap(10),

                const RequestLeaveTitle(),

                const Gap(10),

                const LeaveRequestForm(),

                const Gap(15),

                const LeaveHistoryTitle(),

                const Gap(5),

                const LeaveHistoryList(),

                const Gap(10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
