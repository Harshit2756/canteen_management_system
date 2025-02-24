/// API service for managing API communications
///
/// Purpose:
/// - Handle API configuration
/// - Manage API state
/// - Provide API utilities
library;

import 'dart:async';

import 'package:canteen_app/core/utils/helpers/logger.dart';
import 'package:canteen_app/core/widgets/snackbar/snackbars.dart';
import 'package:dio/dio.dart';

import '../../../../core/utils/constants/extension/platform_extensions.dart';
import '../../models/response_model.dart';
import '../base_service.dart';

class ApiService extends BaseService {
  final Duration timeout;
  final ErrorHandlerService _errorHandler = ErrorHandlerService();
  final Dio _dio;

  ApiService({
    this.timeout = const Duration(seconds: 90),
  }) : _dio = Dio(BaseOptions(
          connectTimeout: timeout,
          receiveTimeout: timeout,
          sendTimeout: PlatformHelper.isWeb ? null : timeout,
          validateStatus: (status) => true,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ));

  /// Delete request
  Future<ResponseModel<T>> delete<T>(String endpoint) async {
    _dio.options.headers['Content-Type'] = 'application/json';
    HLoggerHelper.info('''
      DELETE<$T> Request to URL: $endpoint
      Request Headers: ${_dio.options.headers}
    ''');

    try {
      final Response<Map<String, dynamic>> response = await _dio.delete(endpoint);
      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Get request
  Future<ResponseModel<T>> get<T>(String endpoint, {Map<String, dynamic>? queryParams}) async {
    _dio.options.headers['Content-Type'] = 'application/json';
    HLoggerHelper.info('''
      GET<$T> Request to URL: $endpoint
      Query Parameters: $queryParams
      Request Headers: ${_dio.options.headers}
    ''');
    try {
      final Response<Map<String, dynamic>> response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Post request
  Future<ResponseModel<T>> post<T>(String endpoint, Map<String, dynamic>? body) async {
    _dio.options.headers['Content-Type'] = 'application/json';
    HLoggerHelper.info('POST<$T> Request to URL: $endpoint \n Body: $body \nRequest Headers: ${_dio.options.headers}');
    try {
      final Response<Map<String, dynamic>> response = await _dio.post(endpoint, data: body);
      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Post request with form data
  Future<ResponseModel<T>> postFormData<T>(
    String endpoint,
    FormData body,
  ) async {
    _dio.options.headers['Content-Type'] = 'multipart/form-data';
    HLoggerHelper.info('''
      POST FILE Request Details:
      URL: $endpoint
      Headers: ${_dio.options.headers}
      Form Data Fields: ${body.fields}
      Form Data Files: ${body.files.map((f) => '${f.key}: ${f.value.filename}')}
    ''');
    try {
      final Response<Map<String, dynamic>> response = await _dio.post(
        endpoint,
        data: body,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Put request
  Future<ResponseModel<T>> put<T>(String endpoint, Map<String, dynamic> body) async {
    _dio.options.headers['Content-Type'] = 'application/json';
    HLoggerHelper.info('PUT<$T> Request to URL: $endpoint \nBody: $body \nRequest Headers: ${_dio.options.headers}');
    try {
      final Response<Map<String, dynamic>> response = await _dio.put(endpoint, data: body);
      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Put request with form data
  Future<ResponseModel<T>> putFormData<T>(String endpoint, FormData body, {void Function(int, int)? onSendProgress}) async {
    _dio.options.headers['Content-Type'] = 'multipart/form-data';
    HLoggerHelper.info('''
      PUT FILE Request Details:
      URL: $endpoint
      Headers: ${_dio.options.headers}
      Form Data Fields: ${body.fields}
      Form Data Files: ${body.files.map((f) => '${f.key}: ${f.value.filename}')}
    ''');
    try {
      final Response<Map<String, dynamic>> response = await _dio.put(
        endpoint,
        data: body,
        onSendProgress: onSendProgress,
      );
      return _handleResponse<T>(response);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Set auth token
  void setAuthToken(String token) {
    if (token.isEmpty) {
      HLoggerHelper.warning('Warning: Empty token provided');
      return;
    }
    _dio.options.headers['x-auth-token'] = token;
    HLoggerHelper.info('Headers after setting token: ${_dio.options.headers}');
  }

  /// Handle error
  ResponseModel<T> _handleError<T>(dynamic error) {
    _errorHandler.logError(error);
    String errorMessage;
    if (error is DioException && error.response != null) {
      HLoggerHelper.info('DioException Details:');
      HLoggerHelper.error('Error Type: ${error.type}');
      HLoggerHelper.error('Response Status: ${error.response?.statusCode}');
      HLoggerHelper.error('Response Data: ${error.response?.data}');
      errorMessage = error.response?.data['message'] ?? 'An unexpected error occurred';
    } else {
      errorMessage = 'An unexpected error occurred';
    }
    HLoggerHelper.info('Final Error Message: $errorMessage');
    HSnackbars.showSnackbar(type: SnackbarType.error, message: errorMessage);
    return ResponseModel<T>.error(errorMessage);
  }

  ResponseModel<T> _handleResponse<T>(Response<Map<String, dynamic>> response) {
    if ((response.statusCode ?? 500) >= 200 && (response.statusCode ?? 500) < 300) {
      HLoggerHelper.info('Successful Response Data: ${response.data}');
      final data = response.data;
      if (data == null) {
        HLoggerHelper.warning('Warning: Response data is null');
        return ResponseModel.error('Invalid response data');
      }
      return ResponseModel(
        success: data['status'] == 'success',
        message: data['message'] as String?,
        statusCode: data['statusCode'] as int?,
        data: data['data'] as T,
      );
    } else {
      HLoggerHelper.error('Error Response Data: ${response.data}');
      final error = _errorHandler.handleHttpError(response.statusCode ?? 500, response.data);
      HSnackbars.showSnackbar(type: SnackbarType.error, message: error);
      return ResponseModel<T>.error(error);
    }
  }
}

class ErrorHandlerService {
  String handleHttpError(int statusCode, dynamic responseBody) {
    switch (statusCode) {
      case 400:
        return responseBody['message'] ?? 'Bad request';
      case 401:
        return responseBody['message'] ?? 'Unauthorized';
      case 403:
        return responseBody['message'] ?? 'Forbidden';
      case 404:
        return responseBody['message'] ?? 'Not found';
      case 500:
        return responseBody['message'] ?? 'Internal server error';
      default:
        return responseBody['message'] ?? 'An error occurred';
    }
  }

  void logError(dynamic e) {
    // HLoggerHelper.error('Error occurred: ${e.runtimeType} - $e');
    if (e is DioException) {
      HLoggerHelper.error('DioException: Type: ${e.type}, Message: ${e.message}');
      if (e.response != null) {
        HLoggerHelper.error('Response Status: ${e.response?.statusCode}, Data: ${e.response?.data}, Headers: ${e.response?.headers}');
      }
    }
  }
}
