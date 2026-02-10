import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:g_json/g_json.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuPro/library/client/api/call_api.dart';
import 'package:nuPro/library/client/api/nurse_api.dart';
import 'package:nuPro/library/components/button/io_button_model.dart';
import 'package:nuPro/library/components/main/io_alert.dart';
import 'package:nuPro/library/components/main/io_controller.dart';
import 'package:nuPro/library/components/main/io_toast.dart';
import 'package:nuPro/library/shared/location_manager.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/screens/home/home_call_google_map/widget/nurse_map_info_widget.dart';
import 'package:nuPro/screens/home/home_questionnaire/model/health_info_model.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/model/specialization_model.dart';

class HomeCallGoogleMapController extends IOController {
  final HealthInfoModel healthInfo;
  final RxList<NearestNursesModel> nearestNurses = <NearestNursesModel>[].obs;
  final RxList<SpecializationModel> availableSpecializations =
      <SpecializationModel>[].obs;
  final Rxn<SpecializationModel> selectedSpecialization =
      Rxn<SpecializationModel>();

  HomeCallGoogleMapController({
    required this.healthInfo,
    required List<NearestNursesModel> nearestNurses,
  }) {
    this.nearestNurses.value = nearestNurses;
  }
  final loadingNurseId = Rxn<int>();
  final mapController = Completer<GoogleMapController>();
  final markers = <Marker>[].obs;
  final userLocation = Rx<LatLng?>(null);
  StreamSubscription<Position>? locationStream;
  final calledNurseId = Rxn<int>();
  final activeCallId = Rxn<int>();

  final defaultLocation = const LatLng(47.91855296258276, 106.91778241997314);

  final nearButton = IOButtonModel(
    label: 'Өөрт ойр салбар харах',
    type: IOButtonType.primary,
    size: IOButtonSize.medium,
  );

