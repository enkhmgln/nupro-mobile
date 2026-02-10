import 'package:nuPro/library/pages/io_pages.dart';
import 'package:nuPro/library/theme/io_theme.dart';
import 'package:nuPro/main_config.dart';
import 'package:nuPro/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await MainConfig.setOrientationConfig();
  await MainConfig.setStoreConfig();
  await MainConfig.setFirebaseConfig();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final controller = Get.put(MainController());
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NuPro',
      theme: IOTheme.lightTheme,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
      themeMode: ThemeMode.light,
      getPages: IOPages.pages,
      initialRoute: IOPages.initial,
      debugShowCheckedModeBanner: false,
    );
  }
}
