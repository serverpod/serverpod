import 'package:serverpod_cli/src/analyzer/entities/validation/validate_node.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/protocol_validator.dart';
import 'package:serverpod_cli/src/analyzer/entities/yaml_definitions/class_yaml_definition.dart';
import 'package:serverpod_cli/src/analyzer/entities/yaml_definitions/enum_yaml_definition.dart';
import 'package:serverpod_cli/src/analyzer/entities/yaml_definitions/exception_yaml_definition.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:source_span/source_span.dart';
// ignore: implementation_imports
import 'package:yaml/src/error_listener.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import '../../util/yaml_docs.dart';
import '../code_analysis_collector.dart';
import '../../config/config.dart';
import 'definitions.dart';
import 'entity_parser/enetity_parser.dart';
import 'validation/restrictions.dart';

String _transformFileNameWithoutPathOrExtension(String path) {
  return p.basenameWithoutExtension(path);
}

/// Used to analyze a singe yaml protocol file.
class SerializableEntityAnalyzer {

  static const Set<String> _protocolClassTypes = {
    Keyword.classType,
    Keyword.exceptionType,
    Keyword.enumType,
  };

  /// Analyze all yaml files int the protocol directory.
  static Future<List<SerializableEntityDefinition>> analyzeAllFiles({
    bool verbose = true,
    required CodeAnalysisCollector collector,
    required GeneratorConfig config,
  }) async {
    var protocols =
        await ProtocolHelper.loadProjectYamlProtocolsFromDisk(config);

    var classDefinitions = protocols
        .map((protocol) {
          return SerializableEntityAnalyzer.extractEntityDefinition(protocol);
        })
        .where((definition) => definition != null)
        .cast<SerializableEntityDefinition>()
        .toList();

    for (var classDefinition in classDefinitions) {
      SerializableEntityAnalyzer.validateYamlDefinition(
        classDefinition.yamlProtocol,
        classDefinition.sourceFileName,
        collector,
        classDefinition,
        classDefinitions,
      );
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

    var restrictions = Restrictions(
      documentType: definitionType,
      documentContents: documentContents,
    );

    switch (definitionType) {
      case Keyword.classType:
        var yamlStructure = ClassYamlDefinition(restrictions);
        return EntityParser.serializeClassFile(
          Keyword.classType,
          protocolSource,
          outFileName,
          documentContents,
          docsExtractor,
          yamlStructure.fieldStructure,
        );
      case Keyword.exceptionType:
        var yamlStructure = ExceptionYamlDefinition(restrictions);
        return EntityParser.serializeClassFile(
          Keyword.exceptionType,
          protocolSource,
          outFileName,
          documentContents,
          docsExtractor,
          yamlStructure.fieldStructure,
        );
      case Keyword.enumType:
        return EntityParser.serializeEnumFile(
          Keyword.enumType,
          protocolSource,
          outFileName,
          documentContents,
          docsExtractor,
        );
      default:
        return null;
    }
  }

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
      collector.addError(SourceSpanException(
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
      protocolEntities: entities,
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
}
