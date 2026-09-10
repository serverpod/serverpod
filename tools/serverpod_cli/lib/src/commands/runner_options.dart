import 'package:config/config.dart';

// Shared by `runner start` and `runner serve`, so passed flags parse alike.

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
/// Unset, the project is found from the current directory without a prompt.
const clientDirectoryOption = StringOption(
  argName: 'directory',
  argAbbrev: 'd',
  helpText:
      'The server directory (defaults to auto-detect from current '
      'directory).',
);
