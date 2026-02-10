import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/library/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateBirthPicker extends StatefulWidget {
  final String dateBirth;
  const DateBirthPicker({
    super.key,
    required this.dateBirth,
  });

  @override
  State<DateBirthPicker> createState() => _DateBirthPickerState();

  Future<String?> show() {
    return Get.bottomSheet(this);
  }
}

class _DateBirthPickerState extends State<DateBirthPicker> {
  DateTime picked = DateTime.now();
  DateTime initialDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.dateBirth.isNotEmpty) {
      initialDateTime = widget.dateBirth.toFormattedDate(format: 'yyyy-MM-dd');
      picked = initialDateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: IOColors.backgroundPrimary,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: IOColors.strokeTertiary,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      picked.toFormattedString('yyyy-MM-dd'),
                      style: IOStyles.body1Medium.copyWith(
                        color: IOColors.textPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      onPressed: () => Get.back(
                        result: picked.toFormattedString('yyyy-MM-dd'),
                      ),
                      icon: Text(
                        'Хадгалах',
                        style: IOStyles.body1Medium.copyWith(
                          color: IOColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height / 3,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: picked,
                maximumDate: DateTime.now(),
                minimumYear: DateTime.now().year - 200,
                maximumYear: DateTime.now().year,
                onDateTimeChanged: (DateTime selectedDate) {
                  setState(() {
                    picked = selectedDate;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
