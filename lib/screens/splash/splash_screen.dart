import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/SplashScreen';
  final SplashController controller = Get.put(SplashController());

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/splash_background.png',
              fit: BoxFit.cover,
            ),
            Center(
              child: AnimatedOpacity(
                opacity: controller.opacity.value,
                duration: const Duration(seconds: 2),
                onEnd: controller.navigateToLogin,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 92,
                    left: 92,
                    top: 235,
                    bottom: 200,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/app_logo.png',
                              height: 100,
                            ),
                            Flexible(
                              child: Text(
                                'NuPro',
                                style: IOStyles.h2.copyWith(
                                  color: IOColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Loading...',
                        style: IOStyles.body1Bold.copyWith(
                          color: IOColors.brand500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
