import 'package:flutter/material.dart';
import '../../data/static_tasks_data.dart';
import '../../domain/models/task_models.dart';
import '../widgets/attachment_uploader.dart';
import '../widgets/progress_slider.dart';
import '../widgets/task_card.dart';
import '../widgets/task_status_badge.dart';

class TaskSubmissionScreen extends StatefulWidget {
  const TaskSubmissionScreen({
    super.key,
    required this.task,
    this.onSubmitted,
  });

  final Task task;
  final VoidCallback? onSubmitted;

  @override
  State<TaskSubmissionScreen> createState() => _TaskSubmissionScreenState();
}

class _TaskSubmissionScreenState extends State<TaskSubmissionScreen> {
  late final TextEditingController _notesController;
  late int _draftProgress;
  final List<TaskAttachment> _attachments = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    _draftProgress = widget.task.progress;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _updateProgress(double value) {
    setState(() => _draftProgress = value.round());
  }

  void _pickAttachment() {
    // Simulate picking attachment
    setState(() {
      _attachments.add(
        TaskAttachment(
          name: 'document_${_attachments.length + 1}.pdf',
          sizeInBytes: 2450000,
          localPath: '/mock/path/file_${_attachments.length + 1}',
        ),
      );
    });
  }

  void _removeAttachment(TaskAttachment attachment) {
    setState(() {
      _attachments.remove(attachment);
    });
  }

  Future<void> _submitForReview() async {
    setState(() => _isSubmitting = true);

    // Simulate submission delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Update static data
    StaticTasksData.updateTask(
      widget.task.id,
      _draftProgress,
      TaskStatus.underReview,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task submitted for review.')),
      );
      Navigator.of(context).pop();
      widget.onSubmitted?.call();
    }
  }

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(top: 10, bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6D6D6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'T-${widget.task.id}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.task.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Meta info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    PriorityBadge(priority: widget.task.priority),
                    const SizedBox(width: 8),
                    TaskStatusBadge(status: widget.task.status),
                    const SizedBox(width: 12),
                    Text(
                      'Due ${_date(widget.task.deadline)}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.task.description != null) ...[
                        Text(
                          widget.task.description!,
                          style: TextStyle(color: Colors.grey.shade800),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (widget.task.feedback != null) ...[
                        const SizedBox(height: 16),
                        _FeedbackCard(feedback: widget.task.feedback!),
                      ],
                      const SizedBox(height: 28),
                      ProgressSlider(
                        value: _draftProgress,
                        enabled: !_isSubmitting,
                        onChanged: _updateProgress,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Notes',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _notesController,
                        enabled: !_isSubmitting,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Add a note for your manager...',
                          hintStyle: const TextStyle(color: Color(0xFF9EA4AC)),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          contentPadding: const EdgeInsets.all(14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE2E6EE)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE2E6EE)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF1F365C),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AttachmentUploader(
                        attachments: _attachments,
                        onPick: _pickAttachment,
                        onRemove: _removeAttachment,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F365C),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _isSubmitting ? null : _submitForReview,
                    child: _isSubmitting
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Submit for Review',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  static String _date(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.feedback});
  final String feedback;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text('Manager feedback: $feedback'),
      );
}
