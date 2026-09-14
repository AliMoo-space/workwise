import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/feedback/app_loader.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/features/tasks/presentation/widgets/task_filter.dart';
import 'package:workwise/generated/app_localizations.dart';
import '../../data/static_tasks_data.dart';
import '../../domain/models/task_models.dart';
import '../../../../core/design_system/widgets/empty_view/empty_view.dart';
import '../widgets/task_card.dart';
import '../widgets/custom_widgets/task_updown_sheet.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TaskFilter _currentFilter = TaskFilter.all;
  List<Task> _filteredTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _filteredTasks = StaticTasksData.getTasksByFilter(_currentFilter);
      _isLoading = false;
    });
  }

  void _selectFilter(TaskFilter filter) {
    setState(() {
      _currentFilter = filter;
      _filteredTasks = StaticTasksData.getTasksByFilter(filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.onPrimary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(l10n.tasks, style: AppTextStyles.headlineMedium),
              Gap(4.h),
              AppText(l10n.trackAssignments, style: AppTextStyles.bodyMedium),
              Gap(20.h),
              TaskFilterBar(
                selected: _currentFilter,
                onSelected: _selectFilter,
              ),
              Gap(16.h),
              Expanded(
                child: _isLoading
                    ? const Center(child: AppLoader.large())
                    : _filteredTasks.isEmpty
                    ? const EmptyView()
                    : RefreshIndicator(
                        onRefresh: _loadTasks,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _filteredTasks.length,
                          itemBuilder: (context, index) => TaskCard(
                            task: _filteredTasks[index],
                            onTap: () => _openTask(_filteredTasks[index]),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openTask(Task task) {
    TaskUpdownSheet.show(
      context: context,
      task: task,
      onSubmitted: () {
        setState(() {
          _filteredTasks = StaticTasksData.getTasksByFilter(_currentFilter);
        });
      },
    );
  }
}
