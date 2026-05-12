import 'package:postgres/postgres.dart' as pg;
import 'package:serverpod_shared/serverpod_shared.dart';

/// Builds a Serverpod [DatabaseConfig] pointing at a running embedded
/// PostgreSQL postmaster.
///
/// [endpoint] is the `pg.Endpoint` returned from [EmbeddedPostgres.endpoint];
/// [databaseName] and [username] are forwarded as the [DatabaseConfig] `name`
/// and `user` (with `endpoint.username` taking precedence over [username]
/// when set, mirroring `package:postgres`'s own precedence).
///
/// [source] is preset to [DatabaseSource.embedded] so the resulting config
/// announces its provenance in logs and downstream tooling.
///
/// Consumed by `serverpod_test`'s `EmbeddedPostgresTestFixture` to build a
/// `ServerpodConfig.copyWith(database: ...)` override; the same logical
/// mapping is exposed in env-variable form via
/// [envOverlayForEmbeddedPostgres] for `serverpod_cli`'s `serverpod start`
/// auto-spawn path.
DatabaseConfig databaseConfigForEmbeddedPostgres({
  required pg.Endpoint endpoint,
  required String databaseName,
  required String username,
}) {
  return DatabaseConfig(
    host: endpoint.host,
    port: endpoint.port,
    user: endpoint.username ?? username,
    password: endpoint.password ?? '',
    name: databaseName,
    isUnixSocket: endpoint.isUnixSocket,
    source: DatabaseSource.embedded,
  );
}

/// Builds a `SERVERPOD_DATABASE_*` environment-variable overlay pointing at
/// a running embedded PostgreSQL postmaster.
///
/// Suitable for `Process.start(..., environment: overlay,
/// includeParentEnvironment: true)` so the spawned pod's config loader
/// picks up the embedded endpoint instead of whatever the on-disk config
/// would otherwise dictate. The pod-side merge is handled by the existing
/// env-var support in `ServerpodConfig.loadFromMap` - no special-casing on
/// the pod side.
///
/// `SERVERPOD_DATABASE_SOURCE` is set to `embedded` so the running pod
/// records its provenance via the schema field added in the slice-A
/// schema change.
Map<String, String> envOverlayForEmbeddedPostgres({
  required pg.Endpoint endpoint,
  required String databaseName,
  required String username,
}) {
  return {
    ServerpodEnv.databaseHost.envVariable: endpoint.host,
    ServerpodEnv.databasePort.envVariable: endpoint.port.toString(),
    ServerpodEnv.databaseName.envVariable: databaseName,
    ServerpodEnv.databaseUser.envVariable: endpoint.username ?? username,
    ServerpodEnv.databaseIsUnixSocket.envVariable: endpoint.isUnixSocket
        .toString(),
    ServerpodEnv.databaseSource.envVariable: DatabaseSource.embedded.name,
    ServerpodPassword.databasePassword.envVariable: endpoint.password ?? '',
  };
}
