import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuPro/library/client/api/call_api.dart';
import 'package:nuPro/library/client/models/call_detail_info.dart';
import 'package:nuPro/library/components/main/io_controller.dart';
import 'package:nuPro/library/shared/location_manager.dart';
import 'package:nuPro/library/utils/call_status_enum.dart';
import 'package:nuPro/library/utils/log.dart';
import 'package:nuPro/nurse_screen/nurse_call_google_map/widget/map_info_widget.dart';

class NurseCallGoogleMapController extends IOController {
  final CallDetailInfoModel callDetailInfoModel;

  NurseCallGoogleMapController({
    required this.callDetailInfoModel,
  });

  late LatLng defaultLocation;
  final markers = <Marker>[].obs;
  late BitmapDescriptor markerIcon;
  final userLocation = Rx<LatLng?>(null);
  StreamSubscription<Position>? locationStream;
  final mapController = Completer<GoogleMapController>();
  final completionCodeController = TextEditingController();
  final polylines = <Polyline>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final lat = double.tryParse(callDetailInfoModel.customerLatitude) ??
        47.91855296258276;
    final lng = double.tryParse(callDetailInfoModel.customerLongitude) ??
        106.91778241997314;
    defaultLocation = LatLng(lat, lng);

    initializeMarker();
    checkLocation();
    if (userLocation.value != null) {
      drawRoute();
    }
  }

  Future<void> drawRoute() async {
    if (userLocation.value == null) return;

    final origin = userLocation.value!;
    final destination = LatLng(
      double.parse(callDetailInfoModel.customerLatitude),
      double.parse(callDetailInfoModel.customerLongitude),
    );

    final distanceInMeters = Geolocator.distanceBetween(
      origin.latitude,
      origin.longitude,
      destination.latitude,
      destination.longitude,
    );
    final distanceKm = (distanceInMeters / 1000).toStringAsFixed(2);

    polylines.clear();
    polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: [origin, destination],
        color: Colors.blue,
        width: 5,
        geodesic: true,
        patterns: [
          PatternItem.dash(30),
          PatternItem.gap(15),
        ],
      ),
    );

    // Midpoint for distance text
    final midLat = (origin.latitude + destination.latitude) / 2;
    final midLng = (origin.longitude + destination.longitude) / 2;

    // Create custom marker with distance text
    final markerIcon = await _createTextMarker('$distanceKm km');

    // Add distance marker
    markers.add(
      Marker(
        markerId: const MarkerId('distance_marker'),
        position: LatLng(midLat, midLng),
        icon: markerIcon,
        anchor: const Offset(0.5, 0.5),
      ),
    );
  }

  Future<BitmapDescriptor> _createTextMarker(String text) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    // Том marker хэмжээ
    const double width = 180;
    const double height = 60;

    // Marker background
    final Paint paint = Paint()..color = Colors.yellow.shade700;
    final RRect rrect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, width, height), const Radius.circular(12));
    canvas.drawRRect(rrect, paint);

    // Border
    final Paint border = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rrect, border);

    // Text
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    textPainter.text = TextSpan(
      text: text,
      style: const TextStyle(
        fontSize: 22,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );

    textPainter.layout(minWidth: 0, maxWidth: width);
    textPainter.paint(
      canvas,
      Offset(
          (width - textPainter.width) / 2, (height - textPainter.height) / 2),
    );

    final ui.Image markerAsImage =
        await recorder.endRecording().toImage(width.toInt(), height.toInt());
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8list = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8list);
  }

  void showMarkers() {
    final lat = double.tryParse(callDetailInfoModel.customerLatitude);
    final lng = double.tryParse(callDetailInfoModel.customerLongitude);

    if (lat != null && lng != null && userLocation.value != null) {
      markers.value = [
        // Хэрэглэгч
        Marker(
          markerId: MarkerId('customer_${callDetailInfoModel.id}'),
          position: LatLng(lat, lng),
          infoWindow: const InfoWindow(title: 'Хэрэглэгч'),
          onTap: () => showInfo(customer: callDetailInfoModel),
        ),
        // Сувилагч
        Marker(
          markerId: const MarkerId('nurse'),
          position: userLocation.value!,
          infoWindow: const InfoWindow(title: 'Сувилагч'),
        ),
      ];
    }
  }

  Future<void> completeCall(CallDetailInfoModel customer) async {
    if (completionCodeController.text.isEmpty) {
      showError(text: "Дуусгах код оруулна уу");
      return;
    }

    isLoading.value = true;

    final response = await CallApi().completeCall(
      callId: customer.id,
      completionCode: completionCodeController.text,
    );

    isLoading.value = false;

    print('object_+_+_+_+_+_+_');

    if (response.isSuccess) {
      Get.back();
      // Get.until((route) => route.isFirst);
      showSuccess(text: response.message);
    } else {
      showError(text: response.message);
    }
  }

  @override
  void onClose() {
    try {
      completionCodeController.dispose();
    } catch (e) {}
    try {
      locationStream?.cancel();
    } catch (e) {}
    try {
      mapController.isCompleted
          ? mapController.future.then((c) => c.dispose())
          : null;
    } catch (e) {}
    super.onClose();
  }

  Future checkLocation() async {
    await LocationManager.shared.checkPermissionStatus();

    if (!LocationManager.shared.locatoinEnabled) {
      showError(text: "Байршлын үйлчилгээ идэвхгүй байна");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showError(text: "Байршлын зөвшөөрөл олгогдоогүй");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showError(text: "Байршлын зөвшөөрлийг тохиргооноос идэвхжүүлнэ үү");
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _locationChange(pos);

    locationStream = LocationManager.shared.positionStream.listen(
      _locationChange,
    );
  }

  void _locationChange(Position position) {
    userLocation.value = LatLng(
      position.latitude,
      position.longitude,
    );
    showMarkers();
    drawRoute();
  }

  Future initializeMarker() async {
    showCustomerLocation();
  }

  void showCustomerLocation() {
    final lat = double.tryParse(callDetailInfoModel.customerLatitude);
    final lng = double.tryParse(callDetailInfoModel.customerLongitude);

    if (lat != null && lng != null) {
      markers.value = [
        Marker(
          markerId: MarkerId('${callDetailInfoModel.id}'),
          position: LatLng(lat, lng),
          onTap: () => showInfo(customer: callDetailInfoModel),
        ),
      ];
    } else {
      showError(text: "Хэрэглэгчийн байршлыг уншиж чадсангүй");
    }
  }

  void showInfo({required CallDetailInfoModel customer}) {
    MapInfoWidget.showSheet(
      customer,
      onTapCall: () => callCancel(customer),
      completionCodeController: completionCodeController,
      onTapComplete: () => completeCall(customer),
    );
  }

  Future<void> callCancel(CallDetailInfoModel customer) async {
    if (userLocation.value == null) {
      showError(text: "Байршлыг тогтоож чадсангүй");
      return;
    }
    isLoading.value = true;
    if (userLocation.value == null) {
      showError(text: "Байршлыг тогтоож чадсангүй");
      return;
    }
    final response = await CallApi().updateCallStatus(
      callId: customer.id,
      status: CallStatus.rejected.value,
    );
    isLoading.value = false;
    if (response.isSuccess) {
      Get.back();
      showSuccess(text: response.message);
    } else {
      showError(text: response.message);
    }
  }

  Future<void> refreshCallDetails() async {
    try {
      final response = await CallApi().getCallDetails(
        callId: callDetailInfoModel.id,
      );

      if (response.isSuccess) {
        // final updatedCallDetail = CallDetailInfoModel.fromJson(response.data);
        // You might want to update the controller's callDetailInfoModel here
        // or trigger a UI refresh
        showCustomerLocation(); // Refresh map markers
      }
    } catch (e) {
      Log.error(
          'Error refreshing call details: $e', 'NurseCallGoogleMapController');
    }
  }
}
