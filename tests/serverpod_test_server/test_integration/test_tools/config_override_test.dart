import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  const overriddenId = 'from-with-serverpod-callback';

  withServerpod(
    'Given withServerpod initialized with a config override callback, ',
    configOverride: (config) => config.copyWith(
      serverId: overriddenId,
      healthCheckInterval: Duration.zero,
    ),
    (sessionBuilder, _) {
      test(
        'when reading the config from the built session '
        'then it matches the overridden config.',
        () {
          final session = sessionBuilder.build();
          expect(session.serverpod.config.serverId, equals(overriddenId));
          expect(session.serverpod.serverId, equals(overriddenId));
          expect(
            session.serverpod.config.healthCheckInterval,
            equals(Duration.zero),
          );
        },
      );
    },
  );

  withServerpod(
    'Given withServerpod initialized without config override, ',
    (sessionBuilder, _) {
      test(
        'when reading the config from the built session '
        'then it matches the default config.',
        () {
          final session = sessionBuilder.build();
          expect(session.serverpod.config.serverId, equals('default'));
          expect(session.serverpod.serverId, equals('default'));
          expect(
            session.serverpod.config.healthCheckInterval,
            equals(const Duration(minutes: 1)),
          );
        },
      );
    },
  );
}
