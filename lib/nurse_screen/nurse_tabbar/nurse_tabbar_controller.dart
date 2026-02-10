import 'package:get/get.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/nurse_screen/nurse_home/nurse_home_screen.dart';
import 'package:nuPro/screens/menu/menu_tab/menu_tab_screen.dart';
import 'package:nuPro/screens/notification/notification_list/notification_list_screen.dart';
import 'package:nuPro/screens/tabbar/models/tabbar_model.dart';
import 'package:nuPro/screens/treatment_history/treatment_schedule/treatment_schedule_screen.dart';

class NurseTabbarController extends IOController {
  final tabIndex = 0.obs;

  void onTabChanged(int index) {
    tabIndex.value = index;
  }

  final tabItems = [
    TabBarModel(
      icon: 'home-svgrepo-com.svg',
      label: 'Нүүр',
      screen: const NurseHomeScreen(),
    ),
    TabBarModel(
      icon: 'history.svg',
      label: 'Түүх',
      screen: const TreatmentScheduleScreen(),
    ),
    TabBarModel(
      icon: 'message.svg',
      label: 'Мэдэгдэл',
      screen: const NotificationListScreen(),
    ),
    TabBarModel(
      icon: 'profile.svg',
      label: 'Цэс',
      screen: MenuTabScreen(),
    ),
  ];
}
