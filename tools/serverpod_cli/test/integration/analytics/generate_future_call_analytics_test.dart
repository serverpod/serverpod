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
    'Given a project with a future call, '
    'when generation completes, '
    'then the cli.generate event reports the future-call tag and count.',
    () async {
      final projectDir = Directory.systemTemp.createTempSync(
        'cli_analytics_future_call_',
      );
      addTearDown(() => projectDir.deleteIfExists(recursive: true));
      addTearDown(() => initializeCliAnalytics(CliAnalytics.disabled()));

      await createTestEnvironment(projectDir);
      File(p.join(projectDir.path, 'lib', 'src', 'reminder_future_call.dart'))
        ..createSync(recursive: true)
        ..writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ReminderFutureCall extends FutureCall {
  Future<void> remind(Session session, String message) async {
    session.log(message);
  }
}
''');

      final recording = RecordingAnalytics();
      initializeCliAnalytics(
        CliAnalytics(analytics: recording)..enabled = true,
      );

      final success = await performOneShotGenerate(
        config: buildTestServerConfig(projectDir),
      );

      expect(success, isTrue);
      final event = recording.eventNamed('cli.generate');
      expect(event['features'], contains('future_call'));
      expect(event['feature_counts'], containsPair('future_call', 1));
      expect(event['counts'], containsPair('future_call_count', 1));
    },
  );
}
