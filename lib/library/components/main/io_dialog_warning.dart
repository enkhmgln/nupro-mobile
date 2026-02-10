import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/button/io_button_model.dart';
import 'package:nuPro/library/components/button/io_button_widget.dart';
import 'package:nuPro/library/components/main/io_dialog.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';

class IODialogWarning extends IODialog {
  final String title;

  IODialogWarning({
    super.key,
    required this.title,
  }) : super(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SvgPicture.asset(
                'assets/icons/con-warning-svgrepo-com.svg',
                width: 70,
                height: 70,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: IOStyles.h6.copyWith(
                  color: IOColors.brand700,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: IOButtonWidget(
                      model: IOButtonModel(
                        type: IOButtonType.secondary,
                        size: IOButtonSize.medium,
                        label: 'Тийм',
                      ),
                      onPressed: () {
                        Get.back(result: true);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: IOButtonWidget(
                      model: IOButtonModel(
                        type: IOButtonType.primary,
                        size: IOButtonSize.medium,
                        label: 'Үгүй',
                      ),
                      onPressed: Get.back,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
}
