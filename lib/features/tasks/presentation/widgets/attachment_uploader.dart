import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/generated/app_localizations.dart';
import '../../domain/models/task_models.dart';

class AttachmentUploader extends StatelessWidget {
  const AttachmentUploader({
    super.key,
    required this.attachments,
    required this.onPick,
    required this.onRemove,
  });

  final List<TaskAttachment> attachments;
  final void Function(List<TaskAttachment> newAttachments) onPick;
  final ValueChanged<TaskAttachment> onRemove;

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc', 'png', 'jpg', 'jpeg'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final newAttachments = result.files.map((file) {
          return TaskAttachment(
            name: file.name,
            sizeInBytes: file.size,
            localPath: file.path ?? '',
          );
        }).toList();

        onPick(newAttachments);
      }
    } catch (e) {
      debugPrint('Error picking files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          l10n.attachments,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
        ),
        Gap(10.h),
        InkWell(
          onTap: _pickFiles,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.disabled,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE2E6EE), width: 1.2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 32.sp,
                  color: AppColors.focus,
                ),
                Gap(8.h),
                AppText(l10n.tapToUpload),
                Gap(4.h),
                AppText(
                  l10n.fileFormatsSupported,
                  style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
                ),
              ],
            ),
          ),
        ),
        if (attachments.isNotEmpty) ...[
          Gap(12.h),
          ...attachments.map(
            (attachment) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                _getFileIcon(attachment.name),
                size: 24.sp,
                color: AppColors.focus,
              ),
              title: Text(
                attachment.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15.sp),
              ),
              subtitle: Text(
                _sizeLabel(attachment.sizeInBytes),
                style: TextStyle(fontSize: 13.sp),
              ),
              trailing: IconButton(
                tooltip: l10n.removeAttachment,
                onPressed: () => onRemove(attachment),
                icon: Icon(Icons.close, size: 20.sp),
              ),
            ),
          ),
        ],
      ],
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Icons.image;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  String _sizeLabel(int bytes) {
    if (bytes < 1024 * 1024) return '${(bytes / 1024).ceil()} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
