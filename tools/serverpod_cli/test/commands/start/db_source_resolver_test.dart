import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:postgres/postgres.dart' as pg;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/start/db_source_resolver.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

/// Fake [EmbeddedPostgres] used to exercise the resolver's embedded arm
/// without spawning a real postmaster.
class _FakeEmbeddedPostgres implements EmbeddedPostgres {
  @override
  final pg.Endpoint endpoint;

  bool stopped = false;
  int stopCalls = 0;

  _FakeEmbeddedPostgres(this.endpoint);

  @override
  Future<void> stop({Duration timeout = const Duration(seconds: 10)}) async {
    stopped = true;
    stopCalls++;
  }

  @override
  String get connectionString => endpoint.toString();
  @override
  Uri get connectionUri => Uri.parse(connectionString);
  @override
  bool get isRunning => !stopped;
  @override
  int? get pid => stopped ? null : 12345;
  @override
  Future<void> reset() async {}
  @override
  Version get version => Version(16, 13, 0);
}

void main() {
  test(
    'Given dialect=sqlite when resolving then result is passthrough '
    'regardless of source override.',
    () async {
      final result = await resolveDbSource(
        serverDir: '/tmp/unused',
        runMode: 'development',
        dialect: DatabaseDialect.sqlite,
        configSource: null,
        cliOverride: DatabaseSource.embedded,
        databaseName: 'db',
        username: 'u',
        embeddedPostgresStarter: (_) async => fail(
          'embedded starter must not be called for sqlite',
        ),
        prompter: (_) async => true,
        reachabilityProbe:
            ({required host, required port, required isUnixSocket}) async =>
                true,
      );

      expect(result.source, DatabaseSource.config);
      expect(result.envOverlay, isNull);
      expect(result.onStop, isNull);
    },
  );

  test(
    'Given runMode=production and source=auto when resolving then '
    'DbSourceResolutionException is thrown.',
    () async {
      expect(
        () => resolveDbSource(
          serverDir: '/tmp/unused',
          runMode: 'production',
          dialect: DatabaseDialect.postgres,
          configSource: null,
          cliOverride: DatabaseSource.auto,
          databaseName: 'db',
          username: 'u',
        ),
        throwsA(isA<DbSourceResolutionException>()),
      );
    },
  );

  test(
    'Given runMode=production and source=config when resolving then '
    'result is passthrough.',
    () async {
      final result = await resolveDbSource(
        serverDir: '/tmp/unused',
        runMode: 'production',
        dialect: DatabaseDialect.postgres,
        configSource: DatabaseSource.config,
        cliOverride: null,
        databaseName: 'db',
        username: 'u',
      );

      expect(result.source, DatabaseSource.config);
      expect(result.envOverlay, isNull);
    },
  );

  test(
    'Given source=embedded when resolving then embedded PG is booted, env '
    'overlay is built, and onStop teardown is wired.',
    () async {
      late final _FakeEmbeddedPostgres fake;
      final result = await resolveDbSource(
        serverDir: '/tmp/unused',
        runMode: 'development',
        dialect: DatabaseDialect.postgres,
        configSource: DatabaseSource.embedded,
        cliOverride: null,
        databaseName: 'projectname',
        username: 'postgres',
        embeddedPostgresStarter: (_) async {
          fake = _FakeEmbeddedPostgres(
            pg.Endpoint(
              host: '127.0.0.1',
              port: 49152,
              database: 'projectname',
              username: 'postgres',
              password: 'sup3r',
            ),
          );
          return fake;
        },
      );

      expect(result.source, DatabaseSource.embedded);
      expect(
        result.envOverlay?[ServerpodEnv.databaseHost.envVariable],
        '127.0.0.1',
      );
      expect(
        result.envOverlay?[ServerpodEnv.databasePort.envVariable],
        '49152',
      );
      expect(
        result.envOverlay?[ServerpodEnv.databaseSource.envVariable],
        'embedded',
      );

      expect(fake.stopped, isFalse);
      await result.onStop!();
      expect(fake.stopped, isTrue);
    },
  );

  test(
    'Given configSource=config and cliOverride=embedded when resolving '
    'then CLI wins.',
    () async {
      var bootCalled = false;
      final result = await resolveDbSource(
        serverDir: '/tmp/unused',
        runMode: 'development',
        dialect: DatabaseDialect.postgres,
        configSource: DatabaseSource.config,
        cliOverride: DatabaseSource.embedded,
        databaseName: 'db',
        username: 'u',
        embeddedPostgresStarter: (_) async {
          bootCalled = true;
          return _FakeEmbeddedPostgres(
            pg.Endpoint(host: '/tmp/sock', isUnixSocket: true, database: 'db'),
          );
        },
      );

      expect(bootCalled, isTrue);
      expect(result.source, DatabaseSource.embedded);
    },
  );

  group('Given source=auto', () {
    late Directory tmp;
    setUp(() => tmp = Directory.systemTemp.createTempSync('resolver_test_'));
    tearDown(() {
      if (tmp.existsSync()) tmp.deleteSync(recursive: true);
    });

    test(
      'when .serverpod/pgdata/PG_VERSION exists then resolver boots embedded '
      'without probing.',
      () async {
        final pgVersion = File(
          p.join(tmp.path, '.serverpod', 'pgdata', 'PG_VERSION'),
        );
        pgVersion.parent.createSync(recursive: true);
        pgVersion.writeAsStringSync('16\n');

        var probeCalled = false;
        var bootCalled = false;
        final result = await resolveDbSource(
          serverDir: tmp.path,
          runMode: 'development',
          dialect: DatabaseDialect.postgres,
          configSource: null,
          cliOverride: DatabaseSource.auto,
          databaseName: 'db',
          username: 'u',
          configuredHost: 'unreachable.invalid',
          configuredPort: 12345,
          embeddedPostgresStarter: (_) async {
            bootCalled = true;
            return _FakeEmbeddedPostgres(
              pg.Endpoint(host: '127.0.0.1', port: 49152, database: 'db'),
            );
          },
          reachabilityProbe:
              ({required host, required port, required isUnixSocket}) async {
                probeCalled = true;
                return true;
              },
        );

        expect(probeCalled, isFalse, reason: 'pgdata short-circuits the probe');
        expect(bootCalled, isTrue);
        expect(result.source, DatabaseSource.embedded);
      },
    );

    test(
      'when configured host is reachable then resolver returns passthrough.',
      () async {
        var bootCalled = false;
        final result = await resolveDbSource(
          serverDir: tmp.path,
          runMode: 'development',
          dialect: DatabaseDialect.postgres,
          configSource: DatabaseSource.auto,
          cliOverride: null,
          databaseName: 'db',
          username: 'u',
          configuredHost: 'localhost',
          configuredPort: 5432,
          reachabilityProbe:
              ({required host, required port, required isUnixSocket}) async =>
                  true,
          embeddedPostgresStarter: (_) async {
            bootCalled = true;
            fail('embedded must not boot when config host is reachable');
          },
        );

        expect(bootCalled, isFalse);
        expect(result.source, DatabaseSource.config);
        expect(result.envOverlay, isNull);
      },
    );

    test(
      'when nothing is reachable and the user declines the prompt then a '
      'DbSourceResolutionException is thrown.',
      () async {
        expect(
          () => resolveDbSource(
            serverDir: tmp.path,
            runMode: 'development',
            dialect: DatabaseDialect.postgres,
            configSource: DatabaseSource.auto,
            cliOverride: null,
            databaseName: 'db',
            username: 'u',
            configuredHost: 'localhost',
            configuredPort: 5432,
            interactive: true,
            reachabilityProbe:
                ({required host, required port, required isUnixSocket}) async =>
                    false,
            prompter: (_) async => false,
          ),
          throwsA(isA<DbSourceResolutionException>()),
        );
      },
    );

    test(
      'when nothing is reachable, non-interactive, then resolver falls back '
      'to embedded.',
      () async {
        var bootCalled = false;
        final result = await resolveDbSource(
          serverDir: tmp.path,
          runMode: 'development',
          dialect: DatabaseDialect.postgres,
          configSource: DatabaseSource.auto,
          cliOverride: null,
          databaseName: 'db',
          username: 'u',
          configuredHost: 'localhost',
          configuredPort: 5432,
          interactive: false,
          reachabilityProbe:
              ({required host, required port, required isUnixSocket}) async =>
                  false,
          embeddedPostgresStarter: (_) async {
            bootCalled = true;
            return _FakeEmbeddedPostgres(
              pg.Endpoint(host: '127.0.0.1', port: 49152, database: 'db'),
            );
          },
        );

        expect(bootCalled, isTrue);
        expect(result.source, DatabaseSource.embedded);
      },
    );

    test(
      'when nothing is reachable and user accepts the prompt then resolver '
      'boots embedded.',
      () async {
        var promptCalled = false;
        var bootCalled = false;
        final result = await resolveDbSource(
          serverDir: tmp.path,
          runMode: 'development',
          dialect: DatabaseDialect.postgres,
          configSource: DatabaseSource.auto,
          cliOverride: null,
          databaseName: 'db',
          username: 'u',
          configuredHost: 'localhost',
          configuredPort: 5432,
          interactive: true,
          reachabilityProbe:
              ({required host, required port, required isUnixSocket}) async =>
                  false,
          prompter: (msg) async {
            promptCalled = true;
            return true;
          },
          embeddedPostgresStarter: (_) async {
            bootCalled = true;
            return _FakeEmbeddedPostgres(
              pg.Endpoint(host: '127.0.0.1', port: 49152, database: 'db'),
            );
          },
        );

        expect(promptCalled, isTrue);
        expect(bootCalled, isTrue);
        expect(result.source, DatabaseSource.embedded);
      },
    );
  });
}
