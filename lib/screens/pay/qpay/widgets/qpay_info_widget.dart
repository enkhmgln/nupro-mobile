import 'package:flutter/material.dart';
import 'package:nuPro/library/components/main/io_card_border.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/pay/qpay/models/qpay_screen_model.dart';

class QpayInfoWidget extends StatelessWidget {
  final List<QpayInfoModel> info;
  const QpayInfoWidget({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return IOCardBorderWidget(
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = info[index];
          return RowWidget(
            title: item.title,
            value: item.value,
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16);
        },
        itemCount: info.length,
      ),
    );
  }
}

class RowWidget extends StatelessWidget {
  final String title;
  final String value;

  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  const RowWidget({
    super.key,
    required this.title,
    required this.value,
    this.titleStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleStyle ?? IOStyles.caption1Regular,
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            '$value MNT',
            style: valueStyle ?? IOStyles.caption1Bold,
          ),
        ),
      ],
    );
  }
}
