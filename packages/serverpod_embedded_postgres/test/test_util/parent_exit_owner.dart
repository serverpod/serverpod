import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';

Future<void> main(List<String> args) async {
  if (args.single == 'isolate') {
    final ready = ReceivePort();
    await Isolate.spawn((SendPort port) async {
      await startPostgres();
      Isolate.exit(port, true);
    }, ready.sendPort);
    await ready.first;
    File(
      '${Platform.environment['PG_TEST_ROOT']}/isolate_exited',
    ).writeAsStringSync('');
  } else {
    await startPostgres(detach: args.single == 'detach');
  }

  await stdin.first;
  exit(0);
}

Future<void> startPostgres({bool detach = false}) async {
  final root = Platform.environment['PG_TEST_ROOT']!;
  final postgres = await EmbeddedPostgres.start(
    EmbeddedPostgresOptions(
      dataDir: Directory('$root/pgdata'),
      databaseName: 'lifetime_test',
      transport: const TcpTransport(password: 'test-password'),
      detach: detach,
    ),
  );
  File('$root/ready.json').writeAsStringSync(
    jsonEncode({'port': postgres.endpoint.port}),
  );
}
