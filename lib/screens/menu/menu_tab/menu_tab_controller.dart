import 'package:get/get.dart';
import 'package:nuPro/library/components/button/io_button_model.dart';
import 'package:nuPro/library/components/main/io_dialog_warning.dart';
import 'package:nuPro/library/components/main/io_super_controller.dart';
import 'package:nuPro/library/pages/io_pages.dart';
import 'package:nuPro/library/routes/menu_route.dart';
import 'package:nuPro/library/shared/helper_manager.dart';
import 'package:nuPro/library/shared/store_manager.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/utils/constants.dart';
import 'package:nuPro/screens/menu/menu_tab/models/menu_tab_model.dart';

class MenuTabController extends IOSuperController {
  final profileInfo = HelperManager.profileInfo.obs;
  final isNotificationEnabled = false.obs;
  List<MenuTabModel> get items {
    return [
      MenuTabModel(
        title: '',
        items: [
          // MenuTabItemModel(type: MenuTabItemType.branch),
        ],
      ),
      MenuTabModel(
        title: 'Бусад',
        items: [
          if (HelperManager.profileInfo.userType == "customer")
            MenuTabItemModel(type: MenuTabItemType.myRatings),
          if (HelperManager.profileInfo.userType == "nurse")
            MenuTabItemModel(type: MenuTabItemType.ratingNurse),
          MenuTabItemModel(type: MenuTabItemType.contact),
          MenuTabItemModel(type: MenuTabItemType.faq),
          MenuTabItemModel(type: MenuTabItemType.terms),
          MenuTabItemModel(type: MenuTabItemType.policy),
          MenuTabItemModel(type: MenuTabItemType.logout),
        ],
      ),
    ];
  }

  final logoutButton = IOButtonModel(
    label: 'Системээс гарах',
    type: IOButtonType.primary,
    size: IOButtonSize.medium,
    enabledBackgroundColor: IOColors.secondary500,
  );

  @override
  void onInit() {
    super.onInit();
    isEnabledNotification();
    UserStoreManager.shared.store.listenKey(kProfileUser, (_) {
      profileInfo.value = HelperManager.profileInfo;
    });
  }

  @override
  void onResumed() {
    super.onResumed();
    isEnabledNotification();
  }

  void onTapProfile() {
    MenuRoute.toMenuInfo();
  }

  void openNotificationSettings() {
    // AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  void onTapItem(MenuTabItemType type, bool? value) {
    switch (type) {
      // case MenuTabItemType.branch:
      // MenuRoute.toPurchaseHistory();
      // break;
      case MenuTabItemType.myRatings:
        MenuRoute.toMyRatings();
        break;
      case MenuTabItemType.ratingNurse:
        final nurseProfile = HelperManager.profileInfo.nurseProfile;
        final nurseId = nurseProfile != null ? nurseProfile['id'] : null;
        if (nurseId != null) {
          MenuRoute.toRatingNurse(nurseId: nurseId);
        } else {
          print('Сувилагчийн ID олдсонгүй');
        }
        break;
      case MenuTabItemType.contact:
        MenuRoute.toContact();
        break;
      case MenuTabItemType.faq:
        MenuRoute.toFaq();
        break;
      case MenuTabItemType.terms:
        MenuRoute.toTermsOfService();
        break;
      case MenuTabItemType.policy:
        MenuRoute.toPrivayPolicy();
        break;
      case MenuTabItemType.logout:
        onTapLogout();
        break;
    }
  }

  Future isEnabledNotification() async {
    // isNotificationEnabled.value = await Permission.notification.isGranted;
    refresh();
  }

  Future onTapLogout() async {
    final confirm = await IODialogWarning(
      title: 'Та системээс гарахдаа итгэлтэй байна уу?',
    ).show();

    if (confirm == null) return;

    // await UserApi().logout();

    await UserStoreManager.shared.deleteStore();
    Get.offAllNamed(IOPages.initial);
  }
}
