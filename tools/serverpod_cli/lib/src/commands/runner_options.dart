import 'package:config/config.dart';

/// The options that shape the stack a runner brings up.
///
/// Shared by `runner start` and the hidden `runner serve`, which spawn the
/// same stack and must agree on every default: `serverpod start` brings a
/// runner up by re-emitting these flags to `runner serve`, so a default that
/// drifts between the two changes behaviour on only one of the paths.
const runnerWatchOption = FlagOption(
  argName: 'watch',
  argAbbrev: 'w',
  defaultsTo: true,
  negatable: true,
  helpText: 'Watch files and use the Frontend Server.',
);

/// The server directory for a command that brings a runner up.
const runnerDirectoryOption = StringOption(
  argName: 'directory',
  argAbbrev: 'd',
  defaultsTo: '',
  helpText: 'The server directory.',
);

const runnerDockerOption = FlagOption(
  argName: 'docker',
  helpText: 'Start Docker Compose services if a compose file exists.',
);

const runnerFlutterOption = FlagOption(
  argName: 'flutter',
  defaultsTo: true,
  helpText: 'Auto-launch companion Flutter apps on the first UI attach.',
);

/// The server directory for a command that talks to a runner already up.
///
/// Unlike [runnerDirectoryOption] this has no default: `attach`, `status` and
/// `stop` auto-detect the project from the current directory rather than
/// falling back to the package root.
const clientDirectoryOption = StringOption(
  argName: 'directory',
  argAbbrev: 'd',
  helpText:
      'The server directory (defaults to auto-detect from current '
      'directory).',
);
