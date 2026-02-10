import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class CallerHealthInfo {
  final bool isHealthy;
  final bool hasRegularMedication;
  final String regularMedicationDetails;
  final bool hasAllergies;
  final String allergyDetails;
  final bool hasDiabetes;
  final bool hasHypertension;
  final bool hasEpilepsy;
  final bool hasHeartDisease;
  final String medicalConditionsSummary;
  final String additionalNotes;

  const CallerHealthInfo({
    required this.isHealthy,
    required this.hasRegularMedication,
    required this.regularMedicationDetails,
    required this.hasAllergies,
    required this.allergyDetails,
    required this.hasDiabetes,
    required this.hasHypertension,
    required this.hasEpilepsy,
    required this.hasHeartDisease,
    required this.medicalConditionsSummary,
    required this.additionalNotes,
  });

  factory CallerHealthInfo.fromJson(Map<String, dynamic> json) {
    return CallerHealthInfo(
      isHealthy: (json['is_healthy'] ?? false) == true,
      hasRegularMedication: (json['has_regular_medication'] ?? false) == true,
      regularMedicationDetails:
          (json['regular_medication_details'] ?? '').toString(),
      hasAllergies: (json['has_allergies'] ?? false) == true,
      allergyDetails: (json['allergy_details'] ?? '').toString(),
      hasDiabetes: (json['has_diabetes'] ?? false) == true,
      hasHypertension: (json['has_hypertension'] ?? false) == true,
      hasEpilepsy: (json['has_epilepsy'] ?? false) == true,
      hasHeartDisease: (json['has_heart_disease'] ?? false) == true,
      medicalConditionsSummary:
          (json['medical_conditions_summary'] ?? '').toString(),
      additionalNotes: (json['additional_notes'] ?? '').toString(),
    );
  }
}

class IncomingCallModal extends StatelessWidget {
  final String callId;
  final String callerName;
  final String callerPhone;
  final String? profilePicture;
  final String? location; // Free-text address if provided
  final double? latitude; // From caller_location.latitude
  final double? longitude; // From caller_location.longitude
  final CallerHealthInfo? healthInfo; // From caller_health_info
  final String? callStatus; // e.g., pending, accepted
  final String? callType; // e.g., nurse_call
  final DateTime? timestamp; // ISO string parsed
  final VoidCallback onAccept;
  final Function(String reason) onDecline;

  const IncomingCallModal({
    super.key,
    required this.callId,
    required this.callerName,
    required this.callerPhone,
    this.profilePicture,
    this.location,
    this.latitude,
    this.longitude,
    this.healthInfo,
    this.callStatus,
    this.callType,
    this.timestamp,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // ✅ Background gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0A1931), Color(0xFF185ADB)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(color: Colors.black.withOpacity(0.25)),
              ),
            ),

            // ✅ Main Content (scrollable to avoid overflow)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Scrollable content (header + info card)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),

