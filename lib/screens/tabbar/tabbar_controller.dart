import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/routes/home_route.dart';
import 'package:nuPro/screens/home/home_screen.dart';
import 'package:nuPro/screens/menu/menu_tab/menu_tab_screen.dart';
import 'package:nuPro/screens/notification/notification_list/notification_list_screen.dart';
import 'package:nuPro/screens/tabbar/models/tabbar_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/screens/treatment_history/treatment_schedule/treatment_schedule_screen.dart';

class TabBarController extends IOController {
  final pageController = PageController();
  final tabIndex = 0.obs;
  final notificationCount = 0.obs;

  void onTabChanged(int index) {
    tabIndex.value = index;
  }

  void goToHistory() {
    tabIndex.value = 1;
    pageController.jumpToPage(1);
  }

  final tabItems = [
    TabBarModel(
      icon: 'home-svgrepo-com.svg',
      label: 'Нүүр',
      screen: const HomeScreen(),
    ),
    TabBarModel(
      icon: 'history.svg',
      label: 'Түүх',
      screen: const TreatmentScheduleScreen(),
    ),
    TabBarModel(
      icon: '+.svg',
      label: 'Дуудлага',
      isFab: true,
      screen: Container(),
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

  void onTapNotfication() async {
    // if (isLogged) {
    //   AppRoute.toNotification();
    // } else {
    //   final result = await showWarning(
    //     text: 'Та нэвтэрж орсноор мэдэгдэл харах боломжтой',
    //     cancelText: 'Хаах',
    //     acceptText: 'Тийм',
    //   );
    //   if (result == null) return;
    //   IOPages.toInitial();
    // }
  }

  void onTapQuestionnaire() async {
    await HomeRoute.toQuestionnaire();
  }
}
