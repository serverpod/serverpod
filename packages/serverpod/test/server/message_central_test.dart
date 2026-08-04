import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:serverpod/src/server/message_central.dart'
    show MessageCentralInternalMethods;
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group('Given a session with an open message central stream,', () {
    late Serverpod pod;
    late InternalSession session;
    late MessageCentral messageCentral;
    late StreamSubscription<SerializableModel> subscription;

    setUp(() async {
      pod = Serverpod(
        [],
        internal.Protocol(),
        EmptyEndpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
          database: null,
          runMode: ServerpodRunMode.development,
          healthCheckInterval: Duration.zero,
        ),
      );
      session = await pod.createSession(enableLogging: false);
      messageCentral = session.server.messageCentral;
      subscription = session.messages
          .createStream<SerializableModel>('test-channel')
          .listen((_) {});
    });

    tearDown(() async {
      await subscription.cancel();
      await session.close();
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when the stream subscription is cancelled, '
      'then the message central retains no references to the session.',
      () async {
        await subscription.cancel();

        expect(messageCentral.hasSessionReferences(session), isFalse);
      },
    );

    test(
      'when the stream subscription is cancelled before the session is '
      'closed, then the message central retains no references to the session.',
      () async {
        await subscription.cancel();
        await session.close();

        expect(messageCentral.hasSessionReferences(session), isFalse);
      },
    );

    test(
      'when the session is closed while the stream subscription is active, '
      'then the message central retains no references to the session.',
      () async {
        await session.close();

        expect(messageCentral.hasSessionReferences(session), isFalse);
      },
    );
  });
}
