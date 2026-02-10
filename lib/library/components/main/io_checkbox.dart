import 'package:flutter/material.dart';
import 'package:nuPro/library/theme/io_colors.dart';

class IOCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const IOCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        checkboxTheme: CheckboxThemeData(
          side: WidgetStateBorderSide.resolveWith(
            (states) => const BorderSide(
              color: IOColors.brand500,
              width: 1,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      child: Checkbox(
        value: value,
        onChanged: (e) => onChanged(e ?? false),
        activeColor: IOColors.brand500,
      ),
    );
  }
}
