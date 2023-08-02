import 'package:serverpod_cli/src/analyzer/entities/validation/entity_relations.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/validate_node.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/protocol_validator.dart';
import 'package:serverpod_cli/src/analyzer/entities/yaml_definitions/class_yaml_definition.dart';
import 'package:serverpod_cli/src/analyzer/entities/yaml_definitions/enum_yaml_definition.dart';
import 'package:serverpod_cli/src/analyzer/entities/yaml_definitions/exception_yaml_definition.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
// ignore: implementation_imports
import 'package:yaml/src/error_listener.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import 'package:serverpod_cli/src/util/yaml_docs.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_parser/entity_parser.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/restrictions.dart';

String _transformFileNameWithoutPathOrExtension(String path) {
  return p.basenameWithoutExtension(path);
}

class _ProtocolClassDefinitionSource {
  final ProtocolSource protocolSource;
  final SerializableEntityDefinition entityDefinition;

  _ProtocolClassDefinitionSource({
    required this.protocolSource,
    required this.entityDefinition,
  });
}

/// Used to analyze a singe yaml protocol file.
class SerializableEntityAnalyzer {
  static const Set<String> _protocolClassTypes = {
    Keyword.classType,
    Keyword.exceptionType,
    Keyword.enumType,
  };

  /// Analyze all yaml files in the protocol directory.
  static Future<List<SerializableEntityDefinition>> analyzeAllFiles({
    required CodeAnalysisCollector collector,
    required GeneratorConfig config,
  }) async {
    var protocols =
        await ProtocolHelper.loadProjectYamlProtocolsFromDisk(config);

    var entityProtocolDefinitions = _createEntityProtocolDefinitions(
      protocols,
    );

    var entityDefinitions = entityProtocolDefinitions
        .map((definition) => definition.entityDefinition)
        .toList();

    resolveEntityDependencies(entityDefinitions);

    for (var definition in entityProtocolDefinitions) {
      SerializableEntityAnalyzer.validateYamlDefinition(
        definition.protocolSource.yaml,
        definition.entityDefinition.sourceFileName,
        collector,
        definition.entityDefinition,
        entityDefinitions,
      );
    }

    return entityDefinitions;
  }

  /// Best effort attempt to extract an entity definition from a yaml file.
  static SerializableEntityDefinition? extractEntityDefinition(
    ProtocolSource protocolSource,
  ) {
    var outFileName = _transformFileNameWithoutPathOrExtension(
      protocolSource.yamlSourceUri.path,
    );
    var yamlErrorCollector = ErrorCollector();
    YamlMap? documentContents = _loadYamlMap(
      protocolSource.yaml,
      protocolSource.yamlSourceUri.path,
      yamlErrorCollector,
    );

    if (yamlErrorCollector.errors.isNotEmpty) return null;
    if (documentContents == null) return null;

    var definitionType = _findDefinitionType(documentContents);
    var docsExtractor = YamlDocumentationExtractor(protocolSource.yaml);

    if (definitionType == null) return null;

    switch (definitionType) {
      case Keyword.classType:
        return EntityParser.serializeClassFile(
          Keyword.classType,
          protocolSource,
          outFileName,
          documentContents,
          docsExtractor,
        );
      case Keyword.exceptionType:
        return EntityParser.serializeClassFile(
          Keyword.exceptionType,
          protocolSource,
          outFileName,
          documentContents,
          docsExtractor,
        );
      case Keyword.enumType:
        return EntityParser.serializeEnumFile(
          protocolSource,
          outFileName,
          documentContents,
          docsExtractor,
        );
      default:
        return null;
    }
  }

  /// Resolves dependencies between entities, this method mutates the input.
  static void resolveEntityDependencies(
    List<SerializableEntityDefinition> entityDefinitions,
  ) {
    entityDefinitions.whereType<ClassDefinition>().forEach((classDefinition) {
      for (var fieldDefinition in classDefinition.fields) {
        _resolveProtocolReference(fieldDefinition, entityDefinitions);
        _resolveEnumType(fieldDefinition, entityDefinitions);
        _resolveScalarParentTableReference(
          classDefinition,
          fieldDefinition,
          entityDefinitions,
        );
        _resolveRelationReferences(
          classDefinition,
          fieldDefinition,
          entityDefinitions,
        );
      }
    });
  }

