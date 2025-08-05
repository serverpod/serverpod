import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_session_server/src/business/session_key.dart';
import 'package:test/test.dart';

import 'integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a session key based on a session secret which would result in `+` when base64 encoded,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      final secret = Uint8List.fromList([0, 0, 250]);
      final authSessionId = const Uuid().v4obj();
      late String sessionKey;

      setUp(() {
        session = sessionBuilder.build();

        sessionKey = buildSessionKey(
          authSessionId: authSessionId,
          secret: secret,
        );
      });

      test(
        'when inspecting the key, then it does not contain a "+" because the encoding is URL safe.',
        () {
          expect(sessionKey, isNot(contains('+')));
        },
      );

      test(
        'when inspecting the key, then contains the secret in the expected format.',
        () {
          // In non-URL-safe base64 this would end in `+g==`
          expect(sessionKey, endsWith('-g=='));
        },
      );

      test(
        'when parsing the key, then it can be read again.',
        () {
          final keyParts = tryParseSessionKey(session, sessionKey);

          expect(keyParts?.authSessionId, authSessionId);
          expect(keyParts?.secret, secret);
        },
      );
    },
  );
}
