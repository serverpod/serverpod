import 'package:cli_tools/cli_tools.dart';

class MockLogOutput {
  List<String> messages = [];
  List<String> infoMessages = [];
  List<String> errorMessages = [];
  List<String> debugMessages = [];
  List<String> warningMessages = [];

  void info(String message) {
    messages.add(message);
    infoMessages.add(message);
  }

  void error(String message) {
    messages.add(message);
    errorMessages.add(message);
  }

  void debug(String message) {
    messages.add(message);
    debugMessages.add(message);
  }

  void warning(String message) {
    messages.add(message);
    warningMessages.add(message);
  }

  MockLogOutput reset() {
    messages.clear();
    infoMessages.clear();
    errorMessages.clear();
    debugMessages.clear();
    warningMessages.clear();
    return this;
  }
}

class MockLogger extends VoidLogger {
  final MockLogOutput output = MockLogOutput();

  MockLogger();

  @override
  void info(String message, {bool newParagraph = false, LogType? type}) {
    output.info(message);
  }

  @override
  void error(
    String message, {
    bool newParagraph = false,
    LogType? type,
    Object? exception,
    StackTrace? stackTrace,
  }) {
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
