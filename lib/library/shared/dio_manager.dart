import 'package:dio/dio.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/shared/session_manager.dart';
import 'package:nuPro/library/utils/constants.dart';

enum DioType { auth, offline }

class DioManager {
  static final DioManager _singleton = DioManager._internal();

  factory DioManager() {
    return _singleton;
  }

  final _connectTimeout = const Duration(seconds: 60);
  final _receiveTimeout = const Duration(seconds: 60);
  final _headers = {
    Headers.acceptHeader: Headers.jsonContentType,
    Headers.contentTypeHeader: Headers.jsonContentType,
  };

  BaseOptions get option => BaseOptions(
        baseUrl: domain,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        headers: _headers,
      );

  late Dio mainDio;
  late Dio customDio;
  bool _isLoggingOut = false;

  DioManager._internal() {
    mainDio = Dio(option);
    mainDio.transformer = CustomTransformer();
    customDio = Dio(option);
    customDio.transformer = CustomTransformer();
    addMainInterceptor();
  }

  addMainInterceptor() async {
    mainDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (HelperManager.isLogged) {
            final token = HelperManager.token;
            if (token.isExpired) {
              // Only attempt refresh if we have a non-empty, non-expired refresh token
              if (token.hasValidRefresh) {
                try {
                  final response = await UserApi().getAccess(
                    refresh: token.refreshToken,
                  );
                  if (response.data.exist('access')) {
                    final newToken = TokenModel.fromJson(response.data);
                    await UserStoreManager.shared
                        .write(kToken, newToken.toMap());
                    options.headers['Authorization'] =
                        'Bearer ${newToken.accessToken}';
                  } else {
                    // Refresh endpoint responded but did not include access
                    // Proceed without auth to let request fail gracefully
                  }
                } catch (_) {
                  // Network or 4xx from refresh: proceed without Authorization
                }
                handler.next(options);
              } else {
                // No valid refresh; proceed without Authorization to avoid sending empty refresh
                handler.next(options);
              }
            } else {
              options.headers['Authorization'] = 'Bearer ${token.accessToken}';
              handler.next(options);
            }
          } else {
            handler.next(options);
          }
        },
        onError: (e, handler) async {
          final status = e.response?.statusCode;
          if (status == 401 && !_isLoggingOut) {
            _isLoggingOut = true;
            try {
              await SessionManager.shared.logout();
            } finally {
              _isLoggingOut = false;
            }
          }
          handler.next(e);
        },
      ),
    );
  }
}

class CustomTransformer extends BackgroundTransformer {
  @override
  Future<String> transformRequest(RequestOptions options) async {
    options.path = Uri.decodeFull(options.path);
    return super.transformRequest(options);
  }
}
