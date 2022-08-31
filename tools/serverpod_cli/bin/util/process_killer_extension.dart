import 'dart:io';

extension ProcessKillerExtension on Process {
  Future<bool> killAll([int? killPid]) async {
    if (Platform.isWindows) {
      // TODO: Fix for Windows, if necessary
      return Process.killPid(killPid ?? this.pid);
    }

    killPid ??= this.pid;

    var pgrepResult = Process.runSync('pgrep', ['-P', '$killPid']);

    var childPidsString = (pgrepResult.stdout as String).trim();
    if (childPidsString.isNotEmpty) {
      var childPids = childPidsString.split('\n');
      for (var i = childPids.length - 1; i >= 0; i--) {
        var childPid = int.parse(childPids[i]);
        await killAll(childPid);
      }
    }

    return Process.killPid(killPid);
  }

  static bool isProcessAlive(int pid) {
    var res = Process.runSync('kill', ['-0', '$pid']);
    return res.exitCode == 0;
  }
}
