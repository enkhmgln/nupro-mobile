import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';

class MenuInfoWidget extends StatelessWidget {
  final String title;
  final RxString value;
  final bool isEditable;

  const MenuInfoWidget({
    super.key,
    required this.title,
    required this.value,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(
        () => isEditable
            ? TextField(
                controller: TextEditingController(text: value.value)
                  ..selection = TextSelection.fromPosition(
                      TextPosition(offset: value.value.length)),
                onChanged: (val) => value.value = val,
                textInputAction: TextInputAction.done,
                cursorColor: IOColors.textPrimary,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  labelText: title,
                  labelStyle: IOStyles.body1Regular.copyWith(
                    color: IOColors.textTertiary,
                  ),
                  floatingLabelStyle: IOStyles.caption1Regular.copyWith(
                    color: IOColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  filled: true,
                  fillColor: IOColors.backgroundPrimary,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: IOColors.strokePrimary,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: IOColors.textQuarternary,
                      width: 2,
                    ),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: IOStyles.caption1Regular.copyWith(
                      color: IOColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: IOColors.backgroundPrimary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: IOColors.strokePrimary,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      value.value.isEmpty ? '-' : value.value,
                      style: IOStyles.body1Regular.copyWith(
                        fontSize: 16,
                        color: IOColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
