import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/endpoint_validation_helpers.dart';

void main() {
  group(
    'Given a project whose code generation already ran, '
    'when generation runs again with unchanged sources,',
    () {
      late Directory projectDir;
      late GeneratorConfig config;
      late Analyzers analyzers;
      late File protocolFile;
      late String protocolContent;
      late GenerateResult secondRun;

      // A timestamp no generation run could produce; pinned on protocol.dart
      // between the runs so any rewrite - even one with identical content -
      // is detectable regardless of file system timestamp granularity.
      final mtimeSentinel = DateTime.utc(2020, 1, 1);

      tearDownAll(() => projectDir.deleteIfExists(recursive: true));

      setUpAll(() async {
        projectDir = Directory.systemTemp.createTempSync('cli_test_');
        await createTestEnvironment(projectDir);

        File(
          p.join(projectDir.path, 'lib', 'src', 'protocol', 'item.spy.yaml'),
        )
          ..createSync(recursive: true)
          ..writeAsStringSync('''
class: Item
fields:
  name: String
''');

        File(
          p.join(
            projectDir.path,
            'lib',
            'src',
            'endpoints',
            'item_endpoint.dart',
          ),
        )
          ..createSync(recursive: true)
          ..writeAsStringSync('''
import 'package:serverpod/serverpod.dart';
import 'package:test_server/src/generated/protocol.dart';

class ItemEndpoint extends Endpoint {
  Future<Item> getItem(Session session, String name) async {
    return Item(name: name);
  }
}
''');

        config = buildTestServerConfig(projectDir);
        analyzers = await Analyzers.create(config);
        await analyzers.performGenerate(config: config);

        protocolFile = File(
          p.join(projectDir.path, 'lib', 'src', 'generated', 'protocol.dart'),
        );
        protocolContent = protocolFile.readAsStringSync();
        protocolFile.setLastModifiedSync(mtimeSentinel);

        secondRun = await analyzers.performGenerate(config: config);
      });

      test('then generation succeeds.', () {
        expect(secondRun.success, isTrue);
      });

      test('then protocol.dart is not rewritten.', () {
        // A rewrite here re-triggers file watchers and compile pipelines on
        // every generation, even when nothing changed (the temporary analysis
        // stub must shadow protocol.dart in memory, not on disk).
        expect(protocolFile.lastModifiedSync().toUtc(), mtimeSentinel);
        expect(protocolFile.readAsStringSync(), protocolContent);
      });
    },
  );
}
