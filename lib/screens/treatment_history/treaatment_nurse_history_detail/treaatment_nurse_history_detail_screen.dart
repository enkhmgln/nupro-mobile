import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/main/io_appbar.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/home/model/nurse_treatment_model.dart';
import 'package:nuPro/screens/treatment_history/treaatment_nurse_history_detail/treaatment_nurse_history_detail_controller.dart';
import 'package:intl/intl.dart';

class TreaatmentNurseHistoryDetailScreen extends StatelessWidget {
  final NurseTreatmentModel item;
  const TreaatmentNurseHistoryDetailScreen({super.key, required this.item});

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
    return GetBuilder<TreatmentNurseHistoryDetailController>(
      init: TreatmentNurseHistoryDetailController(item: item),
      builder: (controller) {
        return IOScaffold(
          appBar: IOAppBar(
            titleText: 'Дэлгэрэнгүй',
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Customer Information Card
                  _buildSectionCard(
                    title: 'Захиалагчийн мэдээлэл',
                    icon: Icons.person_outline_rounded,
                    color: IOColors.brand500,
                    child: Column(
                      children: [
                        _buildProfileHeader(
                          imageUrl: item.customerProfilePicture ?? '',
                          phone: item.customerPhone,
                        ),
                        const SizedBox(height: 20),
                        _buildInfoRow(
                          Icons.location_on_outlined,
                          'Байршил',
                          item.customerLocation,
                          IOColors.errorPrimary,
                        ),
                        _buildInfoRow(
                          Icons.cake_outlined,
                          'Нас',
                          '${item.customerAge} нас',
                          IOColors.secondary500,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Service Information Card
                  _buildSectionCard(
                    title: 'Үйлчилгээний мэдээлэл',
                    icon: Icons.medical_services_outlined,
                    color: IOColors.brand600,
                    child: Column(
                      children: [
                        _buildInfoRow(
                          Icons.qr_code_2_outlined,
                          'Дуудлагын дугаар',
                          '#${item.id}',
                          IOColors.brand600,
                        ),
                        const SizedBox(height: 8),
                        _buildTimeline(
                          serviceType: item.serviceType,
                          status: item.status,
                          statusDisplay: item.statusDisplay,
                          createdAt: item.createdAt,
                          acceptedAt: item.acceptedAt,
                          completedAt: item.completedAt,
                          paymentAmount: item.amount,
                          paymentStatus: item.paymentStatus,
                          paymentCurrency: item.currency,
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
                ],
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
    required String phone,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: IOColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Захиалагч',
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

  Widget _buildTimeline({
    required String serviceType,
    required String status,
    required String statusDisplay,
    required String? createdAt,
    String? acceptedAt,
    String? completedAt,
    double? paymentAmount,
    String? paymentStatus,
    String? paymentCurrency,
  }) {
    final steps = <TimelineStep>[];

    // Step 1: Created (always present)
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
    final isPaymentPaid = paymentStatus?.toLowerCase() == 'paid';
    final paymentTitle = isPaymentPaid ? 'Төлбөр төлсөн' : 'Төлбөр';
    final paymentSubtitle = paymentAmount != null && paymentAmount > 0
        ? '${paymentAmount.toInt()} ${paymentCurrency ?? '₮'}'
        : null;
    steps.add(TimelineStep(
      title: paymentTitle,
      subtitle: paymentSubtitle,
      date: null,
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
