import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/button/io_button_widget.dart';
import 'package:nuPro/library/components/main/io_appbar.dart';
import 'package:nuPro/library/components/main/io_bottom_navigation.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/screens/pay/qpay/qpay_controller.dart';
import 'package:nuPro/screens/pay/qpay/widgets/qpay_info_widget.dart';
import 'package:nuPro/screens/pay/qpay/widgets/qpay_item_widget.dart';

class QpayScreen extends GetView<QpayController> {
  const QpayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.showPaymentRequiredDialog();
        return false;
      },
      child: Obx(
        () => IOScaffold(
          appBar: IOAppBar(
            titleText: controller.model.title,
          ),
          body: AbsorbPointer(
            absorbing: controller.isLoading.value,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.green.shade600, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Эмч таны хүсэлтийг зөвшөөрлөө',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Үйлчилгээг үргэлжлүүлэхийн тулд төлбөрөө төлөх шаардлагатай',
                          style: TextStyle(
                            color: Colors.green.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  QpayInfoWidget(info: controller.model.info),
                  const SizedBox(height: 24),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                    children: controller.model.urls
                        .map(
                          (e) => QpayItemWidget(
                            url: e,
                            onTap: controller.onCheck,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: IOBottomNavigationBar(
            child: IOButtonWidget(
              model: controller.check.value,
              onPressed: controller.checkPayment,
            ),
          ),
        ),
      ),
    );
  }
}
