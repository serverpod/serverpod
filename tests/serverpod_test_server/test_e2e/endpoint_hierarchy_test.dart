import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  group(
      'Given an endpoint which subclasses a base class which requires login, ',
      () {
    test(
        'when calling `echo` as an unauthenticated user, then the request errs with "Unauthorized"',
        () async {
      await expectLater(
        () async => await client.myLoggedIn.echo('hello'),
        throwsA(
          isA<ServerpodClientException>()
              .having((e) => e.message, 'statusCode', contains('Unauthorized'))
              .having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });
  });

  group(
      'Given an endpoint which subclasses a base class which requires login and admin scope, ',
      () {
    test(
        'when calling `echo` as a guest user, then the request errs with "Unauthorized"',
        () async {
      await expectLater(
        () async => await client.myAdmin.echo('hello'),
        throwsA(
          isA<ServerpodClientException>()
              .having((e) => e.message, 'statusCode', contains('Unauthorized'))
              .having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });
  });
}
