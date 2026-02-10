import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;
import 'package:nuPro/library/components/main/io_alert.dart';

class LocationManager {
  static final shared = LocationManager();

  bool serviceEnabled = false;
  LocationPermission permission = LocationPermission.denied;

  bool get locatoinEnabled =>
      permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always;

  Stream<Position> get positionStream => Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );

  Future checkPermissionStatus() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await const IOAlert(
        type: IOAlertType.error,
        bodyText: 'Таны төхөөрөмж байршил тогтоох боломжгүй байна',
        acceptText: 'Ойлголоо',
      ).show();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await const IOAlert(
          type: IOAlertType.error,
          bodyText: 'Та байршил авах тохиргоог зөвшөөрнө үү',
          acceptText: 'Ойлголоо',
        ).show();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await const IOAlert(
        type: IOAlertType.error,
        bodyText: 'Та байршил авах тохиргоог зөвшөөрнө үү',
        acceptText: 'Ойлголоо',
      ).show();
    }
  }

  // Triggers the native Google Play Services Location Accuracy dialog (if available)
  // Returns true if the request was sent or location already satisfied, false otherwise.
  Future<bool> triggerLocationSettingsDialog() async {
    // This native dialog is implemented only on Android. Avoid calling the
    // platform channel on other platforms to prevent MissingPluginException.
    if (!Platform.isAndroid) {
      print(
          'Location settings dialog is Android-only; skipping on this platform.');
      return false;
    }

    const channel = MethodChannel('nuPro/location_settings');
    try {
      final res = await channel.invokeMethod('showLocationSettings');
      return res == true;
    } on PlatformException catch (e) {
      print(
          'PlatformException when requesting location settings: ${e.message}');
      return false;
    } catch (e) {
      print('Error when requesting location settings: $e');
      return false;
    }
  }

  double getRangeInKm({required LatLng from, required LatLng to}) {
    return Geolocator.distanceBetween(
          from.latitude,
          from.longitude,
          to.latitude,
          to.longitude,
        ) /
        1000;
  }
}
