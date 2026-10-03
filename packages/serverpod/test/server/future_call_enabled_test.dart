import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:serverpod/src/server/serverpod.dart';
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';

final _portZeroConfig = ServerConfig(
  port: 0,
  publicScheme: 'http',
  publicHost: 'localhost',
  publicPort: 0,
);

void main() {
  late Directory tempDir;
  late Serverpod pod;

  Serverpod createPod({
    required FutureCallConfig futureCall,
    bool withDatabase = true,
  }) {
    return Serverpod(
      [],
      internal.Protocol(),
      EmptyEndpoints(),
      config: ServerpodConfig(
        apiServer: _portZeroConfig,
        webServer: _portZeroConfig,
        database: withDatabase
            ? SqliteDatabaseConfig(filePath: p.join(tempDir.path, 'test.db'))
            : null,
        futureCall: futureCall,
      ),
    );
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('future_call_enabled_');
  });

  tearDown(() async {
    await pod.shutdown(exitProcess: false);
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test(
    'Given Serverpod is constructed with a database and future calls both enabled, '
    'when accessing the future call manager, '
    'then it is not null.',
    () {
      pod = createPod(futureCall: const FutureCallConfig());

      expect(pod.futureCallManager, isNotNull);
    },
  );

  test(
    'Given Serverpod is constructed with a database enabled and future calls disabled, '
    'when accessing the future call manager, '
    'then it is null.',
    () {
      pod = createPod(futureCall: const FutureCallConfig(enabled: false));

      expect(pod.futureCallManager, isNull);
    },
  );

  test(
    'Given Serverpod is constructed with a database disabled and future calls enabled, '
    'when accessing the future call manager, '
    'then it is null.',
    () {
      pod = createPod(
        futureCall: const FutureCallConfig(),
        withDatabase: false,
      );

      expect(pod.futureCallManager, isNull);
    },
  );
}
