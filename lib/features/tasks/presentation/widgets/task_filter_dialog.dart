import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/features/tasks/presentation/cubit/tasks_cubit.dart';

class TaskFilterDialog extends StatefulWidget {
  const TaskFilterDialog({super.key});

  @override
  State<TaskFilterDialog> createState() => _TaskFilterDialogState();
}

class _TaskFilterDialogState extends State<TaskFilterDialog> {
  String? selectedStatus;
  String? selectedPriority;
  DateTime? deadlineFrom;
  DateTime? deadlineTo;

  final List<String> statuses = ['In Progress', 'Under Review', 'Completed'];
  final List<String> priorities = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Tasks'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: statuses.map((status) {
                return ChoiceChip(
                  label: Text(status),
                  selected: selectedStatus == status,
                  onSelected: (selected) {
                    setState(() {
                      selectedStatus = selected ? status : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Priority', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: priorities.map((priority) {
                return ChoiceChip(
                  label: Text(priority),
                  selected: selectedPriority == priority,
                  onSelected: (selected) {
                    setState(() {
                      selectedPriority = selected ? priority : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Deadline Range', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: deadlineFrom ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        setState(() => deadlineFrom = date);
                      }
                    },
                    child: Text(
                      deadlineFrom != null
                          ? '${deadlineFrom!.year}-${deadlineFrom!.month.toString().padLeft(2, '0')}-${deadlineFrom!.day.toString().padLeft(2, '0')}'
                          : 'From',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: deadlineTo ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        setState(() => deadlineTo = date);
                      }
                    },
                    child: Text(
                      deadlineTo != null
                          ? '${deadlineTo!.year}-${deadlineTo!.month.toString().padLeft(2, '0')}-${deadlineTo!.day.toString().padLeft(2, '0')}'
                          : 'To',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              selectedStatus = null;
              selectedPriority = null;
              deadlineFrom = null;
              deadlineTo = null;
            });
          },
          child: const Text('Clear'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<TasksCubit>().applyFilters(
              lang: 'en',
              status: selectedStatus,
              priority: selectedPriority,
              deadlineFrom: deadlineFrom != null
                  ? '${deadlineFrom!.year}-${deadlineFrom!.month.toString().padLeft(2, '0')}-${deadlineFrom!.day.toString().padLeft(2, '0')}'
                  : null,
              deadlineTo: deadlineTo != null
                  ? '${deadlineTo!.year}-${deadlineTo!.month.toString().padLeft(2, '0')}-${deadlineTo!.day.toString().padLeft(2, '0')}'
                  : null,
            );
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
