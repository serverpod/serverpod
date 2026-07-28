import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

GeneratorConfig buildAnalyticsTestConfig(String serverDir) {
  return GeneratorConfig(
    name: 'myapp',
    type: PackageType.server,
    serverPackage: 'myapp_server',
    dartClientPackage: 'myapp_client',
    dartClientDependsOnServiceClient: true,
    serverPackageDirectoryPathParts: p.split(serverDir),
    sharedModelsSourcePathsParts: const {},
    relativeDartClientPackagePathParts: const ['..', 'myapp_client'],
    modules: const [],
    extraClasses: const [],
    enabledFeatures: const [ServerpodFeature.database],
    databaseDialect: DatabaseDialect.postgres,
  );
}

/// Captures the events a [CliAnalytics] would have sent to PostHog.
///
/// Install with `initializeCliAnalytics(CliAnalytics(analytics: recording)
/// ..enabled = true)` so tests assert on the payload a real command produced,
/// rather than on hand-built inputs.
class RecordingAnalytics extends Analytics {
  final events = <String>[];
  final properties = <Map<String, dynamic>>[];

  @override
  Future<void> sendEvent({
    required String event,
    Map<String, dynamic> properties = const {},
  }) async {
    events.add(event);
    this.properties.add(properties);
  }

  void clear() {
    events.clear();
    properties.clear();
  }

  /// The single payload recorded for [event]. Fails the test when the event was
  /// not sent exactly once, so a silently dropped event cannot pass as an
  /// empty assertion.
  Map<String, dynamic> eventNamed(String event) {
    final matches = [
      for (var i = 0; i < events.length; i++)
        if (events[i] == event) properties[i],
    ];

    expect(
      matches,
      hasLength(1),
      reason: 'Expected exactly one "$event"; recorded: $events',
    );
    return matches.single;
  }
}
