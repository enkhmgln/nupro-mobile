import 'package:flutter/material.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;

  const OnboardingPageWidget({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  IOColors.brand500.withOpacity(0.1),
                  IOColors.brand500.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: IOColors.brand500.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(
              _getIconForPage(),
              size: 80,
              color: IOColors.brand500,
            ),
          ),

          const SizedBox(height: 48),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: IOStyles.h3.copyWith(
              color: IOColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: IOStyles.body1Regular.copyWith(
              color: IOColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForPage() {
    // You can customize icons based on page content
    if (title.contains('Мэргэжлийн сувилагч')) {
      return Icons.medical_services;
    } else if (title.contains('Шуурхай үйлчилгээ')) {
      return Icons.speed;
    } else if (title.contains('24/7')) {
      return Icons.support_agent;
    }
    return Icons.health_and_safety;
  }
}
