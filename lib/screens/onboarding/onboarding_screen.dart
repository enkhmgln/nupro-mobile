import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/onboarding/onboarding_controller.dart';
import 'package:nuPro/screens/onboarding/widgets/onboarding_page_widget.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  static const String routeName = '/onboarding';

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: controller.skipOnboarding,
                  child: Text(
                    'Алгасах',
                    style: IOStyles.body2Regular.copyWith(
                      color: IOColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.onboardingPages.length,
                itemBuilder: (context, index) {
                  final page = controller.onboardingPages[index];
                  return OnboardingPageWidget(
                    title: page.title,
                    description: page.description,
                  );
                },
              ),
            ),

            // Bottom section with indicators and buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.onboardingPages.length,
                      (index) => Obx(() => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width:
                                controller.currentPage.value == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: controller.currentPage.value == index
                                  ? IOColors.brand500
                                  : IOColors.textSecondary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          )),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Navigation buttons
                  Row(
                    children: [
                      // Previous button (only show if not on first page)
                      Obx(() => controller.currentPage.value > 0
                          ? Expanded(
                              child: OutlinedButton(
                                onPressed: controller.previousPage,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: IOColors.brand500),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: Text(
                                  'Буцах',
                                  style: IOStyles.body1SemiBold.copyWith(
                                    color: IOColors.brand500,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink()),

                      // Spacing
                      Obx(() => controller.currentPage.value > 0
                          ? const SizedBox(width: 16)
                          : const SizedBox.shrink()),

                      // Next/Get Started button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: controller.nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: IOColors.brand500,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                          ),
                          child: Obx(() => Text(
                                controller.currentPage.value ==
                                        controller.onboardingPages.length - 1
                                    ? 'Эхлэх'
                                    : 'Дараах',
                                style: IOStyles.body1SemiBold.copyWith(
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
