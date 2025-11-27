import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/session/business/server_side_sessions_token.dart';
import 'package:test/test.dart';

import '../serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a session key based on a session secret which would result in `+` when base64 encoded,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      final secret = Uint8List.fromList([0, 0, 250]);
      final serverSideSessionId = const Uuid().v4obj();
      late String serverSideSessionToken;

      setUp(() {
        session = sessionBuilder.build();

        serverSideSessionToken = buildServerSideSessionToken(
          serverSideSessionId: serverSideSessionId,
          secret: secret,
        );
      });

      test(
        'when inspecting the key, then it does not contain a "+" because the encoding is URL safe.',
        () {
          expect(serverSideSessionToken, isNot(contains('+')));
        },
      );

      test(
        'when inspecting the key, then contains the secret in the expected format.',
        () {
          // In non-URL-safe base64 this would end in `+g==`
          expect(serverSideSessionToken, endsWith('-g=='));
        },
      );

      test(
        'when parsing the key, then it can be read again.',
        () {
          final keyParts = tryParseServerSideSessionToken(
            session,
            serverSideSessionToken,
          );

          expect(keyParts?.serverSideSessionId, serverSideSessionId);
          expect(keyParts?.secret, secret);
        },
      );
    },
  );
}
