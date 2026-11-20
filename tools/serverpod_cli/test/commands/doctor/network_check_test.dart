import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/doctor/network_check.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given pub.dev answering the request, '
    'when probing, then the status is ready',
    () async {
      final client = MockClient(
        (request) async {
          expect(request.method, 'HEAD');
          expect(request.url.host, 'pub.dev');
          return http.Response('', 200);
        },
      );

      final result = await NetworkCheck.probe(client: client);

      expect(result.status, DoctorStatus.ready);
      expect(result.message, contains('pub.dev'));
    },
  );

  test(
    'Given pub.dev answering with a server error, '
    'when probing, then the status is missing',
    () async {
      final client = MockClient((request) async => http.Response('', 503));

      final result = await NetworkCheck.probe(client: client);

      expect(result.status, DoctorStatus.missing);
    },
  );

  test(
    'Given a connection that fails, '
    'when probing, then the status is missing with a connectivity remedy',
    () async {
      final client = MockClient(
        (request) async => throw const SocketException('no route to host'),
      );

      final result = await NetworkCheck.probe(client: client);

      expect(result.status, DoctorStatus.missing);
      expect(result.remedy, contains('internet connection'));
    },
  );

  test(
    'Given a request that outlasts the timeout, '
    'when probing, then the status is missing once the timeout passes',
    () async {
      final client = MockClient(
        (request) => Future.delayed(
          const Duration(seconds: 10),
          () => http.Response('', 200),
        ),
      );

      final stopwatch = Stopwatch()..start();
      final result = await NetworkCheck.probe(
        client: client,
        timeout: const Duration(milliseconds: 100),
      );
      stopwatch.stop();

      expect(result.status, DoctorStatus.missing);
      expect(stopwatch.elapsed, lessThan(const Duration(seconds: 5)));
    },
  );
}
