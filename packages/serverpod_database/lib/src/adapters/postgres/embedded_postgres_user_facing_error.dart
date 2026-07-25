import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

const _dockerFallback =
    'To use Docker instead, remove `database.dataPath` from the relevant '
    'file in `config/`, then try again.';

/// Whether [error] should be accompanied by its diagnostic details and stack
/// trace when shown to a Serverpod user for issue reporting.
bool shouldReportEmbeddedPostgresFailure(Object error) => switch (error) {
  BinaryFetchException(kind: BinaryFetchFailureKind.download) ||
  UnsupportedPlatformException() ||
  UnsupportedVersionException() ||
  PostmasterLockBusyException() ||
  StaleClusterException() ||
  AttachException() => false,
  _ => true,
};

/// Converts an embedded PostgreSQL startup failure into guidance for a
/// Serverpod user.
///
/// Expected user-correctable conditions receive a direct remedy. Failures that
/// indicate a possible Serverpod defect use the standard issue-reporting
/// guidance; unexpected errors also retain their original diagnostic text.
String formatEmbeddedPostgresFailure(Object error) {
  final userFacingMessage = switch (error) {
    UnsupportedPlatformException() =>
      'The embedded database is not available on this platform.',
    UnsupportedVersionException() =>
      'This Serverpod version cannot prepare the configured local database. '
          'Update Serverpod and try again.',
    PostmasterLockBusyException() =>
      'Another process is using the local database. Stop other Serverpod or '
          'database processes for this project, then try again.',
    StaleClusterException(:final existingMajor, :final requestedMajor) =>
      'The local database was created with PostgreSQL $existingMajor, but '
          'this Serverpod version uses PostgreSQL $requestedMajor. If the '
          'local data can be discarded, back up anything important and '
          'delete the configured database data directory before retrying.',
    AttachException() =>
      'Serverpod could not reconnect to the local database. Stop other '
          'Serverpod or database processes for this project, then try again.',
    BinaryFetchException(kind: BinaryFetchFailureKind.download) =>
      'Serverpod could not download the local database. Check your internet '
          'connection and try again.',
    BinaryFetchException(kind: BinaryFetchFailureKind.unavailable) =>
      'The local database required by this Serverpod version is unavailable.',
    BinaryFetchException() => 'Serverpod could not prepare the local database.',
    BinaryVerificationException() =>
      'Serverpod could not verify the downloaded local database. Try again.',
    BinaryBuildException() => 'Serverpod could not prepare the local database.',
    InitializeDatabaseException() =>
      'Serverpod could not create the local database.',
    StartupTimeoutException() ||
    CrashedException() => 'The local database did not start successfully.',
    _ => 'Serverpod could not start the local database.',
  };

  final formattedMessage =
      '$userFacingMessage\n\n'
      '$_dockerFallback';

  return shouldReportEmbeddedPostgresFailure(error)
      ? '$formattedMessage\n\n${formatInternalErrorMessage(error)}'
      : formattedMessage;
}
