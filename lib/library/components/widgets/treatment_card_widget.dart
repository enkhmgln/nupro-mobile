import 'package:flutter/material.dart';
import 'package:nuPro/library/components/image/io_image_network_widget.dart';
import 'package:nuPro/library/components/main/io_card_border.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/home/model/treatment_model.dart';
import 'package:nuPro/screens/home/model/nurse_treatment_model.dart';

class TreatmentCardWidget extends StatelessWidget {
  final TreatmentModel? customerItem;
  final NurseTreatmentModel? nurseItem;
  final bool isNurseView;

  const TreatmentCardWidget.customer({
    super.key,
    required TreatmentModel item,
  })  : customerItem = item,
        nurseItem = null,
        isNurseView = false;

  const TreatmentCardWidget.nurse({
    super.key,
    required NurseTreatmentModel item,
  })  : customerItem = null,
        nurseItem = item,
        isNurseView = true;

  @override
  Widget build(BuildContext context) {
    final date = isNurseView
        ? nurseItem!.createdAt.split('T').first
        : customerItem!.createdAt.split('T').first;
    final time = isNurseView
        ? nurseItem!.createdAt.split('T').last.substring(0, 5)
        : customerItem!.createdAt.split('T').last.substring(0, 5);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: IOCardBorderWidget(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 16, color: IOColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: IOStyles.caption1SemiBold
                        .copyWith(color: IOColors.textSecondary),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.access_time_outlined,
                      size: 16, color: IOColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: IOStyles.caption1SemiBold
                        .copyWith(color: IOColors.textSecondary),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(_getStatus()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusDisplay(),
                      style: IOStyles.caption1SemiBold.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: IOColors.backgroundSecondary,
                    child: _getProfilePicture() != null &&
                            _getProfilePicture()!.isNotEmpty
                        ? ClipOval(
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: IOImageNetworkWidget(
                                imageUrl: _getProfilePicture()!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Image.asset(
                            'assets/images/profile.png',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getName(),
                          style: IOStyles.body1Bold
                              .copyWith(color: IOColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getSubtitle(),
                          style: IOStyles.caption1Regular
                              .copyWith(color: IOColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: IOColors.brand50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getServiceType(),
                                  style: IOStyles.caption1SemiBold.copyWith(
                                      color: IOColors.brand500,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: IOColors.brand50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getExperienceText(),
                                  style: IOStyles.caption1SemiBold.copyWith(
                                      color: IOColors.brand500,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_getAmount() != null && _getAmount()! > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.payment,
                                  size: 16, color: IOColors.brand600),
                              const SizedBox(width: 4),
                              Text(
                                '${_getAmount()!.toStringAsFixed(0)} ${_getCurrency() ?? 'MNT'}',
                                style: IOStyles.caption1SemiBold.copyWith(
                                  color: IOColors.brand600,
                                ),
                              ),
                              if (_getPaymentStatus() != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '• ${_getPaymentStatus()}',
                                  style: IOStyles.caption1Regular.copyWith(
                                    color: IOColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return IOColors.warningPrimary;
      case 'accepted':
        return IOColors.brand500;
      case 'completed':
        return IOColors.successPrimary;
      case 'cancelled':
        return IOColors.errorPrimary;
      default:
        return IOColors.textSecondary;
    }
  }

  String? _getProfilePicture() {
    if (isNurseView) {
      return nurseItem!.customerProfilePicture;
    } else {
      return customerItem!.nurseProfilePicture;
    }
  }

  String _getName() {
    if (isNurseView) {
      return 'Хэрэглэгч (${nurseItem!.customerPhone})';
    } else {
      return customerItem!.nurseName;
    }
  }

  String _getSubtitle() {
    if (isNurseView) {
      return nurseItem!.customerLocation;
    } else {
      return customerItem!.nurseHospital;
    }
  }

  String _getExperienceText() {
    if (isNurseView) {
      return 'Нас: ${nurseItem!.customerAge}';
    } else {
      return customerItem!.nurseExperience;
    }
  }

  String _getStatus() {
    if (isNurseView) {
      return nurseItem!.status;
    } else {
      return customerItem!.status;
    }
  }

  String _getStatusDisplay() {
    if (isNurseView) {
      return nurseItem!.statusDisplay;
    } else {
      return customerItem!.statusDisplay;
    }
  }

  String _getServiceType() {
    if (isNurseView) {
      return nurseItem!.serviceType;
    } else {
      return customerItem!.serviceType;
    }
  }

  double? _getAmount() {
    if (isNurseView) {
      return nurseItem!.amount;
    } else {
      return customerItem!.amount;
    }
  }

  String? _getCurrency() {
    if (isNurseView) {
      return nurseItem!.currency;
    } else {
      return customerItem!.currency;
    }
  }

  String? _getPaymentStatus() {
    if (isNurseView) {
      return nurseItem!.paymentStatus;
    } else {
      return customerItem!.paymentStatus;
    }
  }
}
