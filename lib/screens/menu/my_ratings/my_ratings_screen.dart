import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/main/io_appbar.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/extensions/extensions.dart';
import 'package:nuPro/screens/menu/my_ratings/my_ratings_controller.dart';

class MyRatingsScreen extends GetView<MyRatingsController> {
  const MyRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      appBar: IOAppBar(titleText: 'Миний үнэлгээ'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value != null) {
          return Center(child: Text('Алдаа: ${controller.error.value}'));
        }
        if (controller.ratings.isEmpty) {
          return const Center(child: Text('Үнэлгээ олдсонгүй'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.ratings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final rating = controller.ratings[index];

            String comment = rating['comment']?.toString() ?? '';
            if (comment.isEmpty || comment == 'null') comment = 'Тайлбаргүй';

            String createdAt = rating['created_at']?.toString() ?? '';
            if (createdAt.isEmpty || createdAt == 'null') createdAt = '-';

            String score = rating['rating']?.toString() ?? '-';

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                  width: 1.2,
                ),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  radius: 24,
                  child: Icon(Icons.star, color: Colors.blue[700], size: 28),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${rating['nurse_name'] ?? '-'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      comment,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF222222),
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Огноо: ${createdAt.toFormattedString()} минутанд',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF888888),
                    ),
                  ),
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '★ $score',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
