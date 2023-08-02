import 'package:serverpod_cli/src/analyzer/entities/checker/analyze_checker.dart';
import 'package:serverpod_cli/src/util/extensions.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:serverpod_cli/src/util/yaml_docs.dart';
import 'package:serverpod_cli/src/generator/types.dart';
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
          scope: SerializableEntityFieldScope.all,
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
    var parentTable = _parseParentTable(value);
    var scalarFieldName = _parseScalarField(value, fieldName);
    var isEnum = _parseIsEnumField(value);

    RelationDefinition? relation;

    if (parentTable != null) {
      relation = IdRelationDefinition(
        parentTable: parentTable,
        referenceFieldName: 'id',
      );
    } else if (scalarFieldName != null) {
      relation = ObjectRelationDefinition(scalarFieldName: scalarFieldName);
    } else if (typeResult.type.isList && _isRelation(value)) {
      relation = UnresolvedListRelationDefinition();
    }

    return [
      if (scalarFieldName != null)
        SerializableEntityFieldDefinition(
          name: scalarFieldName,
          relation: UnresolvedIdRelationDefinition(
            referenceFieldName: 'id',
          ),
          scope: SerializableEntityFieldScope.all,
          type: _createScalarType(value),
        ),
      SerializableEntityFieldDefinition(
        name: fieldName,
        relation: relation,
        scope:
            scalarFieldName != null ? SerializableEntityFieldScope.api : scope,
        type: typeResult.type..isEnum = isEnum,
        documentation: fieldDocumentation,
      )
    ];
  }

  static TypeDefinition _createScalarType(YamlMap value) {
    if (_isOptionalRelation(value)) {
      return TypeDefinition.int.asNullable;
    } else {
      return TypeDefinition.int;
    }
  }

  static String? _parseScalarField(YamlMap value, String fieldName) {
    if (!value.containsKey(Keyword.relation)) return null;
    var type = value.nodes[Keyword.type]?.value;
    if (type is! String) return null;
    if (AnalyzeChecker.isIdType(type)) return null;
    if (type.startsWith('List')) return null;

    return '${fieldName}Id';
  }

  static bool _isRelation(YamlMap documentContents) {
    return documentContents.containsKey([Keyword.relation]);
  }

  static bool _isOptionalRelation(YamlMap documentContents) {
    var relation = documentContents.nodes[Keyword.relation];

    if (relation is! YamlMap) return false;

    var optional = relation.containsKey(Keyword.optional);

    if (optional) return true;

    return false;
  }

  static SerializableEntityFieldScope _parseClassFieldScope(
    YamlMap documentContents,
  ) {
    var database = documentContents.containsKey(Keyword.database);
    var api = documentContents.containsKey(Keyword.api);

    if (database) return SerializableEntityFieldScope.database;
    if (api) return SerializableEntityFieldScope.api;

    return SerializableEntityFieldScope.all;
  }

  static String? _parseParentTable(YamlMap documentContents) {
    var parent = documentContents.nodes[Keyword.parent]?.value;
    if (parent is String) return parent;

    var relationMap = documentContents.nodes[Keyword.relation];

    if (relationMap is! YamlMap) return null;
    parent = relationMap.nodes[Keyword.parent]?.value;

    if (parent is String) return parent;

    var type = documentContents.nodes[Keyword.type]?.value;
    if (AnalyzeChecker.isIdType(type)) return null;
    if (type is! String) return null;

    return parent;
  }

  static bool _parseIsEnumField(YamlMap documentContents) {
    return documentContents.containsKey(Keyword.enumType);
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
