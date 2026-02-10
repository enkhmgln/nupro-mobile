import 'package:g_json/g_json.dart';
import 'package:nuPro/library/utils/constants.dart';

class NotificationListModel {
  final int id;
  final String title;
  final String body;
  final String photo;
  final DateTime createdAt;
  final int actionId;
  final String actionType;
  final String notifType;
  final bool jumpFeedback;
  final String url;

  bool isViewed;

  String get photoUrl => domain + photo;
  NotificationType get type => switch (notifType) {
        'sale' => NotificationType.sale,
        'loyalty' => NotificationType.loyalty,
        'feedback' => NotificationType.feedback,
        'notif' => NotificationType.notif,
        String() => NotificationType.notif,
      };

  NotificationListModel.fromJson(JSON json)
      : id = json['id'].integerValue,
        title = json['title'].stringValue,
        body = json['body'].stringValue,
        photo = json['photo'].stringValue,
        createdAt =
            DateTime.tryParse(json['created_at'].stringValue) ?? DateTime.now(),
        actionId = json['action_id'].integerValue,
        actionType = json['action_type'].stringValue,
        notifType = json['notif_type'].stringValue,
        isViewed = json['is_viewed'].booleanValue,
        jumpFeedback = json['jump_feedback'].booleanValue,
        url = json['url'].stringValue;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'photo': photo,
      'created_at': createdAt,
      'action_id': actionId,
      'action_type': actionType,
      'notif_type': notifType,
      'is_viewed': isViewed,
      'jump_feedback': jumpFeedback,
      'url': url,
    };
  }
}

enum NotificationType {
  sale(icon: 'coupon.svg'),
  loyalty(icon: 'star.svg'),
  feedback(icon: 'puzzle.svg'),
  notif(icon: 'notification.svg');

  const NotificationType({required this.icon});

  final String icon;
}
