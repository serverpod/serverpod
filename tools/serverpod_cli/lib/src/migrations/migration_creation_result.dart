import 'package:serverpod_cli/analyzer.dart';

/// Represents the result of a migration creation operation.
enum MigrationCreationStatus {
  /// Migration was created successfully.
  success,

  /// No changes were detected, no migration was created.
  noChanges,

  /// An error occurred during migration creation.
  error,
}

/// Result wrapper for migration creation operations.
class MigrationCreationResult {
  /// The created migration version, null if no migration was created.
  final MigrationVersion? migration;

  /// The status of the migration creation operation.
  final MigrationCreationStatus status;

  /// Optional message describing the result.
  final String? message;

  /// Creates a successful result with the created migration.
  MigrationCreationResult.success(this.migration)
      : status = MigrationCreationStatus.success,
        message = null;

  /// Creates a result indicating no changes were detected.
  const MigrationCreationResult.noChanges([this.message])
      : migration = null,
        status = MigrationCreationStatus.noChanges;

  /// Creates a result indicating an error occurred.
  const MigrationCreationResult.error([this.message])
      : migration = null,
        status = MigrationCreationStatus.error;

  /// Returns true if the operation was successful.
  bool get isSuccess => status == MigrationCreationStatus.success;

  /// Returns true if no changes were detected.
  bool get isNoChanges => status == MigrationCreationStatus.noChanges;

  /// Returns true if an error occurred.
  bool get isError => status == MigrationCreationStatus.error;
}
