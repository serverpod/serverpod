import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/session/business/session_key.dart';
import 'package:test/test.dart';

import '../serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a session key based on a session secret which would result in `+` when base64 encoded,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      final secret = Uint8List.fromList([250]);
      final authSessionId = const Uuid().v4obj();
      late String sessionKey;

      setUp(() {
        session = sessionBuilder.build();

        assert(base64Encode(secret) == '+g==');

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
        'when inspecting the key, then it does at least one ":" to be usable as a Basic auth header.',
        () {
          expect(sessionKey, contains(':'));
        },
      );

      test(
        'when inspecting the key, then contains the secret in the expected format.',
        () {
          expect(sessionKey, endsWith(':-g=='));
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
