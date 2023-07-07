import 'package:serverpod_cli/src/analyzer/entities/converter/converter.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/validate_node.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/restrictions.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/protocol_validator.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:source_span/source_span.dart';
// ignore: implementation_imports
import 'package:yaml/src/error_listener.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import '../../util/extensions.dart';
import '../../util/yaml_docs.dart';
import '../code_analysis_collector.dart';
import '../../config/config.dart';
import '../../generator/types.dart';
import 'definitions.dart';

String _transformFileNameWithoutPathOrExtension(String path) {
  return p.basenameWithoutExtension(path);
}

/// Used to analyze a singe yaml protocol file.
class SerializableEntityAnalyzer {
  String yaml;
  final String sourceFileName;
  late final String outFileName;
  final List<String> subDirectoryParts;
  final CodeAnalysisCollector collector;
  static const Set<String> _protocolClassTypes = {
    Keyword.classType,
    Keyword.exceptionType,
    Keyword.enumType,
  };

  /// Create a new [SerializableEntityAnalyzer].
  SerializableEntityAnalyzer({
    required this.yaml,
    required this.sourceFileName,
    this.subDirectoryParts = const [],
    required this.collector,
  }) {
    outFileName = _transformFileNameWithoutPathOrExtension(sourceFileName);
  }

  /// Analyze all yaml files int the protocol directory.
  static Future<List<SerializableEntityDefinition>> analyzeAllFiles({
    bool verbose = true,
    required CodeAnalysisCollector collector,
    required GeneratorConfig config,
  }) async {
    var classDefinitions = <SerializableEntityDefinition>[];

    var protocols =
        await ProtocolHelper.loadProjectYamlProtocolsFromDisk(config);

    var validators = protocols.map((protocol) {
      return SerializableEntityAnalyzer(
        yaml: protocol.yaml,
        sourceFileName: protocol.uri.path,
        subDirectoryParts: protocol.protocolRootPathParts,
        collector: collector,
      );
    });

    for (var validator in validators) {
      var classDefinition = validator.analyze();
      if (classDefinition != null) {
        classDefinitions.add(classDefinition);
      }
    }

    var classes = classDefinitions.map((definition) {
      var analyzer = SerializableEntityAnalyzer(
        yaml: definition.yamlProtocol,
        sourceFileName: definition.sourceFileName,
        collector: collector,
        subDirectoryParts: definition.subDirParts,
      );
      return analyzer.analyze(protocolEntities: classDefinitions);
    });

    classDefinitions = classes
        .where((definition) => definition != null)
        .cast<SerializableEntityDefinition>()
        .toList();

    // Detect protocol references
    for (var classDefinition in classDefinitions) {
      if (classDefinition is ClassDefinition) {
        for (var fieldDefinition in classDefinition.fields) {
          fieldDefinition.type =
              fieldDefinition.type.applyProtocolReferences(classDefinitions);
        }
      }
    }

    // Detect enum fields
    for (var classDefinition in classDefinitions) {
      if (classDefinition is ClassDefinition) {
        for (var fieldDefinition in classDefinition.fields) {
          if (fieldDefinition.type.url == 'protocol' &&
              classDefinitions
                  .whereType<EnumDefinition>()
                  .any((e) => e.className == fieldDefinition.type.className)) {
            fieldDefinition.type.isEnum = true;
          }
        }
      }
    }

    return classDefinitions;
  }

