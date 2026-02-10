import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/screens/treatment_history/treatment_history_tab/treatment_history_tab_controller.dart';
import 'package:nuPro/screens/treatment_history/treatment_schedule/treatment_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class TreatmentHistoryTabScreen extends GetView<TreatmentHistoryTabController> {
  const TreatmentHistoryTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      appBar: IOAppBar(
        titleText: 'Түүх',
      ),
      body: const DefaultTabController(
        length: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            // Padding(
            //   padding: EdgeInsetsGeometry.all(16),
            //   child: IOTabBar(
            //     tabs: ['Түүх'],
            //   ),
            // ),
            Expanded(
              child: TabBarView(
                children: [
                  TreatmentScheduleScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
