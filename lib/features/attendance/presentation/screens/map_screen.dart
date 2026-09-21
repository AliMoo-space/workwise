import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:workwise/core/design_system/colors/app_colors.dart';
import 'package:workwise/core/localization/localization_extension.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static const workplaceLocation = LatLng(30.0444, 31.2357);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.insideWorkplaceRadius)),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: workplaceLocation,
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                    border: Border.all(color: AppColors.white, width: 3),
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
            attributions: [TextSourceAttribution('OpenStreetMap contributors')],
          ),
        ],
      ),
    );
  }
}
