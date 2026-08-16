import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given an unexpected Serverpod error, '
    'when the issue-reporting message is formatted, '
    'then it asks for an issue with reproduction details and includes the error.',
    () {
      var message = formatInternalErrorMessage(StateError('unexpected'));

      expect(
        message,
        'Yikes! It is possible that this error is caused by an internal issue '
        'with the Serverpod tooling. We would appreciate if you filed an issue '
        'over at Github. Please include the stack trace below and describe any '
        'steps you did to trigger the error.\n\n'
        '$serverpodIssueTrackerUrl\n\n'
        'Bad state: unexpected',
      );
    },
  );
}
