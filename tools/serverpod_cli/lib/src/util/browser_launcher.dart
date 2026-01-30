import 'dart:io';
import 'package:ci/ci.dart' as ci;

abstract final class BrowserLauncher {
  /// Opens a URL in the default browser, if possible. Returns true if
  /// successful.
  static Future<bool> openUrl(final Uri url) async {
    if (!canLaunchBrowser()) return false;
    try {
      final commandWithArgs = _getPlatformBrowserCommand();
      final result = await Process.run(
        commandWithArgs.first,
        [...commandWithArgs.sublist(1), url.toString()],
        runInShell: true,
      );
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// Returns true if a browser can likely be opened.
  static bool canLaunchBrowser() {
    if (ci.isCI) return false;
    if (Platform.isWindows) return true;
    if (Platform.isLinux) {
      if (_isWsl()) return true;
      if (!_hasDesktopSession()) return false;
      return _commandExists(_getPlatformBrowserCommand().first);
    }
    if (Platform.isMacOS) {
      return _commandExists(_getPlatformBrowserCommand().first);
    }
    return false;
  }

  static List<String> _getPlatformBrowserCommand() {
    if (Platform.isWindows) {
      return ['start'];
    } else if (Platform.isLinux) {
      final wslCmdPath = _getWslWindowsCmdPath();
      if (wslCmdPath != null) {
        return [wslCmdPath, '/C', 'start'];
      }
      return ['xdg-open'];
    } else if (Platform.isMacOS) {
      return ['open'];
    }
    throw Exception('Unsupported platform: ${Platform.operatingSystem}.');
  }

  static bool _hasDesktopSession() {
    final env = Platform.environment;
    return env.containsKey('DISPLAY') || env.containsKey('WAYLAND_DISPLAY');
  }

  static bool _commandExists(String command) {
    try {
      final result = Process.runSync(
        'which',
        [command],
        runInShell: true,
      );
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  static bool _isWsl() => _getWslWindowsCmdPath() != null;

  /// Lists single-letter drive mounts under /mnt and returns the path to
  /// Windows cmd.exe if found (WSL). Otherwise returns null. This method
  /// intentionally does not rely on the PATH environment variable since
  /// users might have configured it to not contain the Windows paths.
  static String? _getWslWindowsCmdPath() {
    if (_isWslCached == true) return _wslWindowsCmdPath;

    try {
      final mnt = Directory('/mnt');
      if (!mnt.existsSync()) return null;

      // The list of single-letter mounts under /mnt that can be drives.
      // Sorted alphabetically since we expect the system to be on the first.
      final driveLetters =
          (mnt.listSync())
              .whereType<Directory>()
              .map((entity) => entity.path.split('/').last)
              .where((name) => name.length == 1)
              .toList()
            ..sort((a, b) => a.compareTo(b));

      for (final driveLetter in driveLetters) {
        final cmdPath = '/mnt/$driveLetter/Windows/System32/cmd.exe';
        if (!File(cmdPath).existsSync()) continue;
        _wslWindowsCmdPath = cmdPath;
        break;
      }
    } on Exception catch (_) {}

    _isWslCached = true;
    return _wslWindowsCmdPath;
  }

  /// The cached path to the Windows cmd.exe in WSL to avoid repeated lookups.
  static String? _wslWindowsCmdPath;
  static bool _isWslCached = false;
}
