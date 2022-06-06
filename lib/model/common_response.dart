enum ResponseErrorType { connection, timeout, auth, server, unknown }

class CommonResponse {
  final ResponseErrorType? errorType;
  final dynamic data;

  CommonResponse({
    this.errorType,
    this.data,
  });
}