import 'package:g_json/g_json.dart';

class ActiveCallModel {
  bool hasActiveCall;
  int? callId;
  String? status;
  String? statusDisplay;
  String? createdAt;

  ActiveCallModel.fromJson(JSON json)
      : hasActiveCall = json['has_active_call'].booleanValue,
        callId = json['call_id'].integerValue,
        status = json['status'].stringValue,
        statusDisplay = json['status_display'].stringValue,
        createdAt = json['created_at'].stringValue;

  Map<String, dynamic> toMap() {
    return {
      'has_active_call': hasActiveCall,
      'call_id': callId,
      'status': status,
      'status_display': statusDisplay,
      'created_at': createdAt,
    };
  }
}
