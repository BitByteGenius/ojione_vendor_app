import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../errors/app_exception.dart';
import 'api_endpoints.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;

  String? _authToken;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken != null && _authToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          final appException = _handleDioError(e);
          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              response: e.response,
              error: appException,
              type: e.type,
              message: appException.message,
            ),
          );
        },
      ),
    );
  }

  static ApiClient get instance => _instance ??= ApiClient._internal();

  Dio get dio => _dio;

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(message: 'Connection timed out. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        final message = data is Map<String, dynamic> ? (data['message'] ?? 'Unexpected server error') : 'Unexpected server error';

        if (statusCode == 401) {
          return UnauthorizedException(message: message.toString(), statusCode: statusCode);
        } else if (statusCode == 403) {
          return ForbiddenException(message: message.toString(), statusCode: statusCode);
        } else if (statusCode == 404) {
          return NotFoundException(message: message.toString(), statusCode: statusCode);
        } else if (statusCode == 422) {
          return ValidationException(
            message: message.toString(),
            statusCode: statusCode,
            errors: (data is Map && data['errors'] is Map)
                ? (data['errors'] as Map).map((k, v) => MapEntry(k.toString(), List<String>.from(v is List ? v : [v.toString()])))
                : {},
          );
        }
        return AppException(message: message.toString(), statusCode: statusCode, details: data);
      case DioExceptionType.cancel:
        return const AppException(message: 'Request was cancelled.');
      case DioExceptionType.connectionError:
        return const NetworkException(message: 'Unable to connect to server. Please check internet connection.');
      default:
        return AppException(message: error.message ?? 'An unexpected network error occurred.');
    }
  }
}
