import 'package:nuPro/library/components/main/io_card_border.dart';
import 'package:flutter/material.dart';

class TreatmentHistoryWidget extends StatelessWidget {
  const TreatmentHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const IOCardBorderWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
