---
trigger: always_on
description: "Design system widget usage, ScreenUtil responsiveness, spacing, colors, and typography rules for WorkWise UI."
---

# Design System & UI Implementation Rules

## 1. Widget Usage
- Never use default Flutter primitives when a Design System counterpart exists:
  - Text → `AppText`
  - Container / Card decoration → `AppCard`
  - ElevatedButton / OutlinedButton → `AppButton`
  - IconButton → `AppIconButton`
  - CircularProgressIndicator → `AppLoader`
  - Shimmer / Skeleton → `Skeletonizer`
  - Error View → `AppErrorState`
  - Empty View → `EmptyView`

## 2. Responsiveness & Spacing
- Use `flutter_screenutil_plus` extensions strictly:
  - Width: `.w` (e.g., `AppSpacing.space16.w`)
  - Height: `.h` (e.g., `AppSpacing.space24.h`)
  - Radius: `.r` (e.g., `24.r`)
  - Font & Icon sizes: `.sp` (e.g., `20.sp`)
- Spacing between widgets must use `Gap(AppSpacing.spaceXX.h)` or `Gap(AppSpacing.spaceXX.w)`. Never use empty `SizedBox` or hardcoded integer padding.

## 3. Colors & Typography
- Only reference constants from `AppColors.*` and `AppTextStyles.*`.
- Never write hardcoded `Color(0xFF...)` or inline `TextStyle()` inside feature widgets.