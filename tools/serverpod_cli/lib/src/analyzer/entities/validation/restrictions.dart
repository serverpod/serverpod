import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

import 'package:serverpod_cli/src/analyzer/entities/converter/converter.dart';

import 'entity_relations.dart';

class Restrictions {
  String documentType;
  YamlMap documentContents;
  SerializableEntityDefinition? documentDefinition;
  EntityRelations? entityRelations;

  Restrictions({
    required this.documentType,
    required this.documentContents,
    this.documentDefinition,
    this.entityRelations,
  });

  List<SourceSpanSeverityException> validateClassName(
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is! String) {
      return [
        SourceSpanSeverityException(
          'The "$documentType" type must be a String.',
          span,
        )
      ];
    }

    if (!StringValidators.isValidClassName(content)) {
      return [
        SourceSpanSeverityException(
          'The "$documentType" type must be a valid class name (e.g. PascalCaseString).',
          span,
        )
      ];
    }

    var reservedClassNames = {'List', 'Map', 'String', 'DateTime'};
    if (reservedClassNames.contains(content)) {
      return [
        SourceSpanSeverityException(
          'The class name "$content" is reserved and cannot be used.',
          span,
        )
      ];
    }

    var classesByName = entityRelations?.classNames[content];
    if (classesByName != null && classesByName.length > 1) {
      return [
        SourceSpanSeverityException(
          'The $documentType name "$content" is already used by another protocol class.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateTableName(
    dynamic tableName,
    SourceSpan? span,
  ) {
    if (tableName is! String) {
      return [
        SourceSpanSeverityException(
            'The "table" property must be a snake_case_string.', span)
      ];
    }

    if (!StringValidators.isValidTableName(tableName)) {
      return [
        SourceSpanSeverityException(
          'The "table" property must be a snake_case_string.',
          span,
        )
      ];
    }

    var relations = entityRelations;
    if (relations != null &&
        !_isKeyGloballyUnique(tableName, relations.tableNames)) {
      var otherClass =
          _findFirstClassOtherClass(tableName, relations.tableNames);
      return [
        SourceSpanSeverityException(
          'The table name "$tableName" is already in use by the class "${otherClass?.className}".',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateBoolType(
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is bool) return [];

    return [
      SourceSpanSeverityException(
        'The property value must be a bool.',
        span,
      )
    ];
  }

  List<SourceSpanSeverityException> validateTableIndexName(
    dynamic indexName,
    SourceSpan? span,
  ) {
    if (indexName is! String ||
        !StringValidators.isValidTableIndexName(indexName)) {
      return [
        SourceSpanSeverityException(
          'Invalid format for index "$indexName", must follow the format lower_snake_case.',
          span,
        )
      ];
    }
    var indexNames = entityRelations?.indexNames;
    if (indexNames != null && !_isKeyGloballyUnique(indexName, indexNames)) {
      var collision = _findFirstClassOtherClass(indexName, indexNames);
      return [
        SourceSpanSeverityException(
          'The index name "$indexName" is already used by the protocol class "${collision?.className}".',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateFieldName(
    dynamic content,
    SourceSpan? span,
  ) {
    if (!StringValidators.isValidFieldName(content)) {
      return [
        SourceSpanSeverityException(
          'Keys of "fields" Map must be valid Dart variable names (e.g. camelCaseString).',
          span,
        )
      ];
    }

    var def = documentDefinition;
    if (content == 'id' && def is ClassDefinition && def.tableName != null) {
      return [
        SourceSpanSeverityException(
          'The field name "id" is not allowed when a table is defined (the "id" field will be auto generated).',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateParentName(
    dynamic content,
    SourceSpan? span,
  ) {
    if (content == null) return [];

    var definition = documentDefinition;
    if (definition is ClassDefinition && definition.tableName == null) {
      return [
        SourceSpanSeverityException(
          'The "table" property must be defined in the class to set a parent on a field.',
          span,
        )
      ];
    }

    if (!StringValidators.isValidTableIndexName(content)) {
      return [
        SourceSpanSeverityException(
          'The parent must reference a valid table name (e.g. parent=table_name). "$content" is not a valid parent name.',
          span,
        )
      ];
    }

    var relations = entityRelations;
    if (relations != null && !relations.tableNames.containsKey(content)) {
      return [
        SourceSpanSeverityException(
          'The parent table "$content" was not found in any protocol.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateFieldDataType(
    dynamic type,
    SourceSpan? span,
  ) {
    if (type is! String) {
      return [
        SourceSpanSeverityException(
          'The field must have a datatype defined (e.g. field: String).',
          span,
        )
      ];
    }

    if (!_isValidFieldType(type)) {
      return [
        SourceSpanSeverityException(
          'The field has an invalid datatype "$type".',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateIndexFieldsValue(
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is! String) {
      return [
        SourceSpanSeverityException(
          'The "fields" property must have at least one field, (e.g. fields: fieldName).',
          span,
        )
      ];
    }

    if (documentDefinition is! ClassDefinition) return [];
    var definition = documentDefinition as ClassDefinition;

    var fields = definition.fields;
    var indexFields = convertIndexList(content);

    var validDatabaseFieldNames = fields
        .where((field) => field.scope != SerializableEntityFieldScope.api)
        .fold(<String>{}, (output, field) => output..add(field.name));

    var missingFieldErrors = indexFields
        .where((field) => !validDatabaseFieldNames.contains(field))
        .map((field) => SourceSpanSeverityException(
              'The field name "$field" is not added to the class or has an api scope.',
              span,
            ));

    var duplicatesCount = _duplicatesCount(indexFields);

    var duplicateFieldErrors = duplicatesCount.entries
        .where((entry) => entry.value > 1)
        .map((entry) => SourceSpanSeverityException(
              'Duplicated field name "name", can only reference a field once per index.',
              span,
            ));

    return [...missingFieldErrors, ...duplicateFieldErrors];
  }

  List<SourceSpanSeverityException> validateIndexType(
    dynamic content,
    SourceSpan? span,
  ) {
    var validIndexTypes = {'btree', 'hash', 'gin', 'gist', 'spgist', 'brin'};

    if (content is! String || !validIndexTypes.contains(content)) {
      return [
        SourceSpanSeverityException(
          'The "type" property must be one of: ${validIndexTypes.join(', ')}.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateRelationKey(
    String relation,
    SourceSpan? span,
  ) {
    var definition = documentDefinition;
    if (definition is ClassDefinition && definition.tableName == null) {
      return [
        SourceSpanSeverityException(
          'The "table" property must be defined in the class to set a relation on a field.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateEnumValues(
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is! YamlList) {
      return [
        SourceSpanSeverityException(
          'The "values" property must be a list of strings.',
          span,
        )
      ];
    }

    var enumCount = _duplicatesCount(content);

    var nodeExceptions = content.nodes.map((node) {
      var enumValue = node.value;
      if (node is! YamlScalar || enumValue is! String) {
        return SourceSpanSeverityException(
          'The "values" property must be a list of strings.',
          node.span,
        );
      }

      if (StringValidators.isInvalidInfoEnumValue(node.value)) {
        return SourceSpanSeverityException(
          'Enum values should be lowerCamelCase.',
          node.span,
          severity: SourceSpanSeverity.info,
        );
      }

      if (!StringValidators.isValidEnumValue(node.value)) {
        return SourceSpanSeverityException(
          'Enum values must be lowerCamelCase.',
          node.span,
        );
      }

      if (enumCount[enumValue] != 1) {
        return SourceSpanSeverityException(
          'Enum values must be unique.',
          node.span,
        );
      }

      return null;
    });

    return nodeExceptions.whereType<SourceSpanSeverityException>().toList();
  }

  Map<dynamic, int> _duplicatesCount(List<dynamic> list) {
    Map<dynamic, int> valueCount = {};
    for (var listValue in list) {
      valueCount.update(listValue, (value) => value + 1, ifAbsent: () => 1);
    }

    return valueCount;
  }

  bool _isValidFieldType(String type) {
    var typeComponents = type
        .replaceAll('?', '')
        .replaceAll(' ', '')
        .replaceAll('<', ',')
        .replaceAll('>', ',')
        .split(',')
        .where((t) => t.isNotEmpty);

    if (typeComponents.isEmpty) return false;

    // Checks if the type has several ??? in a row.
    if (RegExp(r'\?{2,}').hasMatch(type)) return false;

    return typeComponents.every(
      (type) => StringValidators.isValidFieldType(type),
    );
  }

  bool _isKeyGloballyUnique(
    String key,
    Map<String, List<SerializableEntityDefinition>> map,
  ) {
    var classes = map[key];

    if (documentDefinition == null && classes != null && classes.isNotEmpty) {
      return false;
    }

    return classes == null || classes.length == 1;
  }

  SerializableEntityDefinition? _findFirstClassOtherClass(
    String key,
    Map<String, List<SerializableEntityDefinition>> map,
  ) {
    var classes = map[key];
    if (classes == null || classes.isEmpty) return null;

    return classes.firstWhere((c) => c != documentDefinition);
  }
}
