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
    'Given a project configured to use SQLite, '
    'when generation completes, '
    'then the cli.generate event reports only the SQLite database tag.',
    () async {
      final projectDir = Directory.systemTemp.createTempSync(
        'cli_analytics_sqlite_',
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
table: note
fields:
  text: String
''');

      final recording = RecordingAnalytics();
      initializeCliAnalytics(
        CliAnalytics(analytics: recording)..enabled = true,
      );

      final success = await performOneShotGenerate(
        config: buildTestServerConfig(
          projectDir,
          databaseDialect: DatabaseDialect.sqlite,
        ),
      );

      expect(success, isTrue);
      final features = recording.eventNamed('cli.generate')['features'] as List;
      expect(features, contains('sqlite'));
      expect(features, isNot(contains('postgres')));
    },
  );
}
