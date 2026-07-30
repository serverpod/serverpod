import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_shared/process_io.dart';
import 'package:uuid/uuid.dart';

({String projectName, String commandRoot}) createRandomProjectName(
  String root,
) {
  // Short on purpose: the name appears twice in the created project's
  // absolute temp path, and macOS install_name_tool rejects install names
  // longer than sqlite3_connection_pool's precompiled (headerpad-less)
  // dylibs can absorb (~170 chars) when dartdev patches them in .dart_tool.
  final projectName = 't${Uuid().v4().replaceAll('-', '').substring(0, 9)}';
  final commandRoot = path.join(root, projectName, '${projectName}_server');

  return (projectName: projectName, commandRoot: commandRoot);
}

({String serverDir, String flutterDir, String clientDir})
createProjectFolderPaths(String projectName) {
  final serverDir = path.join(projectName, '${projectName}_server');
  final flutterDir = path.join(projectName, '${projectName}_flutter');
  final clientDir = path.join(projectName, '${projectName}_client');

  return (serverDir: serverDir, flutterDir: flutterDir, clientDir: clientDir);
}

String createServerFolderPath(String projectName) {
  return path.join(projectName, '${projectName}_server');
}

String createFlutterFolderPath(String projectName) {
  return path.join(projectName, '${projectName}_flutter');
}

String createClientFolderPath(String projectName) {
  return path.join(projectName, '${projectName}_client');
}

Future<ProcessResult> runProcess(
  String command,
  List<String> arguments, {
  String? workingDirectory,
  Map<String, String>? environment,
  bool skipBatExtentionOnWindows = false,
}) async {
  var process = await Process.run(
    _getCommandToRun(command, skipBatExtentionOnWindows),
    arguments,
    workingDirectory: workingDirectory,
    environment: environment,
  );

  print('COMMAND "$command" stdout: ${process.stdout}');
  print('COMMAND "$command" stderr: ${process.stderr}');

  return process;
}

Future<Process> startProcess(
  String command,
  List<String> arguments, {
  String? workingDirectory,
  Map<String, String>? environment,
  bool ignorePlatform = false,
}) async {
  var process = await Process.start(
    _getCommandToRun(command, ignorePlatform),
    arguments,
    workingDirectory: workingDirectory,
    environment: environment,
  );

  process.stderr
      .transform(utf8.decoder)
      .listen((e) => print('COMMAND "$command" stderr: $e'));
  process.stdout
      .transform(utf8.decoder)
      .listen((e) => print('COMMAND "$command" stdout: $e'));

  return process;
}

Future<Process> startProcessAndWaitForKeywords(
  String command,
  List<String> arguments, {
  String? workingDirectory,
  Map<String, String>? environment,
  bool ignorePlatform = false,
  required List<String> keywords,
}) async {
  final completer = Completer<Process>();

  var process = await Process.start(
    _getCommandToRun(command, ignorePlatform),
    arguments,
    workingDirectory: workingDirectory,
    environment: environment,
  );

  void checkForKeywords(String data) {
    if (keywords.isEmpty) return;
    for (var keyword in keywords) {
      if (data.contains(keyword)) {
        if (!completer.isCompleted) {
          completer.complete(process);
        }
      }
    }
  }

  process.stderr.transform(utf8.decoder).listen((e) {
    print('COMMAND "$command" stderr: $e');
    checkForKeywords(e);
  });
  process.stdout.transform(utf8.decoder).listen((e) {
    print('COMMAND "$command" stdout: $e');
    checkForKeywords(e);
  });

  if (keywords.isEmpty && !completer.isCompleted) {
    completer.complete(process);
  }

  return completer.future;
}

Future<Process> startServerpodCli(
  List<String> arguments, {
  required String rootPath,
  String? workingDirectory,
  Map<String, String>? environment,
  bool ignorePlatform = false,
}) async {
  final exe = await compiledServerpodCli(rootPath: rootPath);
  return startProcess(
    exe,
    arguments,
    workingDirectory: workingDirectory,
    environment: environment,
    ignorePlatform: true,
  );
}

Future<ProcessResult> runServerpodCli(
  List<String> arguments, {
  required String rootPath,
  String? workingDirectory,
  Map<String, String>? environment,
  bool skipBatExtentionOnWindows = false,
}) async {
  final exe = await compiledServerpodCli(rootPath: rootPath);
  return runProcess(
    exe,
    arguments,
    workingDirectory: workingDirectory,
    environment: environment,
    skipBatExtentionOnWindows: true,
  );
}

/// Runs `serverpod create` non-interactively for [projectName] and throws if
/// the command does not exit successfully.
///
/// Pass [template] to select a non-default project template (e.g. `server`).
Future<void> createProject({
  required String rootPath,
  required String tempPath,
  required String projectName,
  required List<String> options,
  String? template,
}) async {
  final createProcess = await startServerpodCli(
    [
      'create',
      projectName,
      if (template != null) ...['--template', template],
      ...options,
      '--no-analytics',
      '--no-interactive',
    ],
    rootPath: rootPath,
    workingDirectory: tempPath,
    environment: {'SERVERPOD_HOME': rootPath},
  );

  final exitCode = await createProcess.exitCode;
  if (exitCode != 0) {
    throw StateError(
      'Failed to create project $projectName '
      '(template: ${template ?? 'default'}) with options $options '
      '(exit code $exitCode).',
    );
  }
}

Future<String>? _compiledServerpodCli;

/// Path to the compiled in-repo serverpod CLI, built once per `dart test` run.
///
/// A prebuilt CLI can be supplied via SERVERPOD_CLI_EXE.
Future<String> compiledServerpodCli({required String rootPath}) =>
    _compiledServerpodCli ??= _compileServerpodCli(rootPath);

Future<String> _compileServerpodCli(String rootPath) async {
  // Keyed on `dart test` run pid. Shared by its isolates.
  const prefix = 'serverpod_bootstrap_cli_';
  _cleanupStaleBuildDirs(prefix);
  return buildServerpodCli(
    buildRoot: path.join(Directory.systemTemp.path, '$prefix$pid'),
    serverpodHome: rootPath,
  );
}

/// Deletes CLI build dirs left behind by previous runs (older than a day).
void _cleanupStaleBuildDirs(String prefix) {
  final now = DateTime.now();
  for (final entity in Directory.systemTemp.listSync()) {
    if (entity is! Directory) continue;
    final name = path.basename(entity.path);
    if (!name.startsWith(prefix)) continue;
    if (name == '$prefix$pid') continue;
    if (now.difference(entity.statSync().modified).inDays < 1) continue;
    try {
      entity.deleteSync(recursive: true);
    } catch (_) {
      // Might be in use by a concurrent run.
    }
  }
}

String getServerpodCliProjectPath({required final String rootPath}) {
  return path.join(
    rootPath,
    'tools',
    'serverpod_cli',
  );
}

String getServerpodCliEntrypointPath({required final String rootPath}) {
  return path.join(
    getServerpodCliProjectPath(rootPath: rootPath),
    'bin',
    'serverpod_cli.dart',
  );
}

String _getCommandToRun(String command, bool ignorePlatform) {
  // The real SDK binary, so kill()/signals reach the process: a PATH 'dart'
  // may be a version-manager shell shim (puro, fvm) that neither forwards
  // signals nor dies with its child - leaking spawned servers that keep
  // their ports (e.g. 8080) bound for subsequent tests.
  if (command == 'dart') return dartExecutablePath;

  if (ignorePlatform) {
    return command;
  }

  return Platform.isWindows ? '$command.bat' : command;
}
