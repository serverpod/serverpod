/// Result of comparing the live database to the target schema.
class DatabaseIntegrityCheck {
  /// Creates a [DatabaseIntegrityCheck].
  DatabaseIntegrityCheck({
    required this.warnings,
    required this.missingTables,
  });

  /// Human-readable mismatch descriptions. Empty when the schema matches.
  final List<String> warnings;

  /// Target table names that are not present in the live database.
  final Set<String> missingTables;

  /// Whether the live schema matches the target (no warnings).
  bool get matchesTarget => warnings.isEmpty;

  /// Framework table that records installed migration versions.
  static const migrationsTable = 'serverpod_migrations';

  /// Framework table for runtime log settings.
  static const runtimeSettingsTable = 'serverpod_runtime_settings';

  /// Framework table for persisted future calls.
  static const futureCallTable = 'serverpod_future_call';

  /// Framework table for health metric samples.
  static const healthMetricTable = 'serverpod_health_metric';

  /// Framework table for connection-info health samples.
  static const healthConnectionInfoTable = 'serverpod_health_connection_info';

  /// Framework table for persistent session logs.
  static const sessionLogTable = 'serverpod_session_log';

  /// Whether [runtimeSettingsTable] is missing.
  bool get runtimeSettingsTableMissing =>
      missingTables.contains(runtimeSettingsTable);

  /// Whether [futureCallTable] is missing.
  bool get futureCallTableMissing => missingTables.contains(futureCallTable);

  /// Whether either health table is missing.
  bool get healthTablesMissing =>
      missingTables.contains(healthMetricTable) ||
      missingTables.contains(healthConnectionInfoTable);

  /// Whether [sessionLogTable] is missing.
  bool get sessionLogTableMissing => missingTables.contains(sessionLogTable);

  /// Whether any framework table used by DB-backed loops is missing.
  bool get frameworkTablesMissing =>
      runtimeSettingsTableMissing ||
      futureCallTableMissing ||
      healthTablesMissing ||
      sessionLogTableMissing;
}
