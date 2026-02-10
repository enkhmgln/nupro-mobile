import 'package:g_json/g_json.dart';

class CompletionCodeModel {
  final String completionCode;
  final String expiresAt;
  final int callId;

  CompletionCodeModel({
    required this.completionCode,
    required this.expiresAt,
    required this.callId,
  });

  factory CompletionCodeModel.fromJson(JSON json) {
    return CompletionCodeModel(
      completionCode: json['completion_code'].stringValue,
      expiresAt: json['expires_at'].stringValue,
      callId: json['call_id'].integerValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'completion_code': completionCode,
      'expires_at': expiresAt,
      'call_id': callId,
    };
  }
}
