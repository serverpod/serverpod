import 'dart:async';
import 'dart:io';

import 'package:serverpod_cli/src/serverpod_cloud/local_cloud_server.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() async {
  group('Given listening local cloud server', () {
    late Completer<Uri> callbackUrlFuture;
    late Future<String?> tokenFuture;

    setUp(() async {
      callbackUrlFuture = Completer<Uri>();
      tokenFuture = LocalCloudServer.listenForAuthenticationToken(
        onConnected: (Uri callbackUrl) {
          callbackUrlFuture.complete(callbackUrl);
        },
      );
    });

    group(
        'when called with authentication token parameter then token is returned.',
        () {
      const testToken = 'myTestToken';

      late http.Response response;
      setUp(() async {
        var callbackUrl = await callbackUrlFuture.future;
        var urlWithToken =
            callbackUrl.replace(queryParameters: {'token': testToken});
        response = await http.get(urlWithToken);
      });

      test('then token is returned.', () async {
        var fetchedToken = await tokenFuture;
        expect(fetchedToken, testToken);
      });

      test('then response status code is 200.', () {
        expect(response.statusCode, 200);
      });

      test('then response body has successful login message.', () {
        expect(response.body,
            contains('Login successful, you may now close this window.'));
      });
    });

    group(
        'when called without authentication token parameter then token null is returned.',
        () {
      late http.Response response;
      setUp(() async {
        var callbackUrl = await callbackUrlFuture.future;
        response = await http.get(callbackUrl);
      });

      test('then null is returned.', () async {
        var fetchedToken = await tokenFuture;
        expect(fetchedToken, null);
      });

      test('then response status code is 200.', () {
        expect(response.statusCode, 200);
      });

      test('then response body has failed login message.', () {
        expect(response.body,
            contains('Login failed, please try again or contact support.'));
      });
    });

    group('when called with preflight check', () {
      late http.Response response;

      setUp(() async {
        var callbackUrl = await callbackUrlFuture.future;
        var client = http.Client();
        var request = http.Request('OPTIONS', callbackUrl);
        var streamedResponse = await client.send(request);
        response = await http.Response.fromStream(streamedResponse);
      });

      test('then response status code is 200.', () {
        expect(response.statusCode, 200);
      });

      test('then response headers contain expected CORS headers.', () {
        expect(
            response.headers[HttpHeaders.accessControlAllowOriginHeader], '*');
        expect(response.headers[HttpHeaders.accessControlAllowMethodsHeader],
            'GET, OPTIONS');
        expect(
            response.headers[HttpHeaders.accessControlAllowHeadersHeader], '*');
      });
    });
  });

  group('Given listening local cloud server when time limit is reached', () {
    late Completer<Uri> callbackUrlFuture;
    late Future<String?> tokenFuture;

    setUp(() async {
      callbackUrlFuture = Completer<Uri>();
      tokenFuture = LocalCloudServer.listenForAuthenticationToken(
        onConnected: (Uri callbackUrl) {
          callbackUrlFuture.complete(callbackUrl);
        },
        timeLimit: const Duration(milliseconds: 1),
      );
    });

    test('then token is null.', () async {
      var fetchedToken = await tokenFuture;
      expect(fetchedToken, isNull);
    });
  });
}
