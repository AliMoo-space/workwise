import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 16,
    this.shape = BoxShape.rectangle,
    this.backgroundColor,
    this.placeholder,
    this.errorWidget,
    this.cacheKey,
  });
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final BoxShape shape;
  final Color? backgroundColor;
  final Widget? placeholder;
  final Widget? errorWidget;
  final String? cacheKey;

  @override
  Widget build(BuildContext context) {
    final isSvg = imageUrl.toLowerCase().endsWith('.svg');

    final Widget image = isSvg
        ? SvgPicture.network(
            imageUrl,
            width: width?.w,
            height: height?.h,
            fit: fit,
            placeholderBuilder: (context) =>
                placeholder ??
                SizedBox(
                  width: width?.w,
                  height: height?.h,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
          )
        : CachedNetworkImage(
            imageUrl: imageUrl,
            cacheKey: cacheKey,
            width: width?.w,
            height: height?.h,
            fit: fit,
            fadeInDuration: const Duration(milliseconds: 250),
            fadeOutDuration: const Duration(milliseconds: 150),
            placeholder: (context, url) =>
                placeholder ??
                SizedBox(
                  width: width?.w,
                  height: height?.h,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            errorWidget: (context, url, error) =>
                errorWidget ??
                Container(
                  width: width?.w,
                  height: height?.h,
                  alignment: Alignment.center,
                  color: backgroundColor ?? AppColors.surfaceContainer,
                  child: const Icon(Icons.broken_image_outlined),
                ),
          );

    if (shape == BoxShape.circle) {
      return ClipOval(child: image);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius.r),
      child: image,
    );
  }
}
