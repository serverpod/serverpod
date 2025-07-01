import 'package:serverpod_cli/src/analyzer/models/converter/converter.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/utils/quote_utils.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/util/extensions.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/yaml_docs.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

class ModelParser {
  static SerializableModelDefinition? serializeModelClassFile(
    String documentTypeName,
    ModelSource protocolSource,
    String outFileName,
    YamlMap documentContents,
    YamlDocumentationExtractor docsExtractor,
    List<TypeDefinition> extraClasses,
  ) {
    var isSealed = _parseIsSealed(documentContents);

    var extendsClass = _parseExtendsClass(documentContents);

    var migrationValue =
        documentContents.nodes[Keyword.managedMigration]?.value;
    var manageMigration = _parseBool(migrationValue) ?? true;

    var tableName = _parseTableName(documentContents);

    return _initializeFromClassFields(
        documentTypeName: documentTypeName,
        protocolSource: protocolSource,
        outFileName: outFileName,
        documentContents: documentContents,
        docsExtractor: docsExtractor,
        extraClasses: extraClasses,
        hasTable: tableName != null,
        initialize: ({
          required String className,
          required TypeDefinition classType,
          required bool serverOnly,
          required List<SerializableModelFieldDefinition> fields,
          required List<String>? classDocumentation,
        }) {
          var indexes = _parseIndexes(documentContents, fields);

          return ModelClassDefinition(
            className: className,
            isSealed: isSealed,
            extendsClass: extendsClass,
            sourceFileName: protocolSource.yamlSourceUri.path,
            tableName: tableName,
            manageMigration: manageMigration,
            fileName: outFileName,
            fields: fields,
            indexes: indexes,
            subDirParts: protocolSource.subDirPathParts,
            documentation: classDocumentation,
            serverOnly: serverOnly,
            type: classType,
          );
        });
  }

  static SerializableModelDefinition? serializeExceptionClassFile(
    String documentTypeName,
    ModelSource protocolSource,
    String outFileName,
    YamlMap documentContents,
    YamlDocumentationExtractor docsExtractor,
    List<TypeDefinition> extraClasses,
  ) {
    return _initializeFromClassFields(
      documentTypeName: documentTypeName,
      protocolSource: protocolSource,
      outFileName: outFileName,
      documentContents: documentContents,
      docsExtractor: docsExtractor,
      extraClasses: extraClasses,
      hasTable: false,
      initialize: ({
        required String className,
        required TypeDefinition classType,
        required bool serverOnly,
        required List<SerializableModelFieldDefinition> fields,
        required List<String>? classDocumentation,
      }) =>
          ExceptionClassDefinition(
        className: className,
        fields: fields,
        fileName: outFileName,
        serverOnly: serverOnly,
        sourceFileName: protocolSource.yamlSourceUri.path,
        type: classType,
        subDirParts: protocolSource.subDirPathParts,
        documentation: classDocumentation,
      ),
    );
  }

  /// Initializes a [ClassDefinition] specialization, [T], from the shared
  /// [ClassDefinition] fields.
  ///
  /// This function is used to avoid code duplication when initializing
  /// different class definitions from the same shared fields.
  static T? _initializeFromClassFields<T>({
    required String documentTypeName,
    required ModelSource protocolSource,
    required String outFileName,
    required YamlMap documentContents,
    required YamlDocumentationExtractor docsExtractor,
    required List<TypeDefinition> extraClasses,
    required bool hasTable,
    required T Function({
      required String className,
      required TypeDefinition classType,
      required bool serverOnly,
      required List<SerializableModelFieldDefinition> fields,
      required List<String>? classDocumentation,
    }) initialize,
  }) {
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

    var classType = parseType(
      '${protocolSource.moduleAlias}:$className',
      extraClasses: extraClasses,
    );

    var tableName = _parseTableName(documentContents);
    var serverOnly = _parseServerOnly(documentContents);
    var fields = _parseClassFields(
      documentContents,
      docsExtractor,
      tableName != null,
      extraClasses,
      serverOnly,
    );

    return initialize(
      className: className,
      classType: classType,
      serverOnly: serverOnly,
      fields: fields,
      classDocumentation: classDocumentation,
    );
  }

  static SerializableModelDefinition? serializeEnumFile(
    ModelSource protocolSource,
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
    var serializeAs = _parseSerializedAs(documentContents);
    var values = _parseEnumValues(documentContents, docsExtractor);
    var enumType = parseType(
      '${protocolSource.moduleAlias}:$className',
      extraClasses: [],
    );
    var defaultEnumDefinitionValue =
        _parseEnumDefaultValue(documentContents, values);

    var enumDef = EnumDefinition(
      fileName: outFileName,
      sourceFileName: protocolSource.yamlSourceUri.path,
      className: className,
      values: values,
      serialized: serializeAs,
      documentation: enumDocumentation,
      defaultValue: defaultEnumDefinitionValue,
      subDirParts: protocolSource.subDirPathParts,
      serverOnly: serverOnly,
      type: enumType,
    );
    enumDef.type.enumDefinition = enumDef;
    return enumDef;
  }

