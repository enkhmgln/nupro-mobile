import 'package:get/get.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/routes/home_route.dart';
import 'package:nuPro/library/routes/menu_route.dart';
import 'package:nuPro/library/utils/constants.dart';
import 'package:nuPro/main_controller.dart';
import 'package:nuPro/screens/home/model/home_banner_model.dart';
import 'package:nuPro/screens/home/model/nurse_treatment_model.dart';
import 'package:nuPro/screens/home/model/treatment_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends IOController {
  final profileInfo = HelperManager.profileInfo.obs;

  final bannerItems = <HomeBannerModel>[].obs;
  final history = <TreatmentModel>[].obs;
  final pagination = PaginationModel();
  final refreshController = RefreshController();
  int doneRequests = 0;

  @override
  void onInit() async {
    super.onInit();
    await getHomeBanner();
    await getTreatment();
    Get.find<MainController>().getUserInfo;

    UserStoreManager.shared.store.listenKey(kProfileUser, (_) {
      profileInfo.value = HelperManager.profileInfo;
    });
  }

  Future getData() async {
    doneRequests = 0;
    getHomeBanner();
    getTreatment();

    refreshController.refreshCompleted();
  }

  void checkRequestIsdone() {
    doneRequests += 1;
    if (doneRequests == 3) {
      refreshController.refreshCompleted();
    }
  }

  Future getHomeBanner() async {
    final response = await CustomerApi().getBanner(
      page: pagination.page,
      limit: pagination.limit,
    );
    if (response.isSuccess) {
      bannerItems.value = response.data.listValue
          .map((e) => HomeBannerModel.fromJson(e))
          .toList();
    }
    checkRequestIsdone();
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
          .map((e) => TreatmentModel.fromJson(e))
          .toList();
    }
    checkRequestIsdone();
  }

  void onTapCallScreen() {
    HomeRoute.toQuestionnaire();
  }

  void onTapProfile() {
    MenuRoute.toMenuInfo();
  }

  void toTreatmentHistoryDetail(item) {
    if (item is NurseTreatmentModel) {
      // HomeRoute.toTreatmentHistoryDetailScreen(item);
    } else if (item is TreatmentModel) {
      HomeRoute.toTreatmentHistoryDetailScreenCustomer(item);
    } else {
      // Unknown type, show error or do nothing
      print('Unknown item type for detail screen');
    }
  }
}
