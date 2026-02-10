import 'package:g_json/g_json.dart';

class TokenModel {
  String accessToken;
  String refreshToken;
  DateTime accessExpiresAt;
  DateTime refreshExpiresAt;

  TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.accessExpiresAt,
    required this.refreshExpiresAt,
  });

  factory TokenModel.fromJson(JSON json) {
    final access = json['access'].stringValue;
    final refresh = json['refresh'].stringValue;

    // Prefer durations if present (fresh from server)
    final hasExpiresIn = json.exist('token_expires_in');
    DateTime accessExpiresAt;
    DateTime refreshExpiresAt;

    if (hasExpiresIn) {
      accessExpiresAt = DateTime.now().add(
        Duration(
            seconds: json['token_expires_in']['access_token'].integerValue),
      );
      refreshExpiresAt = DateTime.now().add(
        Duration(
            seconds: json['token_expires_in']['refresh_token'].integerValue),
      );
    } else {
      // Fallback to stored ISO timestamps when reading from local storage
      final accessIso = json['access_expires_at'].stringValue;
      final refreshIso = json['refresh_expires_at'].stringValue;
      accessExpiresAt = DateTime.tryParse(accessIso) ?? DateTime.now();
      refreshExpiresAt = DateTime.tryParse(refreshIso) ?? DateTime.now();
    }

    return TokenModel(
      accessToken: access,
      refreshToken: refresh,
      accessExpiresAt: accessExpiresAt,
      refreshExpiresAt: refreshExpiresAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'access': accessToken,
      'refresh': refreshToken,
      'access_expires_at': accessExpiresAt.toIso8601String(),
      'refresh_expires_at': refreshExpiresAt.toIso8601String(),
    };
  }

  bool get isExpired {
    final now = DateTime.now();
    final difference = accessExpiresAt.difference(now).inSeconds;
    return difference < 30;
  }

  bool get isRefreshExpired {
    final now = DateTime.now();
    final difference = refreshExpiresAt.difference(now).inSeconds;
    return difference < 30;
  }

  bool get hasValidRefresh => refreshToken.isNotEmpty && !isRefreshExpired;
}
