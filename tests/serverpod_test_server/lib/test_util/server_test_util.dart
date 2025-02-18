import 'dart:io';

abstract class ServerTestUtils {
  static Future<Process> runServerWithServerId(String serverId) async {
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
        'SERVER_ID': serverId,
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