  SerializableEntityDefinition? analyze({
    String? yaml,
    List<SerializableEntityDefinition>? protocolEntities,
  }) {
    var yamlErrorCollector = ErrorCollector();
    this.yaml = yaml ?? this.yaml;

    YamlDocument document;
    try {
      document = loadYamlDocument(
        this.yaml,
        sourceUrl: Uri.file(sourceFileName),
        errorListener: yamlErrorCollector,
        recover: true,
      );
    } catch (e) {
      if (e is SourceSpanException) {
        collector.addError(e);
        return null;
      }
      rethrow;
    }

    collector.addErrors(yamlErrorCollector.errors);

    if (yamlErrorCollector.errors.isNotEmpty) {
      return null;
    }

    var documentContents = document.contents;

    // Validate document is a map.
    if (documentContents is! YamlMap) {
      collector.addError(SourceSpanException(
        'The top level object in the class yaml file must be a Map.',
        documentContents.span,
      ));
      return null;
    }

    validateTopLevelEntityType(
      documentContents,
      _protocolClassTypes,
      collector,
    );

    var docsExtractor = YamlDocumentationExtractor(this.yaml);

    if (documentContents.nodes[Keyword.classType] != null) {
      return _analyzeClassFile(
        documentContents,
        docsExtractor,
        protocolEntities,
      );
    }

    if (documentContents.nodes[Keyword.exceptionType] != null) {
      return _analyzeExceptionFile(
        documentContents,
        docsExtractor,
        protocolEntities,
      );
    }

    if (documentContents.nodes[Keyword.enumType] != null) {
      return _analyzeEnumFile(
        documentContents,
        docsExtractor,
        protocolEntities,
      );
    }

    return null;
  }

  SerializableEntityDefinition? _analyzeClassFile(
    YamlMap documentContents,
    YamlDocumentationExtractor docsExtractor,
    List<SerializableEntityDefinition>? protocolEntities,
  ) {
    var restrictions = Restrictions(
      documentType: Keyword.classType,
      documentContents: documentContents,
      protocolEntities: protocolEntities,
    );

    var fieldStructure = ValidateNode(
      Keyword.any,
      keyRestriction: restrictions.validateFieldName,
      allowStringifiedNestedValue: true,
      nested: {
        ValidateNode(
          Keyword.type,
          isRequired: true,
          valueRestriction: restrictions.validateFieldType,
        ),
        ValidateNode(
          Keyword.parent,
          valueRestriction: restrictions.validateParentName,
        ),
        ValidateNode(
          Keyword.database,
          mutuallyExclusiveKeys: {Keyword.api},
        ),
        ValidateNode(
          Keyword.api,
          mutuallyExclusiveKeys: {Keyword.database},
        ),
      },
    );

    Set<ValidateNode> documentStructure = {
      ValidateNode(
        Keyword.classType,
        isRequired: true,
        valueRestriction: restrictions.validateClassName,
      ),
      ValidateNode(
        Keyword.table,
        valueRestriction: restrictions.validateTableName,
      ),
      ValidateNode(
        Keyword.serverOnly,
        valueRestriction: restrictions.validateBoolType,
      ),
      ValidateNode(
        Keyword.fields,
        isRequired: true,
        nested: {
          fieldStructure,
        },
      ),
      ValidateNode(
        Keyword.indexes,
        nested: {
          ValidateNode(
            Keyword.any,
            keyRestriction: restrictions.validateTableIndexName,
            nested: {
              ValidateNode(
                Keyword.fields,
                isRequired: true,
                valueRestriction: restrictions.validateIndexFieldsValue,
              ),
              ValidateNode(
                Keyword.type,
                valueRestriction: restrictions.validateIndexType,
              ),
              ValidateNode(
                Keyword.unique,
                valueRestriction: restrictions.validateBoolType,
              ),
            },
          )
        },
      ),
    };

    validateYamlProtocol(
      Keyword.classType,
      documentStructure,
      documentContents,
      collector,
    );

    return _serializeClassFile(
      Keyword.classType,
      documentContents,
      docsExtractor,
      fieldStructure,
    );
  }

  SerializableEntityDefinition? _analyzeExceptionFile(
    YamlMap documentContents,
    YamlDocumentationExtractor docsExtractor,
    List<SerializableEntityDefinition>? protocolEntities,
  ) {
    var restrictions = Restrictions(
      documentType: Keyword.exceptionType,
      documentContents: documentContents,
      protocolEntities: protocolEntities,
    );

    var fieldStructure = ValidateNode(
      Keyword.any,
      keyRestriction: restrictions.validateFieldName,
      allowStringifiedNestedValue: true,
      nested: {
        ValidateNode(
          Keyword.type,
          isRequired: true,
          valueRestriction: restrictions.validateFieldDataType,
        ),
      },
    );

    Set<ValidateNode> documentStructure = {
      ValidateNode(
        Keyword.exceptionType,
        isRequired: true,
        valueRestriction: restrictions.validateClassName,
      ),
      ValidateNode(
        Keyword.serverOnly,
        valueRestriction: restrictions.validateBoolType,
      ),
      ValidateNode(
        Keyword.fields,
        isRequired: true,
        nested: {
          fieldStructure,
        },
      ),
    };

    validateYamlProtocol(
      Keyword.exceptionType,
      documentStructure,
      documentContents,
      collector,
    );

    return _serializeClassFile(
      Keyword.exceptionType,
      documentContents,
      docsExtractor,
      fieldStructure,
    );
  }