  static bool _parseIsSealed(YamlMap documentContents) {
    var isSealed = documentContents.nodes[Keyword.isSealed]?.value;
    if (isSealed is! bool) return false;

    return isSealed;
  }

  static UnresolvedInheritanceDefinition? _parseExtendsClass(
    YamlMap documentContents,
  ) {
    var extendsClass = documentContents.nodes[Keyword.extendsClass]?.value;
    if (extendsClass is! String) return null;

    return UnresolvedInheritanceDefinition(extendsClass);
  }

  static bool _parseServerOnly(YamlMap documentContents) {
    var serverOnly = documentContents.nodes[Keyword.serverOnly]?.value;
    if (serverOnly is! bool) return false;

    return serverOnly;
  }

  static EnumSerialization _parseSerializedAs(YamlMap documentContents) {
    var serializedAs = documentContents.nodes[Keyword.serialized]?.value;

    return convertToEnum<EnumSerialization>(
      value: serializedAs,
      enumDefault: EnumSerialization.byIndex,
      enumValues: EnumSerialization.values,
    );
  }

  static String? _parseTableName(YamlMap documentContents) {
    var tableName = documentContents.nodes[Keyword.table]?.value;
    if (tableName is! String) return null;

    return tableName;
  }

  static List<SerializableModelFieldDefinition> _parseClassFields(
    YamlMap documentContents,
    YamlDocumentationExtractor docsExtractor,
    bool hasTable,
    List<TypeDefinition> extraClasses,
    bool serverOnlyClass,
  ) {
    List<SerializableModelFieldDefinition> fields = [];

    var fieldsNode = documentContents.nodes[Keyword.fields];
    if (fieldsNode is YamlMap) {
      var fieldsNodeEntries = fieldsNode.nodes.entries;
      fields.addAll(fieldsNodeEntries.expand((fieldNode) {
        return _parseModelFieldDefinition(
          fieldNode,
          docsExtractor,
          extraClasses,
          serverOnlyClass,
        );
      }).toList());
    }

    if (hasTable) {
      final defaultIdType = SupportedIdType.int;

      var maybeIdField =
          fields.where((f) => f.name == defaultPrimaryKeyName).firstOrNull;

      var idFieldType = maybeIdField?.type ?? defaultIdType.type.asNullable;

      var defaultPersistValue = (maybeIdField != null)
          ? maybeIdField.defaultPersistValue
          : defaultIdType.defaultValue;

      // The 'int' id type can be specified without a default value.
      if (maybeIdField?.type.className == 'int') {
        defaultPersistValue ??= SupportedIdType.int.defaultValue;
      }

      var defaultModelValue = maybeIdField?.defaultModelValue;
      if (maybeIdField == null && defaultIdType.type.className != 'int') {
        defaultModelValue ??= defaultIdType.defaultValue;
      }

      var defaultIdFieldDoc = [
        '/// The database id, set if the object has been inserted into the',
        '/// database or if it has been fetched from the database. Otherwise,',
        '/// the id will be null.',
      ];

      fields.removeWhere((f) => f.name == defaultPrimaryKeyName);
      fields.insert(
        0,
        SerializableModelFieldDefinition(
          name: defaultPrimaryKeyName,
          type: idFieldType,
          scope: ModelFieldScopeDefinition.all,
          defaultModelValue: defaultModelValue,
          defaultPersistValue: defaultPersistValue ?? defaultModelValue,
          shouldPersist: true,
          documentation: maybeIdField?.documentation ?? defaultIdFieldDoc,
        ),
      );
    }

    return fields;
  }

