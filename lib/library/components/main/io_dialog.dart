import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/theme/io_colors.dart';

class IODialog extends StatelessWidget {
  final Widget child;

  const IODialog({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: IOColors.backgroundPrimary,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: child,
      ),
    );
  }

  Future<bool?> show() async {
    return Get.dialog(this);
  }
}