  SerializableEntityDefinition? _analyzeEnumFile(
    YamlMap documentContents,
    YamlDocumentationExtractor docsExtractor,
    List<SerializableEntityDefinition>? protocolEntities,
  ) {
    var restrictions = Restrictions(
      documentType: Keyword.enumType,
      documentContents: documentContents,
      protocolEntities: protocolEntities,
    );

    Set<ValidateNode> documentStructure = {
      ValidateNode(
        Keyword.enumType,
        isRequired: true,
        valueRestriction: restrictions.validateClassName,
      ),
      ValidateNode(
        Keyword.serverOnly,
        valueRestriction: restrictions.validateBoolType,
      ),
      ValidateNode(
        Keyword.values,
        isRequired: true,
        valueRestriction: restrictions.validateEnumValues,
      ),
    };

    validateYamlProtocol(
      Keyword.enumType,
      documentStructure,
      documentContents,
      collector,
    );

    var className = documentContents[Keyword.enumType];
    if (className is! String) return null;

    var enumDocumentation = docsExtractor.getDocumentation(
      documentContents.key(Keyword.enumType)!.span.start,
    );

    var serverOnly = _parseServerOnly(documentContents);
    var values = _parseEnumValues(documentContents, docsExtractor);

    return EnumDefinition(
      yamlProtocol: yaml,
      fileName: outFileName,
      sourceFileName: sourceFileName,
      className: className,
      values: values,
      documentation: enumDocumentation,
      subDirParts: subDirectoryParts,
      serverOnly: serverOnly,
    );
  }

  SerializableEntityDefinition? _serializeClassFile(
    String documentType,
    YamlMap documentContents,
    YamlDocumentationExtractor docsExtractor,
    ValidateNode fieldStructure,
  ) {
    YamlNode? classNode = documentContents.nodes[documentType];

    if (classNode == null) {
      throw ArgumentError(
        'No $documentType node found, only valid to call this function if '
        ' the documentType exists as a top level key in the document.',
      );
    }

    var classDocumentation = docsExtractor.getDocumentation(
      documentContents.key(documentType)!.span.start,
    );

    var className = classNode.value;
    if (className is! String) return null;

    var tableName = _parseTableName(documentContents);
    var serverOnly = _parseServerOnly(documentContents);
    var fields = _parseClassFields(
      documentContents,
      docsExtractor,
      tableName != null,
      fieldStructure,
    );
    var indexes = _parseIndexes(documentContents, fields);

    return ClassDefinition(
      yamlProtocol: yaml,
      className: className,
      sourceFileName: sourceFileName,
      tableName: tableName,
      fileName: outFileName,
      fields: fields,
      indexes: indexes,
      subDirParts: subDirectoryParts,
      documentation: classDocumentation,
      isException: documentType == Keyword.exceptionType,
      serverOnly: serverOnly,
    );
  }

  bool _parseServerOnly(YamlMap documentContents) {
    var serverOnly = documentContents.nodes[Keyword.serverOnly]?.value;
    if (serverOnly is! bool) return false;

    return serverOnly;
  }

  String? _parseTableName(YamlMap documentContents) {
    var tableName = documentContents.nodes[Keyword.table]?.value;
    if (tableName is! String) return null;

    return tableName;
  }