  static List<SerializableModelFieldDefinition> _parseModelFieldDefinition(
    MapEntry<dynamic, YamlNode> fieldNode,
    YamlDocumentationExtractor docsExtractor,
    List<TypeDefinition> extraClasses,
    bool serverOnlyClass,
  ) {
    var key = fieldNode.key;
    if (key is! YamlScalar) return [];

    var nodeValue = fieldNode.value;
    var node = nodeValue.value;
    if (node is String) {
      node = convertStringifiedNestedNodesToYamlMap(
        node,
        nodeValue.span,
        firstKey: Keyword.type,
      );
    }
    if (node is! YamlMap) return [];

    var fieldName = key.value;
    if (fieldName is! String) return [];

    var typeNode = node.nodes[Keyword.type];
    var typeValue = typeNode?.value;
    if (typeNode is! YamlScalar) return [];
    if (typeValue is! String) return [];

    var fieldDocumentation = docsExtractor.getDocumentation(key.span.start);

    var typeResult = parseType(
      typeValue,
      extraClasses: extraClasses,
    );

    var scope = _parseClassFieldScope(node, serverOnlyClass);
    var shouldPersist = _parseShouldPersist(node);

    var defaultModelValue = _parseDefaultValue(
      node,
      Keyword.defaultModelKey,
    );
    var defaultPersistValue = _parseDefaultValue(
      node,
      Keyword.defaultPersistKey,
    );

    RelationDefinition? relation = _parseRelation(
      fieldName,
      typeResult,
      node,
    );

    return [
      SerializableModelFieldDefinition(
        name: fieldName,
        relation: relation,
        shouldPersist: _shouldNeverPersist(relation) ? false : shouldPersist,
        scope: scope,
        type: typeResult,
        documentation: fieldDocumentation,
        defaultModelValue: defaultModelValue,
        defaultPersistValue: defaultPersistValue,
      )
    ];
  }

  static bool _shouldNeverPersist(RelationDefinition? relation) {
    if (relation is ObjectRelationDefinition) return true;
    if (relation is UnresolvedListRelationDefinition) return true;
    if (relation is UnresolvedObjectRelationDefinition) return true;
    return false;
  }

  static RelationDefinition? _parseRelation(
    String fieldName,
    TypeDefinition typeResult,
    YamlMap node,
  ) {
    if (!_isRelation(node)) return null;

    var relationName = _parseRelationName(node);

    var parentTable = _parseParentTable(node);
    var relationFieldName = _parseFieldRelationName(node, fieldName);

    var onDelete = _parseOnDelete(node);
    var onUpdate = _parseOnUpdate(node);

    var optionalRelation = _isOptionalRelation(node);

    if (typeResult.isListType) {
      return UnresolvedListRelationDefinition(
        name: relationName,
        nullableRelation: optionalRelation,
      );
    } else if (typeResult.isIdType && parentTable != null) {
      return ForeignRelationDefinition(
        name: relationName,
        parentTable: parentTable,
        foreignFieldName: defaultPrimaryKeyName,
        onUpdate: onUpdate,
        onDelete: onDelete,
      );
    } else if (!typeResult.isIdType) {
      return UnresolvedObjectRelationDefinition(
        name: relationName,
        fieldName: relationFieldName,
        onUpdate: onUpdate,
        onDelete: onDelete,
        isForeignKeyOrigin: relationFieldName != null,
        nullableRelation: optionalRelation,
      );
    } else {
      return null;
    }
  }

  static String? _parseRelationName(YamlMap node) {
    var relationNameNode = _parseRelationNode(node, Keyword.name);

    if (relationNameNode?.value is! String) return null;

    return relationNameNode?.value;
  }

  static String? _parseFieldRelationName(YamlMap value, String fieldName) {
    var relationFieldNode = _parseRelationNode(value, Keyword.field);
    var relationField = relationFieldNode?.value;

    if (relationField is! String) return null;

    return relationField;
  }

  static ForeignKeyAction _parseOnUpdate(YamlMap node) {
    return _parseDatabaseAction(
      Keyword.onUpdate,
      onUpdateDefault,
      onUpdateDefault,
      node,
    );
  }

  static ForeignKeyAction _parseOnDelete(YamlMap node) {
    return _parseDatabaseAction(
      Keyword.onDelete,
      onDeleteDefault,
      onDeleteDefaultOld,
      node,
    );
  }

