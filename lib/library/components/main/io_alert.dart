import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class IOAlert extends StatelessWidget {
  final IOAlertType type;
  final String? titleText;
  final String bodyText;
  final String? acceptText;
  final String? cancelText;

  final bool dismissable;
  const IOAlert({
    super.key,
    required this.type,
    required this.bodyText,
    this.dismissable = true,
    this.titleText,
    this.acceptText,
    this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: IOColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.1),
          //     blurRadius: 20,
          //     offset: const Offset(0, 10),
          //   ),
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.05),
          //     blurRadius: 40,
          //     offset: const Offset(0, 20),
          //   ),
          // ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: switch (type) {
                    IOAlertType.success =>
                      IOColors.infoPrimary.withOpacity(0.1),
                    IOAlertType.error => IOColors.errorPrimary.withOpacity(0.1),
                    IOAlertType.warning =>
                      IOColors.warningPrimary.withOpacity(0.1),
                  },
                ),
                child: Center(
                  child: SvgPicture.asset(
                    type.image,
                    width: 32,
                    height: 32,
                    colorFilter: ColorFilter.mode(
                      switch (type) {
                        IOAlertType.success => IOColors.infoPrimary,
                        IOAlertType.error => IOColors.errorPrimary,
                        IOAlertType.warning => IOColors.warningPrimary,
                      },
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                titleText ?? type.text,
                textAlign: TextAlign.center,
                style: IOStyles.h5.copyWith(
                  color: IOColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                bodyText,
                maxLines: 8,
                textAlign: TextAlign.center,
                style: IOStyles.body1Regular.copyWith(
                  color: IOColors.textSecondary,
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
              ),
              if (acceptText != null || cancelText != null) ...[
                const SizedBox(height: 32),
                Row(
                  children: [
                    if (cancelText != null) ...[
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: IOColors.strokePrimary,
                              width: 1.5,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: Get.back,
                              child: Center(
                                child: Text(
                                  cancelText ?? 'Үгүй',
                                  style: IOStyles.body1SemiBold.copyWith(
                                    color: IOColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (acceptText != null) const SizedBox(width: 12),
                    ],
                    if (acceptText != null)
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                IOColors.brand600,
                                IOColors.brand700,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: IOColors.brand600.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => Get.back(result: true),
                              child: Center(
                                child: Text(
                                  acceptText ?? 'Тийм',
                                  style: IOStyles.body1SemiBold.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> show() async {
    return Get.dialog(
      this,
      barrierDismissible: dismissable,
    );
  }
}

enum IOAlertType {
  success(
    text: 'Амжилттай',
    image: 'assets/icons/success.svg',
  ),
  error(
    text: 'Анхаарна уу',
    image: 'assets/icons/info-square-svgrepo-com.svg',
  ),
  warning(
    text: 'Анхаарна уу',
    image: 'assets/icons/info-square-svgrepo-com.svg',
  );

  const IOAlertType({required this.text, required this.image});

  final String text;
  final String image;
}
