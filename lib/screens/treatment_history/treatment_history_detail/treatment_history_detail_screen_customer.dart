import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/main/io_loading.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/home/model/treatment_model.dart';
import 'package:nuPro/screens/treatment_history/treatment_history_detail/treatment_history_detail_controller_customer.dart';
import 'package:intl/intl.dart';

class TreatmentHistoryDetailScreenCustomer extends StatelessWidget {
  final TreatmentModel item;

  const TreatmentHistoryDetailScreenCustomer({super.key, required this.item});

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TreatmentHistoryDetailControllerCustomer>(
      init: TreatmentHistoryDetailControllerCustomer(item: item),
      builder: (controller) {
        final detail = controller.detailInfo;
        final nurse = detail?.nurse;
        final payment = detail?.payment;
        final call = detail?.call;
        final healthInfo = controller.healthInfo;

        return IOScaffold(
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: IOColors.backgroundPrimary,
              boxShadow: [
                BoxShadow(
                  color: IOColors.textQuarternary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SafeArea(
                child: Obx(
                  () => IOButtonWidget(
                    model: controller.reCallButton.value,
                    onPressed: controller.repeatCall,
                  ),
                ),
              ),
            ),
          ),
          appBar: IOAppBar(
            titleText: 'Дэлгэрэнгүй',
          ),
          body: Obx(
            () => controller.isLoading.value
                ? const Center(child: IOLoading())
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Nurse Information Card
                          _buildSectionCard(
                            title: 'Сувилагчийн мэдээлэл',
                            icon: Icons.person_outline_rounded,
                            color: IOColors.brand500,
                            child: Column(
                              children: [
                                _buildProfileHeader(
                                  imageUrl: nurse?.profilePicture ??
                                      item.nurseProfilePicture ??
                                      '',
                                  name:
                                      '${nurse?.firstName ?? ''} ${nurse?.lastName ?? ''}',
                                  phone: nurse?.phoneNumber ?? item.nursePhone,
                                  isVerified: nurse?.isVerified ?? false,
                                ),
                                const SizedBox(height: 20),
                                if (nurse?.specializations != null &&
                                    nurse!.specializations!.isNotEmpty)
                                  _buildInfoRow(
                                    Icons.medical_services_outlined,
                                    'Мэргэжил',
                                    nurse.specializations!
                                        .map((s) => s.name)
                                        .join(', '),
                                    IOColors.brand600,
                                  ),
                                if (nurse?.experienceLevel != null)
                                  _buildInfoRow(
                                    Icons.workspace_premium_outlined,
                                    'Туршлага',
                                    '${nurse?.experienceLevel} (${nurse?.workedYears ?? 0} жил)',
                                    IOColors.warningPrimary,
                                  ),
                                if (nurse?.hospital != null)
                                  _buildInfoRow(
                                    Icons.local_hospital_outlined,
                                    'Эмнэлэг',
                                    nurse?.hospital?.name ?? '',
                                    IOColors.infoPrimary,
                                  ),
                                if (nurse?.averageRating != null)
                                  _buildInfoRow(
                                    Icons.star_rounded,
                                    'Үнэлгээ',
                                    '${nurse?.averageRating?.averageRating ?? 0} ⭐ (${nurse?.averageRating?.totalRatings ?? 0} үнэлгээ)',
                                    IOColors.warningPrimary,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Call Status Card
                          _buildSectionCard(
                            title: 'Үйлчилгээний мэдээлэл',
                            icon: Icons.phone_in_talk_outlined,
                            color: IOColors.brand600,
                            child: Column(
                              children: [
                                _buildInfoRow(
                                  Icons.qr_code_2_outlined,
                                  'Дуудлагын дугаар',
                                  '#${call?.id ?? item.id}',
                                  IOColors.brand600,
                                ),
                                const SizedBox(height: 8),
                                _buildTimeline(
                                  serviceType: item.serviceType,
                                  status: call?.status ?? item.status,
                                  statusDisplay:
                                      call?.statusDisplay ?? item.statusDisplay,
                                  createdAt: call?.createdAt ?? item.createdAt,
                                  acceptedAt: call?.acceptedAt,
                                  completedAt: call?.completedAt,
                                  paymentAmount: (payment?.amount != null &&
                                          payment!.amount!.isNotEmpty)
                                      ? double.tryParse(payment.amount!)
                                      : item.amount,
                                  paymentStatus: payment?.paymentStatus ??
                                      item.paymentStatus,
                                  paymentPaidAt: payment?.paidAt,
                                ),
                                if (call?.completionCode != null)
                                  _buildInfoRow(
                                    Icons.lock_outline_rounded,
                                    'Баталгаажуулах код',
                                    call?.completionCode ?? '',
                                    IOColors.warningPrimary,
                                  ),
                                if (item.nurseNotes != null &&
                                    item.nurseNotes!.isNotEmpty)
                                  _buildInfoRow(
                                    Icons.note_outlined,
                                    'Тэмдэглэл',
                                    item.nurseNotes!,
                                    IOColors.brand700,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Health Information Card
                          if (healthInfo != null)
                            _buildSectionCard(
                              title: 'Эрүүл мэндийн мэдээлэл',
                              icon: Icons.health_and_safety_outlined,
                              color: IOColors.errorPrimary,
                              child: Column(
                                children: [
                                  _buildHealthStatus('Эрүүл мэнд',
                                      healthInfo.isHealthy ?? false),
                                  if (healthInfo.medicalConditionsSummary
                                          ?.isNotEmpty ==
                                      true)
                                    _buildInfoRow(
                                      Icons.warning_amber_rounded,
                                      'Өвчний хураангуй',
                                      healthInfo.medicalConditionsSummary!,
                                      IOColors.warningPrimary,
                                    ),
                                  _buildHealthStatus('Тогтмол эм',
                                      healthInfo.hasRegularMedication ?? false),
                                  if (healthInfo.regularMedicationDetails
                                          ?.isNotEmpty ==
                                      true)
                                    _buildInfoRow(
                                      Icons.medication_outlined,
                                      'Эмийн дэлгэрэнгүй',
                                      healthInfo.regularMedicationDetails!,
                                      IOColors.secondary500,
                                    ),
                                  _buildHealthStatus('Харшил',
                                      healthInfo.hasAllergies ?? false),
                                  if (healthInfo.allergyDetails?.isNotEmpty ==
                                      true)
                                    _buildInfoRow(
                                      Icons.info_outline_rounded,
                                      'Харшлын дэлгэрэнгүй',
                                      healthInfo.allergyDetails!,
                                      IOColors.errorPrimary,
                                    ),
                                  _buildHealthStatus('Чихрийн шижин',
                                      healthInfo.hasDiabetes ?? false),
                                  _buildHealthStatus('Цусны даралт',
                                      healthInfo.hasHypertension ?? false),
                                  _buildHealthStatus('Татаж унах',
                                      healthInfo.hasEpilepsy ?? false),
                                  _buildHealthStatus('Зүрхний өвчин',
                                      healthInfo.hasHeartDisease ?? false),
                                  if (healthInfo.preferredServiceType != null)
                                    _buildInfoRow(
                                      Icons.favorite_outline_rounded,
                                      'Сонгосон үйлчилгээ',
                                      healthInfo.preferredServiceType!.name ??
                                          '-',
                                      IOColors.brand600,
                                    ),
                                  if (healthInfo.additionalNotes?.isNotEmpty ==
                                      true)
                                    _buildInfoRow(
                                      Icons.note_alt_outlined,
                                      'Нэмэлт тэмдэглэл',
                                      healthInfo.additionalNotes!,
                                      IOColors.textSecondary,
                                    ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: IOColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: IOColors.textQuarternary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.12),
                  color.withOpacity(0.08),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: IOStyles.h6.copyWith(color: color),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader({
    required String imageUrl,
    required String name,
    required String phone,
    required bool isVerified,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: IOColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: IOColors.brand200,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 36,
                  backgroundImage:
                      imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  backgroundColor: IOColors.backgroundTertiary,
                  child: imageUrl.isEmpty
                      ? const Icon(Icons.person,
                          size: 36, color: IOColors.textTertiary)
                      : null,
                ),
              ),
              if (isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: IOColors.brand500,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: IOColors.backgroundPrimary, width: 2),
                    ),
                    child: const Icon(
                      Icons.verified,
                      size: 14,
                      color: IOColors.backgroundPrimary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.trim().isEmpty ? 'Сувилагч' : name,
                  style: IOStyles.body1Bold.copyWith(
                    color: IOColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined,
                        size: 16, color: IOColors.textTertiary),
                    const SizedBox(width: 6),
                    Text(
                      phone,
                      style: IOStyles.body2Regular.copyWith(
                        color: IOColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: IOStyles.caption1Medium.copyWith(
                    color: IOColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: IOStyles.body2Semibold.copyWith(
                    color: IOColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthStatus(String label, bool status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: status
                  ? IOColors.successSecondary
                  : IOColors.backgroundTertiary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              status ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color:
                  status ? IOColors.successPrimary : IOColors.textQuarternary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: IOStyles.body2Regular.copyWith(
                color: IOColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline({
    required String serviceType,
    required String status,
    required String statusDisplay,
    required String? createdAt,
    String? acceptedAt,
    String? completedAt,
    double? paymentAmount,
    String? paymentStatus,
    String? paymentPaidAt,
  }) {
    final steps = <TimelineStep>[];

    steps.add(TimelineStep(
      title: 'Үүсгэсэн',
      subtitle: serviceType,
      date: createdAt,
      isCompleted: true,
      icon: Icons.add_circle_outline,
      color: IOColors.brand500,
    ));

    // Step 2: Accepted
    final isAccepted = acceptedAt != null ||
        ['accepted', 'completed'].contains(status.toLowerCase());
    steps.add(TimelineStep(
      title: 'Хүлээн авсан',
      subtitle: null,
      date: acceptedAt,
      isCompleted: isAccepted,
      isActive: status.toLowerCase() == 'accepted',
      icon: Icons.check_circle_outline,
      color: IOColors.infoPrimary,
    ));

    // Step 3: Payment
    final isPaymentPaid =
        paymentStatus?.toLowerCase() == 'paid' || paymentPaidAt != null;
    final paymentTitle = isPaymentPaid ? 'Төлбөр төлсөн' : 'Төлбөр';
    final paymentSubtitle = paymentAmount != null && paymentAmount > 0
        ? '${paymentAmount.toInt()} ₮'
        : null;
    steps.add(TimelineStep(
      title: paymentTitle,
      subtitle: paymentSubtitle,
      date: paymentPaidAt,
      isCompleted: isPaymentPaid,
      isActive: paymentStatus?.toLowerCase() == 'pending',
      icon: Icons.payment_outlined,
      color: IOColors.warningPrimary,
    ));

    // Step 4: Completed
    final isCompleted =
        completedAt != null || status.toLowerCase() == 'completed';
    steps.add(TimelineStep(
      title: 'Дууссан',
      subtitle: null,
      date: completedAt,
      isCompleted: isCompleted,
      isActive: status.toLowerCase() == 'completed',
      icon: Icons.done_all_rounded,
      color: IOColors.successPrimary,
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Үйлчилгээний явц',
          style: IOStyles.body2Semibold.copyWith(
            color: IOColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isLast = index == steps.length - 1;

          return _buildTimelineStep(
            step: step,
            isLast: isLast,
            nextStepCompleted: !isLast && steps[index + 1].isCompleted,
          );
        }),
      ],
    );
  }

  Widget _buildTimelineStep({
    required TimelineStep step,
    required bool isLast,
    required bool nextStepCompleted,
  }) {
    final isActive = step.isActive;
    final isCompleted = step.isCompleted;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line and icon
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted || isActive
                    ? step.color.withOpacity(0.15)
                    : IOColors.backgroundTertiary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted || isActive
                      ? step.color
                      : IOColors.textQuarternary,
                  width: 2,
                ),
              ),
              child: Icon(
                step.icon,
                color: isCompleted || isActive
                    ? step.color
                    : IOColors.textQuarternary,
                size: 20,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted || nextStepCompleted
                      ? step.color.withOpacity(0.3)
                      : IOColors.strokePrimary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Content
        Expanded(
          child: Padding(
            padding:
                EdgeInsets.only(top: isLast ? 0 : 8, bottom: isLast ? 16 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: IOStyles.body2Semibold.copyWith(
                    color: isCompleted || isActive
                        ? IOColors.textPrimary
                        : IOColors.textTertiary,
                  ),
                ),
                if (step.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      step.subtitle!,
                      style: IOStyles.body2Medium.copyWith(
                        color: IOColors.textPrimary,
                      ),
                    ),
                  ),
                if (step.date != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _formatDateTime(step.date),
                      style: IOStyles.caption1Regular.copyWith(
                        color: IOColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TimelineStep {
  final String title;
  final String? subtitle;
  final String? date;
  final bool isCompleted;
  final bool isActive;
  final IconData icon;
  final Color color;

  TimelineStep({
    required this.title,
    this.subtitle,
    this.date,
    required this.isCompleted,
    this.isActive = false,
    required this.icon,
    required this.color,
  });
}
