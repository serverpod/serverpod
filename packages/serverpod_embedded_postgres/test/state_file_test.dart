import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_embedded_postgres/src/state_file.dart';
import 'package:test/test.dart';

void main() {
  late Directory tmp;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('state_file_test_');
  });

  tearDown(() {
    tmp.deleteSync(recursive: true);
  });

  test(
    'Given a state with a DualTransport on port 5433, '
    'when it is written and read back with a password, '
    'then the transport is dual with the same port and the given password',
    () {
      var file = File(p.join(tmp.path, 'embedded_postgres_state.json'));
      EmbeddedPostgresState.writeAtomic(
        file,
        EmbeddedPostgresState(
          version: Version(16, 13, 0),
          username: 'postgres',
          databaseName: 'projectname',
          transport: const DualTransport(port: 5433),
        ),
      );

      var state = EmbeddedPostgresState.read(file, tcpPassword: 'secret');

      expect(state, isNotNull);
      expect(state!.version, Version(16, 13, 0));
      expect(state.username, 'postgres');
      expect(state.databaseName, 'projectname');
      expect(
        state.transport,
        isA<DualTransport>()
            .having((t) => t.port, 'port', 5433)
            .having((t) => t.password, 'password', 'secret'),
      );
    },
  );

  test(
    'Given a state with a UnixTransport, '
    'when it is written and read back with a password, '
    'then the transport is unix',
    () {
      var file = File(p.join(tmp.path, 'embedded_postgres_state.json'));
      EmbeddedPostgresState.writeAtomic(
        file,
        EmbeddedPostgresState(
          version: Version(16, 13, 0),
          username: 'postgres',
          databaseName: 'projectname',
          transport: const UnixTransport(),
        ),
      );

      var state = EmbeddedPostgresState.read(file, tcpPassword: 'secret');

      expect(state!.transport, isA<UnixTransport>());
    },
  );

  test(
    'Given a state file with an unknown transport kind, '
    'when it is read, '
    'then null is returned',
    () {
      var file = File(p.join(tmp.path, 'embedded_postgres_state.json'))
        ..writeAsStringSync(
          '{"version":"16.13.0","username":"postgres",'
          '"databaseName":"projectname","transport":{"kind":"carrier-pigeon"}}',
        );

      expect(EmbeddedPostgresState.read(file), isNull);
    },
  );
}
