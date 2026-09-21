import 'package:path/path.dart' as p;

/// The directory holding every artifact the runner publishes for [serverDir].
String serverpodToolDirPath(String serverDir) =>
    p.join(serverDir, '.dart_tool', 'serverpod');

/// The runner's manifest file.
String serverpodRunnerManifestPath(String serverDir) =>
    p.join(serverpodToolDirPath(serverDir), 'runner.json');

/// The lock file that admits one runner per server package.
String serverpodRunnerLockPath(String serverDir) =>
    p.join(serverpodToolDirPath(serverDir), 'runner.lock');

/// The attach socket's file name. See `docs/design/runner.md#runner-api`.
const serverpodTuiSocketName = 'tui.sock';

/// The MCP socket's file name.
const serverpodMcpSocketName = 'mcp.sock';

/// The socket a UI attaches to.
String serverpodTuiSocketPath(String serverDir) =>
    p.join(serverpodToolDirPath(serverDir), serverpodTuiSocketName);

/// The file a detached runner writes its output to.
String serverpodRunnerLogPath(String serverDir) =>
    p.join(serverpodToolDirPath(serverDir), 'runner.log');
