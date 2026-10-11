import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/services/service_locator.dart';
import 'package:workwise/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:workwise/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:workwise/features/tasks/presentation/widgets/task_filter.dart';
import '../../domain/models/task_models.dart';
import '../../../../core/design_system/widgets/empty_view/empty_view.dart';
import '../widgets/task_card.dart';
import '../widgets/custom_widgets/task_updown_sheet.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TasksCubit>()..getTasks(lang: 'en'),
      child: const _TasksScreenContent(),
    );
  }
}

class _TasksScreenContent extends StatefulWidget {
  const _TasksScreenContent();

  @override
  State<_TasksScreenContent> createState() => _TasksScreenContentState();
}

class _TasksScreenContentState extends State<_TasksScreenContent> {
  TaskFilter _currentFilter = TaskFilter.all;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<TasksCubit>().loadMore();
    }
  }

  void _selectFilter(TaskFilter filter) {
    setState(() => _currentFilter = filter);
    
    String? status;
    switch (filter) {
      case TaskFilter.inProgress:
        status = 'In Progress';
        break;
      case TaskFilter.underReview:
        status = 'Pending'; // API uses "Pending" not "Under Review"
        break;
      case TaskFilter.completed:
        status = 'Completed';
        break;
      case TaskFilter.all:
        status = null;
        break;
    }
    
    context.read<TasksCubit>().applyFilters(lang: 'en', status: status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onPrimary,
      body: SafeArea(
        bottom: false,
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
                selected: _currentFilter,
                onSelected: _selectFilter,
              ),
              Gap(16.h),
              Expanded(
                child: BlocBuilder<TasksCubit, TasksState>(
                  builder: (context, state) {
                    if (state is TasksLoading && state is! TasksLoaded) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is TasksError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64.w,
                              color: AppColors.error,
                            ),
                            Gap(16.h),
                            AppText(
                              state.message,
                              style: AppTextStyles.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            Gap(16.h),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<TasksCubit>().refresh(),
                              child: const AppText('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is TasksLoaded) {
                      final tasks = _convertToTaskModels(state);

                      if (tasks.isEmpty) {
                        return const EmptyView();
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<TasksCubit>().refresh();
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: tasks.length + (state.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == tasks.length) {
                              return Padding(
                                padding: EdgeInsets.all(16.h),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return TaskCard(
                              task: tasks[index],
                              onTap: () => _openTask(context, tasks[index]),
                            );
                          },
                        ),
                      );
                    }

                    return const EmptyView();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Task> _convertToTaskModels(TasksLoaded state) {
    return state.response.data.tasks.map((taskModel) {
      return Task(
        id: taskModel.id.toString(),
        title: taskModel.title,
        managerName: 'Manager ${taskModel.createdBy}',
        priority: _convertPriority(taskModel.priority),
        deadline: taskModel.deadline,
        progress: taskModel.progress,
        status: _convertStatus(taskModel.status),
        description: taskModel.description,
      );
    }).toList();
  }

  TaskPriority _convertPriority(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return TaskPriority.low;
      case 'high':
        return TaskPriority.high;
      default:
        return TaskPriority.medium;
    }
  }

  TaskStatus _convertStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return TaskStatus.completed;
      case 'pending': // API uses "Pending" for under review
        return TaskStatus.underReview;
      case 'in progress':
        return TaskStatus.inProgress;
      default:
        return TaskStatus.inProgress;
    }
  }

  void _openTask(BuildContext context, Task task) {
    TaskUpdownSheet.show(
      context: context,
      task: task,
      onSubmitted: () {
        context.read<TasksCubit>().refresh();
      },
    );
  }
}
