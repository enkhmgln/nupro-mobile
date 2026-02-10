import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/button/io_button_model.dart';
import 'package:nuPro/library/components/button/io_button_widget.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/screens/customer_call_map/customer_call_map_rating/customer_call_map_rating_controller.dart';

class CustomerCallMapRatingScreen
    extends GetView<CustomerCallMapRatingController> {
  const CustomerCallMapRatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IOColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: IOColors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: IOColors.textPrimary),
          onPressed: () => Get.until((route) => route.isFirst),
        ),
        title: const Text(
          'Үнэлгээ өгөх',
          style: TextStyle(
            color: IOColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: IOColors.successPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 48,
                color: IOColors.successPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Дуудлага амжилттай дууслаа!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: IOColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Үйлчилгээний чанарыг үнэлж, сэтгэгдэл үлдээнэ үү',
              style: TextStyle(
                fontSize: 16,
                color: IOColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: IOColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Үйлчилгээний чанар',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: IOColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final starIndex = index + 1;
                          final isSelected =
                              starIndex <= controller.selectedRating.value;

                          return GestureDetector(
                            onTap: () => controller.setRating(starIndex),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                isSelected ? Icons.star : Icons.star_border,
                                size: 40,
                                color: isSelected
                                    ? const Color(0xFFFFB800)
                                    : IOColors.textTertiary,
                              ),
                            ),
                          );
                        }),
                      )),
                  const SizedBox(height: 16),
                  Obx(() {
                    final rating = controller.selectedRating.value;
                    String ratingText = '';
                    Color textColor = IOColors.textSecondary;

                    switch (rating) {
                      case 1:
                        ratingText = 'Маш муу';
                        textColor = IOColors.errorPrimary;
                        break;
                      case 2:
                        ratingText = 'Муу';
                        textColor = IOColors.warningPrimary;
                        break;
                      case 3:
                        ratingText = 'Дундаж';
                        textColor = IOColors.warningPrimary;
                        break;
                      case 4:
                        ratingText = 'Сайн';
                        textColor = IOColors.brand500;
                        break;
                      case 5:
                        ratingText = 'Маш сайн';
                        textColor = IOColors.successPrimary;
                        break;
                      default:
                        ratingText = 'Үнэлгээ сонгоно уу';
                    }

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        ratingText,
                        key: ValueKey(rating),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: IOColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Сэтгэгдэл',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: IOColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.commentController,
                    maxLines: 4,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: 'Үйлчилгээний талаар сэтгэгдэл бичнэ үү...',
                      hintStyle: const TextStyle(
                        color: IOColors.textTertiary,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: IOColors.strokePrimary.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: IOColors.brand500,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: IOColors.strokePrimary.withOpacity(0.3),
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: IOColors.backgroundPrimary,
                    ),
                    style: const TextStyle(
                      color: IOColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => IOButtonWidget(
                model: IOButtonModel(
                  label: controller.isLoading.value
                      ? 'Илгээж байна...'
                      : 'Үнэлгээ илгээх',
                  type: IOButtonType.primary,
                  size: IOButtonSize.large,
                  isExpanded: true,
                  isLoading: controller.isLoading.value,
                  isEnabled: !controller.isLoading.value,
                ),
                onPressed:
                    controller.isLoading.value ? null : controller.submitRating,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => IOButtonWidget(
                  model: IOButtonModel(
                    label: 'Алгасах',
                    type: IOButtonType.textGray,
                    size: IOButtonSize.medium,
                    isExpanded: true,
                    isEnabled: !controller.isLoading.value,
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () => Get.until((route) => route.isFirst),
                )),
          ],
        ),
      ),
    );
  }
}
