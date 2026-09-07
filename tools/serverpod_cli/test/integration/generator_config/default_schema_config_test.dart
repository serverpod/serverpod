import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../../test_util/builders/project_directory_builder.dart';

const _serverRootDir = 'project/my_project_server';

void main() {
  setUpAll(() {
    CommandLineExperimentalFeatures.initialize([]);
  });

  Future<GeneratorConfig> loadConfig() => GeneratorConfig.load(
    serverRootDir: path.join(d.sandbox, _serverRootDir),
    interactive: false,
  );

  group('Given a generator.yaml without a database property', () {
    setUpAll(() async {
      await ProjectDirectoryBuilder()
          .withGeneratorYaml('type: server\n')
          .build()
          .create();
    });

    test('when loading GeneratorConfig then defaultSchema is null.', () async {
      var config = await loadConfig();

      expect(config.defaultSchema, isNull);
    });
  });

  group('Given a generator.yaml with a database property without a default '
      'schema', () {
    setUpAll(() async {
      await ProjectDirectoryBuilder()
          .withGeneratorYaml('''
type: server
database:
  other: value
''')
          .build()
          .create();
    });

    test('when loading GeneratorConfig then defaultSchema is null.', () async {
      var config = await loadConfig();

      expect(config.defaultSchema, isNull);
    });
  });

  group('Given a server generator.yaml with a default schema', () {
    setUpAll(() async {
      await ProjectDirectoryBuilder()
          .withGeneratorYaml('''
type: server
database:
  default_schema: app
''')
          .build()
          .create();
    });

    test('when loading GeneratorConfig then defaultSchema is set.', () async {
      var config = await loadConfig();

      expect(config.defaultSchema, 'app');
    });
  });

  group('Given a module generator.yaml with a default schema', () {
    setUpAll(() async {
      await ProjectDirectoryBuilder()
          .withGeneratorYaml('''
type: module
database:
  default_schema: app
''')
          .build()
          .create();
    });

    test(
      'when loading GeneratorConfig then SourceSpanFormatException is thrown.',
      () async {
        await expectLater(
          loadConfig(),
          throwsA(
            isA<SourceSpanFormatException>().having(
              (e) => e.message,
              'message',
              'The "default_schema" property is only allowed in server '
                  'projects. Modules must qualify their table names explicitly.',
            ),
          ),
        );
      },
    );
  });

  group(
    'Given a generator.yaml with a default schema that is not snake case',
    () {
      setUpAll(() async {
        await ProjectDirectoryBuilder()
            .withGeneratorYaml('''
type: server
database:
  default_schema: MySchema
''')
            .build()
            .create();
      });

      test(
        'when loading GeneratorConfig then SourceSpanFormatException is thrown.',
        () async {
          await expectLater(
            loadConfig(),
            throwsA(
              isA<SourceSpanFormatException>().having(
                (e) => e.message,
                'message',
                'The "default_schema" property must be a snake_case_string.',
              ),
            ),
          );
        },
      );
    },
  );

  group('Given a generator.yaml with a default schema that is not a string', () {
    setUpAll(() async {
      await ProjectDirectoryBuilder()
          .withGeneratorYaml('''
type: server
database:
  default_schema: 123
''')
          .build()
          .create();
    });

    test(
      'when loading GeneratorConfig then SourceSpanFormatException is thrown.',
      () async {
        await expectLater(
          loadConfig(),
          throwsA(
            isA<SourceSpanFormatException>().having(
              (e) => e.message,
              'message',
              'The "default_schema" property must be a snake_case_string.',
            ),
          ),
        );
      },
    );
  });

  group('Given a server generator.yaml with a default schema and a sqlite '
      'run-mode config', () {
    setUpAll(() async {
      await ProjectDirectoryBuilder()
          .withGeneratorYaml('''
type: server
database:
  default_schema: app
''')
          .withConfigFiles({
            'development.yaml': '''
database:
  filePath: app.db
''',
          })
          .build()
          .create();
    });

    test(
      'when loading GeneratorConfig then SourceSpanFormatException is thrown.',
      () async {
        await expectLater(
          loadConfig(),
          throwsA(
            isA<SourceSpanFormatException>().having(
              (e) => e.message,
              'message',
              'The "default_schema" property is not supported with the '
                  '"sqlite" database dialect.',
            ),
          ),
        );
      },
    );
  });

  group('Given a generator.yaml with the public default schema', () {
    setUpAll(() async {
      await ProjectDirectoryBuilder()
          .withGeneratorYaml('''
type: server
database:
  default_schema: public
''')
          .build()
          .create();
    });

    test(
      'when loading GeneratorConfig then SourceSpanFormatException is thrown.',
      () async {
        await expectLater(
          loadConfig(),
          throwsA(
            isA<SourceSpanFormatException>().having(
              (e) => e.message,
              'message',
              'The "default_schema" property cannot be "public", which is '
                  'already the default when no schema is set.',
            ),
          ),
        );
      },
    );
  });

  group('Given a generator.yaml with a database property that is not a map', () {
    setUpAll(() async {
      await ProjectDirectoryBuilder()
          .withGeneratorYaml('''
type: server
database: app
''')
          .build()
          .create();
    });

    test(
      'when loading GeneratorConfig then SourceSpanFormatException is thrown.',
      () async {
        await expectLater(
          loadConfig(),
          throwsA(
            isA<SourceSpanFormatException>().having(
              (e) => e.message,
              'message',
              'The "database" property must be a map.',
            ),
          ),
        );
      },
    );
  });
}
