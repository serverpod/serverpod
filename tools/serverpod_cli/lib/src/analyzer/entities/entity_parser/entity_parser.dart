import 'package:serverpod_cli/src/analyzer/entities/checker/analyze_checker.dart';
import 'package:serverpod_cli/src/util/extensions.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:serverpod_cli/src/util/yaml_docs.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

import 'package:serverpod_cli/src/analyzer/entities/converter/converter.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/keywords.dart';

class EntityParser {
  static SerializableEntityDefinition? serializeClassFile(
    String documentTypeName,
    ProtocolSource protocolSource,
    String outFileName,
    YamlMap documentContents,
    YamlDocumentationExtractor docsExtractor,
  ) {
    YamlNode? classNode = documentContents.nodes[documentTypeName];

    if (classNode == null) {
      throw ArgumentError(
        'No $documentTypeName node found, only valid to call this function if '
        ' the documentType exists as a top level key in the document.',
      );
    }

    var classDocumentation = docsExtractor.getDocumentation(
      documentContents.key(documentTypeName)!.span.start,
    );

    var className = classNode.value;
    if (className is! String) return null;

    var tableName = _parseTableName(documentContents);
    var serverOnly = _parseServerOnly(documentContents);
    var fields = _parseClassFields(
      documentContents,
      docsExtractor,
      tableName != null,
    );
    var indexes = _parseIndexes(documentContents, fields);

    return ClassDefinition(
      className: className,
      sourceFileName: protocolSource.yamlSourceUri.path,
      tableName: tableName,
      fileName: outFileName,
      fields: fields,
      indexes: indexes,
      subDirParts: protocolSource.protocolRootPathParts,
      documentation: classDocumentation,
      isException: documentTypeName == Keyword.exceptionType,
      serverOnly: serverOnly,
    );
  }

  static SerializableEntityDefinition? serializeEnumFile(
    ProtocolSource protocolSource,
    String outFileName,
    YamlMap documentContents,
    YamlDocumentationExtractor docsExtractor,
  ) {
    var className = documentContents[Keyword.enumType];
    if (className is! String) return null;

    var enumDocumentation = docsExtractor.getDocumentation(
      documentContents.key(Keyword.enumType)!.span.start,
    );

    var serverOnly = _parseServerOnly(documentContents);
    var values = _parseEnumValues(documentContents, docsExtractor);

    return EnumDefinition(
      fileName: outFileName,
      sourceFileName: protocolSource.yamlSourceUri.path,
      className: className,
      values: values,
      documentation: enumDocumentation,
      subDirParts: protocolSource.protocolRootPathParts,
      serverOnly: serverOnly,
    );
  }

  static bool _parseServerOnly(YamlMap documentContents) {
    var serverOnly = documentContents.nodes[Keyword.serverOnly]?.value;
    if (serverOnly is! bool) return false;

    return serverOnly;
  }

  static String? _parseTableName(YamlMap documentContents) {
    var tableName = documentContents.nodes[Keyword.table]?.value;
    if (tableName is! String) return null;

    return tableName;
  }

  static List<SerializableEntityFieldDefinition> _parseClassFields(
    YamlMap documentContents,
    YamlDocumentationExtractor docsExtractor,
    bool hasTable,
  ) {
    var fieldsNode = documentContents.nodes[Keyword.fields];
    if (fieldsNode is! YamlMap) return [];

    var fields = fieldsNode.nodes.entries.expand((fieldNode) {
      return _parseEntityFieldDefinition(
        fieldNode,
        docsExtractor,
      );
    }).toList();

    if (hasTable) {
      fields = [
        SerializableEntityFieldDefinition(
          name: 'id',
          type: TypeDefinition.int.asNullable,
          scope: EntityFieldScopeDefinition.all,
          shouldPersist: true,
          documentation: [
            '/// The database id, set if the object has been inserted into the',
            '/// database or if it has been fetched from the database. Otherwise,',
            '/// the id will be null.',
          ],
        ),
        ...fields,
      ];
    }

    return fields;
  }

