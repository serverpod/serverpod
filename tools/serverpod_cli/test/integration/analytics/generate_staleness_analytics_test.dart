import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../test_util/analytics_helpers.dart';
import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/endpoint_validation_helpers.dart';

void main() {
  test(
    'Given a generated project, '
    'when an unchanged generation is requested, '
    'then the staleness skip does not emit another event.',
    () async {
      final projectDir = Directory.systemTemp.createTempSync(
        'cli_analytics_staleness_',
      );
      addTearDown(() => projectDir.deleteIfExists(recursive: true));
      addTearDown(() => initializeCliAnalytics(CliAnalytics.disabled()));

      await createTestEnvironment(projectDir);
      File(
          p.join(
            projectDir.path,
            'lib',
            'src',
            'protocol',
            'note.spy.yaml',
          ),
        )
        ..createSync(recursive: true)
        ..writeAsStringSync('''
class: Note
fields:
  text: String
''');

      final config = buildTestServerConfig(projectDir);
      final recording = RecordingAnalytics();
      initializeCliAnalytics(
        CliAnalytics(analytics: recording)..enabled = true,
      );

      expect(await performOneShotGenerate(config: config), isTrue);
      recording.eventNamed('cli.generate');

      expect(await performOneShotGenerate(config: config), isTrue);
      expect(
        recording.events,
        ['cli.generate'],
        reason: 'An up-to-date generation does not run and must not emit.',
      );
    },
  );
}
