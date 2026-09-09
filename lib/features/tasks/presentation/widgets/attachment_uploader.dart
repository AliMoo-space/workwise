import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../domain/models/task_models.dart';

class AttachmentUploader extends StatelessWidget {
  const AttachmentUploader({
    super.key,
    required this.attachments,
    required this.onPick,
    required this.onRemove,
  });

  final List<TaskAttachment> attachments;
  final VoidCallback onPick;
  final ValueChanged<TaskAttachment> onRemove;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Attachments', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp)),
      SizedBox(height: 10.h),
      InkWell(
        onTap: onPick,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F9),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFFE2E6EE),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: 32.sp,
                color: const Color(0xFF4A5568),
              ),
              SizedBox(height: 8.h),
              Text(
                'Tap to upload a file',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: const Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'PDF, DOCX, PNG up to 10MB',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF718096),
                ),
              ),
            ],
          ),
        ),
      ),
      ...attachments.map(
        (attachment) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.insert_drive_file_outlined, size: 24.sp),
          title: Text(attachment.name, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15.sp)),
          subtitle: Text(_sizeLabel(attachment.sizeInBytes), style: TextStyle(fontSize: 13.sp)),
          trailing: IconButton(
            tooltip: 'Remove attachment',
            onPressed: () => onRemove(attachment),
            icon: Icon(Icons.close, size: 20.sp),
          ),
        ),
      ),
    ],
  );

  String _sizeLabel(int bytes) {
    if (bytes < 1024 * 1024) return '${(bytes / 1024).ceil()} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
