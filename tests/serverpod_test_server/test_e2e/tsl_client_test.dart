import 'dart:io';

import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given valid certificates when a call to the health endpoint of a service with a valid certificate then the requests completes successfully.',
      () async {
    var client = Client('https://api.serverpod.app/');

    expectLater(
      client.callServerEndpoint<void>('', '', {}),
      completes,
    );
  });

  test(
      'Given no valid certificates when a call to the health endpoint of a service then the requests is rejected with a handshake exception.',
      () async {
    var client = Client(
      'https://api.serverpod.app/',
      securityContext: SecurityContext(withTrustedRoots: false),
    );

    expectLater(
      client.callServerEndpoint<void>('', '', {}),
      throwsA(isA<HandshakeException>()),
    );
  });
}
