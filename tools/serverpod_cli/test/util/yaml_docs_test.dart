import 'package:serverpod_cli/src/util/yaml_docs.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('Given yaml content with different line endings,', () {
    var eolVariants = [
      ('LF', '\n'),
      ('CRLF', '\r\n'),
      ('CR', '\r'),
    ];

    for (var (eolName, eol) in eolVariants) {
      test(
        'when split with $eolName line endings '
        'then each line matches the line numbers the yaml parser reports.',
        () {
          var yaml = [
            'class: Example',
            'fields:',
            '  name: String',
            '  age: int',
            '',
          ].join(eol);

          var extractor = YamlDocumentationExtractor(yaml);
          var document = loadYaml(yaml) as YamlMap;

          var keyNodes = [
            ...document.nodes.keys.cast<YamlNode>(),
            ...(document['fields'] as YamlMap).nodes.keys.cast<YamlNode>(),
          ];
          expect(keyNodes, hasLength(4));
          for (var key in keyNodes) {
            var start = key.span.start;
            var lineAtKey = extractor.lines[start.line];
            expect(
              lineAtKey.substring(start.column),
              startsWith('${(key as YamlScalar).value}'),
              reason:
                  'The yaml parser puts the key "${key.value}" at line '
                  '${start.line}, but that line is "$lineAtKey".',
            );
          }
        },
      );
    }

    test(
      'when split with mixed line endings '
      'then each line matches the line numbers the yaml parser reports.',
      () {
        var yaml =
            'class: Example\r\n'
            'fields:\n'
            '  name: String\r'
            '  age: int\n';

        var extractor = YamlDocumentationExtractor(yaml);
        var document = loadYaml(yaml) as YamlMap;

        var keyNodes = [
          ...document.nodes.keys.cast<YamlNode>(),
          ...(document['fields'] as YamlMap).nodes.keys.cast<YamlNode>(),
        ];
        expect(keyNodes, hasLength(4));
        for (var key in keyNodes) {
          var start = key.span.start;
          var lineAtKey = extractor.lines[start.line];
          expect(
            lineAtKey.substring(start.column),
            startsWith('${(key as YamlScalar).value}'),
            reason:
                'The yaml parser puts the key "${key.value}" at line '
                '${start.line}, but that line is "$lineAtKey".',
          );
        }
      },
    );
  });

  group('Given a doc comment above a key,', () {
    SourceLocation keyAt(int line, int column) {
      return SourceLocation(0, line: line, column: column);
    }

    test(
      'when the doc comment is directly above the key '
      'then the documentation is returned.',
      () {
        var extractor = YamlDocumentationExtractor(
          '  ### This is a doc comment\n'
          '  name: String\n',
        );

        expect(
          extractor.getDocumentation(keyAt(1, 2)),
          ['/// This is a doc comment'],
        );
      },
    );

    test(
      'when a blank line separates the doc comment from the key '
      'then the documentation is returned.',
      () {
        var extractor = YamlDocumentationExtractor(
          '  ### This is a doc comment\n'
          '\n'
          '  name: String\n',
        );

        expect(
          extractor.getDocumentation(keyAt(2, 2)),
          ['/// This is a doc comment'],
        );
      },
    );

    test(
      'when a whitespace-only line separates the doc comment from the key '
      'then the documentation is returned.',
      () {
        var extractor = YamlDocumentationExtractor(
          '  ### This is a doc comment\n'
          '   \n'
          '  name: String\n',
        );

        expect(
          extractor.getDocumentation(keyAt(2, 2)),
          ['/// This is a doc comment'],
        );
      },
    );

    test(
      'when a tab-only line separates the doc comment from the key '
      'then the documentation is returned.',
      () {
        // Tabs cannot appear as yaml indentation, so this case is only
        // reachable through the extractor directly.
        var extractor = YamlDocumentationExtractor(
          '  ### This is a doc comment\n'
          '\t\n'
          '  name: String\n',
        );

        expect(
          extractor.getDocumentation(keyAt(2, 2)),
          ['/// This is a doc comment'],
        );
      },
    );

    test(
      'when a normal comment line separates the doc comment from the key '
      'then the documentation is returned.',
      () {
        var extractor = YamlDocumentationExtractor(
          '  ### This is a doc comment\n'
          '  # This is a normal comment.\n'
          '  name: String\n',
        );

        expect(
          extractor.getDocumentation(keyAt(2, 2)),
          ['/// This is a doc comment'],
        );
      },
    );

    test(
      'when a content line with a trailing comment separates the doc comment '
      'from the key then the documentation is returned.',
      () {
        // Documents the existing scan behavior: lines that contain a `#`
        // anywhere never end the scan, so the doc comment above another field
        // is picked up here. Tracked separately from the line ending fix.
        var extractor = YamlDocumentationExtractor(
          '  ### This is a doc comment\n'
          '  other: int # trailing comment\n'
          '  name: String\n',
        );

        expect(
          extractor.getDocumentation(keyAt(2, 2)),
          ['/// This is a doc comment'],
        );
      },
    );

    test(
      'when a content line separates the doc comment from the key '
      'then no documentation is returned.',
      () {
        var extractor = YamlDocumentationExtractor(
          '  ### This is a doc comment\n'
          '  other: int\n'
          '  name: String\n',
        );

        expect(extractor.getDocumentation(keyAt(2, 2)), isNull);
      },
    );

    test(
      'when the key is on the first line '
      'then no documentation is returned.',
      () {
        var extractor = YamlDocumentationExtractor('name: String\n');

        expect(extractor.getDocumentation(keyAt(0, 0)), isNull);
      },
    );

    test(
      'when the yaml content is empty '
      'then no documentation is returned.',
      () {
        var extractor = YamlDocumentationExtractor('');

        expect(extractor.getDocumentation(keyAt(0, 0)), isNull);
      },
    );
  });
}
