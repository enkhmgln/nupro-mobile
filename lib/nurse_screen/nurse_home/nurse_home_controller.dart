import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nuPro/library/components/main/io_toast.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/routes/home_route.dart';
import 'package:nuPro/library/routes/menu_route.dart';
import 'package:nuPro/nurse_screen/nurse_tabbar/nurse_tabbar_screen.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/utils/constants.dart';
import 'package:nuPro/main_controller.dart';
import 'package:nuPro/screens/home/model/home_banner_model.dart';
import 'package:nuPro/screens/home/model/nurse_treatment_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NurseHomeController extends IOController {
  final profileInfo = HelperManager.profileInfo.obs;
  final bannerItems = <HomeBannerModel>[].obs;
  final refreshController = RefreshController();
  final history = <NurseTreatmentModel>[].obs;

  StreamSubscription<Position>? _positionStream;
  // DateTime? _lastSentTime;s

  @override
  void onClose() {
    _positionStream?.cancel();
    locationTimer?.cancel();
    super.onClose();
  }

  final isCallActive = false.obs;
  final isLocationLoading = false.obs;
  final callStatusLabel = 'Дуудлага идэвхжүүлэх'.obs;

  int doneRequests = 0;

  Timer? locationTimer;

  @override
  void onInit() async {
    super.onInit();
    Get.find<MainController>().getUserInfo;
    await getHomeBanner();
    await getTreatment();

    UserStoreManager.shared.store.listenKey(kProfileUser, (_) {
      profileInfo.value = HelperManager.profileInfo;
    });
  }

  Future getHomeBanner() async {
    final response = await CustomerApi().getBanner(
      page: 1,
      limit: 10,
    );
    if (response.isSuccess) {
      bannerItems.value = response.data.listValue
          .map((e) => HomeBannerModel.fromJson(e))
          .toList();
    }
    checkRequestIsdone();
  }

  void checkRequestIsdone() {
    doneRequests += 1;
    if (doneRequests == 3) {
      refreshController.refreshCompleted();
    }
  }

  Future getData() async {
    doneRequests = 0;
    getHomeBanner();
    getTreatment();

    refreshController.refreshCompleted();
  }

  void onTapProfile() {
    MenuRoute.toMenuInfo();
  }

  Future getTreatment({
    String? startDate,
    String? endDate,
    String? status,
  }) async {
    final response = await CustomerApi().getTreatment(
      limit: 5,
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
    if (response.isSuccess) {
      history.value = response.data.listValue
          .map((e) => NurseTreatmentModel.fromJson(e))
          .toList();
    }
    refreshController.refreshCompleted();
  }

  void toggleCall() {
    CustomerApi().nurseActiveCallToggle().then((response) {
      final isAcceptingCalls = response.data['is_accepting_calls'].booleanValue
          ? response.data['is_accepting_calls'].booleanValue
          : false;
      isCallActive.value = isAcceptingCalls;
      final message = response.message.toString();
      if (message == 'Сувилагч идэвхтэй болгогдлоо') {
        callStatusLabel.value = 'Дуудлага идэвхжүүлсэн';
      } else if (message == 'Сувилагч идэвхгүй болгогдлоо') {
        callStatusLabel.value = 'Дуудлага идэвхжүүлэх';
      } else {
        callStatusLabel.value =
            isAcceptingCalls ? 'Дуудлага идэвхжүүлсэн' : 'Дуудлага идэвхжүүлэх';
      }
      IOToast(
        text: message,
        backgroundColor: IOColors.successPrimary,
        time: 2,
        gravity: ToastGravity.TOP,
      ).show();
      print('object_+_+_+_+_+${isCallActive.value}');
      if (isCallActive.value) {
        isLocationLoading.value = true;
        startSendingLocation();
      } else {
        locationTimer?.cancel();
        isLocationLoading.value = false;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (Get.currentRoute != NurseTabbarScreen.routeName) {
            Get.offAllNamed(NurseTabbarScreen.routeName);
          }
          onClose();
        });
      }
    });
  }

  void startSendingLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLocationLoading.value = false;
        print('Location services are disabled.');
        IOToast(
          text: 'Байршлын үйлчилгээ идэвхгүй байна',
          backgroundColor: IOColors.errorPrimary,
        ).show();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isLocationLoading.value = false;
          IOToast(
            text: 'Байршлын зөвшөөрөл олгогдоогүй',
            backgroundColor: IOColors.errorPrimary,
          ).show();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        isLocationLoading.value = false;
        IOToast(
          text: 'Байршлын зөвшөөрлийг тохиргооноос идэвхжүүлнэ үү',
          backgroundColor: IOColors.errorPrimary,
        ).show();
        return;
      }

      // Эхний байршлыг илгээнэ
      Position firstPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final firstLat = double.parse(firstPosition.latitude.toStringAsFixed(6));
      final firstLng = double.parse(firstPosition.longitude.toStringAsFixed(6));

      await NurseApi().sendNurseLocation(
        latitude: firstLat,
        longitude: firstLng,
      );

      print('First location sent: $firstLat, $firstLng');
      isLocationLoading.value = false;

      // 30 секунд тутам шинэ байршлыг илгээх
      locationTimer?.cancel(); // давхар Timer үүсэхээс сэргийлнэ
      locationTimer = Timer.periodic(const Duration(seconds: 50), (_) async {
        // Дуудлага идэвхтэй үед л ажиллана
        if (!isCallActive.value) return;

        try {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          final lat = double.parse(position.latitude.toStringAsFixed(6));
          final lng = double.parse(position.longitude.toStringAsFixed(6));

          await NurseApi().sendNurseLocation(
            latitude: lat,
            longitude: lng,
          );

          print('Location sent (30s): $lat, $lng');
        } catch (e) {
          print('Error getting location: $e');
        }
      });
    } catch (e) {
      isLocationLoading.value = false;
      IOToast(
        text: 'Байршил илгээхэд алдаа гарлаа',
        backgroundColor: IOColors.errorPrimary,
      ).show();
      print('Error sending first location: $e');
    }
  }

  void toTreatmentHistoryDetail(item) {
    if (item is NurseTreatmentModel) {
      HomeRoute.toTreatmentHistoryDetailScreenNurse(item);
    }
  }
}
