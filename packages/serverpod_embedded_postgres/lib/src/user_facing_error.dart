import 'package:serverpod_shared/serverpod_shared.dart';

import 'exceptions.dart';

const _dockerFallback =
    'To use Docker instead, remove `database.dataPath` from the relevant '
    'file in `config/`, then run `serverpod start --docker`.';

/// Whether [error] should be accompanied by a stack trace when shown to a
/// user for issue reporting.
bool shouldReportEmbeddedPostgresFailure(Object error) => switch (error) {
  UnsupportedPlatformException() ||
  UnsupportedVersionException() ||
  PostmasterLockBusyException() ||
  StaleClusterException() ||
  AttachException() => false,
  _ => true,
};

/// Converts an embedded PostgreSQL startup failure into guidance intended for
/// a Serverpod user.
///
/// Expected user-correctable conditions receive a direct remedy. Failures that
/// indicate a possible Serverpod defect use the standard issue-reporting
/// guidance; unexpected errors also retain their original diagnostic text.
String formatEmbeddedPostgresFailure(Object error) {
  var guidance = error is! EmbeddedPostgresException
      ? 'Serverpod could not start the local database.\n\n'
            '${formatInternalErrorMessage(error)}'
      : switch (error) {
          UnsupportedPlatformException() =>
            'The embedded database is not available on this platform.',
          UnsupportedVersionException() =>
            'This Serverpod version cannot prepare the configured local database. '
                'Update Serverpod and try again.',
          PostmasterLockBusyException() =>
            'Another process is using the local database. Stop other Serverpod '
                'or database processes for this project, then try again.',
          StaleClusterException(:final existingMajor, :final requestedMajor) =>
            'The local database was created with PostgreSQL $existingMajor, but '
                'this Serverpod version uses PostgreSQL $requestedMajor. If the '
                'local data can be discarded, back up anything important and '
                'delete the configured database data directory before retrying.',
          AttachException() =>
            'Serverpod could not reconnect to the local database. Stop other '
                'Serverpod or database processes for this project, then try again.',
          BinaryFetchException(:final statusCode) when statusCode != 404 =>
            'Serverpod could not download the local database. Check your internet '
                'connection and try again.\n\n${formatInternalErrorMessage()}',
          BinaryFetchException() =>
            'The local database required by this Serverpod version is '
                'unavailable.\n\n${formatInternalErrorMessage()}',
          BinaryVerificationException() =>
            'Serverpod could not verify the downloaded local database. '
                'Try again.\n\n${formatInternalErrorMessage()}',
          BinaryBuildException() =>
            'Serverpod could not prepare the local database.\n\n'
                '${formatInternalErrorMessage()}',
          InitializeDatabaseException() =>
            'Serverpod could not create the local database.\n\n'
                '${formatInternalErrorMessage()}',
          StartupTimeoutException() || CrashedException() =>
            'The local database did not start successfully.\n\n'
                '${formatInternalErrorMessage()}',
        };

  return '$guidance\n\n$_dockerFallback';
}
