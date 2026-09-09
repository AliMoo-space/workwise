import '../domain/models/task_models.dart';

/// Static data for tasks - no bloc, no cubit, just pure data
class StaticTasksData {
  // Static list of tasks
  static final List<Task> tasks = [
    Task(
      id: '1',
      title: 'Design new landing page',
      managerName: 'Sara Ahmed',
      priority: TaskPriority.high,
      deadline: DateTime.now().add(const Duration(days: 3)),
      progress: 60,
      status: TaskStatus.inProgress,
      description:
          'Create a modern, responsive landing page based on the provided Figma mockups.',
    ),
    Task(
      id: '2',
      title: 'Fix login bug on iOS',
      managerName: 'Mohamed Ali',
      priority: TaskPriority.urgent,
      deadline: DateTime.now().add(const Duration(days: 1)),
      progress: 80,
      status: TaskStatus.inProgress,
      description: 'Users on iOS 17+ cannot log in via Apple Sign-In.',
    ),
    Task(
      id: '3',
      title: 'Write unit tests for auth module',
      managerName: 'Sara Ahmed',
      priority: TaskPriority.medium,
      deadline: DateTime.now().add(const Duration(days: 7)),
      progress: 100,
      status: TaskStatus.underReview,
    ),
    Task(
      id: '4',
      title: 'Update API documentation',
      managerName: 'Layla Hassan',
      priority: TaskPriority.low,
      deadline: DateTime.now().subtract(const Duration(days: 2)),
      progress: 100,
      status: TaskStatus.completed,
      feedback: 'Great work! Well structured docs.',
    ),
  ];

  // Get tasks by filter
  static List<Task> getTasksByFilter(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return tasks;
      case TaskFilter.inProgress:
        return tasks.where((t) => t.status == TaskStatus.inProgress).toList();
      case TaskFilter.underReview:
        return tasks.where((t) => t.status == TaskStatus.underReview).toList();
      case TaskFilter.completed:
        return tasks.where((t) => t.status == TaskStatus.completed).toList();
    }
  }

  // Update task progress and status
  static void updateTask(String taskId, int progress, TaskStatus status) {
    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      tasks[index] = tasks[index].copyWith(
        progress: progress,
        status: status,
      );
    }
  }
}
