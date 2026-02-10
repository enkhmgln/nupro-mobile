import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/tabbar/models/tabbar_model.dart';

class TabBarWidget extends StatelessWidget {
  final List<TabBarModel> items;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  final barHeight = 56;
  final fabSize = 56.0;
  final fabPadding = 6.0;

  const TabBarWidget({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return SizedBox(
      height: barHeight + bottomPadding,
      child: CustomPaint(
        painter: TabBarPainter(),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Row(
            children: items
                .mapIndexed(
                  (i, e) => e.isFab
                      ? SizedBox(width: fabSize)
                      : TabBarButton(
                          item: e,
                          selected: currentIndex == i,
                          onTap: () => onChanged(i),
                        ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class TabBarButton extends StatelessWidget {
  final TabBarModel item;
  final bool selected;
  final VoidCallback? onTap;
  const TabBarButton({
    super.key,
    required this.item,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: IOColors.brand100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 24,
              child: SvgPicture.asset(
                'assets/icons/${item.icon}',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  selected ? item.activeColor : item.color,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Text(
              item.label,
              style: IOStyles.caption1Medium.copyWith(
                color: selected ? item.activeColor : item.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabBarFab extends StatelessWidget {
  final TabBarModel item;

  final double size;
  final VoidCallback? onTap;
  const TabBarFab({
    super.key,
    required this.size,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -size / 2),
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          backgroundColor: IOColors.brand500,
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/${item.icon}',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              IOColors.backgroundPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class TabBarPainter extends CustomPainter {
  final notchSize = const Size(118, 34);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final notchStartX = centerX - notchSize.width / 2;
    final notchEndX = centerX + notchSize.width / 2;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(notchStartX, 0)
      ..cubicTo(
        notchStartX + notchSize.width / 4,
        0,
        notchStartX + notchSize.width / 4,
        -notchSize.height,
        size.width / 2,
        -notchSize.height,
      )
      ..cubicTo(
        notchEndX - notchSize.width / 4,
        -notchSize.height,
        notchEndX - notchSize.width / 4,
        0,
        notchEndX,
        0,
      )
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = IOColors.backgroundPrimary;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
