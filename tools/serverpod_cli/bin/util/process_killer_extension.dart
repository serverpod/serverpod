import 'dart:io';

extension ProcessKillerExtension on Process {
  Future<void> killAll([int? killPid]) async {
    if (Platform.isWindows) {
      // TODO: Fix for Windows, if necessary
      Process.killPid(killPid ?? this.pid);
      return;
    }

    killPid ??= this.pid;

    ProcessResult pgrepResult = Process.runSync('pgrep', <String>['-P', '$killPid']);

    String childPidsString = (pgrepResult.stdout as String).trim();
    if (childPidsString.isNotEmpty) {
      List<String> childPids = childPidsString.split('\n');
      for (int i = childPids.length - 1; i >= 0; i--) {
        int childPid = int.parse(childPids[i]);
        await killAll(childPid);
      }
    }

    Process.killPid(killPid);
  }

  static bool isProcessAlive(int pid) {
    ProcessResult res = Process.runSync('kill', <String>['-0', '$pid']);
    return res.exitCode == 0;
  }
}
