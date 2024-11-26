import 'dart:io';
import 'package:test/test.dart';
import 'package:relic/src/headers/headers.dart';
import 'package:relic/src/relic_server.dart';

import '../headers_test_utils.dart';
import '../docs/strict_validation_docs.dart';

/// Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Disposition
/// About empty value test, check the [StrictValidationDocs] class for more details.
void main() {
  group('Given a Content-Disposition header with the strict flag true', () {
    late RelicServer server;

    setUp(() async {
      try {
        server = await RelicServer.createServer(
          InternetAddress.loopbackIPv6,
          0,
          strictHeaders: true,
        );
      } on SocketException catch (_) {
        server = await RelicServer.createServer(
          InternetAddress.loopbackIPv4,
          0,
          strictHeaders: true,
        );
      }
    });

    tearDown(() => server.close());

    test(
      'when an empty Content-Disposition header is passed then the server should respond with a bad request '
      'including a message that states the value cannot be empty',
      () async {
        expect(
          () async => await getServerRequestHeaders(
            server: server,
            headers: {'content-disposition': ''},
          ),
          throwsA(isA<BadRequestException>().having(
            (e) => e.message,
            'message',
            contains('Value cannot be empty'),
          )),
        );
      },
    );

    test(
      'when a Content-Disposition header is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {
            'content-disposition': 'attachment; filename="example.txt"'
          },
        );

        expect(headers.contentDisposition?.type, equals('attachment'));
        expect(
          headers.contentDisposition?.parameters.first.name,
          equals('filename'),
        );
        expect(
          headers.contentDisposition?.parameters.first.value,
          equals('example.txt'),
        );
      },
    );

    test(
      'when a Content-Disposition header with "inline" type is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {'content-disposition': 'inline'},
        );

        expect(headers.contentDisposition?.type, equals('inline'));
        expect(headers.contentDisposition?.parameters.isEmpty, isTrue);
      },
    );

    test(
      'when a Content-Disposition header with multiple parameters is passed then it should parse correctly',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {
            'content-disposition':
                'attachment; filename="example.txt"; size=12345'
          },
        );

        expect(headers.contentDisposition?.type, equals('attachment'));
        expect(
          headers.contentDisposition?.parameters.first.name,
          equals('filename'),
        );
        expect(
          headers.contentDisposition?.parameters.first.value,
          equals('example.txt'),
        );
        expect(
          headers.contentDisposition?.parameters.last.name,
          equals('size'),
        );
        expect(
          headers.contentDisposition?.parameters.last.value,
          equals('12345'),
        );
      },
    );

    test(
      'when no Content-Disposition header is passed then it should return null',
      () async {
        Headers headers = await getServerRequestHeaders(
          server: server,
          headers: {},
        );

        expect(headers.contentDisposition, isNull);
      },
    );
  });

  group('Given a Content-Disposition header with the strict flag false', () {
    late RelicServer server;

    setUp(() async {
      try {
        server = await RelicServer.createServer(
          InternetAddress.loopbackIPv6,
          0,
          strictHeaders: false,
        );
      } on SocketException catch (_) {
        server = await RelicServer.createServer(
          InternetAddress.loopbackIPv4,
          0,
          strictHeaders: false,
        );
      }
    });

    tearDown(() => server.close());

    group('when an empty Content-Disposition header is passed', () {
      test(
        'then it should return null',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'content-disposition': ''},
          );

          expect(headers.contentDisposition, isNull);
        },
      );
      test(
        'then it should be recorded in the "failedHeadersToParse" field',
        () async {
          Headers headers = await getServerRequestHeaders(
            server: server,
            headers: {'content-disposition': ''},
          );

          expect(
            headers.failedHeadersToParse['content-disposition'],
            equals(['']),
          );
        },
      );
    });
  });
}
