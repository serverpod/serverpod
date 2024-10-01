import 'dart:io';

import 'http_headers_mock.dart';

class HttpRequestMock implements HttpRequest {
  @override
  final HttpHeaders headers = HttpHeadersMock();


  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
