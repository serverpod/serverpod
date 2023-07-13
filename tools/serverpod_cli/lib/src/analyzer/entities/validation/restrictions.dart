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

    var reservedClassNames = {'List', 'Map', 'String', 'DateTime'};
    if (reservedClassNames.contains(content)) {
      return [
        SourceSpanException(
          'The class name "$content" is reserved and cannot be used.',
          span,
        )
      ];
    }

    if (entityRelations?.classNames.containsKey(content) == true) {
      return [
        SourceSpanException(
          'The $documentType name "$content" is already used by another protocol class.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanException> validateTableName(
    dynamic tableName,
    SourceSpan? span,
  ) {
    if (tableName is! String) {
      return [
        SourceSpanException(
          'The "table" property must be a snake_case_string.',
          span,
        )
      ];
    }

    if (!StringValidators.isValidTableName(tableName)) {
      return [
        SourceSpanException(
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
        SourceSpanException(
          'The table name "$tableName" is already in use by the class "${otherClass?.className}".',
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
    dynamic indexName,
    SourceSpan? span,
  ) {
    if (indexName is! String ||
        !StringValidators.isValidTableIndexName(indexName)) {
      return [
        SourceSpanException(
          'Invalid format for index "$indexName", must follow the format lower_snake_case.',
          span,
        )
      ];
    }
    var indexNames = entityRelations?.indexNames;
    if (indexNames != null && !_isKeyGloballyUnique(indexName, indexNames)) {
      var collision = _findFirstClassOtherClass(indexName, indexNames);
      return [
        SourceSpanException(
          'The index name "$indexName" is already used by the protocol class "${collision?.className}".',
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

    var def = documentDefinition;
    if (content == 'id' && def is ClassDefinition && def.tableName != null) {
      return [
        SourceSpanException(
          'The field name "id" is not allowed when a table is defined (the "id" field will be auto generated).',
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
    if (content == null) return [];

    var definition = documentDefinition;
    if (definition is ClassDefinition && definition.tableName == null) {
      return [
        SourceSpanException(
          'The "table" property must be defined in the class to set a parent on a field.',
          span,
        )
      ];
    }

    if (!StringValidators.isValidTableIndexName(content)) {
      return [
        SourceSpanException(
          'The parent must reference a valid table name (e.g. parent=table_name). "$content" is not a valid parent name.',
          span,
        )
      ];
    }

    var relations = entityRelations;
    if (relations != null && !relations.tableNames.containsKey(content)) {
      return [
        SourceSpanException(
          'The parent table "$content" was not found in any protocol.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanException> validateFieldDataType(
    dynamic type,
    SourceSpan? span,
  ) {
    if (type is! String) {
      return [
        SourceSpanException(
          'The field must have a datatype defined (e.g. field: String).',
          span,
        )
      ];
    }

    if (!_isValidFieldType(type)) {
      return [
        SourceSpanException(
          'The field has an invalid datatype "$type".',
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

    if (documentDefinition is! ClassDefinition) return [];
    var definition = documentDefinition as ClassDefinition;

    var fields = definition.fields;
    var indexFields = convertIndexList(content);

    var validDatabaseFieldNames = fields
        .where((field) => field.scope != SerializableEntityFieldScope.api)
        .fold(<String>{}, (output, field) => output..add(field.name));

    var missingFieldErrors = indexFields
        .where((field) => !validDatabaseFieldNames.contains(field))
        .map((field) => SourceSpanException(
              'The field name "$field" is not added to the class or has an api scope.',
              span,
            ));

    var duplicatesCount = _duplicatesCount(indexFields);

    var duplicateFieldErrors = duplicatesCount.entries
        .where((entry) => entry.value > 1)
        .map((entry) => SourceSpanException(
              'Duplicated field name "name", can only reference a field once per index.',
              span,
            ));

    return [...missingFieldErrors, ...duplicateFieldErrors];
  }

  List<SourceSpanException> validateIndexType(
    dynamic content,
    SourceSpan? span,
  ) {
    var validIndexTypes = {'btree', 'hash', 'gin', 'gist', 'spgist', 'brin'};

    if (content is! String || !validIndexTypes.contains(content)) {
      return [
        SourceSpanException(
          'The "type" property must be one of: ${validIndexTypes.join(', ')}.',
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

    var enumCount = _duplicatesCount(content);

    var nodeExceptions = content.nodes.map((node) {
      var enumValue = node.value;
      if (node is! YamlScalar || enumValue is! String) {
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

      if (enumCount[enumValue] != 1) {
        return SourceSpanException(
          'Enum values must be unique.',
          node.span,
        );
      }

      return null;
    });

    return nodeExceptions.whereType<SourceSpanException>().toList();
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

    return typeComponents.any(
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
