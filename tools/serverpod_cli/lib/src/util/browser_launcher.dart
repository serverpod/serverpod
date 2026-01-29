import 'dart:io';
import 'package:ci/ci.dart' as ci;

abstract final class BrowserLauncher {
  /// Opens a URL in the default browser, if possible. Returns true if
  /// successful.
  static Future<bool> openUrl(final Uri url) async {
    if (!canLaunchBrowser()) return false;
    try {
      final result = await Process.run(_getPlatformBrowserCommand(), [
        url.toString(),
      ], runInShell: true);
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
      if (!_hasDesktopSession()) return false;
      return _commandExists(_getPlatformBrowserCommand());
    }
    if (Platform.isMacOS) {
      return _commandExists(_getPlatformBrowserCommand());
    }
    return false;
  }

  static String _getPlatformBrowserCommand() {
    if (Platform.isWindows) {
      return 'start';
    } else if (Platform.isLinux) {
      return 'xdg-open';
    } else if (Platform.isMacOS) {
      return 'open';
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
}
