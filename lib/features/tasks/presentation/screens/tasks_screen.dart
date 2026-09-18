import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/tasks/presentation/widgets/task_filter.dart';
import '../../data/static_tasks_data.dart';
import '../../domain/models/task_models.dart';
import '../../../../core/design_system/widgets/empty_view/empty_view.dart';
import '../widgets/task_card.dart';
import '../widgets/custom_widgets/task_updown_sheet.dart';

class TasksScreen extends StatelessWidget {
  TasksScreen({super.key})
    : _currentFilter = ValueNotifier(TaskFilter.all),
      _filteredTasks = ValueNotifier(
        StaticTasksData.getTasksByFilter(TaskFilter.all),
      );

  final ValueNotifier<TaskFilter> _currentFilter;
  final ValueNotifier<List<Task>> _filteredTasks;

  void _selectFilter(TaskFilter filter) {
    _currentFilter.value = filter;
    _filteredTasks.value = StaticTasksData.getTasksByFilter(filter);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TaskFilter>(
      valueListenable: _currentFilter,
      builder: (context, currentFilter, _) {
        return ValueListenableBuilder<List<Task>>(
          valueListenable: _filteredTasks,
          builder: (context, filteredTasks, _) {
            return Scaffold(
              backgroundColor: AppColors.onPrimary,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        context.l10n.tasks,
                        style: AppTextStyles.headlineMedium,
                      ),
                      Gap(4.h),
                      AppText(
                        context.l10n.trackAssignments,
                        style: AppTextStyles.bodyMedium,
                      ),
                      Gap(20.h),
                      TaskFilterBar(
                        selected: currentFilter,
                        onSelected: _selectFilter,
                      ),
                      Gap(16.h),
                      Expanded(
                        child: filteredTasks.isEmpty
                            ? const EmptyView()
                            : RefreshIndicator(
                                onRefresh: () async {
                                  _filteredTasks.value =
                                      StaticTasksData.getTasksByFilter(
                                        currentFilter,
                                      );
                                },
                                child: ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: filteredTasks.length,
                                  itemBuilder: (context, index) => TaskCard(
                                    task: filteredTasks[index],
                                    onTap: () => _openTask(
                                      context,
                                      filteredTasks[index],
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openTask(BuildContext context, Task task) {
    TaskUpdownSheet.show(
      context: context,
      task: task,
      onSubmitted: () {
        _filteredTasks.value = StaticTasksData.getTasksByFilter(
          _currentFilter.value,
        );
      },
    );
  }
}
