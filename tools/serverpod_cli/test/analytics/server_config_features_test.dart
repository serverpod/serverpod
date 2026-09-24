import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analytics/server_config_features.dart';
import 'package:test/test.dart';

void main() {
  late Directory serverDir;

  setUp(() {
    serverDir = Directory.systemTemp.createTempSync('server_config_features_');
  });

  tearDown(() {
    serverDir.deleteSync(recursive: true);
  });

  void writeDevelopmentConfig(String content) {
    File(p.join(serverDir.path, 'config', 'development.yaml'))
      ..createSync(recursive: true)
      ..writeAsStringSync(content);
  }

  group(
    'Given a development config with futureCall.executionEnabled set to false,',
    () {
      setUp(() {
        writeDevelopmentConfig('''
futureCall:
  executionEnabled: false
''');
      });

      test(
        'when loading server config features, '
        'then the future_calls_disabled tag is included.',
        () {
          final features = ServerConfigFeatures.load(serverDir.path);
          expect(features.tags, contains('future_calls_disabled'));
        },
      );
    },
  );

  group(
    'Given a development config with the legacy futureCallExecutionEnabled set to false,',
    () {
      setUp(() {
        writeDevelopmentConfig('''
futureCallExecutionEnabled: false
''');
      });

      test(
        'when loading server config features, '
        'then the future_calls_disabled tag is included.',
        () {
          final features = ServerConfigFeatures.load(serverDir.path);
          expect(features.tags, contains('future_calls_disabled'));
        },
      );
    },
  );

  group(
    'Given a development config with futureCall.executionEnabled set to true and the legacy futureCallExecutionEnabled set to false,',
    () {
      setUp(() {
        writeDevelopmentConfig('''
futureCallExecutionEnabled: false
futureCall:
  executionEnabled: true
''');
      });

      test(
        'when loading server config features, '
        'then the future_calls_disabled tag is not included.',
        () {
          final features = ServerConfigFeatures.load(serverDir.path);
          expect(features.tags, isNot(contains('future_calls_disabled')));
        },
      );
    },
  );
}
