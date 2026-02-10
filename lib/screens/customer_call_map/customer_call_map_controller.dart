import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuPro/library/client/api/call_api.dart';
import 'package:nuPro/library/client/models/call_detail_info.dart';
import 'package:nuPro/library/components/main/io_controller.dart';
import 'package:nuPro/library/utils/log.dart';
import 'package:nuPro/screens/customer_call_map/widget/customer_call_map_info.dart';

class CustomerCallMapController extends IOController {
  final polylines = <Polyline>[].obs;
  final distanceKm = RxDouble(0.0);
  final CallDetailInfoModel callDetailInfoModel;

  CustomerCallMapController({
    required this.callDetailInfoModel,
  });

  final mapController = Completer<GoogleMapController>();
  final markers = <Marker>[].obs;
  final userLocation = Rx<LatLng?>(null);
  StreamSubscription<Position>? locationStream;

  final defaultLocation = const LatLng(47.91855296258276, 106.91778241997314);

  @override
  void onInit() {
    super.onInit();
    initializeMarker();
    checkLocation();
  }

  @override
  void onClose() {
    locationStream?.cancel();
    super.onClose();
  }

  Future<void> initializeMarker() async {
    await _addCustomerMarker();
    await _addNurseMarker();
    _addPolylineAndDistance();
  }

  Future<void> _addCustomerMarker() async {
    final customerLat =
        double.tryParse(callDetailInfoModel.customerLatitude) ?? 0.0;
    final customerLng =
        double.tryParse(callDetailInfoModel.customerLongitude) ?? 0.0;

    if (customerLat != 0.0 && customerLng != 0.0) {
      final customerMarker = Marker(
        markerId: const MarkerId('customer'),
        position: LatLng(customerLat, customerLng),
        infoWindow: InfoWindow(
          title: 'Таны байршил',
          snippet:
              '${callDetailInfoModel.customerFirstName} ${callDetailInfoModel.customerLastName}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );

      markers.add(customerMarker);
    }
  }

  Future<void> _addNurseMarker() async {
    final nurseLat = double.tryParse(callDetailInfoModel.nurseLatitude) ?? 0.0;
    final nurseLng = double.tryParse(callDetailInfoModel.nurseLongitude) ?? 0.0;

    if (nurseLat != 0.0 && nurseLng != 0.0) {
      final nurseMarker = Marker(
        markerId: const MarkerId('nurse'),
        position: LatLng(nurseLat, nurseLng),
        infoWindow: InfoWindow(
          title: 'Эмчийн байршил',
          snippet: callDetailInfoModel.nurseName,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        onTap: () {
          Get.bottomSheet(
            NurseInfoBottomSheet(callDetailInfoModel: callDetailInfoModel),
            isScrollControlled: true,
          );
        },
      );
      markers.add(nurseMarker);
    }
  }

  void _addPolylineAndDistance() {
    final customerLat =
        double.tryParse(callDetailInfoModel.customerLatitude) ?? 0.0;
    final customerLng =
        double.tryParse(callDetailInfoModel.customerLongitude) ?? 0.0;
    final nurseLat = double.tryParse(callDetailInfoModel.nurseLatitude) ?? 0.0;
    final nurseLng = double.tryParse(callDetailInfoModel.nurseLongitude) ?? 0.0;
    if (customerLat != 0.0 &&
        customerLng != 0.0 &&
        nurseLat != 0.0 &&
        nurseLng != 0.0) {
      final customer = LatLng(customerLat, customerLng);
      final nurse = LatLng(nurseLat, nurseLng);
      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: const PolylineId('nurse_customer'),
          points: [customer, nurse],
          color: Colors.red,
          width: 4,
        ),
      );
      // Calculate distance in km
      final distanceMeters = Geolocator.distanceBetween(
        customer.latitude,
        customer.longitude,
        nurse.latitude,
        nurse.longitude,
      );
      distanceKm.value = distanceMeters / 1000.0;
    } else {
      polylines.clear();
      distanceKm.value = 0.0;
    }
  }

  Future<void> checkLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      userLocation.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      Log.error('Error getting location: $e', 'CustomerCallMapController');
    }
  }

  // Refresh call details after status change
  Future<void> refreshCallDetails() async {
    try {
      final response = await CallApi().getCallDetails(
        callId: callDetailInfoModel.id,
      );

      if (response.isSuccess) {
        // You might want to update the controller's callDetailInfoModel here
        // or trigger a UI refresh
        initializeMarker(); // Refresh map markers
      }
    } catch (e) {
      Log.error(
          'Error refreshing call details: $e', 'CustomerCallMapController');
    }
  }
}
