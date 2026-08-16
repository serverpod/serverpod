import 'package:http/http.dart' as http;
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group(
    'Given a Serverpod server when calling an endpoint with a malformed json body',
    () {
      late http.Response response;

      setUpAll(() async {
        var anyServerEndpoint = Uri.parse("${serverUrl}exceptionTest");
        response = await http.post(
          anyServerEndpoint,
          body: 'malformed json body',
        );
      });

      test('then it should return status code 400', () {
        expect(response.statusCode, 400);
      });
    },
  );
}
