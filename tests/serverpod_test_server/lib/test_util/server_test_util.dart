import 'dart:io';

abstract class ServerTestUtils {
  static Future<Process> runServerWithServerIdFromEnvironment(
      String serverId) async {
    return await _runProcess(
      'dart',
      arguments: [
        'run',
        'bin/main.dart',
        '--apply-migrations',
        '--mode',
        'production',
        '--logging',
        'normal',
      ],
      environment: {
        'SERVERPOD_SERVER_ID': serverId,
      },
    );
  }

  static Future<Process> runServerWithServerIdFromCommandLineArg(
      String serverId) async {
    return await _runProcess(
      'dart',
      arguments: [
        'run',
        'bin/main.dart',
        '--apply-migrations',
        '--server-id=$serverId',
        '--mode',
        'production',
        '--logging',
        'normal',
      ],
    );
  }

  static Future<Process> runServerWithOutServerId() async {
    return await _runProcess(
      'dart',
      arguments: [
        'run',
        'bin/main.dart',
        '--apply-migrations',
        '--mode',
        'production',
        '--logging',
        'normal',
      ],
    );
  }

  static Future<Process>
  runServerWithServerIdFromBothCommandLineArgAndEnvironment(
      String commandLineServerId, String environmentServerID) async {
    return await _runProcess(
      'dart',
      arguments: [
        'run',
        'bin/main.dart',
        '--apply-migrations',
        '--server-id=$commandLineServerId',
        '--mode',
        'production',
        '--logging',
        'normal',
      ],
      environment: {
        'SERVERPOD_SERVER_ID': environmentServerID,
      },
    );
  }

  static Future<Process> _runProcess(
      String command, {
        List<String>? arguments,
        Directory? workingDirectory,
        Map<String, String> environment = const {},
      }) async {
    var process = await Process.start(
      command,
      arguments ?? [],
      workingDirectory: workingDirectory?.path ?? Directory.current.path,
      environment: environment,
    );

    return process;
  }
}