  List<SerializableEntityFieldDefinition> _parseClassFields(
    YamlMap documentContents,
    YamlDocumentationExtractor docsExtractor,
    bool hasTable,
    ValidateNode fieldStructure,
  ) {
    var fieldsNode = documentContents.nodes[Keyword.fields];
    if (fieldsNode is! YamlMap) return [];

    var parsedFields = fieldsNode.nodes.entries.map((fieldNode) {
      return _parseEntityFieldDefinition(
        fieldNode,
        fieldStructure,
        docsExtractor,
      );
    });

    var fields = parsedFields
        .where((field) => field != null)
        .cast<SerializableEntityFieldDefinition>()
        .toList();

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

  SerializableEntityFieldDefinition? _parseEntityFieldDefinition(
    MapEntry<dynamic, YamlNode> fieldNode,
    ValidateNode fieldStructure,
    YamlDocumentationExtractor docsExtractor,
  ) {
    var key = fieldNode.key;
    if (key is! YamlScalar) return null;

    var nodeValue = fieldNode.value;
    var value = nodeValue.value;
    if (value is String) {
      value = convertStringifiedNestedNodesToYamlMap(
        value,
        nodeValue,
        fieldStructure,
      );
    }
    if (value is! YamlMap) return null;

    var fieldName = key.value;
    if (fieldName is! String) return null;

    var typeNode = value.nodes[Keyword.type];
    var typeValue = typeNode?.value;
    if (typeNode is! YamlScalar) return null;
    if (typeValue is! String) return null;

    var fieldDocumentation = docsExtractor.getDocumentation(key.span.start);
    var typeResult = parseAndAnalyzeType(
      typeValue.replaceAll(' ', ''),
      sourceSpan: typeNode.span,
    );
    var scope = _parseClassFieldscope(value);
    var parentTable = _parseParentTable(value);
    var isEnum = _parseIsEnumField(value);

    return SerializableEntityFieldDefinition(
      name: fieldName,
      scope: scope,
      type: typeResult.type..isEnum = isEnum,
      parentTable: parentTable,
      documentation: fieldDocumentation,
    );
  }

  SerializableEntityFieldScope _parseClassFieldscope(YamlMap documentContents) {
    var database = documentContents.containsKey(Keyword.database);
    var api = documentContents.containsKey(Keyword.api);

    if (database) return SerializableEntityFieldScope.database;
    if (api) return SerializableEntityFieldScope.api;

    return SerializableEntityFieldScope.all;
  }

  String? _parseParentTable(YamlMap documentContents) {
    var parent = documentContents.nodes[Keyword.parent]?.value;
    if (parent is! String) return null;

    return parent;
  }

  bool _parseIsEnumField(YamlMap documentContents) {
    return documentContents.containsKey(Keyword.enumType);
  }

  List<SerializableEntityIndexDefinition>? _parseIndexes(
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

  List<String> _parseIndexFields(
    YamlMap documentContents,
    List<SerializableEntityFieldDefinition> fields,
  ) {
    var fieldsNode = documentContents.nodes[Keyword.fields];
    if (fieldsNode is! YamlNode) return [];

    var stringifiedFields = fieldsNode.value;
    if (stringifiedFields is! String) return [];

    var indexFields = stringifiedFields
        .split(',')
        .map(
          (String str) => str.trim(),
        )
        .toList();

    // Validate that index fields exists in class,
    // Todo: move this to validation file when we support multipass parsing.
    _validateIndexFileds(fields, indexFields, fieldsNode.span);

    return indexFields;
  }

  String _parseIndexType(YamlMap documentContents) {
    var typeNode = documentContents.nodes[Keyword.type];
    var type = typeNode?.value;

    if (type == null || type is! String) {
      return 'btree';
    }

    return type;
  }

  bool _parseUniqueKey(YamlMap documentContents) {
    var node = documentContents.nodes[Keyword.unique];
    var nodeValue = node?.value;
    return nodeValue is bool ? nodeValue : false;
  }

  List<ProtocolEnumValueDefinition> _parseEnumValues(
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

  void _validateIndexFileds(
    List<SerializableEntityFieldDefinition> fields,
    List<String> indexFields,
    SourceSpan span,
  ) {
    var validDatabaseFieldNames = fields
        .where((field) => field.scope != SerializableEntityFieldScope.api)
        .fold(<String>{}, (output, field) => output..add(field.name));

    for (var indexField in indexFields) {
      if (!validDatabaseFieldNames.contains(indexField)) {
        collector.addError(SourceSpanException(
          'The field name "$indexField" is not added to the class or has an api scope.',
          span,
        ));
      }
    }
  }
}
