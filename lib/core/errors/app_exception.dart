class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const AppException({
    required this.message,
    this.statusCode,
    this.details,
  });

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.statusCode,
    super.details,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Session expired or unauthorized. Please log in again.',
    super.statusCode = 401,
    super.details,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'You do not have permission to perform this action.',
    super.statusCode = 403,
    super.details,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Requested resource not found.',
    super.statusCode = 404,
    super.details,
  });
}

class ValidationException extends AppException {
  final Map<String, List<String>> errors;

  const ValidationException({
    super.message = 'Validation failed. Please check the entered data.',
    super.statusCode = 422,
    this.errors = const {},
  });
}