  static ForeignKeyAction _parseDatabaseAction(
    String key,
    ForeignKeyAction defaultValue,
    ForeignKeyAction oldDefaultValue,
    YamlMap node,
  ) {
    if (node.containsKey(Keyword.parent)) return oldDefaultValue;

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

  static dynamic _parseDefaultValue(YamlMap node, String keyword) {
    var value =
        node.nodes[keyword]?.value ?? node.nodes[Keyword.defaultKey]?.value;

    /// If the value is a string and is enclosed in double quotes,
    /// convert it to a single-quoted string with proper escaping.
    if (value is String && isValidDoubleQuote(value)) {
      return convertToSingleQuotedString(value);
    }

    return value;
  }

  static bool _parseBooleanKey(YamlMap node, String key) {
    var value = node.nodes[key]?.value;
    var boolValue = _parseBool(value);

    if (boolValue != null) return boolValue;

    var containsKey = node.containsKey(key);
    return containsKey;
  }

  static bool? _parseBool(dynamic value) {
    if (value is bool) return value;

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

  static ModelFieldScopeDefinition _parseClassFieldScope(
    YamlMap documentContents,
    bool serverOnlyClass,
  ) {
    var database = _parseBooleanKey(documentContents, Keyword.database);
    if (database) return ModelFieldScopeDefinition.serverOnly;

    var scope = documentContents.nodes[Keyword.scope]?.value;

    if (scope is String) {
      return convertToEnum(
        value: scope,
        enumDefault: ModelFieldScopeDefinition.all,
        enumValues: ModelFieldScopeDefinition.values,
      );
    }

    if (serverOnlyClass) return ModelFieldScopeDefinition.serverOnly;

    return ModelFieldScopeDefinition.all;
  }

  static String? _parseParentTable(YamlMap documentContents) {
    var parent = documentContents.nodes[Keyword.parent]?.value;
    if (parent is String) return parent;

    parent = _parseRelationNode(documentContents, Keyword.parent)?.value;
    if (parent is String) return parent;

    return null;
  }

  static List<SerializableModelIndexDefinition> _parseIndexes(
    YamlMap documentContents,
    List<SerializableModelFieldDefinition> fields,
  ) {
    var indexesNode = documentContents.nodes[Keyword.indexes];
    if (indexesNode is! YamlMap) return [];

    var indexes = indexesNode.nodes.entries.map((node) {
      var keyScalar = node.key;
      var nodeDocument = node.value;
      if (keyScalar is! YamlScalar) return null;
      if (nodeDocument is! YamlMap) return null;

      var indexName = keyScalar.value;
      if (indexName is! String) return null;

      var indexFields = _parseIndexFields(nodeDocument, fields);
      var indexFieldsTypes = fields.where((f) => indexFields.contains(f.name));
      var type = _parseIndexType(
        nodeDocument,
        onlyVectorFields: indexFieldsTypes.isNotEmpty &&
            indexFieldsTypes.every((f) => f.type.isVectorType),
      );
      var unique = _parseUniqueKey(nodeDocument);
      var distanceFunction =
          _parseDistanceFunction(nodeDocument, type, indexFieldsTypes);
      var parameters = _parseParametersKey(nodeDocument);

      return SerializableModelIndexDefinition(
        name: indexName,
        type: type,
        unique: unique,
        fields: indexFields,
        vectorDistanceFunction: distanceFunction,
        parameters: parameters,
      );
    });

    return indexes
        .where((index) => index != null)
        .cast<SerializableModelIndexDefinition>()
        .toList();
  }

  static List<String> _parseIndexFields(
    YamlMap documentContents,
    List<SerializableModelFieldDefinition> fields,
  ) {
    var fieldsNode = documentContents.nodes[Keyword.fields];
    if (fieldsNode is! YamlNode) return [];

    var stringifiedFields = fieldsNode.value;
    if (stringifiedFields is! String) return [];

    var indexFields = convertIndexList(stringifiedFields);

    return indexFields;
  }

  static String _parseIndexType(
    YamlMap documentContents, {
    required bool onlyVectorFields,
  }) {
    var typeNode = documentContents.nodes[Keyword.type];
    var type = typeNode?.value;

    if (type == null || type is! String) {
      return onlyVectorFields ? 'hnsw' : 'btree';
    }

    return type;
  }

  static bool _parseUniqueKey(YamlMap documentContents) {
    var node = documentContents.nodes[Keyword.unique];
    var nodeValue = node?.value;
    return nodeValue is bool ? nodeValue : false;
  }

  static VectorDistanceFunction? _parseDistanceFunction(
    YamlMap documentContents,
    String indexType,
    Iterable<SerializableModelFieldDefinition> indexFieldsTypes,
  ) {
    var node = documentContents.nodes[Keyword.distanceFunction];
    var nodeValue = node?.value;

    if (nodeValue is! String) {
      return VectorIndexType.values.any((e) => e.name == indexType)
          ? (indexFieldsTypes.any((field) => field.type.className == 'Bit')
              ? VectorDistanceFunction.hamming
              : VectorDistanceFunction.l2)
          : null;
    }

    try {
      return unsafeConvertToEnum(
        value: nodeValue,
        enumValues: VectorDistanceFunction.values,
      );
    } catch (_) {
      return null;
    }
  }

  static Map<String, String>? _parseParametersKey(YamlMap documentContents) {
    var parametersNode = documentContents.nodes[Keyword.parameters];
    if (parametersNode is! YamlMap) return null;

    Map<String, String> parameters = {};
    for (var entry in parametersNode.nodes.entries) {
      if (entry.key is YamlScalar) {
        var key = (entry.key as YamlScalar).value;
        if (key is String) {
          parameters[key] = entry.value.value.toString();
        }
      }
    }

    return parameters.isNotEmpty ? parameters : null;
  }

  static ProtocolEnumValueDefinition? _parseEnumDefaultValue(
    YamlMap documentContents,
    List<ProtocolEnumValueDefinition> values,
  ) {
    final defaultValue =
        _parseDefaultValue(documentContents, Keyword.defaultKey);
    return values.where((value) => value.name == defaultValue).firstOrNull;
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
