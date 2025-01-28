import 'dart:async';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  group('Given redis is enabled', () {
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
        'and a non valid message type when broadcasting revoked authentication event then exception is thrown',
        () {
      expect(
        () => session.serviceLocator
            .locate<MessageCentralAccess>()!
            .authenticationRevoked(1, EmptyModel()),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
        'and a valid message type when broadcasting revoked authentication event then event is broadcasted',
        () async {
      var eventCompleter = Completer<RevokedAuthenticationUser>();
      session.serviceLocator
          .locate<MessageCentralAccess>()!
          .createStream(
              session, MessageCentralServerpodChannels.revokedAuthentication(1))
          .listen(
            (event) => eventCompleter.complete(event),
          );

      var message = RevokedAuthenticationUser();
      var event = await session.serviceLocator
          .locate<MessageCentralAccess>()!
          .authenticationRevoked(1, message);

      expect(event, isTrue);
      await expectLater(
        eventCompleter.future,
        completion(isA<RevokedAuthenticationUser>()),
      );
    });
  });

  group('Given redis is disabled', () {
    late Session session;
    late Serverpod server;
    setUp(() async {
      server = IntegrationTestServer.create(
          config: ServerpodConfig(
              apiServer: ServerConfig(
        port: 8080,
        publicHost: 'localhost',
        publicPort: 8080,
        publicScheme: 'http',
      )));

      await server.start();
      session = await server.createSession();
    });

    tearDown(() async {
      await session.close();
      await server.shutdown(exitProcess: false);
    });

    test(
        'and a valid message type when broadcasting revoked authentication event then event is broadcasted',
        () async {
      var eventCompleter = Completer<RevokedAuthenticationUser>();
      session.serviceLocator
          .locate<MessageCentralAccess>()!
          .createStream(
              session, MessageCentralServerpodChannels.revokedAuthentication(1))
          .listen(
            (event) => eventCompleter.complete(event),
          );

      var message = RevokedAuthenticationUser();
      var event = await session.serviceLocator
          .locate<MessageCentralAccess>()!
          .authenticationRevoked(1, message);

      expect(event, isTrue);
      await expectLater(
        eventCompleter.future,
        completion(isA<RevokedAuthenticationUser>()),
      );
    });
  });
}
