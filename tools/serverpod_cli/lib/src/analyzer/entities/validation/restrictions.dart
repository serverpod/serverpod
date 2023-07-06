import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

class Restrictions {
  String documentType;
  YamlMap documentContents;
  List<SerializableEntityDefinition>? protocolEntities;

  Restrictions({
    required this.documentType,
    required this.documentContents,
    this.protocolEntities,
  });

  List<SourceSpanException> validateClassName(
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is! String) {
      return [
        SourceSpanException(
          'The "$documentType" type must be a String.',
          span,
        )
      ];
    }

    if (!StringValidators.isValidClassName(content)) {
      return [
        SourceSpanException(
          'The "$documentType" type must be a valid class name (e.g. PascalCaseString).',
          span,
        )
      ];
    }

    // TODO n-squared time complexity when validating all protocol files.
    if (_countClassNames(content, protocolEntities) > 1) {
      return [
        SourceSpanException(
          'The $documentType name "$content" is already used by another protocol class.',
          span,
        )
      ];
    }

    return [];
  }

  int _countClassNames(
      String className, List<SerializableEntityDefinition>? protocolEntities) {
    if (protocolEntities == null) return 0;

    return protocolEntities.fold(
      0,
      (sum, entity) => sum += entity.className == className ? 1 : 0,
    );
  }

  List<SourceSpanException> validateTableName(
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is! String) {
      return [
        SourceSpanException(
          'The "table" property must be a snake_case_string.',
          span,
        )
      ];
    }

    if (!StringValidators.isValidTableName(content)) {
      return [
        SourceSpanException(
          'The "table" property must be a snake_case_string.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanException> validateBoolType(
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is bool) return [];

    return [
      SourceSpanException(
        'The property value must be a bool.',
        span,
      )
    ];
  }

  List<SourceSpanException> validateTableIndexName(
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is! String ||
        !StringValidators.isValidTableIndexName(content)) {
      return [
        SourceSpanException(
          'Invalid format for index "$content", must follow the format lower_snake_case.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanException> validateFieldName(
    dynamic content,
    SourceSpan? span,
  ) {
    if (!StringValidators.isValidFieldName(content)) {
      return [
        SourceSpanException(
          'Keys of "fields" Map must be valid Dart variable names (e.g. camelCaseString).',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanException> validateParentName(
    dynamic content,
    SourceSpan? span,
  ) {
    if (content != null && !StringValidators.isValidTableIndexName(content)) {
      return [
        SourceSpanException(
          'The parent must reference a valid table name (e.g. parent=table_name). "$content" is not a valid parent name.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanException> validateFieldType(
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is! String) {
      return [
        SourceSpanException(
          'The field must have a datatype defined (e.g. field: String).',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanException> validateFieldDataType(
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is! String) {
      return [
        SourceSpanException(
          'The field must have a datatype defined (e.g. field: String).',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanException> validateIndexFieldsValue(
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is! String) {
      return [
        SourceSpanException(
          'The "fields" property must have at least one field, (e.g. fields: fieldName).',
          span,
        )
      ];
    }

    return [];

    // todo add 2 pass check that fields exists in the class
  }

  List<SourceSpanException> validateIndexType(
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is! String) {
      return [
        SourceSpanException(
          'The "type" property must be of type String.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanException> validateEnumValues(
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is! YamlList) {
      return [
        SourceSpanException(
          'The "values" property must be a list of strings.',
          span,
        )
      ];
    }

    var nodeExceptions = [
      ...content.nodes
          .map((node) {
            if (node is! YamlScalar || node.value is! String) {
              return SourceSpanException(
                'The "values" property must be a list of strings.',
                node.span,
              );
            }

            if (!StringValidators.isValidFieldName(node.value)) {
              return SourceSpanException(
                'Enum values must be lowerCamelCase.',
                node.span,
              );
            }

            return null;
          })
          .where((node) => node != null)
          .cast<SourceSpanException>(),
      if (content.nodes.map((n) => n.value).toSet().length <
          content.nodes.length)
        SourceSpanException(
          'Enum values are not distinct',
          content.span,
        )
    ];

    return nodeExceptions;
  }
}
