import 'package:flutter/material.dart';
import 'package:nuPro/library/client/models/call_detail_info.dart';
import 'package:nuPro/library/components/image/io_image_network_widget.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';

class NurseInfoBottomSheet extends StatelessWidget {
  final CallDetailInfoModel callDetailInfoModel;

  const NurseInfoBottomSheet({
    super.key,
    required this.callDetailInfoModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: IOColors.backgroundPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildDragIndicator(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 8,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileRow(),
                      const SizedBox(height: 24),
                      _buildDistenceRow(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          height: 4,
          width: 36,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            IOColors.brand500.withOpacity(0.1),
            IOColors.brand500.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: IOColors.brand500.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: IOColors.brand500.withOpacity(0.3),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: IOColors.brand500.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: SizedBox(
                width: 70,
                height: 70,
                child: IOImageNetworkWidget(
                  imageUrl: callDetailInfoModel.customerProfilePicture,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${callDetailInfoModel.customerLastName} ${callDetailInfoModel.customerFirstName}',
                  style: IOStyles.body1Bold.copyWith(
                    color: IOColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: IOColors.brand500.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Дуудлагийн дугаар: ${callDetailInfoModel.id}',
                    style: IOStyles.body2Medium.copyWith(
                      color: IOColors.brand500,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (callDetailInfoModel.statusDisplay.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(callDetailInfoModel.status)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Дуудлагийн төлөв: ${callDetailInfoModel.statusDisplay}",
                      style: IOStyles.body2Medium.copyWith(
                        color: _getStatusColor(callDetailInfoModel.status),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return IOColors.textSecondary;
    }
  }

  Widget _buildDistenceRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic Information Section
        _buildInfoCard(
          title: 'Үндсэн мэдээлэл',
          icon: Icons.person_outline,
          color: Colors.blue,
          children: [
            _buildInfoRow('Хүйс', callDetailInfoModel.customerSex, Icons.wc),
            _buildInfoRow('Төрсөн он сар өдөр',
                callDetailInfoModel.customerDateOfBirth, Icons.cake),
            _buildInfoRow(
                'Эмчилгээний төрөл',
                callDetailInfoModel.customerPreferredServiceTypeName.isNotEmpty
                    ? callDetailInfoModel.customerPreferredServiceTypeName
                    : callDetailInfoModel.customerPreferredServiceType,
                Icons.medical_services),
            _buildInfoRow('Хүссэн цаг',
                callDetailInfoModel.customerPreferredTime, Icons.access_time),
          ],
        ),

        const SizedBox(height: 16),

        // Location Information Section
        _buildInfoCard(
          title: 'Байршил',
          icon: Icons.location_on_outlined,
          color: Colors.green,
          children: [
            _buildInfoRow(
                'Хот', callDetailInfoModel.customerCity, Icons.location_city),
            _buildInfoRow(
                'Дүүрэг', callDetailInfoModel.customerDistrict, Icons.map),
            _buildInfoRow(
                'Хороо', callDetailInfoModel.customerSubDistrict, Icons.home),
            if (callDetailInfoModel.customerLocation.isNotEmpty)
              _buildInfoRow('Дэлгэрэнгүй хаяг',
                  callDetailInfoModel.customerLocation, Icons.place),
          ],
        ),

        const SizedBox(height: 16),

        // Health Information Section
        _buildInfoCard(
          title: 'Эрүүл мэндийн мэдээлэл',
          icon: Icons.health_and_safety_outlined,
          color: Colors.red,
          children: [
            _buildInfoRow(
                'Эрүүл мэндийн байдал',
                callDetailInfoModel.customerHealthStatus
                    ? 'Сайн'
                    : 'Асуудалтай',
                callDetailInfoModel.customerHealthStatus
                    ? Icons.check_circle
                    : Icons.warning),
            if (callDetailInfoModel.customerHasMedication)
              _buildInfoRow(
                  'Эм уудаг',
                  callDetailInfoModel.customerMedicationDetails,
                  Icons.medication),
            if (callDetailInfoModel.customerHasAllergies)
              _buildInfoRow(
                  'Харшилтай',
                  callDetailInfoModel.customerAllergyDetails,
                  Icons.warning_amber),
            if (callDetailInfoModel.customerMedicalConditionsSummary.isNotEmpty)
              _buildInfoRow(
                  'Үйлчилгээний түүх',
                  callDetailInfoModel.customerMedicalConditionsSummary,
                  Icons.history_edu),
            if (callDetailInfoModel.customerAdditionalHealthNotes.isNotEmpty)
              _buildInfoRow(
                  'Нэмэлт тэмдэглэл',
                  callDetailInfoModel.customerAdditionalHealthNotes,
                  Icons.note),
          ],
        ),

        const SizedBox(height: 16),

        // Payment Information Section
        if (callDetailInfoModel.paymentAmount.isNotEmpty)
          _buildInfoCard(
            title: 'Төлбөрийн мэдээлэл',
            icon: Icons.payment_outlined,
            color: Colors.purple,
            children: [
              _buildInfoRow(
                  'Төлбөрийн хэмжээ',
                  '${callDetailInfoModel.paymentAmount} ${callDetailInfoModel.paymentCurrency}',
                  Icons.attach_money),
              _buildInfoRow('Төлбөрийн статус',
                  callDetailInfoModel.paymentStatus, Icons.info),
            ],
          ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
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
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: IOStyles.body1Bold.copyWith(
                    color: IOColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: IOColors.backgroundSecondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: IOColors.strokePrimary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: IOColors.brand500.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: IOColors.brand500,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: IOStyles.body2Medium.copyWith(
                    color: IOColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: IOStyles.body2Regular.copyWith(
                    color: IOColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
