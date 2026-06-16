import 'dart:async';

import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/analytics/generate_tracker.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

class RecordingAnalytics extends Analytics {
  final events = <String>[];

  @override
  void cleanUp() {}

  @override
  Future<void> sendEvent({
    required String event,
    Map<String, dynamic> properties = const {},
  }) async {
    events.add(event);
  }
}

void main() {
  group('Given a GenerateTracker, ', () {
    late RecordingAnalytics recording;

    setUp(() async {
      recording = RecordingAnalytics();
      initializeCliAnalytics(CliAnalytics(analytics: recording));

      await d.dir('tracker_project', [
        d.dir('myapp_server', [
          d.file('pubspec.yaml', 'name: myapp_server\n'),
        ]),
      ]).create();
    });

    test(
      'when two incremental runs are debounced, '
      'then one cli.generate event is sent.',
      () async {
        final tracker = GenerateTracker(debounceDuration: Duration.zero);
        final config = GeneratorConfig(
          name: 'myapp',
          type: PackageType.server,
          serverPackage: 'myapp_server',
          dartClientPackage: 'myapp_client',
          dartClientDependsOnServiceClient: true,
          serverPackageDirectoryPathParts: [
            d.sandbox,
            'tracker_project',
            'myapp_server',
          ],
          sharedModelsSourcePathsParts: {},
          relativeDartClientPackagePathParts: ['..', 'myapp_client'],
          modules: [],
          extraClasses: [],
          enabledFeatures: [ServerpodFeature.database],
          databaseDialect: DatabaseDialect.postgres,
          relativeFlutterPackagePathParts: ['..', 'myapp_flutter'],
        );
        const protocolDefinition = ProtocolDefinition(
          endpoints: [],
          models: [],
          futureCalls: [],
        );

        tracker.recordIncrementalRun(
          config: config,
          success: true,
          duration: const Duration(milliseconds: 100),
          protocolDefinition: protocolDefinition,
          enabled: true,
        );
        tracker.recordIncrementalRun(
          config: config,
          success: true,
          duration: const Duration(milliseconds: 300),
          protocolDefinition: protocolDefinition,
          enabled: true,
        );

        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(recording.events, ['cli.generate']);
      },
    );
  });
}