  /// Validates a yaml file against an expected syntax for protocol files.
  static void validateYamlDefinition(
    String yaml,
    String sourceFileName,
    CodeAnalysisCollector collector,
    SerializableEntityDefinition? entity,
    List<SerializableEntityDefinition>? entities,
  ) {
    var yamlErrors = ErrorCollector();
    YamlMap? document = _loadYamlMap(yaml, sourceFileName, yamlErrors);
    collector.addErrors(yamlErrors.errors);

    if (yamlErrors.errors.isNotEmpty) return;

    var documentContents = document;
    if (documentContents is! YamlMap) {
      collector.addError(SourceSpanSeverityException(
        'The top level object in the class yaml file must be a Map.',
        documentContents?.span,
      ));
      return;
    }

    var topErrors = validateTopLevelEntityType(
      documentContents,
      _protocolClassTypes,
    );
    collector.addErrors(topErrors);

    var definitionType = _findDefinitionType(documentContents);
    if (definitionType == null) return;

    var restrictions = Restrictions(
      documentType: definitionType,
      documentContents: documentContents,
      documentDefinition: entity,
      // TODO: move instance creation of EntityRelations to StatefulAnalyzer
      // to resolve n-squared time complexity.
      entityRelations: entities != null ? EntityRelations(entities) : null,
    );

    Set<ValidateNode> documentStructure;
    switch (definitionType) {
      case Keyword.classType:
        documentStructure = ClassYamlDefinition(restrictions).documentStructure;
        break;
      case Keyword.exceptionType:
        documentStructure = ExceptionYamlDefinition(
          restrictions,
        ).documentStructure;
        break;
      case Keyword.enumType:
        documentStructure = EnumYamlDefinition(restrictions).documentStructure;
        break;
      default:
        throw UnimplementedError(
            'Validation for $definitionType is not implemented.');
    }

    validateYamlProtocol(
      definitionType,
      documentStructure,
      documentContents,
      collector,
    );

    return;
  }

  static YamlMap? _loadYamlMap(
    String yaml,
    String sourceFileName, [
    ErrorCollector? collector,
  ]) {
    YamlDocument document = loadYamlDocument(
      yaml,
      sourceUrl: Uri.file(sourceFileName),
      errorListener: collector,
      recover: true,
    );

    var documentContents = document.contents;
    if (documentContents is! YamlMap) return null;
    return documentContents;
  }

  static String? _findDefinitionType(YamlMap documentContents) {
    if (documentContents.nodes[Keyword.classType] != null) {
      return Keyword.classType;
    }

    if (documentContents.nodes[Keyword.exceptionType] != null) {
      return Keyword.exceptionType;
    }

    if (documentContents.nodes[Keyword.enumType] != null) {
      return Keyword.enumType;
    }

    return null;
  }

  static List<_ProtocolClassDefinitionSource> _createEntityProtocolDefinitions(
      List<ProtocolSource> protocols) {
    return protocols
        .map((protocol) {
          var entity = SerializableEntityAnalyzer.extractEntityDefinition(
            protocol,
          );

          if (entity == null) return null;

          return _ProtocolClassDefinitionSource(
            protocolSource: protocol,
            entityDefinition: entity,
          );
        })
        .whereType<_ProtocolClassDefinitionSource>()
        .toList();
  }

  static TypeDefinition _resolveProtocolReference(
      SerializableEntityFieldDefinition fieldDefinition,
      List<SerializableEntityDefinition> entityDefinitions) {
    return fieldDefinition.type =
        fieldDefinition.type.applyProtocolReferences(entityDefinitions);
  }

  static void _resolveEnumType(
      SerializableEntityFieldDefinition fieldDefinition,
      List<SerializableEntityDefinition> entityDefinitions) {
    if (_isEnumField(fieldDefinition, entityDefinitions)) {
      fieldDefinition.type.isEnum = true;
    }
  }

  static bool _isEnumField(SerializableEntityFieldDefinition fieldDefinition,
      List<SerializableEntityDefinition> entityDefinitions) {
    return fieldDefinition.type.url == 'protocol' &&
        entityDefinitions
            .whereType<EnumDefinition>()
            .any((e) => e.className == fieldDefinition.type.className);
  }

  static void _resolveScalarParentTableReference(
    ClassDefinition classDefinition,
    SerializableEntityFieldDefinition fieldDefinition,
    List<SerializableEntityDefinition> entityDefinitions,
  ) {
    if (fieldDefinition.scalarFieldName == null) return;

    var referenceClass = entityDefinitions
        .cast<SerializableEntityDefinition?>()
        .firstWhere(
            (entity) => entity?.className == fieldDefinition.type.className,
            orElse: () => null);

    if (referenceClass == null) return;
    if (referenceClass is! ClassDefinition) return;

    var scalarField = classDefinition.findField(
      fieldDefinition.scalarFieldName!,
    );

    scalarField?.parentTable = referenceClass.tableName;
  }

  static void _resolveRelationReferences(
    ClassDefinition classDefinition,
    SerializableEntityFieldDefinition fieldDefinition,
    List<SerializableEntityDefinition> entityDefinitions,
  ) {
    var type = fieldDefinition.type;
    if (!type.isList || type.generics.isEmpty) return;

    var referenceClassName = type.generics.first.className;

    var referenceClass =
        entityDefinitions.cast<SerializableEntityDefinition?>().firstWhere(
              (entity) => entity?.className == referenceClassName,
              orElse: () => null,
            );

    if (referenceClass is! ClassDefinition) return;

    var referenceFields = referenceClass.fields.where((field) {
      return field.parentTable == classDefinition.tableName;
    });

    if (referenceFields.isEmpty) return;

    // TODO: Handle multiple references.
    fieldDefinition.referenceFieldName = referenceFields.first.name;
  }
}
