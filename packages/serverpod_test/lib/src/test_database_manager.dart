import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_shared/serverpod_shared.dart';

/// Creates and drops the per-group PostgreSQL databases that back
/// `withServerpod` tests, so groups that commit (rather than rolling back) can
/// run in parallel without sharing state.
///
/// All databases live on the one embedded postmaster resolved from the project
/// config; isolation comes from each group owning its own database, not its own
/// postmaster. Administrative statements run against the always-present
/// `postgres` maintenance database.
class TestDatabaseManager {
  /// Connection coordinates for the postmaster.
  final PostgresDatabaseConfig _connectivity;

  /// Creates a manager for the server reachable via [connectivity].
  TestDatabaseManager(PostgresDatabaseConfig connectivity)
    : _connectivity = connectivity;

  static final Random _random = Random.secure();

  /// A 64-bit random token as 16 hex chars - wide enough that the per-call
  /// tokens of every group across every parallel suite stay collision-free.
  static String _randomToken() =>
      List.generate(16, (_) => _random.nextInt(16).toRadixString(16)).join();

  /// A process-unique database name. Decided eagerly by the caller (before any
  /// server is constructed) so the per-group database name can be baked into
  /// the configuration up front and only its creation deferred to start-up.
  ///
  /// `dart test` runs suites as isolates sharing one OS process (one `pid`),
  /// so a fresh random token per call - not `pid` - is what keeps names from
  /// colliding across the parallel groups of every parallel suite.
  static String generateDatabaseName() => 'sp_test_${pid}_${_randomToken()}';

  /// Creates a fresh, empty database named [name]. The caller is responsible
  /// for applying the schema (e.g. by booting a server against it with
  /// migrations enabled).
  Future<void> createEmptyDatabase(String name) async {
    _assertIdentifierFits(name);
    await _runAdmin(
      (admin) => admin.execute('CREATE DATABASE ${_ident(name)};'),
    );
  }

  /// Drops the database [name], terminating any lingering connections.
  Future<void> dropDatabase(String name) => _runAdmin(
    (admin) =>
        admin.execute('DROP DATABASE IF EXISTS ${_ident(name)} WITH (FORCE);'),
  );

  /// Quotes [name] as a PostgreSQL identifier, doubling embedded quotes.
  String _ident(String name) => '"${name.replaceAll('"', '""')}"';

  /// PostgreSQL silently truncates identifiers past 63 bytes; fail loudly
  /// instead of risking a collision.
  void _assertIdentifierFits(String identifier) {
    final bytes = utf8.encode(identifier).length;
    if (bytes > 63) {
      throw ArgumentError(
        'Derived database identifier "$identifier" is $bytes bytes, over '
        "PostgreSQL's 63-byte limit.",
      );
    }
  }

  Future<T> _runAdmin<T>(
    Future<T> Function(pg.Connection admin) action,
  ) async {
    final admin = await _openAdmin();
    try {
      return await action(admin);
    } finally {
      await admin.close();
    }
  }

  Future<pg.Connection> _openAdmin() => pg.Connection.open(
    pg.Endpoint(
      host: _connectivity.host,
      port: _connectivity.port,
      database: 'postgres',
      username: _connectivity.user,
      password: _connectivity.password,
      isUnixSocket: _connectivity.isUnixSocket,
    ),
    settings: pg.ConnectionSettings(
      sslMode: _connectivity.requireSsl
          ? pg.SslMode.require
          : pg.SslMode.disable,
    ),
  );
}
