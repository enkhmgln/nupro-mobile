import 'package:flutter/material.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/screens/home/home_questionnaire/home_questionnaire_screen.dart';

class HomeFormPageController extends IOController {
  final pageController = PageController();

  final screens = const [
    HomeQuestionnaireScreen(),
  ];

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
