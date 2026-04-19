import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/mock_stdout.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Given a Serverpod instance with a SQLite database configured and persistent logging enabled,',
    () {
      late MockStdout record;
      late Serverpod pod;

      setUp(() async {
        record = MockStdout();
        pod = Serverpod(
          [],
          Protocol(),
          _EmptyEndpoints(),
          config: ServerpodConfig(
            database: SqliteDatabaseConfig(
              filePath: 'sqlite_data/serverpod_test_prod.db',
            ),
            apiServer: ServerConfig(
              port: 0,
              publicScheme: 'http',
              publicHost: 'localhost',
              publicPort: 0,
            ),
          ),
        );
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      test(
        'when starting the server, '
        'then a warning is logged that persistent logging is not supported for SQLite.',
        () async {
          await IOOverrides.runZoned(
            () async {
              await pod.start();
            },
            stderr: () => record,
          );

          expect(
            record.output,
            'Persistent logging is not supported when using SQLite database '
            'because it does not allow concurrent writes. Use console logging '
            'instead.\n',
          );
        },
      );
    },
  );
}

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}
