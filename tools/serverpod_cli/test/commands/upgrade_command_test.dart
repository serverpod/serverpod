import 'dart:async';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/upgrade.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

class _MockLogger extends VoidLogger {
  final List<String> infoMessages = [];
  final List<String> debugMessages = [];
  final List<String> errorMessages = [];

  @override
  void info(String message, {bool newParagraph = false, LogType? type}) {
    infoMessages.add(message);
  }

  @override
  void debug(String message, {bool newParagraph = false, LogType? type}) {
    debugMessages.add(message);
  }

  @override
  void error(
    String message, {
    bool newParagraph = false,
    LogType? type,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    errorMessages.add(message);
  }
}

class _UpgradeCommandWithMockedVersion extends UpgradeCommand {
  final Version? installedVersion;

  _UpgradeCommandWithMockedVersion(this.installedVersion);

  @override
  Future<Version?> fetchInstalledCliVersion() async => installedVersion;
}

void main() {
  final mockLogger = _MockLogger();

  setUpAll(() {
    initializeLoggerWith(mockLogger);
  });

  tearDownAll(() async {
    await closeLogger();
  });

  setUp(() {
    mockLogger
      ..infoMessages.clear()
      ..debugMessages.clear()
      ..errorMessages.clear();
  });

  group('Given an UpgradeCommand', () {
    test(
      'when the installed version can be determined '
      'then the completion message contains that version.',
      () async {
        var upgradeCommand = _UpgradeCommandWithMockedVersion(Version(2, 3, 4));
        await upgradeCommand.runWithConfig(
          Configuration<OptionDefinition>.resolveNoExcept(options: []),
        );

        expect(
          mockLogger.infoMessages,
          contains('Serverpod is up to date: 2.3.4 version.'),
        );
      },
    );

    test(
      'when the installed version cannot be determined '
      'then a fallback message is logged.',
      () async {
        var upgradeCommand = _UpgradeCommandWithMockedVersion(null);
        await upgradeCommand.runWithConfig(
          Configuration<OptionDefinition>.resolveNoExcept(options: []),
        );

        expect(
          mockLogger.infoMessages,
          contains(
            'Serverpod was upgraded, but the installed version could not be determined.',
          ),
        );
      },
    );
  });
}
