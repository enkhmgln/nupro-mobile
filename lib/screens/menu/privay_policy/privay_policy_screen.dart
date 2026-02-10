import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:nuPro/library/components/main/io_appbar.dart';
import 'package:nuPro/library/components/main/io_loading.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/menu/privay_policy/privay_policy_controller.dart';

class PrivayPolicyScreen extends GetView<PrivayPolicyController> {
  const PrivayPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IOScaffold(
        appBar: IOAppBar(
          titleText: 'Нууцлалын бодлого',
        ),
        body: controller.isLoading.value
            ? const IOLoading()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  child: HtmlWidget(
                    controller.privacy.string,
                    textStyle: IOStyles.caption1SemiBold,
                  ),
                ),
              ),
      ),
    );
  }
}
