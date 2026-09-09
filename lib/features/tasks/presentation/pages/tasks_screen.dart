import 'package:flutter/material.dart';
import '../../data/static_tasks_data.dart';
import '../../domain/models/task_models.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter.dart';
import 'task_submission_screen.dart';

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
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color.fromARGB(255, 248, 246, 250),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tasks', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 4),
                Text(
                  'Track assignments and submit for review',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                TaskFilterBar(
                  selected: _currentFilter,
                  onSelected: _selectFilter,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredTasks.isEmpty
                          ? const _EmptyState()
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

  void _openTask(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.92,
        child: TaskSubmissionScreen(
          task: task,
          onSubmitted: () {
            setState(() {
              _filteredTasks = StaticTasksData.getTasksByFilter(_currentFilter);
            });
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.assignment_turned_in_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text('No tasks here', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              const Text(
                'There are no tasks in this filter right now.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}
