import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';

import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/inputs/app_text_field.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/features/profile/domain/entities/profile.dart';

import 'job_detail_item.dart';

class JobDetailsSection extends StatefulWidget {
  const JobDetailsSection({
    super.key,
    required this.profile,
    required this.onSave,
  });

  final Profile profile;
  final Future<bool> Function({String? name, String? phone, String? address})
  onSave;

  @override
  State<JobDetailsSection> createState() => _JobDetailsSectionState();
}

class _JobDetailsSectionState extends State<JobDetailsSection> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText(
              context.l10n.profileJobDetails,
              style: AppTextStyles.titleLarge,
            ),

            const Spacer(),
            TextButton.icon(
              onPressed: () => setState(() => _isEditing = !_isEditing),
              icon: Icon(_isEditing ? Icons.close : Icons.edit_outlined),
              label: Text(
                _isEditing ? context.l10n.cancel : context.l10n.editProfile,
              ),
            ),
          ],
        ),

        Gap(AppSpacing.space16.h),

        JobDetailItem(
          icon: Icons.person_outline,
          label: context.l10n.profileName,
          title: widget.profile.name,
          isEditable: true,
          isEditing: _isEditing,
          isRequired: true,
          onSave: (value) => widget.onSave(name: value),
        ),

        Gap(AppSpacing.space12.h),

        JobDetailItem(
          icon: Icons.badge_outlined,
          label: context.l10n.profileDirectManager,
          title: widget.profile.managerName ?? '-',
          badge: context.l10n.profileHeadOfOperations,
          showLock: true,
        ),

        Gap(AppSpacing.space12.h),

        JobDetailItem(
          icon: Icons.location_on_outlined,
          label: context.l10n.profileWorkLocation,
          title: widget.profile.address,
          badge: context.l10n.profileWithinAssignedRadius,
          isEditable: true,
          isEditing: _isEditing,
          fieldType: AppTextFieldType.multiline,
          onSave: (value) => widget.onSave(address: value),
        ),

        Gap(AppSpacing.space12.h),

        JobDetailItem(
          icon: Icons.email_outlined,
          label: context.l10n.profileWorkEmail,
          title: widget.profile.email,
          showLock: true,
        ),

        Gap(AppSpacing.space12.h),

        JobDetailItem(
          icon: Icons.phone_outlined,
          label: context.l10n.profileWorkPhone,
          title: widget.profile.phone,
          isEditable: true,
          isEditing: _isEditing,
          fieldType: AppTextFieldType.phone,
          onSave: (value) => widget.onSave(phone: value),
        ),
      ],
    );
  }
}
