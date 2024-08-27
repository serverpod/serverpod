import 'dart:async';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  late Session session;
  late Serverpod server;

  setUp(() async {
    server = IntegrationTestServer.create();
    await server.start();
    session = await server.createSession();
  });

  tearDown(() async {
    await session.close();
    await server.shutdown(exitProcess: false);
  });

  test(
      'Given a non valid message type when broadcasting revoked authentication event then exception is thrown',
      () {
    expect(
      () => session.messages.revokedAuthentication(1, EmptyModel()),
      throwsA(isA<ArgumentError>()),
    );
  });

  test(
      'Given a valid message type when broadcasting revoked authentication event then event is broadcasted',
      () async {
    var eventCompleter = Completer<RevokedAuthenticationUser>();
    session.messages
        .createStream(MessageCentralServerpodChannels.revokedAuthentication(1))
        .listen(
          (event) => eventCompleter.complete(event),
        );

    var message = RevokedAuthenticationUser();
    var event = await session.messages.revokedAuthentication(1, message);

    expect(event, isTrue);
    await expectLater(
      eventCompleter.future,
      completion(isA<RevokedAuthenticationUser>()),
    );
  });
}
