import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/design_system/spacing/app_spacing.dart';
import 'package:workwise/core/design_system/typography/app_text_styles.dart';
import 'package:workwise/core/design_system/widgets/layout/app_card.dart';
import 'package:workwise/core/design_system/widgets/text/app_text.dart';
import 'package:workwise/core/localization/localization_extension.dart';
import 'package:workwise/core/routing/app_routes.dart';
import 'package:workwise/features/attendance/presentation/widgets/status_badge.dart';
import 'package:go_router/go_router.dart';

class LocationStatusCard extends StatelessWidget {
  const LocationStatusCard({super.key});

  static const workplaceLocation = LatLng(30.0444, 31.2357);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      borderRadius: 24,
      onTap: () => context.push(AppRoutes.mapScreen),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: SizedBox(
              height: 220,
              child: ExcludeSemantics(
                child: FlutterMap(
                  options: const MapOptions(
                    initialCenter: workplaceLocation,
                    initialZoom: 14,
                    interactionOptions: InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.workwise.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: workplaceLocation,
                          width: 56,
                          height: 56,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white,
                                width: 3,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: AppColors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution('OpenStreetMap contributors'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.space16),
            child: Row(
              children: [
                Icon(Icons.near_me, color: AppColors.secondary),
                Gap(AppSpacing.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        context.l10n.insideWorkplaceRadius,
                        style: AppTextStyles.titleMedium,
                      ),
                      Gap(AppSpacing.space4),
                      AppText(
                        context.l10n.gpsAccuracy,
                        style: AppTextStyles.bodySmall,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,

                    child: StatusBadge(
                      label: context.l10n.valid,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
