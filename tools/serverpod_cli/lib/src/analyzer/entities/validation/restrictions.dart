import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
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
    required CodeAnalysisCollector collector,
    this.protocolEntities,
  });

  void validateClassName(
    dynamic content,
    SourceSpan? span,
    CodeAnalysisCollector collector,
  ) {
    if (content is! String) {
      collector.addError(SourceSpanException(
        'The "$documentType" type must be a String.',
        span,
      ));
      return;
    }

    if (!StringValidators.isValidClassName(content)) {
      collector.addError(SourceSpanException(
        'The "$documentType" type must be a valid class name (e.g. PascalCaseString).',
        span,
      ));
    }

    // TODO n-squared time complexity when validating all protocol files.
    if (_countClassNames(content, protocolEntities) > 1) {
      collector.addError(SourceSpanException(
        'The $documentType name "$content" is already used by another protocol class.',
        span,
      ));
    }
  }

  int _countClassNames(
      String className, List<SerializableEntityDefinition>? protocolEntities) {
    if (protocolEntities == null) return 0;

    return protocolEntities.fold(
      0,
      (sum, entity) => sum += entity.className == className ? 1 : 0,
    );
  }

  void validateTableName(
    dynamic content,
    SourceSpan? span,
    CodeAnalysisCollector collector,
  ) {
    if (content is! String) {
      collector.addError(SourceSpanException(
        'The "table" property must be a snake_case_string.',
        span,
      ));
      return;
    }

    if (!StringValidators.isValidTableName(content)) {
      collector.addError(SourceSpanException(
        'The "table" property must be a snake_case_string.',
        span,
      ));
    }
  }

  void validateBoolType(
    dynamic content,
    SourceSpan? span,
    CodeAnalysisCollector collector,
  ) {
    if (content is! bool) {
      collector.addError(SourceSpanException(
        'The property value must be a bool.',
        span,
      ));
    }
  }

  void validateTableIndexName(
    dynamic content,
    SourceSpan? span,
    CodeAnalysisCollector collector,
  ) {
    if (content is! String ||
        !StringValidators.isValidTableIndexName(content)) {
      collector.addError(SourceSpanException(
        'Invalid format for index "$content", must follow the format lower_snake_case.',
        span,
      ));
    }
  }

  void validateFieldName(
    dynamic content,
    SourceSpan? span,
    CodeAnalysisCollector collector,
  ) {
    if (!StringValidators.isValidFieldName(content)) {
      collector.addError(SourceSpanException(
        'Keys of "fields" Map must be valid Dart variable names (e.g. camelCaseString).',
        span,
      ));
    }
  }

  void validateParentName(
    dynamic content,
    SourceSpan? span,
    CodeAnalysisCollector collector,
  ) {
    if (content != null && !StringValidators.isValidTableIndexName(content)) {
      collector.addError(SourceSpanException(
        'The parent must reference a valid table name (e.g. parent=table_name). "$content" is not a valid parent name.',
        span,
      ));
    }
  }

  void validateFieldType(
    dynamic content,
    SourceSpan? span,
    CodeAnalysisCollector collector,
  ) {
    if (content is! String) {
      collector.addError(SourceSpanException(
        'The field must have a datatype defined (e.g. field: String).',
        span,
      ));
    }
  }

  void validateFieldDataType(
    dynamic content,
    SourceSpan? span,
    CodeAnalysisCollector collector,
  ) {
    if (content is! String) {
      collector.addError(SourceSpanException(
        'The field must have a datatype defined (e.g. field: String).',
        span,
      ));
    }
  }

  void validateIndexFieldsValue(
    dynamic content,
    SourceSpan? span,
    CodeAnalysisCollector collector,
  ) {
    if (content is! String) {
      collector.addError(SourceSpanException(
        'The "fields" property must have at least one field, (e.g. fields: fieldName).',
        span,
      ));
    }

    // todo add 2 pass check that fields exists in the class
  }

  void validateIndexType(
    dynamic content,
    SourceSpan? span,
    CodeAnalysisCollector collector,
  ) {
    if (content is! String) {
      collector.addError(SourceSpanException(
        'The "type" property must be of type String.',
        span,
      ));
    }
  }

  void validateEnumValues(
    dynamic content,
    SourceSpan? span,
    CodeAnalysisCollector collector,
  ) {
    if (content is! YamlList) {
      collector.addError(SourceSpanException(
        'The "values" property must be a list of strings.',
        span,
      ));
      return;
    }

    for (var node in content.nodes) {
      if (node is! YamlScalar || node.value is! String) {
        collector.addError(SourceSpanException(
          'The "values" property must be a list of strings.',
          node.span,
        ));
        continue;
      }

      if (!StringValidators.isValidFieldName(node.value)) {
        collector.addError(SourceSpanException(
          'Enum values must be lowerCamelCase.',
          node.span,
        ));
      }
    }
  }
}
