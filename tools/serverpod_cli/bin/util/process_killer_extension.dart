import 'dart:io';

import 'constants.dart';

extension ProcessKillerExtension on Process {
  Future<void> killAll([int? killPid]) async {
    if (isWindows) {
      // TODO: Fix for Windows, if necessary
      Process.killPid(killPid ?? this.pid);
      return;
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

    Process.killPid(killPid);
  }

  static bool isProcessAlive(int pid) {
    var res = Process.runSync('kill', ['-0', '$pid']);
    return res.exitCode == 0;
  }
}
