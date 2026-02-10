import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/button/io_button_model.dart';
import 'package:nuPro/library/components/button/io_button_widget.dart';
import 'package:nuPro/library/components/main/io_card_border.dart';
import 'package:nuPro/library/extensions/extensions.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarSheet extends StatefulWidget {
  final DateTime initial;
  final DateTime start;
  final DateTime end;
  const CalendarSheet({
    super.key,
    required this.initial,
    required this.start,
    required this.end,
  });

  @override
  State<CalendarSheet> createState() => _CalendarSheetState();

  Future<DateTime?> show() {
    return Get.bottomSheet(this, isScrollControlled: true);
  }
}

class _CalendarSheetState extends State<CalendarSheet> {
  late DateTime selectedDate = widget.initial;
  late DateTime focusedDate = widget.initial;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: IOColors.backgroundPrimary,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: IOColors.textTertiary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: IOCardBorderWidget(
                child: TableCalendar(
                  firstDay: widget.start,
                  lastDay: widget.end,
                  focusedDay: focusedDate,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  rowHeight: 36,
                  daysOfWeekHeight: 30,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: IOStyles.caption1Bold.copyWith(
                      color: IOColors.brand500,
                    ),
                    weekendStyle: IOStyles.caption1Bold.copyWith(
                      color: IOColors.brand500,
                    ),
                    dowTextFormatter: (date, locale) => switch (date.weekday) {
                      1 => 'Дa',
                      2 => 'Мя',
                      3 => 'Лх',
                      4 => 'Пү',
                      5 => 'Ба',
                      6 => 'Бя',
                      7 => 'Ня',
                      _ => '',
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    cellMargin: const EdgeInsets.all(3),
                    isTodayHighlighted: true,
                    outsideDaysVisible: false,
                    outsideTextStyle: IOStyles.caption1Medium.copyWith(
                      color: IOColors.textQuarternary,
                    ),
                    defaultTextStyle: IOStyles.caption1Medium,
                    weekendTextStyle: IOStyles.caption1Medium,
                    selectedTextStyle: IOStyles.body2Bold.copyWith(
                      color: IOColors.backgroundPrimary,
                    ),
                    todayTextStyle: IOStyles.caption1Medium.copyWith(
                      color: IOColors.backgroundPrimary,
                    ),
                    todayDecoration: const BoxDecoration(
                      color: IOColors.textQuarternary,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: IOColors.brand500,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    titleTextStyle: IOStyles.body1Bold,
                    titleTextFormatter: (date, locale) =>
                        date.toFormattedString(format: 'yyyy/MM'),
                    leftChevronIcon: SvgPicture.asset(
                      'assets/icons/chevron.left.svg',
                    ),
                    rightChevronIcon: SvgPicture.asset(
                      'assets/icons/chevron.right.svg',
                    ),
                  ),
                  selectedDayPredicate: (day) => isSameDay(
                    selectedDate,
                    day,
                  ),
                  onDaySelected: onDaySelected,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(16),
              child: IOButtonWidget(
                onPressed: onTap,
                model: IOButtonModel(
                  label: 'Сонгох',
                  type: IOButtonType.primary,
                  size: IOButtonSize.medium,
                  isExpanded: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTap() {
    Get.back(result: selectedDate);
  }

  void onDaySelected(DateTime selectedDay, focusedDay) {
    setState(() {
      selectedDate = selectedDay;
      focusedDate = focusedDay;
    });
  }
}
