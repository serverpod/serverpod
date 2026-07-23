import 'package:serverpod_database/embedded.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given an embedded database condition the user can correct, '
    'when the failure is formatted for Serverpod, '
    'then it gives the direct remedy and Docker fallback without reporting an internal issue.',
    () {
      const failure = StaleClusterException(
        'internal cluster details',
        existingMajor: 15,
        requestedMajor: 16,
      );

      var message = formatEmbeddedPostgresFailure(failure);

      expect(
        message,
        'The local database was created with PostgreSQL 15, but this Serverpod '
        'version uses PostgreSQL 16. If the local data can be discarded, back '
        'up anything important and delete the configured database data directory '
        'before retrying.\n\n'
        'To use Docker instead, remove `database.dataPath` from the relevant '
        'file in `config/`, then try again.',
      );
      expect(shouldReportEmbeddedPostgresFailure(failure), isFalse);
    },
  );

  test(
    'Given an embedded database failure that may be a Serverpod issue, '
    'when the failure is formatted for Serverpod, '
    'then it places recovery guidance before issue-reporting and diagnostic details.',
    () {
      const failure = BinaryFetchException(
        'release asset returned 404',
        statusCode: 404,
        kind: BinaryFetchFailureKind.unavailable,
      );

      var message = formatEmbeddedPostgresFailure(failure);

      expect(
        message,
        'The local database required by this Serverpod version is unavailable.\n\n'
        'To use Docker instead, remove `database.dataPath` from the relevant '
        'file in `config/`, then try again.\n\n'
        'Yikes! It is possible that this error is caused by an internal issue '
        'with the Serverpod tooling. We would appreciate if you filed an issue '
        'over at Github. Please include the stack trace below and describe any '
        'steps you did to trigger the error.\n\n'
        'https://github.com/serverpod/serverpod/issues\n\n'
        'BinaryFetchException: release asset returned 404',
      );
      expect(shouldReportEmbeddedPostgresFailure(failure), isTrue);
    },
  );

  test(
    'Given an unexpected embedded database error, '
    'when the failure is formatted for Serverpod, '
    'then it preserves the error through the standard issue-reporting mechanism.',
    () {
      var message = formatEmbeddedPostgresFailure(
        StateError('unexpected startup failure'),
      );

      expect(
        message,
        'Serverpod could not start the local database.\n\n'
        'To use Docker instead, remove `database.dataPath` from the relevant '
        'file in `config/`, then try again.\n\n'
        'Yikes! It is possible that this error is caused by an internal issue '
        'with the Serverpod tooling. We would appreciate if you filed an issue '
        'over at Github. Please include the stack trace below and describe any '
        'steps you did to trigger the error.\n\n'
        'https://github.com/serverpod/serverpod/issues\n\n'
        'Bad state: unexpected startup failure',
      );
      expect(
        shouldReportEmbeddedPostgresFailure(
          StateError('unexpected startup failure'),
        ),
        isTrue,
      );
    },
  );

  test(
    'Given a bundle download failure without an HTTP status, '
    'when the failure is formatted for Serverpod, '
    'then it is described as a network failure rather than a missing bundle.',
    () {
      const failure = BinaryFetchException(
        'download timed out',
        kind: BinaryFetchFailureKind.download,
      );

      var message = formatEmbeddedPostgresFailure(failure);

      expect(
        message,
        'Serverpod could not download the local database. Check your internet '
        'connection and try again.\n\n'
        'To use Docker instead, remove `database.dataPath` from the relevant '
        'file in `config/`, then try again.',
      );
      expect(shouldReportEmbeddedPostgresFailure(failure), isFalse);
    },
  );
}
