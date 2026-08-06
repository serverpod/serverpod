@Tags(['integration'])
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_embedded_postgres/src/binary/binary_store.dart';
import 'package:serverpod_embedded_postgres/src/binary/maven_url.dart';
import 'package:serverpod_embedded_postgres/src/cluster/cluster_store.dart';
import 'package:serverpod_embedded_postgres/src/cluster/postgres_conf_builder.dart';
import 'package:test/test.dart';

/// Exercises ClusterStore against a real PG install fetched via the prod
/// BinaryStore cache. Uses a tempdir for PGDATA so each run is isolated.
void main() {
  late Directory dataRoot;
  late Directory pgDataDir;
  late Directory installDir;

  setUpAll(() async {
    var store = BinaryStore();
    var artifact = ZonkyArtifact.forCurrentPlatform(
      version: Version(16, 13, 0),
    );
    installDir = await store.ensure(artifact);
    store.close();
  });

  setUp(() {
    dataRoot = Directory.systemTemp.createTempSync('cluster_store_test_');
    pgDataDir = Directory(p.join(dataRoot.path, 'pgdata'));
    Directory(p.join(dataRoot.path, 'run')).createSync();
  });

  tearDown(() {
    if (dataRoot.existsSync()) dataRoot.deleteSync(recursive: true);
  });

  group('Given a fresh data directory and a real PG install', () {
    test(
      'when ensureInitialized runs '
      "then PG_VERSION is written and matches the install's major.",
      () async {
        var cluster = ClusterStore(installDir: installDir, dataDir: pgDataDir);

        await cluster.ensureInitialized(username: 'postgres');

        expect(cluster.isInitialized, isTrue);
        expect(cluster.existingMajor, 16);
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when ensureInitialized runs twice '
      'then the second call is a no-op (idempotent).',
      () async {
        var cluster = ClusterStore(installDir: installDir, dataDir: pgDataDir);

        await cluster.ensureInitialized(username: 'postgres');
        var firstMtime = File(
          p.join(pgDataDir.path, 'PG_VERSION'),
        ).statSync().modified;

        await Future<void>.delayed(const Duration(milliseconds: 100));
        await cluster.ensureInitialized(username: 'postgres');
        var secondMtime = File(
          p.join(pgDataDir.path, 'PG_VERSION'),
        ).statSync().modified;

        expect(
          secondMtime,
          firstMtime,
          reason: 'PG_VERSION must not be touched on the second call',
        );
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });

  group('Given an initialized cluster', () {
    late ClusterStore cluster;

    setUp(() async {
      cluster = ClusterStore(installDir: installDir, dataDir: pgDataDir);
      await cluster.ensureInitialized(username: 'postgres');
    });

    test(
      'when reconcilePostgresConf is called for UnixTransport '
      'then our managed block is present and unix_socket_directories is "../run".',
      () async {
        cluster.reconcilePostgresConf(transport: const UnixTransport());

        var conf = File(
          p.join(pgDataDir.path, 'postgresql.conf'),
        ).readAsStringSync();
        expect(conf, contains(confBlockBeginMarker));
        expect(conf, contains(confBlockEndMarker));
        expect(conf, contains("unix_socket_directories = '../run'"));
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when reconcilePostgresConf is called twice with different transports '
      'then the second call replaces the block (not duplicates it).',
      () async {
        cluster.reconcilePostgresConf(transport: const UnixTransport());
        cluster.reconcilePostgresConf(
          transport: const TcpTransport(port: 5433),
        );

        var conf = File(
          p.join(pgDataDir.path, 'postgresql.conf'),
        ).readAsStringSync();
        expect(
          confBlockBeginMarker.allMatches(conf).length,
          1,
          reason: 'BEGIN marker must appear exactly once after re-reconcile',
        );
        expect(conf, contains('port = 5433'));
        expect(conf, isNot(contains("unix_socket_directories = '../run'")));
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when requireMajorMatch is called with a different major '
      'then StaleClusterException is thrown.',
      () async {
        expect(
          () => cluster.requireMajorMatch(15),
          throwsA(isA<StaleClusterException>()),
        );
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when requireMajorMatch is called with a matching major '
      'then it returns without throwing.',
      () async {
        expect(() => cluster.requireMajorMatch(16), returnsNormally);
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });
}
