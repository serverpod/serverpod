import 'package:serverpod/protocol.dart';
import 'package:serverpod_test_server/test_util/builders/log_settings_builder.dart';

class RuntimeSettingsBuilder {
  LogSettings _logSettings = LogSettingsBuilder().build();

  List<LogSettingsOverride> _logSettingsOverrides = [];

  bool _logServiceCalls = true;

  bool _logMalformedCalls = true;

  RuntimeSettingsBuilder withLogSettings(LogSettings logSettings) {
    _logSettings = logSettings;
    return this;
  }

  RuntimeSettingsBuilder withLogSettingsOverride({
    String? module,
    String? endpoint,
    String? method,
    required LogSettings logSettings,
  }) {
    _logSettingsOverrides.add(
      LogSettingsOverride(
        module: module,
        endpoint: endpoint,
        method: method,
        logSettings: logSettings,
      ),
    );
    return this;
  }

  RuntimeSettingsBuilder withLogSettingsOverrides(
    List<LogSettingsOverride> logSettingsOverrides,
  ) {
    _logSettingsOverrides.addAll(logSettingsOverrides);
    return this;
  }

  RuntimeSettingsBuilder withLogServiceCalls(bool logServiceCalls) {
    _logServiceCalls = logServiceCalls;
    return this;
  }

  RuntimeSettingsBuilder withLogMalformedCalls(bool logMalformedCalls) {
    _logMalformedCalls = logMalformedCalls;
    return this;
  }

  RuntimeSettings build() {
    return RuntimeSettings(
      logSettings: _logSettings,
      logSettingsOverrides: _logSettingsOverrides,
      logServiceCalls: _logServiceCalls,
      logMalformedCalls: _logMalformedCalls,
    );
  }
}
