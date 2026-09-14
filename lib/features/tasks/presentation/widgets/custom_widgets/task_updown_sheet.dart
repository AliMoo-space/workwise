import 'package:flutter/material.dart';
import '../../../domain/models/task_models.dart';
import '../../screens/task_submission_screen.dart';

class TaskUpdownSheet extends StatelessWidget {
  const TaskUpdownSheet({super.key, required this.task, this.onSubmitted});

  final Task task;
  final VoidCallback? onSubmitted;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.92,
      child: TaskSubmissionScreen(task: task, onSubmitted: onSubmitted),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required Task task,
    VoidCallback? onSubmitted,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (_) => TaskUpdownSheet(task: task, onSubmitted: onSubmitted),
    );
  }
}
