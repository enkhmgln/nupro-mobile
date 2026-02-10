import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/main/io_empty.dart';
import 'package:nuPro/library/components/main/io_loading.dart';
import 'package:nuPro/library/components/main/main.dart';
import 'package:nuPro/library/components/widgets/treatment_card_widget.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/library/shared/helper_manager.dart';
import 'package:nuPro/screens/treatment_history/treatment_schedule/treatment_schedule_controller.dart';

class TreatmentScheduleScreen extends GetView<TreatmentScheduleController> {
  const TreatmentScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IOAppBar(
        title: Text('Үйлчилгээний түүх',
            style: IOStyles.body1Bold.copyWith(
              color: IOColors.backgroundPrimary,
            )),
      ),
      body: Obx(() {
        final history = controller.history;
        final isLoading = controller.isLoading.value;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Огноо',
                            style: IOStyles.body1SemiBold.copyWith(
                              color: IOColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  IOColors.backgroundSecondary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: IOColors.brand500.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                  color: IOColors.brand500,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => controller.selectStartDate(),
                                    child: Text(
                                      controller.startDate.value != null
                                          ? '${controller.startDate.value!.year}-${controller.startDate.value!.month.toString().padLeft(2, '0')}-${controller.startDate.value!.day.toString().padLeft(2, '0')}'
                                          : 'Эхлэх огноо',
                                      style: IOStyles.body1Regular.copyWith(
                                        color:
                                            controller.startDate.value != null
                                                ? IOColors.textPrimary
                                                : IOColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 20,
                                  color:
                                      IOColors.textSecondary.withOpacity(0.3),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                  color: IOColors.brand500,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => controller.selectEndDate(),
                                    child: Text(
                                      controller.endDate.value != null
                                          ? '${controller.endDate.value!.year}-${controller.endDate.value!.month.toString().padLeft(2, '0')}-${controller.endDate.value!.day.toString().padLeft(2, '0')}'
                                          : 'Дуусах огноо',
                                      style: IOStyles.body1Regular.copyWith(
                                        color: controller.endDate.value != null
                                            ? IOColors.textPrimary
                                            : IOColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildQuickDateButton(
                                    'Өчигдөр',
                                    'yesterday',
                                    () => controller
                                        .setQuickDateRange('yesterday')),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: _buildQuickDateButton(
                                    '7 хоног',
                                    '7days',
                                    () =>
                                        controller.setQuickDateRange('7days')),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: _buildQuickDateButton(
                                    '1 сар',
                                    '1month',
                                    () =>
                                        controller.setQuickDateRange('1month')),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: _buildQuickDateButton(
                                    '3 сар',
                                    '3months',
                                    () => controller
                                        .setQuickDateRange('3months')),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: IOColors.backgroundSecondary,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Төлөв',
                          style: IOStyles.body1SemiBold.copyWith(
                            color: IOColors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _buildStatusChip('Бүгд', '',
                                controller.selectedStatus.value == ''),
                            _buildStatusChip('Хүлээгдэж буй', 'pending',
                                controller.selectedStatus.value == 'pending'),
                            _buildStatusChip('Зөвшөөрөгдсөн', 'accepted',
                                controller.selectedStatus.value == 'accepted'),
                            _buildStatusChip('Дууссан', 'completed',
                                controller.selectedStatus.value == 'completed'),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: IOColors.backgroundSecondary,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: controller.clearFilters,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: IOColors.textSecondary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                              child: Text(
                                'Цэвэрлэх',
                                style: IOStyles.caption1SemiBold.copyWith(
                                  color: IOColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: controller.applyFilters,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: IOColors.brand500,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                elevation: 0,
                              ),
                              child: Text(
                                'Хайх',
                                style: IOStyles.caption1SemiBold.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: IOLoading()),
                ),
              )
            else if (history.isEmpty)
              const SliverFillRemaining(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Center(
                    child: IOEmptyWidget(
                      text: 'Үйлчилгээний түүх олдсонгүй',
                      icon: 'history-svgrepo-com.svg',
                    ),
                  ),
                ),
              ),
            if (history.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = history[index];
                    final userType = HelperManager.profileInfo.userType;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: GestureDetector(
                        onTap: () => controller.toTreatmentHistoryDetail(item),
                        child: userType == 'nurse'
                            ? TreatmentCardWidget.nurse(item: item)
                            : TreatmentCardWidget.customer(item: item),
                      ),
                    );
                  },
                  childCount: history.length,
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildQuickDateButton(String label, String range, VoidCallback onTap) {
    final isActive = _isQuickDateActive(range);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: isActive
              ? IOColors.brand500
              : IOColors.backgroundSecondary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive
                ? IOColors.brand500
                : IOColors.brand500.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: IOStyles.caption1SemiBold.copyWith(
            color: isActive ? Colors.white : IOColors.textPrimary,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  bool _isQuickDateActive(String range) {
    final now = DateTime.now();
    final startDate = controller.startDate.value;
    final endDate = controller.endDate.value;

    if (startDate == null || endDate == null) return false;

    switch (range) {
      case 'yesterday':
        final yesterday = now.subtract(const Duration(days: 1));
        return startDate.year == yesterday.year &&
            startDate.month == yesterday.month &&
            startDate.day == yesterday.day &&
            endDate.year == yesterday.year &&
            endDate.month == yesterday.month &&
            endDate.day == yesterday.day;
      case '7days':
        final sevenDaysAgo = now.subtract(const Duration(days: 7));
        return startDate.year == sevenDaysAgo.year &&
            startDate.month == sevenDaysAgo.month &&
            startDate.day == sevenDaysAgo.day &&
            endDate.year == now.year &&
            endDate.month == now.month &&
            endDate.day == now.day;
      case '1month':
        final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
        return startDate.year == oneMonthAgo.year &&
            startDate.month == oneMonthAgo.month &&
            startDate.day == oneMonthAgo.day &&
            endDate.year == now.year &&
            endDate.month == now.month &&
            endDate.day == now.day;
      case '3months':
        final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        return startDate.year == threeMonthsAgo.year &&
            startDate.month == threeMonthsAgo.month &&
            startDate.day == threeMonthsAgo.day &&
            endDate.year == now.year &&
            endDate.month == now.month &&
            endDate.day == now.day;
      default:
        return false;
    }
  }

  Widget _buildStatusChip(String label, String status, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.setStatusFilter(status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? IOColors.brand500
              : IOColors.backgroundSecondary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? IOColors.brand500
                : IOColors.brand500.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: IOStyles.caption1SemiBold.copyWith(
            color: isSelected ? Colors.white : IOColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
