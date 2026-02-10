import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/image/io_image_network_widget.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/home/home_call_google_map/home_call_google_map_controller.dart';
import 'package:nuPro/screens/home/home_questionnaire/model/health_info_model.dart';

class NurseMapInfoWidget extends GetView<HomeCallGoogleMapController> {
  final NearestNursesModel nurse;

  const NurseMapInfoWidget({
    super.key,
    required this.nurse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _containerDecoration,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNurseCard(),
              const SizedBox(height: 16),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNurseCard() {
    return Container(
      decoration: BoxDecoration(
        color: IOColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: IOColors.brand600,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Сувилагч',
                  style: IOStyles.h6.copyWith(color: IOColors.textPrimary),
                ),
              ],
            ),
          ),

          // Nurse info
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                // Profile picture
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: IOColors.brand600, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: nurse.profilePicture != null &&
                            nurse.profilePicture!.isNotEmpty
                        ? IOImageNetworkWidget(
                            imageUrl: nurse.profilePicture!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: IOColors.strokePrimary,
                            child: const Icon(
                              Icons.person,
                              size: 24,
                              color: IOColors.textSecondary,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),

                // Nurse details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              nurse.fullName ?? 'Мэдээлэл алга',
                              style: IOStyles.body1SemiBold
                                  .copyWith(color: IOColors.textPrimary),
                            ),
                          ),
                          if (nurse.isVerified == true)
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1877F2),
                                    Color(0xFF42A5F5)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1877F2)
                                        .withOpacity(0.4),
                                    blurRadius: 6,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.verified,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        nurse.experienceLevel ?? '',
                        style: IOStyles.body2Regular.copyWith(
                          color: IOColors.brand600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: IOColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              nurse.hospital ?? '',
                              style: IOStyles.caption1Regular.copyWith(
                                color: IOColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(
                color: IOColors.strokePrimary.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Stats grid
                Row(
                  children: [
                    Expanded(
                      child: _buildProfessionalStat(
                        icon: Icons.star_rounded,
                        value: nurse.averageRating != null &&
                                nurse.averageRating! > 0
                            ? nurse.averageRating!.toStringAsFixed(1)
                            : '—',
                        label: 'Үнэлгээ',
                        subtitle: nurse.totalRatings != null &&
                                nurse.totalRatings! > 0
                            ? '${nurse.totalRatings} үнэлгээ'
                            : 'Үнэлгээ байхгүй',
                        color: const Color(0xFFFF9500), // Orange
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildProfessionalStat(
                        icon: Icons.work_history_rounded,
                        value: '${nurse.workedYears ?? 0}',
                        label: 'Туршлага',
                        subtitle: 'жил',
                        color: const Color(0xFF007AFF), // Blue
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Distance row
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: IOColors.backgroundPrimary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: IOColors.strokePrimary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF34C759).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          size: 20,
                          color: Color(0xFF34C759),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Зай',
                              style: IOStyles.caption1Regular.copyWith(
                                color: IOColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${nurse.distanceKm?.toStringAsFixed(1) ?? "0.0"} км',
                              style: IOStyles.body1SemiBold.copyWith(
                                color: IOColors.textPrimary,
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

  Widget _buildProfessionalStat({
    required IconData icon,
    required String value,
    required String label,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IOColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: IOColors.strokePrimary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const Spacer(),
              Text(
                value,
                style: IOStyles.h5.copyWith(
                  color: IOColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: IOStyles.body2Semibold.copyWith(
              color: IOColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: IOStyles.caption1Regular.copyWith(
              color: IOColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Obx(() {
      final isLoading = controller.loadingNurseId.value == nurse.id;

      return GestureDetector(
        onTap: isLoading ? null : () => controller.sendCallToNurse(nurse),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: isLoading ? IOColors.strokePrimary : IOColors.brand600,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        IOColors.backgroundPrimary),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Дуудаж байна...',
                  style: IOStyles.body2Semibold
                      .copyWith(color: IOColors.backgroundPrimary),
                ),
              ] else ...[
                const Icon(Icons.call,
                    size: 20, color: IOColors.backgroundPrimary),
                const SizedBox(width: 8),
                Text(
                  'Дуудах',
                  style: IOStyles.body2Semibold
                      .copyWith(color: IOColors.backgroundPrimary),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  BoxDecoration get _containerDecoration => BoxDecoration(
        color: IOColors.backgroundPrimary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(width: 0.1),
      );
}
