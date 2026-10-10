import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

abstract final class LocationHelper {
  const LocationHelper._();

  /// Checks location service status and permissions, then retrieves the current [Position].
  /// Returns `null` if location services are disabled, permissions are denied, or position cannot be obtained.
  static Future<Position?> getCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied.');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied.');
        return null;
      }

      try {
        return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 15),
          ),
        );
      } catch (e) {
        debugPrint(
          'Error getting current position, falling back to last known: $e',
        );
        return await Geolocator.getLastKnownPosition();
      }
    } catch (e) {
      debugPrint('LocationHelper error: $e');
      return null;
    }
  }
}
