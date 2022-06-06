import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';

import '../model/common_response.dart';

class RemoteHelper {
  final timeout = const Duration(seconds: 10);

  Future<CommonResponse> defaultRequest(Future<Response> request) async {
    try {
      final response = await request.timeout(timeout);
      final statusCode = response.statusCode;
      if (statusCode == 401 || statusCode == 403) {
        return CommonResponse(errorType: ResponseErrorType.auth);
      }
      if (statusCode >= 500) {
        return CommonResponse(errorType: ResponseErrorType.server);
      }
      if (statusCode != 200) {
        return CommonResponse(errorType: ResponseErrorType.unknown);
      }
      return CommonResponse(data: response.body);
    } on TimeoutException {
      return CommonResponse(errorType: ResponseErrorType.timeout);
    } on SocketException {
      return CommonResponse(errorType: ResponseErrorType.connection);
    } on Exception {
      return CommonResponse(errorType: ResponseErrorType.unknown);
    }
  }
}
