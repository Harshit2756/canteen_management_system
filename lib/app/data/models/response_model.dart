/// Generic API response model
///
/// Purpose:
/// - Standardize API responses
/// - Handle success/error states
/// - Parse API data
/// - Handle pagination data

class PaginationData {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationData({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

class ResponseModel<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;
  final PaginationData? pagination;

  ResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.pagination,
  });

  factory ResponseModel.error(String message, [int? statusCode]) =>
      ResponseModel(
        success: false,
        message: message,
        statusCode: statusCode,
      );

  factory ResponseModel.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>)? fromJson) {
    return ResponseModel(
      success: json['success'] ?? false,
      message: json['message'],
      statusCode: json['status_code'],
      data: json['data'] != null && fromJson != null
          ? fromJson(json['data'])
          : null,
      pagination: json['pagination'] != null
          ? PaginationData.fromJson(json['pagination'])
          : null,
    );
  }

  factory ResponseModel.success(T data, String message) => ResponseModel(
        success: true,
        data: data,
        message: message,
        statusCode: 200,
      );
}
