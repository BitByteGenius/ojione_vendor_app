class ApiResponse<T> {
  final bool success;
  final int statusCode;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;
  final PaginationMeta? meta;

  ApiResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
    this.errors,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? (json['statusCode'] != null && json['statusCode'] < 400),
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : json['data'] as T?,
      errors: json['errors'] as Map<String, dynamic>?,
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
    );
  }

  factory ApiResponse.success({
    required T data,
    String message = 'Success',
    int statusCode = 200,
    PaginationMeta? meta,
  }) {
    return ApiResponse<T>(
      success: true,
      statusCode: statusCode,
      message: message,
      data: data,
      meta: meta,
    );
  }

  factory ApiResponse.error({
    required String message,
    int statusCode = 400,
    Map<String, dynamic>? errors,
  }) {
    return ApiResponse<T>(
      success: false,
      statusCode: statusCode,
      message: message,
      errors: errors,
    );
  }
}

class PaginationMeta {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int perPage;

  PaginationMeta({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.perPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] ?? json['currentPage'] ?? 1,
      totalPages: json['total_pages'] ?? json['totalPages'] ?? 1,
      totalItems: json['total_items'] ?? json['totalItems'] ?? 0,
      perPage: json['per_page'] ?? json['perPage'] ?? 10,
    );
  }
}