  static List<SerializableEntityFieldDefinition> _parseEntityFieldDefinition(
    MapEntry<dynamic, YamlNode> fieldNode,
    YamlDocumentationExtractor docsExtractor,
  ) {
    var key = fieldNode.key;
    if (key is! YamlScalar) return [];

    var nodeValue = fieldNode.value;
    var value = nodeValue.value;
    if (value is String) {
      value = convertStringifiedNestedNodesToYamlMap(
        value,
        nodeValue.span,
        firstKey: Keyword.type,
      );
    }
    if (value is! YamlMap) return [];

    var fieldName = key.value;
    if (fieldName is! String) return [];

    var typeNode = value.nodes[Keyword.type];
    var typeValue = typeNode?.value;
    if (typeNode is! YamlScalar) return [];
    if (typeValue is! String) return [];

    var fieldDocumentation = docsExtractor.getDocumentation(key.span.start);
    var typeResult = parseAndAnalyzeType(
      typeValue.replaceAll(' ', ''),
      sourceSpan: typeNode.span,
    );

    var scope = _parseClassFieldScope(value);
    var shouldPersist = _parseShouldPersist(value);

    var referenceFieldName = 'id';
    String relationName = _parseFieldRelationName(value, fieldName);

    RelationDefinition? relation = _parseRelation(
      fieldName,
      referenceFieldName,
      typeResult,
      value,
    );

    return [
      if (_shouldCreateRelationField(relation))
        SerializableEntityFieldDefinition(
          name: relationName,
          relation: _createUnresolvedForeignRelationDefinition(
            value,
            referenceFieldName,
          ),
          shouldPersist: true,
          scope: scope,
          type: _createRelationFieldType(value),
        ),
      SerializableEntityFieldDefinition(
        name: fieldName,
        relation: relation,
        shouldPersist: _shouldNeverPersist(relation) ? false : shouldPersist,
        scope: scope,
        type: typeResult.type,
        documentation: fieldDocumentation,
      )
    ];
  }

  static UnresolvedForeignRelationDefinition
      _createUnresolvedForeignRelationDefinition(
    YamlMap node,
    String referenceFieldName,
  ) {
    var onDelete = _parseOnDelete(node);
    var onUpdate = _parseOnUpdate(node);

    return UnresolvedForeignRelationDefinition(
      referenceFieldName: referenceFieldName,
      onUpdate: onUpdate,
      onDelete: onDelete,
    );
  }

  static bool _shouldNeverPersist(RelationDefinition? relation) {
    if (relation is ObjectRelationDefinition) return true;
    if (relation is UnresolvedListRelationDefinition) return true;
    if (relation is UnresolvedObjectRelationDefinition) return true;
    return false;
  }

  static bool _shouldCreateRelationField(
    RelationDefinition? relation,
  ) {
    return relation is ObjectRelationDefinition;
  }

  static RelationDefinition? _parseRelation(
    String fieldName,
    String referenceFieldName,
    TypeParseResult typeResult,
    YamlMap node,
  ) {
    if (!_isRelation(node)) return null;

    if (typeResult.type.isList) {
      return UnresolvedListRelationDefinition();
    }

    var parentTable = _parseParentTable(node);

    var onDelete = _parseOnDelete(node);
    var onUpdate = _parseOnUpdate(node);

    if (parentTable != null) {
      return ForeignRelationDefinition(
        parentTable: parentTable,
        foreignFieldName: referenceFieldName,
        onUpdate: onUpdate,
        onDelete: onDelete,
      );
    }

    var relationFieldName = _parseFieldRelationName(node, fieldName);

    if (_containsRelationKey(node, Keyword.field)) {
      return UnresolvedObjectRelationDefinition(
        fieldName: relationFieldName,
        foreignFieldName: referenceFieldName,
        onUpdate: onUpdate,
        onDelete: onDelete,
      );
    }

    if (!_isIdType(node)) {
      return ObjectRelationDefinition(fieldName: relationFieldName);
    }

    return null;
  }

  static bool _containsRelationKey(YamlMap value, String key) {
    var relationNode = value.nodes[Keyword.relation]?.value;
    if (relationNode is! YamlMap) return false;
    return relationNode.containsKey(key);
  }

  static String _parseFieldRelationName(YamlMap value, String fieldName) {
    var relationFieldNode = _parseRelationNode(value, Keyword.field);
    var relationField = relationFieldNode?.value;

    if (relationField is String) return relationField;

    return '${fieldName}Id';
  }

  static TypeDefinition _createRelationFieldType(YamlMap value) {
    if (_isOptionalRelation(value)) {
      return TypeDefinition.int.asNullable;
    } else {
      return TypeDefinition.int;
    }
  }

  static bool _isIdType(YamlMap value) {
    var type = value.nodes[Keyword.type]?.value;
    if (type is! String) return false;
    return AnalyzeChecker.isIdType(type);
  }

  static ForeignKeyAction _parseOnUpdate(YamlMap node) {
    return _parseDatabaseAction(
      Keyword.onUpdate,
      onUpdateDefault,
      node,
    );
  }

  static ForeignKeyAction _parseOnDelete(YamlMap node) {
    return _parseDatabaseAction(
      Keyword.onDelete,
      onDeleteDefault,
      node,
    );
  }

  static ForeignKeyAction _parseDatabaseAction(
    String key,
    ForeignKeyAction defaultValue,
    YamlMap node,
  ) {
    var action = _parseRelationNode(node, key)?.value;
    if (action is! String) return defaultValue;

    return convertToEnum(
      value: action,
      enumDefault: defaultValue,
      enumValues: ForeignKeyAction.values,
    );
  }

