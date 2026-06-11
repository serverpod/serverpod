import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

/// Regression tests for https://github.com/serverpod/serverpod/issues/2120
///
/// Doc comments in model files must be extracted identically regardless of
/// whether the file uses LF (`\n`), CRLF (`\r\n`) or CR (`\r`) line endings.
/// The yaml is built by joining lines with an explicit line ending instead of
/// using multiline string literals, so the line endings under test cannot be
/// changed by editor or formatter settings.
void main() {
  var config = GeneratorConfigBuilder().build();

  ClassDefinition parseClass(List<String> yamlLines, String eol) {
    var modelSources = [
      ModelSourceBuilder().withYaml(yamlLines.join(eol)).build(),
    ];
    var analyzer = StatefulAnalyzer(config, modelSources);
    var definitions = analyzer.validateAll();
    return definitions.first as ClassDefinition;
  }

  for (var (eolName, eol) in [('LF', '\n'), ('CRLF', '\r\n'), ('CR', '\r')]) {
    group('Given a model file with $eolName line endings,', () {
      test(
        'when a field has a doc comment directly above it '
        'then the field documentation is set without stray characters.',
        () {
          var definition = parseClass(
            [
              'class: Example',
              'fields:',
              '  ### This is a doc comment',
              '  name: String',
              '',
            ],
            eol,
          );

          expect(
            definition.fields.first.documentation,
            ['/// This is a doc comment'],
          );
        },
      );

      test(
        'when a field has a doc comment separated by one blank line '
        'then the field documentation is still set.',
        () {
          // This is the exact reproduction from issue #2120.
          var definition = parseClass(
            [
              'class: Example',
              'fields:',
              '  ### This is a doc comment',
              '',
              '  name: String',
              '',
            ],
            eol,
          );

          expect(
            definition.fields.first.documentation,
            ['/// This is a doc comment'],
          );
        },
      );

      test(
        'when a field has a multiline doc comment '
        'then the field documentation contains all lines.',
        () {
          var definition = parseClass(
            [
              'class: Example',
              'fields:',
              '  ### This is a multiline',
              '  ### field comment.',
              '  name: String',
              '',
            ],
            eol,
          );

          expect(
            definition.fields.first.documentation,
            ['/// This is a multiline', '/// field comment.'],
          );
        },
      );

      test(
        'when a field has a multiline doc comment with a blank line inside it '
        'then the field documentation contains all lines.',
        () {
          var definition = parseClass(
            [
              'class: Example',
              'fields:',
              '  ### This is a multiline',
              '',
              '  ### field comment.',
              '  name: String',
              '',
            ],
            eol,
          );

          expect(
            definition.fields.first.documentation,
            ['/// This is a multiline', '/// field comment.'],
          );
        },
      );

      test(
        'when the class has a doc comment '
        'then the class documentation is set without stray characters.',
        () {
          var definition = parseClass(
            [
              '### This is a class comment.',
              'class: Example',
              'fields:',
              '  name: String',
              '',
            ],
            eol,
          );

          expect(
            definition.documentation,
            ['/// This is a class comment.'],
          );
        },
      );

      test(
        'when the class has a doc comment separated by one blank line '
        'then the class documentation is still set.',
        () {
          var definition = parseClass(
            [
              '### This is a class comment.',
              '',
              'class: Example',
              'fields:',
              '  name: String',
              '',
            ],
            eol,
          );

          expect(
            definition.documentation,
            ['/// This is a class comment.'],
          );
        },
      );

      test(
        'when the model file has no trailing newline '
        'then the field documentation is still set.',
        () {
          var definition = parseClass(
            [
              'class: Example',
              'fields:',
              '  ### This is a doc comment',
              '  name: String',
            ],
            eol,
          );

          expect(
            definition.fields.first.documentation,
            ['/// This is a doc comment'],
          );
        },
      );

      test(
        'when extracted documentation exists '
        'then no doc line contains a carriage return.',
        () {
          var definition = parseClass(
            [
              '### Class comment.',
              'class: Example',
              'fields:',
              '  ### Field comment.',
              '  name: String',
              '',
            ],
            eol,
          );

          var allDocLines = [
            ...?definition.documentation,
            ...?definition.fields.first.documentation,
          ];
          expect(allDocLines, isNotEmpty);
          for (var line in allDocLines) {
            expect(
              line.contains('\r'),
              isFalse,
              reason: 'Doc line ${line.codeUnits} contains a carriage return.',
            );
          }
        },
      );
    });
  }

  group('Given a model file with mixed line endings,', () {
    test(
      'when doc comments are separated by a blank line '
      'then class and field documentation are both set.',
      () {
        var yaml =
            '### Class comment.\r\n'
            'class: Example\n'
            'fields:\r\n'
            '  ### Field comment.\n'
            '\r\n'
            '  name: String\n';
        var modelSources = [ModelSourceBuilder().withYaml(yaml).build()];
        var analyzer = StatefulAnalyzer(config, modelSources);
        var definitions = analyzer.validateAll();
        var definition = definitions.first as ClassDefinition;

        expect(definition.documentation, ['/// Class comment.']);
        expect(
          definition.fields.first.documentation,
          ['/// Field comment.'],
        );
      },
    );

    test(
      'when a single line ends with a stray CR '
      'then documentation below it is still set.',
      () {
        // The stray CR makes the yaml parser see one more line than a naive
        // split on LF would, which used to desync the doc comment lookup for
        // all keys below it.
        var yaml =
            'class: Example\r'
            'fields:\n'
            '  ### Field comment.\n'
            '  name: String\n';
        var modelSources = [ModelSourceBuilder().withYaml(yaml).build()];
        var analyzer = StatefulAnalyzer(config, modelSources);
        var definitions = analyzer.validateAll();
        var definition = definitions.first as ClassDefinition;

        expect(
          definition.fields.first.documentation,
          ['/// Field comment.'],
        );
      },
    );
  });

  group('Given the same invalid model file with LF and CRLF line endings,', () {
    test(
      'when the models are validated '
      'then the reported errors have identical positions.',
      () {
        List<SourceSpanException> errorsFor(String eol) {
          var collector = CodeGenerationCollector();
          var modelSources = [
            ModelSourceBuilder()
                .withYaml(
                  [
                    'class: Example',
                    'bogus: value',
                    'fields:',
                    '  name: String',
                    '',
                  ].join(eol),
                )
                .build(),
          ];
          var analyzer = StatefulAnalyzer(
            config,
            modelSources,
            onErrorsCollector(collector),
          );
          analyzer.validateAll();
          return collector.errors;
        }

        var lfErrors = errorsFor('\n');
        var crlfErrors = errorsFor('\r\n');

        expect(lfErrors, isNotEmpty);
        expect(crlfErrors.length, lfErrors.length);
        for (var i = 0; i < lfErrors.length; i++) {
          expect(crlfErrors[i].message, lfErrors[i].message);
          expect(crlfErrors[i].span?.start.line, lfErrors[i].span?.start.line);
          expect(
            crlfErrors[i].span?.start.column,
            lfErrors[i].span?.start.column,
          );
        }
      },
    );
  });

  group('Given a model updated through the single model validation,', () {
    test(
      'when the new yaml has CRLF line endings and a blank line below the '
      'doc comment then the field documentation is still set.',
      () {
        // Exercises the same code path the language server uses for live
        // editor content, which updates an already registered model.
        var source = ModelSourceBuilder().build();
        var analyzer = StatefulAnalyzer(config, [source]);
        analyzer.validateAll();

        var definitions = analyzer.validateModel(
          [
            'class: Example',
            'fields:',
            '  ### This is a doc comment',
            '',
            '  name: String',
            '',
          ].join('\r\n'),
          source.yamlSourceUri,
        );
        var definition = definitions.first as ClassDefinition;

        expect(
          definition.fields.first.documentation,
          ['/// This is a doc comment'],
        );
      },
    );
  });
}
