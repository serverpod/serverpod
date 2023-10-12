import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';

import 'config.dart';

void main() {
  test('Calling endpoint should return server default headers', () async {
    var result = await http.post(Uri.parse('${serverUrl}simple/hello'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode({'name': 'mike'}));

    expect(
      result.headers['access-control-allow-origin'],
      equals("*"),
    );
    expect(
      result.headers['access-control-allow-headers'],
      equals("Content-Type"),
    );
    expect(
      result.headers['access-control-allow-methods'],
      equals("POST"),
    );
  });
}