  static YamlNode? _parseRelationNode(YamlMap node, String key) {
    var relation = node.nodes[Keyword.relation]?.value;
    if (relation is! YamlMap) return null;
    return relation.nodes[key];
  }

  static bool _isRelation(YamlMap documentContents) {
    if (documentContents.containsKey(Keyword.parent)) return true;
    return documentContents.containsKey(Keyword.relation);
  }

  static bool _parseShouldPersist(YamlMap node) {
    var isApi = _parseBooleanKey(node, Keyword.api);
    if (isApi) return false;
    if (!node.containsKey(Keyword.persist)) return true;

    return _parseBooleanKey(node, Keyword.persist);
  }

  static bool _parseBooleanKey(YamlMap node, String key) {
    var value = node.nodes[key]?.value;
    var boolValue = _parseBool(value);
    if (boolValue != null) return boolValue;

    var containsKey = node.containsKey(key);
    return containsKey;
  }

  static bool? _parseBool(dynamic value) {
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }

    return null;
  }

  static bool _isOptionalRelation(YamlMap node) {
    var relation = node.nodes[Keyword.relation];
    if (relation is! YamlMap) return false;

    return _parseBooleanKey(relation, Keyword.optional);
  }

  static EntityFieldScopeDefinition _parseClassFieldScope(
    YamlMap documentContents,
  ) {
    var database = _parseBooleanKey(documentContents, Keyword.database);
    if (database) return EntityFieldScopeDefinition.serverOnly;

    var scope = documentContents.nodes[Keyword.scope]?.value;

    if (scope is! String) return EntityFieldScopeDefinition.all;

    return convertToEnum(
      value: scope,
      enumDefault: EntityFieldScopeDefinition.all,
      enumValues: EntityFieldScopeDefinition.values,
    );
  }

  static String? _parseParentTable(YamlMap documentContents) {
    var parent = documentContents.nodes[Keyword.parent]?.value;
    if (parent is String) return parent;

    parent = _parseRelationNode(documentContents, Keyword.parent)?.value;
    if (parent is String) return parent;

    return null;
  }

  static List<SerializableEntityIndexDefinition>? _parseIndexes(
    YamlMap documentContents,
    List<SerializableEntityFieldDefinition> fields,
  ) {
    var indexesNode = documentContents.nodes[Keyword.indexes];
    if (indexesNode is! YamlMap) return null;

    var indexes = indexesNode.nodes.entries.map((node) {
      var keyScalar = node.key;
      var nodeDocument = node.value;
      if (keyScalar is! YamlScalar) return null;
      if (nodeDocument is! YamlMap) return null;

      var indexName = keyScalar.value;
      if (indexName is! String) return null;

      var indexFields = _parseIndexFields(nodeDocument, fields);
      var type = _parseIndexType(nodeDocument);
      var unique = _parseUniqueKey(nodeDocument);

      return SerializableEntityIndexDefinition(
        name: indexName,
        type: type,
        unique: unique,
        fields: indexFields,
      );
    });

    return indexes
        .where((index) => index != null)
        .cast<SerializableEntityIndexDefinition>()
        .toList();
  }

  static List<String> _parseIndexFields(
    YamlMap documentContents,
    List<SerializableEntityFieldDefinition> fields,
  ) {
    var fieldsNode = documentContents.nodes[Keyword.fields];
    if (fieldsNode is! YamlNode) return [];

    var stringifiedFields = fieldsNode.value;
    if (stringifiedFields is! String) return [];

    var indexFields = convertIndexList(stringifiedFields);

    return indexFields;
  }

  static String _parseIndexType(YamlMap documentContents) {
    var typeNode = documentContents.nodes[Keyword.type];
    var type = typeNode?.value;

    if (type == null || type is! String) {
      return 'btree';
    }

    return type;
  }

  static bool _parseUniqueKey(YamlMap documentContents) {
    var node = documentContents.nodes[Keyword.unique];
    var nodeValue = node?.value;
    return nodeValue is bool ? nodeValue : false;
  }

  static List<ProtocolEnumValueDefinition> _parseEnumValues(
    YamlMap documentContents,
    YamlDocumentationExtractor docsExtractor,
  ) {
    var valuesNode = documentContents.nodes[Keyword.values];
    if (valuesNode is! YamlList) return [];

    var values = valuesNode.nodes.map((node) {
      var value = node.value;
      if (value is! String) return null;

      var start = node.span.start;
      // 2 is the length of '- ' in '- enumValue'
      var valueDocumentation = docsExtractor.getDocumentation(
        SourceLocation(start.offset - 2,
            column: start.column - 2,
            line: start.line,
            sourceUrl: start.sourceUrl),
      );

      return ProtocolEnumValueDefinition(value, valueDocumentation);
    });

    return values
        .where((value) => value != null)
        .cast<ProtocolEnumValueDefinition>()
        .toList();
  }
}