  @override
  void onInit() {
    super.onInit();
    initializeMarker();
    checkLocation();
    fetchAvailableSpecializations();
    if (nearestNurses.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showNursesList();
      });
    }
  }

  Future<void> fetchAvailableSpecializations() async {
    isLoading.value = true;
    final response = await NurseApi().getSpecializations();
    isLoading.value = false;
    if (response.isSuccess) {
      final list = response.data.listValue;
      availableSpecializations.value =
          list.map((json) => SpecializationModel.fromJson(JSON(json))).toList();
    } else {
      showError(text: response.message);
    }
  }

  Future<void> filterNursesBySpecialization(int specializationId) async {
    isLoading.value = true;
    final response = await NurseApi()
        .searchNursesBySpecialization(specializationId: specializationId);
    isLoading.value = false;
    if (response.isSuccess) {
      final nursesJson = response.data.listValue;
      nearestNurses.value =
          nursesJson.map((e) => NearestNursesModel.fromJson(e)).toList();
      await getNurseLocations();
      // If at least one nurse is found, show their info in a bottom sheet
      if (nearestNurses.isNotEmpty) {
        print('object${nearestNurses.first}');
        showInfo(nurse: nearestNurses.first);
      }
    } else {
      nearestNurses.clear();
      markers.clear();
      showError(text: 'Сувилагч олдсонгүй эсвэл алдаа гарлаа');
    }
  }

  void showNursesList() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.45,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: IOColors.backgroundPrimary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 5,
                  width: 40,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: nearestNurses.length,
                    itemBuilder: (context, index) {
                      final nurse = nearestNurses[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: NurseMapInfoWidget(nurse: nurse),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future checkLocation() async {
    await LocationManager.shared.checkPermissionStatus();

    if (!LocationManager.shared.locatoinEnabled) {
      showError(text: "Байршлын үйлчилгээ идэвхгүй байна");
      return;
    }

    // Байршлын зөвшөөрөл шалгах
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

    // Хамгийн сүүлийн мэдэгдэж буй байрлал авах
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _locationChange(pos);

    // Байршлын өөрчлөлт сонсох
    locationStream = LocationManager.shared.positionStream.listen(
      _locationChange,
    );
  }

  void _locationChange(Position position) {
    userLocation.value = LatLng(
      position.latitude,
      position.longitude,
    );
  }

  Future initializeMarker() async {
    getNurseLocations();
  }

  Future getNurseLocations() async {
    final List<Marker> nurseMarkers = [];

    for (int index = 0; index < nearestNurses.length; index++) {
      final nurse = nearestNurses[index];

      BitmapDescriptor markerIcon;
      if (nurse.profilePicture != null && nurse.profilePicture!.isNotEmpty) {
        markerIcon = await _createCircularMarker(nurse.profilePicture!);
      } else {
        markerIcon = await _createPersonIconMarker();
      }

      nurseMarkers.add(
        Marker(
          markerId: MarkerId('${nurse.id}_$index'),
          position: LatLng(nurse.latitude, nurse.longitude),
          icon: markerIcon,
          onTap: () => showInfo(nurse: nurse),
        ),
      );
    }

    markers.value = nurseMarkers;
  }

  Future<BitmapDescriptor> _createCircularMarker(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        final ui.Image image = await decodeImageFromList(bytes);
        final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(pictureRecorder);

        final Path clipPath = Path()
          ..addOval(Rect.fromCircle(center: const Offset(40, 40), radius: 35));
        canvas.clipPath(clipPath);

        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          const Rect.fromLTWH(0, 0, 80, 80),
          Paint(),
        );

        canvas.drawCircle(
          const Offset(40, 40),
          35,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill,
        );

        canvas.clipPath(clipPath);
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          const Rect.fromLTWH(0, 0, 80, 80),
          Paint(),
        );

        canvas.drawCircle(
          const Offset(40, 40),
          35,
          Paint()
            ..color = IOColors.brand600
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4,
        );

        final ui.Picture picture = pictureRecorder.endRecording();
        final ui.Image finalImage = await picture.toImage(80, 80);
        final ByteData? byteData =
            await finalImage.toByteData(format: ui.ImageByteFormat.png);

        // Dispose images to prevent memory leaks
        image.dispose();
        finalImage.dispose();

        if (byteData != null) {
          return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
        }
      }
    } catch (e) {
      debugPrint('Error creating circular marker: $e');
      // Return default marker on any error to prevent crashes
    }

    return await _createPersonIconMarker();
  }

  Future<BitmapDescriptor> _createPersonIconMarker() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Create circular background
    canvas.drawCircle(
      const Offset(40, 40),
      35,
      Paint()
        ..color = IOColors.strokePrimary
        ..style = PaintingStyle.fill,
    );

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.person.codePoint),
        style: TextStyle(
          fontSize: 32,
          fontFamily: Icons.person.fontFamily,
          color: IOColors.textSecondary,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (80 - textPainter.width) / 2,
        (80 - textPainter.height) / 2,
      ),
    );

    // Add border
    canvas.drawCircle(
      const Offset(40, 40),
      35,
      Paint()
        ..color = IOColors.brand600
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    final ui.Picture picture = pictureRecorder.endRecording();
    final ui.Image finalImage = await picture.toImage(80, 80);
    final ByteData? byteData =
        await finalImage.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
    }

    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  }

  void onShowNear() {
    final loc = userLocation.value;
    if (loc == null) return;
    markers.sort((a, b) {
      final aRange = LocationManager.shared.getRangeInKm(
        from: loc,
        to: a.position,
      );
      final bRange = LocationManager.shared.getRangeInKm(
        from: loc,
        to: b.position,
      );
      return aRange.compareTo(bRange);
    });
  }

  void showInfo({required NearestNursesModel nurse}) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NurseMapInfoWidget(nurse: nurse),
    );
  }

  void sendCallToNurse(NearestNursesModel nurse) async {
    if (userLocation.value == null) {
      showError(text: "Байршлыг тогтоож чадсангүй");
      return;
    }
    loadingNurseId.value = nurse.id;

    final response = await NurseApi().createCallNurse(
      nurse: nurse.id.toString(),
      customerLatitude: userLocation.value!.latitude,
      customerLongitude: userLocation.value!.longitude,
    );

    loadingNurseId.value = null;

    if (response.isSuccess) {
      calledNurseId.value = nurse.id;
      activeCallId.value = response.data["id"].integerValue;
      showSuccess(text: response.message);
      IOToast(text: "QPay мэдээлэл гарч иртэл түр хүлээнэ үү");
    } else {
      showError(text: response.message);
    }
  }

  Future<void> cancelCall(String reason) async {
    if (activeCallId.value == null) {
      showError(text: "Цуцлах дуудлага олдсонгүй");
      return;
    }

    isLoading.value = true;
    final response = await NurseApi().bookingsCallsUpdate(
      status: "cancelled",
      id: activeCallId.value!,
      nurseNotes: reason,
    );
    isLoading.value = false;

    if (response.isSuccess) {
      showSuccess(text: "Дуудлага цуцлагдлаа");
      calledNurseId.value = null;
      activeCallId.value = null;
    } else {
      showError(text: response.message);
    }
  }

  Future<void> completeCall(int callId) async {
    isLoading.value = true;
    final response = await CallApi().getCompletionCode(callId: callId);
    isLoading.value = false;

    if (response.isSuccess) {
      final completionCode = response.data['completion_code'].stringValue;
      calledNurseId.value = null;
      activeCallId.value = null;

      // final ratingResponse = await RatingApi().getRatingForCall(callId: callId);
      // final alreadyRated = response.isSuccess && response.data['rated'] == true;

      // print('object $alreadyRated');

      // if (!alreadyRated) {
      // HomeRoute.toRating(callId: callId);
      // } else {
      IOAlert(
        type: IOAlertType.success,
        titleText: 'Дуудлага дууссан',
        bodyText: 'Баталгаажуулах код: $completionCode',
        acceptText: 'Хаах',
      ).show();
      // }
    } else {
      IOAlert(
        type: IOAlertType.error,
        titleText: 'Алдаа',
        bodyText: response.message,
        acceptText: 'Хаах',
      ).show();
    }
  }
}
