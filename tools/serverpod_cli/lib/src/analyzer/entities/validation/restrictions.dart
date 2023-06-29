import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

class Restrictions {
  String documentType;
  YamlMap documentContents;
  Set<SerializableEntityDefinition> entities;

  Restrictions({
    required this.documentType,
    required this.documentContents,
    this.entities = const {},
  });

  void isValidClassName(
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
  }

  void isValidTableName(
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

  void isBoolType(
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

  void isValidTableIndexName(
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

  void isValidFieldName(
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

  void isValidFieldType(
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

  void isValidFieldDataType(
    dynamic content,
    SourceSpan? span,
    CodeAnalysisCollector collector,
  ) {
    // todo implement
  }

  void isValidIndexFieldsValue(
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

    /*

    var fieldNames = content.split(',').map((String str) => str.trim()).toList();

    var doc = documentContents.nodes[Keyword.fields];

    if (doc is! YamlMap)  {
      return;
    }


    var doc.keys.whereType<String>().toSet();
        for (var fieldName in fieldNames) {
          if (!validDatabaseFieldNames.contains(fieldName)) {
            collector.addError(SourceSpanException(
              'The field name "$fieldName" is not added to the class or has an api scope.',
              fieldsNode.span,
            ));
            continue indexLoop;
          }
        }*/
  }

  void isValidIndexType(
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
}
