/// URL where users can report internal Serverpod errors.
const serverpodIssueTrackerUrl =
    'https://github.com/serverpod/serverpod/issues';

/// Formats an unexpected error using Serverpod's standard issue-reporting
/// guidance.
///
/// Pass [error] when its text is safe and useful to include in the report.
String formatInternalErrorMessage([Object? error]) {
  var message =
      'Yikes! It is possible that this error is caused by an internal issue '
      'with the Serverpod tooling. We would appreciate if you filed an issue '
      'over at Github. Please include the stack trace below and describe any '
      'steps you did to trigger the error.\n\n'
      '$serverpodIssueTrackerUrl';
  if (error != null) message += '\n\n$error';
  return message;
}
