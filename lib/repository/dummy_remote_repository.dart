import 'dart:async';

import 'package:http/http.dart' as http;
import '../model/common_response.dart';
import 'remote_helper.dart';

class DummyRemoteRepository {
  final RemoteHelper remoteHelper = RemoteHelper();

  Future<CommonResponse> fetchData(int page) {
    final request = http.get(
      Uri.parse('https://dummyjson.com/products?limit=10&skip=${page * 10}'),
    );
    return remoteHelper.defaultRequest(request);
  }
}
