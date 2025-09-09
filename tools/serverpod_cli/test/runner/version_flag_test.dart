import 'package:args/command_runner.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/version.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

class MockLogOutput {
  List<String> messages = [];
  
  void info(String message) {
    messages.add(message);
  }
  
  void error(String message) {
    messages.add(message);
  }
  
  void debug(String message) {
    messages.add(message);
  }
  
  void warning(String message) {
    messages.add(message);
  }
  
  void clear() {
    messages.clear();
  }
}

class MockLogger extends VoidLogger {
  final MockLogOutput output;
  
  MockLogger(this.output);
  
  @override
  void info(String message, {bool newParagraph = false, LogType? type}) {
    output.info(message);
  }
  
  @override
  void error(String message, {bool newParagraph = false, LogType? type, Object? exception, StackTrace? stackTrace}) {
    output.error(message);
  }
  
  @override
  void debug(String message, {bool newParagraph = false, LogType? type}) {
    output.debug(message);
  }
  
  @override
  void warning(String message, {bool newParagraph = false, LogType? type}) {
    output.warning(message);
  }
}

class MockAnalytics implements Analytics {
  List<String> trackedEvents = [];

  int numberOfCleanups = 0;

  @override
  void track({required String event}) {
    trackedEvents.add(event);
  }

  @override
  void cleanUp() {
    numberOfCleanups++;
  }
}

void main() {
  group('Version Flag Validation - ', () {
    test('Given --version flag when run then should log only expected version message', () async {
      var mockLogOutput = MockLogOutput();
      var mockLogger = MockLogger(mockLogOutput);
      initializeLoggerWith(mockLogger);
      
      var analytics = MockAnalytics();
      var runner = ServerpodCommandRunner.createCommandRunner(
        analytics,
        false,
        Version(1, 1, 0),
        onBeforeRunCommand: (_) => Future(() => {}),
      );
      runner.addCommand(VersionCommand());

      // Run with --version flag
      await runner.run(['--version']);
      
      // Validate that only the expected version info message was logged
      expect(mockLogOutput.messages, hasLength(1));
      expect(mockLogOutput.messages.first, equals('Serverpod version: 3.0.0-alpha.1'));
    });
  });
}