                          Column(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.2),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundImage: profilePicture != null
                                      ? NetworkImage(profilePicture!)
                                      : const AssetImage(
                                              'assets/images/default_avatar.png')
                                          as ImageProvider,
                                ),
                              ).animate().scale(
                                  duration: 400.ms, curve: Curves.easeOutBack),

                              const SizedBox(height: 14),

                              // 🧑‍💼 Name
                              Text(
                                callerName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(callerPhone,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.85),
                                  )),
                              const SizedBox(height: 4),
                              Text(
                                _buildLocationLine(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _buildStatusTypeLine(),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // 📋 Health Info Card
                          _buildInfoCard(),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ✅ Buttons pinned to bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _actionButton(
                        color: Colors.redAccent,
                        icon: Icons.call_end_rounded,
                        label: "Татгалзах",
                        onTap: () async {
                          final reasonController = TextEditingController();
                          final reason = await showModalBottomSheet<String>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (ctx) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                                ),
                                child: Center(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                      width:
                                          MediaQuery.of(ctx).size.width * 0.85,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 28),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 32,
                                            offset: Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Татгалзах шалтгаан',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.close,
                                                    size: 28,
                                                    color: Colors.grey),
                                                onPressed: () =>
                                                    Navigator.of(ctx).pop(),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: TextField(
                                              controller: reasonController,
                                              maxLines: 4,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black87),
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Шалтгаанаа бичнэ үү...',
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 14),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 14),
                                            ),
                                            onPressed: () {
                                              final reason =
                                                  reasonController.text.trim();
                                              if (reason.isNotEmpty) {
                                                Navigator.of(ctx).pop(reason);
                                              }
                                            },
                                            child: const Text(
                                              'Цуцлах',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
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
                          if (reason != null && reason.isNotEmpty) {
                            onDecline(reason);
                            Get.back();
                            // Rating screen removed as requested
                          }
                        },
                      ),
                      _actionButton(
                        color: Colors.greenAccent,
                        icon: Icons.call_rounded,
                        label: "Хүлээн авах",
                        onTap: () {
                          onAccept();
                          Get.back();
                        },
                      ),
                    ],
                  ).animate().fadeIn(duration: 500.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxHeight: 260, // Adjust for design and device size
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🩺 Эрүүл мэндийн мэдээлэл",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            if (healthInfo != null) ...[
              _infoRow(
                "Ерөнхий эрүүл мэнд",
                healthInfo!.isHealthy ? "Эрүүл" : "Өвчтэй",
              ),
              _infoRow(
                "Эмийн хэрэглээ",
                healthInfo!.hasRegularMedication
                    ? (healthInfo!.regularMedicationDetails.isNotEmpty
                        ? "Тийм • ${healthInfo!.regularMedicationDetails}"
                        : "Тийм")
                    : "Үгүй",
              ),
              _infoRow(
                "Харшил",
                healthInfo!.hasAllergies
                    ? (healthInfo!.allergyDetails.isNotEmpty
                        ? "Тийм • ${healthInfo!.allergyDetails}"
                        : "Тийм")
                    : "Үгүй",
              ),
              _infoRow(
                  "Чихрийн шижин", healthInfo!.hasDiabetes ? "Тийм" : "Үгүй"),
              _infoRow("Даралт", healthInfo!.hasHypertension ? "Тийм" : "Үгүй"),
              _infoRow("Таталт", healthInfo!.hasEpilepsy ? "Тийм" : "Үгүй"),
              _infoRow("Зүрхний өвчин",
                  healthInfo!.hasHeartDisease ? "Тийм" : "Үгүй"),
              if (healthInfo!.medicalConditionsSummary.isNotEmpty)
                _infoRow("Онош/Товч", healthInfo!.medicalConditionsSummary),
              if (healthInfo!.additionalNotes.isNotEmpty)
                _infoRow("Бусад тэмдэглэл", healthInfo!.additionalNotes),
            ] else ...[
              _infoRow("Эрүүл мэндийн мэдээлэл", "Мэдээлэлгүй"),
            ],
            const Divider(color: Colors.white24, height: 20),
            _infoRow("Дуудлагын төрөл", _mapCallType(callType) ?? '-'),
            _infoRow("Статус", callStatus?.toUpperCase() ?? '-'),
            _infoRow("Цаг", _formatTimestamp(timestamp)),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  String _buildLocationLine() {
    if (location != null && location!.isNotEmpty) return location!;
    if (latitude != null && longitude != null) {
      return "${latitude!.toStringAsFixed(5)}, ${longitude!.toStringAsFixed(5)}";
    }
    return 'Байршлын мэдээлэл байхгүй';
  }

  String _buildStatusTypeLine() {
    final type = _mapCallType(callType);
    final status = (callStatus ?? '').isNotEmpty ? callStatus : null;
    if (type != null && status != null) return '$type • $status';
    if (type != null) return type;
    if (status != null) return status;
    return '';
  }

  String? _mapCallType(String? type) {
    switch (type) {
      case 'nurse_call':
        return 'Сувилагчийн дуудлага';
      case 'doctor_call':
        return 'Эмчийн дуудлага';
      default:
        return type;
    }
  }

  String _formatTimestamp(DateTime? ts) {
    if (ts == null) return '-';
    // Simple local formatting: yyyy-MM-dd HH:mm
    final d = DateTime.fromMillisecondsSinceEpoch(ts.millisecondsSinceEpoch)
        .toLocal();
    final mm = d.minute.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final mon = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mon-$day $hh:$mm';
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),
          Flexible(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required Color color,
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.8), width: 1.8),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
