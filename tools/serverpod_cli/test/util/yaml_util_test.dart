import 'package:serverpod_cli/src/util/yaml_util.dart';
import 'package:source_span/source_span.dart';
import 'package:term_glyph/term_glyph.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  ascii = false; // force uni-code glyphs on windows

  test('Given an empty string, loadYamlMap returns an empty YamlMap', () {
    late YamlMap map;
    expect(() => map = loadYamlMap(''), returnsNormally);
    expect(map, isEmpty);
  });

  test('Given a whitespace only, loadYamlMap returns an empty YamlMap', () {
    late YamlMap map;
    expect(() => map = loadYamlMap('\t \n'), returnsNormally);
    expect(map, isEmpty);
  });

  test('Given a valid yaml string, loadYamlMap returns a correct YamlMap', () {
    const yamlString = '''
    key: value
    ''';
    late YamlMap map;
    expect(() => map = loadYamlMap(yamlString), returnsNormally);
    expect(map, {'key': 'value'});
  });

  test('Given a yaml string with a scalar, loadYamlMap throws an exception',
      () {
    const yamlString = 'scalar';
    expect(
      () => loadYamlMap(yamlString),
      throwsA(
        isA<SourceSpanException>().having(
          (e) => e.toString(),
          'Expected a map',
          'Error on line 1, column 1: Expected a map\n'
              '  ╷\n'
              '1 │ scalar\n'
              '  │ ^^^^^^\n'
              '  ╵',
        ),
      ),
    );
  });
}
