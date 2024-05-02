import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test(
      'Ensure that a server response matches the client-side serialized object structure.',
      () async {
    http.Response response = await http.post(
      Uri.parse("$serverUrl/jsonProtocol"),
      body: jsonEncode({"method": "getJsonForProtocol"}),
    );

    var clientObject = ScopeServerOnlyField(
      nested: ScopeServerOnlyField(
        allScope: Types(anInt: 1),
      ),
    );

    var clientEncodedString = SerializationManager.encode(clientObject);

    expect(
      response.body,
      clientEncodedString,
    );
  });
}
