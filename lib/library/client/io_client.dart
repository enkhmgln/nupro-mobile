import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:nuPro/library/client/io_response.dart';
import 'package:nuPro/library/shared/dio_manager.dart';
import 'package:nuPro/library/utils/log.dart';

class IOClient {
  static const debugName = 'ServiceLog';

  DioManager get _manager => DioManager();
  Dio get _tokenerDio => _manager.mainDio;
  Dio get _tokenlessDio => _manager.customDio;

  Future<IOResponse> sendGetRequest(
    String path, {
    Map<String, dynamic>? query,
    bool hasToken = true,
  }) async {
    try {
      final response = await getDio(hasToken: hasToken).get(
        path,
        queryParameters: query,
      );
      return getResponse(response);
    } on DioException catch (error) {
      return getErrorResponse(error);
    }
  }

  Future<IOResponse> sendPostRequest(
    String path, {
    Map<String, dynamic>? data,
    bool hasToken = true,
  }) async {
    try {
      Response response =
          await getDio(hasToken: hasToken).post(path, data: data);
      return getResponse(response);
    } on DioException catch (error) {
      return getErrorResponse(error);
    }
  }

  Future<IOResponse> sendPutRequest(
    String path, {
    Map<String, dynamic>? data,
    bool hasToken = true,
  }) async {
    try {
      Response response =
          await getDio(hasToken: hasToken).put(path, data: data);
      return getResponse(response);
    } on DioException catch (error) {
      return getErrorResponse(error);
    }
  }

  Future<IOResponse> sendPatchRequest(
    String path, {
    Map<String, dynamic>? data,
    bool hasToken = true,
  }) async {
    try {
      Response response =
          await getDio(hasToken: hasToken).patch(path, data: data);
      return getResponse(response);
    } on DioException catch (error) {
      return getErrorResponse(error);
    }
  }

  Future<IOResponse> sendDeleteRequest(
    String path, {
    Map<String, dynamic>? data,
    bool hasToken = true,
  }) async {
    try {
      Response response =
          await getDio(hasToken: hasToken).delete(path, data: data);
      return getResponse(response);
    } on DioException catch (error) {
      return getErrorResponse(error);
    }
  }

  Future<IOResponse> sendMultiPartRequest(
    String path, {
    FormData? formData,
    bool hasToken = true,
  }) async {
    try {
      Response response =
          await getDio(hasToken: hasToken).post(path, data: formData);
      return getResponse(response);
    } on DioException catch (error) {
      return getErrorResponse(error);
    }
  }

  Future<IOResponse> sendMultiPartPutRequest(
    String path, {
    FormData? formData,
    bool hasToken = true,
  }) async {
    try {
      Response response =
          await getDio(hasToken: hasToken).put(path, data: formData);
      return getResponse(response);
    } on DioException catch (error) {
      return getErrorResponse(error);
    }
  }

  Dio getDio({required bool hasToken}) {
    return hasToken ? _tokenerDio : _tokenlessDio;
  }

  static IOResponse getResponse(Response serverResponse) {
    Log.success('\n\n', debugName);
    Log.success(serverResponse.requestOptions.uri.toString(), debugName);
    Log.success('statusCode--> ${serverResponse.statusCode}', debugName);
    Log.success(
        'headers--> ${serverResponse.requestOptions.headers}', debugName);
    Log.success('data--> ${serverResponse.requestOptions.data}', debugName);
    Log.success('responseData--> ${serverResponse.data}', debugName);

    final response = IOResponse.fromJSON(JSON(serverResponse.data));
    return response;
  }

  static IOResponse getErrorResponse(DioException error) {
    if (error.response != null) {
      Log.error('\n\n', debugName);
      Log.error(error.requestOptions.uri.toString(), debugName);
      Log.error('statusCode--> ${error.response?.statusCode}', debugName);
      Log.error('headers--> ${error.requestOptions.headers}', debugName);
      Log.error('data--> ${error.requestOptions.data}', debugName);
      Log.error('responseData--> ${error.response?.data}', debugName);
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return IOResponse.withError('Connection time out');
      case DioExceptionType.connectionError:
        return IOResponse.withError('Cant connect the server');
      case DioExceptionType.receiveTimeout:
        return IOResponse.withError('Receive time out');
      case DioExceptionType.sendTimeout:
        return IOResponse.withError('Request time out');
      case DioExceptionType.badResponse:
        if (error.response?.data is String) {
          return IOResponse.withError(error.response?.data ?? '');
        } else {
          final json = JSON(error.response?.data);
          return IOResponse.withErrorJSON(json);
        }

      case DioExceptionType.cancel:
        return IOResponse.withError('Request canceled');

      case DioExceptionType.badCertificate:
        return IOResponse.withError('Bad certificate');

      case DioExceptionType.unknown:
        return IOResponse.withError('Check your internet connection');
    }
  }
}
