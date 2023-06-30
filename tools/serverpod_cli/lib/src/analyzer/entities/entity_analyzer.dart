import 'dart:io';

import 'package:serverpod_cli/src/analyzer/entities/converter/converter.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/validate_node.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/restrictions.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/protocol_validator.dart';
import 'package:source_span/source_span.dart';
// ignore: implementation_imports
import 'package:yaml/src/error_listener.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import '../../util/string_validators.dart';
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
  final String yaml;
  final String sourceFileName;
  final String outFileName;
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
    required this.outFileName,
    this.subDirectoryParts = const [],
    required this.collector,
  });

  /// Analyze all yaml files int the protocol directory.
  static Future<List<SerializableEntityDefinition>> analyzeAllFiles({
    bool verbose = true,
    required CodeAnalysisCollector collector,
    required GeneratorConfig config,
  }) async {
    var classDefinitions = <SerializableEntityDefinition>[];

    // Get list of all files in protocol source directory.
    var sourceDir = Directory(p.joinAll(config.protocolSourcePathParts));
    var sourceFileList = await sourceDir.list(recursive: true).toList();
    sourceFileList.sort((a, b) => a.path.compareTo(b.path));

    var sourceDirPartsLength = p.split(sourceDir.path).length;

    for (var entity in sourceFileList) {
      if (entity is! File || !entity.path.endsWith('.yaml')) {
        if (verbose) print('  - skipping file: ${entity.path}');
        continue;
      }
      var subDirectoryParts =
          p.split(p.dirname(entity.path)).skip(sourceDirPartsLength).toList();

      // Process a file.
      if (verbose) print('  - processing file: ${entity.path}');
      var yaml = await entity.readAsString();
      var analyzer = SerializableEntityAnalyzer(
        yaml: yaml,
        sourceFileName: entity.path,
        outFileName: _transformFileNameWithoutPathOrExtension(entity.path),
        collector: collector,
        subDirectoryParts: subDirectoryParts,
      );
      var classDefinition = analyzer.analyze();
      if (classDefinition != null) {
        classDefinitions.add(classDefinition);
      }
    }

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

  SerializableEntityDefinition? analyze() {
    var yamlErrorCollector = ErrorCollector();

    YamlDocument document;
    try {
      document = loadYamlDocument(
        yaml,
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
    var docsExtractor = YamlDocumentationExtractor(yaml);

    _validateEntityType(documentContents);

    if (documentContents.nodes[Keyword.classType] != null) {
      return _analyzeClassFile(documentContents, docsExtractor);
    }

    if (documentContents.nodes[Keyword.exceptionType] != null) {
      return _analyzeExceptionFile(documentContents, docsExtractor);
    }

    if (documentContents.nodes[Keyword.enumType] != null) {
      return _analyzeEnumFile(documentContents, docsExtractor);
    }

    return null;
  }

  void _validateEntityType(YamlMap documentContents) {
    var typeNodes = _findNodesByKeys(
      documentContents,
      _protocolClassTypes,
    );

    if (typeNodes.length == 1) return;

    if (typeNodes.isEmpty) {
      collector.addError(SourceSpanException(
        'No $_protocolClassTypes type is defined.',
        documentContents.span,
      ));
      return;
    }

    var formattedKeys = _formatNodeKeys(typeNodes);
    var errors = typeNodes
        .skip(1)
        .map(
          (e) => SourceSpanException(
              'Multiple entity types ($formattedKeys) found for a single entity. Only one type per entity allowed.',
              documentContents.key(e.key.toString())?.span),
        )
        .toList();

    collector.addErrors(errors);
  }

  String _formatNodeKeys(Iterable<MapEntry<dynamic, YamlNode>> nodes) {
    return nodes.map((e) => e.key.toString()).fold('', (output, element) {
      if (output.isEmpty) return '"$element"';
      return '$output, "$element"';
    });
  }

  Iterable<MapEntry<dynamic, YamlNode>> _findNodesByKeys(
    YamlMap documentContents,
    Set<String> keys,
  ) {
    return documentContents.nodes.entries.where((element) {
      return keys.contains(element.key.toString());
    });
  }

  SerializableEntityDefinition? _analyzeExceptionFile(
      YamlMap documentContents, YamlDocumentationExtractor docsExtractor) {
    var restrictions = Restrictions(
      documentType: Keyword.exceptionType,
      documentContents: documentContents,
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

  SerializableEntityDefinition? _analyzeClassFile(
    YamlMap documentContents,
    YamlDocumentationExtractor docsExtractor,
  ) {
    var restrictions = Restrictions(
      documentType: Keyword.classType,
      documentContents: documentContents,
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

  SerializableEntityDefinition? _serializeClassFile(
    String documentType,
    YamlMap documentContents,
    YamlDocumentationExtractor docsExtractor,
    ValidateNode fieldStructure,
  ) {
    YamlNode? classNode = documentContents.nodes[documentType];

    if (classNode == null) {
      throw ArgumentError(
          'No $documentType node found, only valid to call this function if the documentType exists as a top level key in the document.');
    }

    var classDocumentation = docsExtractor
        .getDocumentation(documentContents.key(documentType)!.span.start);

    var className = classNode.value;

    var tableName = _parseTableName(documentContents);
    var serverOnly = _parseServerOnly(documentContents);
    var fields = _parseFields(documentContents, docsExtractor, fieldStructure);

    if (tableName != null) {
      fields.insert(
        0,
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
      );
    }

    // Validate that index fields exists in class,
    // Todo: move this to validation when we support multipass validation
    var indexes = _parseIndexes(documentContents, fields);

    return ClassDefinition(
      className: className,
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

  SerializableEntityDefinition? _analyzeEnumFile(
      YamlMap documentContents, YamlDocumentationExtractor docsExtractor) {
    if (!_containsOnlyValidKeys(
      documentContents,
      {'enum', 'serverOnly', 'values'},
    )) {
      return null;
    }

    // Validate class name exists and is correct.
    var classNameNode = documentContents.nodes['enum'];
    if (classNameNode == null) {
      collector.addError(SourceSpanException(
        'No "enum" type is defined.',
        documentContents.span,
      ));
      return null;
    }
    var enumDocumentation = docsExtractor
        .getDocumentation(documentContents.key('enum')!.span.start);

    var className = classNameNode.value;
    if (className is! String) {
      collector.addError(SourceSpanException(
        'The "enum" type must be a String.',
        classNameNode.span,
      ));
      return null;
    }

    if (!StringValidators.isValidClassName(className)) {
      collector.addError(SourceSpanException(
        'The "enum" type must be a valid class name (e.g. PascalCaseString).',
        classNameNode.span,
      ));
      return null;
    }

    bool serverOnly = _parseServerOnly(documentContents);

    // Validate enum values.
    var valuesNode = documentContents.nodes['values'];
    if (valuesNode == null) {
      collector.addError(SourceSpanException(
        'An enum must have a "values" property.',
        documentContents.span,
      ));
      return null;
    }

    if (valuesNode is! YamlList) {
      collector.addError(SourceSpanException(
        'The "values" property must be a List.',
        valuesNode.span,
      ));
      return null;
    }
    var values = <ProtocolEnumValueDefinition>[];
    for (var valueNode in valuesNode.nodes) {
      if (valueNode is! YamlScalar) {
        collector.addError(SourceSpanException(
          'The list value must be of type String.',
          valueNode.span,
        ));
        return null;
      }

      var value = valueNode.value;
      if (value is! String) {
        collector.addError(SourceSpanException(
          'The list value must be of type String.',
          valueNode.span,
        ));
        return null;
      }

      if (!StringValidators.isValidFieldName(value)) {
        collector.addError(SourceSpanException(
          'Enum values must be lowerCamelCase.',
          valueNode.span,
        ));
        return null;
      }
      var start = valueNode.span.start;
      // 2 is the length of '- ' in '- enumValue'
      var valueDocumentation = docsExtractor.getDocumentation(SourceLocation(
          start.offset - 2,
          column: start.column - 2,
          line: start.line,
          sourceUrl: start.sourceUrl));

      values.add(ProtocolEnumValueDefinition(value, valueDocumentation));
    }

    return EnumDefinition(
      fileName: outFileName,
      className: className,
      values: values,
      documentation: enumDocumentation,
      subDirParts: subDirectoryParts,
      serverOnly: serverOnly,
    );
  }

  bool _containsOnlyValidKeys(YamlMap documentMap, Set<String> validKeys) {
    for (var keyNode in documentMap.nodes.keys) {
      if (keyNode is! YamlScalar) {
        collector.addError(SourceSpanException(
          'Key must be of type String.',
          keyNode.span,
        ));
        return false;
      }
      var key = keyNode.value;
      if (key is! String) {
        collector.addError(SourceSpanException(
          'Key must be of type String.',
          keyNode.span,
        ));
        return false;
      }
      if (!validKeys.contains(key)) {
        collector.addError(SourceSpanException(
          'The "$key" property is not allowed for enums. Valid keys are $validKeys.',
          keyNode.span,
        ));
        return false;
      }
    }

    return true;
  }

  bool _parseServerOnly(YamlMap documentContents) {
    var serverOnly = documentContents.nodes[Keyword.serverOnly]?.value;

    if (serverOnly is! bool) {
      return false;
    }

    return serverOnly;
  }

  String? _parseTableName(YamlMap documentContents) {
    var tableName = documentContents.nodes[Keyword.table]?.value;

    if (tableName is! String) return null;

    return tableName;
  }

  List<SerializableEntityFieldDefinition> _parseFields(
    YamlMap documentContents,
    YamlDocumentationExtractor docsExtractor,
    ValidateNode fieldStructure,
  ) {
    var fieldsNode = documentContents.nodes[Keyword.fields];
    if (fieldsNode is! YamlMap) return [];

    var fields = fieldsNode.nodes.entries.map((fieldNode) {
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
        typeValue,
        sourceSpan: typeNode.span,
      );
      var scope = _parseFieldScope(value);
      var parentTable = _parseParentTable(value);
      var isEnum = _parseIsEnumField(value);

      return SerializableEntityFieldDefinition(
        name: fieldName,
        scope: scope,
        type: typeResult.type..isEnum = isEnum,
        parentTable: parentTable,
        documentation: fieldDocumentation,
      );
    });

    return fields
        .where((field) => field != null)
        .cast<SerializableEntityFieldDefinition>()
        .toList();
  }

  SerializableEntityFieldScope _parseFieldScope(YamlMap documentContents) {
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
    var indexesNode = documentContents.nodes['indexes'];
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
    }).toList();

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

    var indexFields =
        stringifiedFields.split(',').map((String str) => str.trim()).toList();

    // Validate that index fields exists in class,
    // Todo: move this to validation when we support multipass validation
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
