import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_radius.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_text_field.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class JobDetailItem extends StatefulWidget {
  const JobDetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.title,
    this.subtitle,
    this.badge,
    this.badgeColor,
    this.isEditable = false,
    this.isEditing = false,
    this.isRequired = false,
    this.fieldType = AppTextFieldType.text,
    this.showLock = false,
    this.onSave,
  });

  final IconData icon;
  final String label;
  final String title;
  final String? subtitle;
  final String? badge;
  final Color? badgeColor;
  final bool isEditable;
  final bool isEditing;
  final bool isRequired;
  final AppTextFieldType fieldType;
  final bool showLock;
  final Future<bool> Function(String value)? onSave;

  @override
  State<JobDetailItem> createState() => _JobDetailItemState();
}

class _JobDetailItemState extends State<JobDetailItem> {
  late final TextEditingController _controller;
  bool _isSaving = false;
  String? _validationMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.title);
  }

  @override
  void didUpdateWidget(covariant JobDetailItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title ||
        (oldWidget.isEditing && !widget.isEditing)) {
      _controller.text = widget.title;
      _validationMessage = null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final value = _controller.text.trim();
    if (widget.isRequired && value.isEmpty) {
      setState(() => _validationMessage = context.l10n.profileNameRequired);
      return;
    }

    final onSave = widget.onSave;
    if (onSave == null) return;

    setState(() {
      _isSaving = true;
      _validationMessage = null;
    });
    await onSave(value);
    if (mounted) setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.space12.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(AppSpacing.space8.w),

          Expanded(child: _buildContent(context)),

          if (widget.badge != null) ...[
            Gap(AppSpacing.space8.w),
            _buildBadge(),
          ],

          if (widget.showLock) ...[
            Gap(AppSpacing.space8.w),
            Icon(
              Icons.lock_outline,
              size: 16.r,
              color: AppColors.textSecondary,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(widget.icon, size: 20.r, color: AppColors.textSecondary),
            Gap(AppSpacing.space4.w),

            AppText(
              widget.label,
              style: AppTextStyles.labelSmall,
              color: AppColors.textSecondary,
            ),
          ],
        ),

        Gap(AppSpacing.space4.h),

        if (widget.isEditable && widget.isEditing) ...[
          Gap(AppSpacing.space4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  controller: _controller,
                  type: widget.fieldType,
                  maxLines: widget.fieldType == AppTextFieldType.multiline
                      ? 2
                      : 1,
                  textCapitalization: widget.isRequired
                      ? TextCapitalization.words
                      : TextCapitalization.sentences,
                ),
              ),
              TextButton.icon(
                onPressed: _isSaving ? null : _save,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4.r),
                  minimumSize: Size(48.r, 40.r),
                  visualDensity: VisualDensity.compact,
                ),
                icon: _isSaving
                    ? SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.check_circle_outline, size: 20.r),
                label: Text(context.l10n.save),
              ),
            ],
          ),
          if (_validationMessage != null)
            AppText(
              _validationMessage!,
              style: AppTextStyles.bodySmall,
              color: AppColors.error,
            ),
        ] else
          AppText(
            widget.title,
            style: AppTextStyles.titleMedium,
            fontSize: 14.sp,
          ),

        if (widget.subtitle != null) ...[
          Gap(AppSpacing.space2.h),

          AppText(
            widget.subtitle!,
            style: AppTextStyles.bodySmall,
            color: AppColors.textSecondary,
          ),
        ],
      ],
    );
  }

  Widget _buildBadge() {
    return Container(
      constraints: BoxConstraints(minWidth: 90.w),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space8.w,
        vertical: AppSpacing.space8.h,
      ),
      decoration: BoxDecoration(
        color: (widget.badgeColor ?? AppColors.accent).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.radius16.r),
      ),
      child: AppText(
        widget.badge!,
        style: AppTextStyles.labelSmall,
        color: widget.badgeColor ?? AppColors.accent,
        textAlign: TextAlign.center,
      ),
    );
  }
}
