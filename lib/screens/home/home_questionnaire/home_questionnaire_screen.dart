import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:nuPro/library/components/components.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/components/main/io_card_border.dart';
import 'package:nuPro/library/components/textfield/io_long_text_field.widget.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/home/home_questionnaire/home_questionnaire_controller.dart';

class HomeQuestionnaireScreen extends GetView<HomeQuestionnaireController> {
  const HomeQuestionnaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      appBar: IOAppBar(
        titleText: 'Эрүүл мэндийн мэдээлэл',
      ),
      body: Obx(() => Column(
            children: [
              _buildProgressIndicator(),
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStep1(),
                    _buildStep2(),
                    _buildStep3(),
                  ],
                ),
              ),
              _buildNavigationButtons(),
            ],
          )),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (index) {
              final isActive = controller.currentStep.value >= index;
              final isCompleted = controller.currentStep.value > index;

              return Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color:
                          isActive ? IOColors.brand600 : IOColors.strokePrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check,
                              color: IOColors.backgroundPrimary, size: 18)
                          : Text(
                              '${index + 1}',
                              style: IOStyles.caption1SemiBold.copyWith(
                                color: isActive
                                    ? IOColors.backgroundPrimary
                                    : IOColors.textSecondary,
                              ),
                            ),
                    ),
                  ),
                  if (index < 2)
                    Container(
                      width:
                          (MediaQuery.of(Get.context!).size.width - 32 - 96) /
                              2,
                      height: 2,
                      color:
                          isCompleted ? IOColors.brand600 : IOColors.brand200,
                    ),
                ],
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            _getStepTitle(controller.currentStep.value),
            style: IOStyles.body1SemiBold.copyWith(color: IOColors.textPrimary),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Эмчилгээний төрөл сонгох';
      case 1:
        return 'Эрүүл мэндийн асуулга';
      case 2:
        return 'Нэмэлт мэдээлэл болон гарын үсэг';
      default:
        return '';
    }
  }

  IconData _getServiceTypeIcon(String serviceTypeName) {
    switch (serviceTypeName) {
      case 'Боолт хийлгэх':
        return Icons.healing;
      case 'Цагийн тариа хийлгэх':
        return Icons.schedule;
      case 'Тариа хийлгэх':
        return Icons.medication;
      case 'Шээсний катетр':
        return Icons.medical_services;
      default:
        return Icons.medical_information;
    }
  }

  Widget _buildMedicalCertificateCard() {
    return IOCardBorderWidget(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Эмчийн бичиг',
            style: IOStyles.body1SemiBold.copyWith(color: IOColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Хэрэв танд эмчийн бичиг байвал оруулна уу',
            style:
                IOStyles.body2Regular.copyWith(color: IOColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Obx(() => controller.medicalCertificate.value.isNotEmpty
              ? _buildMedicalCertificatePreview()
              : _buildMedicalCertificateUpload()),
        ],
      ),
    );
  }

  Widget _buildMedicalCertificatePreview() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: IOColors.strokePrimary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: Image.memory(
                base64Decode(controller.medicalCertificate.value
                    .replaceFirst('data:image/jpeg;base64,', '')),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Column(
              children: [
                GestureDetector(
                  onTap: controller.pickMedicalCertificate,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: IOColors.brand600,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: IOColors.backgroundPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: controller.removeMedicalCertificate,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: IOColors.errorPrimary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: IOColors.backgroundPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalCertificateUpload() {
    return GestureDetector(
      onTap: controller.pickMedicalCertificate,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: IOColors.strokePrimary,
            style: BorderStyle.solid,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_photo_alternate_outlined,
              size: 48,
              color: IOColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              'Эмчийн бичиг зураг авах',
              style:
                  IOStyles.body2Regular.copyWith(color: IOColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Та ямар төрлийн эмчилгээ хийлгэх вэ?',
            style: IOStyles.h6.copyWith(color: IOColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Доорх сонголтоос нэгийг сонгоно уу',
            style:
                IOStyles.body2Regular.copyWith(color: IOColors.textSecondary),
          ),
          const SizedBox(height: 24),
          Obx(() {
            if (controller.isLoadingServiceTypes.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.serviceTypes.isEmpty) {
              return Center(
                child: Text(
                  'Үйлчилгээний төрлүүд олдсонгүй',
                  style: IOStyles.body1Regular
                      .copyWith(color: IOColors.textSecondary),
                ),
              );
            }

            return Column(
              children: controller.serviceTypes.asMap().entries.map((entry) {
                final index = entry.key;
                final serviceType = entry.value;

                return Column(
                  children: [
                    _buildServiceTypeCard(
                      title: serviceType.name,
                      subtitle: serviceType.description,
                      icon: _getServiceTypeIcon(serviceType.name),
                      isSelected: controller.preferredServiceType.value ==
                          serviceType.name,
                      onTap: () => controller.preferredServiceType.value =
                          serviceType.name,
                    ),
                    if (index < controller.serviceTypes.length - 1)
                      const SizedBox(height: 12),
                  ],
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildServiceTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: IOCardBorderWidget(
        padding: const EdgeInsets.all(16),
        backgroundColor:
            isSelected ? IOColors.brand50 : IOColors.backgroundPrimary,
        borderColor: isSelected ? IOColors.brand600 : IOColors.strokePrimary,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? IOColors.brand600 : IOColors.strokePrimary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: IOColors.backgroundPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: IOStyles.body1SemiBold.copyWith(
                      color:
                          isSelected ? IOColors.brand600 : IOColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: IOStyles.caption1Regular.copyWith(
                      color: IOColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: IOColors.brand600,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Доорх асуултуудад хариулна уу',
            style: IOStyles.h6.copyWith(color: IOColors.textPrimary),
          ),
          const SizedBox(height: 24),
          _buildQuestionCard(
            question: 'Одоо таны биеийн байдал хэвийн байна уу?',
            q1Yes: controller.q1Yes,
            q1No: controller.q1No,
          ),
          _buildQuestionCard(
            question: 'Танд байнга хэрэглэдэг эм тариа байгаа юу?',
            q1Yes: controller.q2Yes,
            q1No: controller.q2No,
            hasDetails: true,
            detailsField: controller.q2Details,
          ),
          _buildQuestionCard(
            question: 'Танд харшилдаг эм тариа байгаа юу?',
            q1Yes: controller.q3Yes,
            q1No: controller.q3No,
            hasDetails: true,
            detailsField: controller.q3Details,
          ),
          _buildQuestionCard(
            question: 'Чихрийн шижин',
            q1Yes: controller.q4Yes,
            q1No: controller.q4No,
          ),
          _buildQuestionCard(
            question: 'Даралт ихсэх өвчин',
            q1Yes: controller.q5Yes,
            q1No: controller.q5No,
          ),
          _buildQuestionCard(
            question: 'Татаж унах',
            q1Yes: controller.q6Yes,
            q1No: controller.q6No,
          ),
          _buildQuestionCard(
            question: 'Зүрхний эмгэг',
            q1Yes: controller.q7Yes,
            q1No: controller.q7No,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard({
    required String question,
    required RxBool q1Yes,
    required RxBool q1No,
    bool hasDetails = false,
    IOTextfieldModel? detailsField,
  }) {
    return IOCardBorderWidget(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  question,
                  style: IOStyles.body1SemiBold
                      .copyWith(color: IOColors.textPrimary),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '*',
                style: IOStyles.body1SemiBold
                    .copyWith(color: IOColors.errorPrimary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => Row(
                children: [
                  Expanded(
                    child: _buildAnswerChip(
                      title: 'Тийм',
                      isSelected: q1Yes.value,
                      onTap: () {
                        q1Yes.value = true;
                        q1No.value = false;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildAnswerChip(
                      title: 'Үгүй',
                      isSelected: q1No.value,
                      onTap: () {
                        q1Yes.value = false;
                        q1No.value = true;
                      },
                    ),
                  ),
                ],
              )),
          if (hasDetails && detailsField != null)
            Obx(() => q1Yes.value
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: IOTextfieldWidget(model: detailsField),
                  )
                : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildAnswerChip({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? IOColors.brand600 : IOColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? IOColors.brand600 : IOColors.strokePrimary,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: IOStyles.body2Semibold.copyWith(
              color: isSelected
                  ? IOColors.backgroundPrimary
                  : IOColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Сүүлийн алхам',
            style: IOStyles.h6.copyWith(color: IOColors.textPrimary),
          ),
          const SizedBox(height: 24),
          IOCardBorderWidget(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                IOTextFieldLongText(model: controller.questionField),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildMedicalCertificateCard(),
          const SizedBox(height: 16),
          IOCardBorderWidget(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Гарын үсэг',
                  style: IOStyles.body1SemiBold
                      .copyWith(color: IOColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Гарын үсэг зурах замаар та сувилагч таны эрүүл мэндийн мэдээллийг харахыг зөвшөөрч байна.',
                  style: IOStyles.body2Regular
                      .copyWith(color: IOColors.textSecondary),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: IOColors.strokePrimary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Obx(() => controller.signature.value.isNotEmpty
                            ? Center(
                                child: Image.memory(
                                  base64Decode(controller.signature.value
                                      .replaceFirst(
                                          'data:image/png;base64,', '')),
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Signature(
                                controller: controller.sigController,
                                backgroundColor: IOColors.backgroundPrimary,
                              )),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: controller.saveSignatureToBase64,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: IOColors.brand600,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.save_outlined,
                                  size: 16,
                                  color: IOColors.backgroundPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: controller.clearSignature,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: IOColors.errorPrimary,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.clear_outlined,
                                  size: 16,
                                  color: IOColors.backgroundPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IOColors.backgroundPrimary,
        boxShadow: [
          BoxShadow(
            color: IOColors.strokePrimary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (controller.currentStep.value > 0)
              Expanded(
                child: IOButtonWidget(
                  model: IOButtonModel(
                    label: 'Буцах',
                    type: IOButtonType.oulineGray,
                    size: IOButtonSize.large,
                  ),
                  onPressed: controller.previousStep,
                ),
              ),
            if (controller.currentStep.value > 0) const SizedBox(width: 12),
            Expanded(
              flex: controller.currentStep.value == 0 ? 1 : 1,
              child: Obx(() => IOButtonWidget(
                    model: controller.currentStep.value == 2
                        ? controller.nextButton.value
                        : IOButtonModel(
                            label: controller.currentStep.value == 2
                                ? 'Илгээх'
                                : 'Үргэлжлүүлэх',
                            type: IOButtonType.primary,
                            size: IOButtonSize.large,
                            isEnabled:
                                _isStepValid(controller.currentStep.value),
                          ),
                    onPressed: controller.currentStep.value == 2
                        ? controller.onTapSubmitHealthInfo
                        : controller.validateAndProceedToNextStep,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  bool _isStepValid(int step) {
    switch (step) {
      case 0:
        return controller.preferredServiceType.value.isNotEmpty;
      case 1:
        return controller.isStep2Valid();
      case 2:
        return controller.signature.value.isNotEmpty &&
            controller.questionField.controller.text.isNotEmpty;
      default:
        return false;
    }
  }
}
