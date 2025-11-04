import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  const testClassName = 'Example';
  const testClassFileName = 'example';
  final expectedFilePath =
      path.join('lib', 'src', 'generated', '$testClassFileName.dart');

  group('Given a class with an explicit column name when generating code', () {
    const noColumnFieldName = 'name';
    const columnFieldName = 'userName';
    const columnName = 'user_name';
    const fieldType = 'String';
    final columnField = FieldDefinitionBuilder()
        .withName(columnFieldName)
        .withType(
          TypeDefinitionBuilder().withClassName('String').build(),
        )
        .withColumnNameOverride(columnName)
        .build();
    final noColumnField = FieldDefinitionBuilder()
        .withName(noColumnFieldName)
        .withType(
          TypeDefinitionBuilder().withClassName('String').build(),
        )
        .build();
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withField(columnField)
          .withField(noColumnField)
          .build(),
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: testClassName,
    );

    group('then fromJson method should get ', () {
      test('column name from jsonSerialization for field with column set', () {
        var fromJsonConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          maybeClassNamedExample!,
          name: 'fromJson',
        );

        var fromJsonCode = fromJsonConstructor!.toSource();

        expect(
          fromJsonCode.contains(
            "$columnFieldName: jsonSerialization['$columnName'] as $fieldType",
          ),
          isTrue,
          reason: 'The fromJson method should map the field name to '
              'jsonSerialization of the column name.',
        );
      });

      test('field name from jsonSerialization for field with column not set',
          () {
        var fromJsonConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          maybeClassNamedExample!,
          name: 'fromJson',
        );

        var fromJsonCode = fromJsonConstructor!.toSource();

        expect(
          fromJsonCode.contains(
            "$noColumnFieldName: jsonSerialization['$noColumnFieldName'] as $fieldType",
          ),
          isTrue,
          reason: 'The fromJson method should map the field name to its '
              'jsonSerialization.',
        );
      });
    });

    group('then toJson method should return ', () {
      test(
          'the column mapped to the serialized field name variable for a '
          'field with column set', () {
        var toJsonConstructor = CompilationUnitHelpers.tryFindMethodDeclaration(
          maybeClassNamedExample!,
          name: 'toJson',
        );

        var toJsonCode = toJsonConstructor!.toSource();

        expect(
          toJsonCode.contains(
            "'$columnName' : $columnFieldName",
          ),
          isTrue,
          reason: 'The toJson method should map the column name to '
              'the serialized field name variable.',
        );
      });

      test(
          'the field name mapped to its serialized variable for a field '
          'without column set', () {
        var toJsonConstructor = CompilationUnitHelpers.tryFindMethodDeclaration(
          maybeClassNamedExample!,
          name: 'toJson',
        );

        var toJsonCode = toJsonConstructor!.toSource();

        expect(
          toJsonCode.contains(
            "'$noColumnFieldName' : $noColumnFieldName",
          ),
          isTrue,
          reason: 'The toJson method should map the field name to its '
              'serialized variable.',
        );
      });
    });

    group('then toJsonForProtocol method should return ', () {
      test(
          'the column mapped to the serialized field name variable for a '
          'field with column set', () {
        var toJsonForProtocolConstructor =
            CompilationUnitHelpers.tryFindMethodDeclaration(
          maybeClassNamedExample!,
          name: 'toJsonForProtocol',
        );

        var toJsonForProtocolCode = toJsonForProtocolConstructor!.toSource();

        expect(
          toJsonForProtocolCode.contains(
            "'$columnName' : $columnFieldName",
          ),
          isTrue,
          reason: 'The toJsonForProtocol method should map the column name to '
              'field name.',
        );
      });

      test(
          'the field name mapped to its serialized variable for a field '
          'without column set', () {
        var toJsonForProtocolConstructor =
            CompilationUnitHelpers.tryFindMethodDeclaration(
          maybeClassNamedExample!,
          name: 'toJsonForProtocol',
        );

        var toJsonForProtocolCode = toJsonForProtocolConstructor!.toSource();

        expect(
          toJsonForProtocolCode.contains(
            "'$noColumnFieldName' : $noColumnFieldName",
          ),
          isTrue,
          reason:
              'The toJsonForProtocol method should map the field name to its '
              'serialized variable.',
        );
      });
    });
  });
}
