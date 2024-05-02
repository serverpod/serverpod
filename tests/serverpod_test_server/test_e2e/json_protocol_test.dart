import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test(
      'Given Serverpod server when fetching object with server only fields from endpoint then serialized object does not contain server only fields',
      () async {
    http.Response response = await http.post(
      Uri.parse("${serverUrl}jsonProtocol"),
      body: jsonEncode({"method": "getJsonForProtocol"}),
    );

    expect(
      response.statusCode,
      200,
    );

    Map jsonMap = jsonDecode(response.body);
    expect(
      jsonMap,
      contains('nested'),
    );

    Map nestedMap = jsonMap['nested'];

    expect(
      nestedMap,
      isNot(contains('serverOnlyScope')),
    );
  });
}
