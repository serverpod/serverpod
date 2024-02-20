import 'package:serverpod_cli/src/analyzer/models/entity_dependency_resolver.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/model_relations.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/validate_node.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/model_validator.dart';
import 'package:serverpod_cli/src/analyzer/models/yaml_definitions/class_yaml_definition.dart';
import 'package:serverpod_cli/src/analyzer/models/yaml_definitions/enum_yaml_definition.dart';
import 'package:serverpod_cli/src/analyzer/models/yaml_definitions/exception_yaml_definition.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:source_span/source_span.dart';
// ignore: implementation_imports
import 'package:yaml/src/error_listener.dart';
import 'package:yaml/yaml.dart';
import 'package:serverpod_cli/src/util/yaml_docs.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/model_parser/model_parser.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions.dart';

String _transformFileNameWithoutPathOrExtension(Uri path) {
  var fileName = path.pathSegments.last;

  for (var ext in modelFileExtensions) {
    fileName = fileName.replaceAll(ext, '');
  }
  return fileName;
}

/// Used to analyze a singe yaml model file.
class SerializableModelAnalyzer {
  static const Set<String> _modelClassTypes = {
    Keyword.classType,
    Keyword.exceptionType,
    Keyword.enumType,
  };

  /// Best effort attempt to extract an model definition from a yaml file.
  static SerializableModelDefinition? extractModelDefinition(
    ModelSource modelSource,
    List<TypeDefinition> extraClasses,
  ) {
    var outFileName = _transformFileNameWithoutPathOrExtension(
      modelSource.yamlSourceUri,
    );
    var yamlErrorCollector = ErrorCollector();
    YamlMap? documentContents = _loadYamlMap(
      modelSource.yaml,
      modelSource.yamlSourceUri,
      yamlErrorCollector,
    );

    if (yamlErrorCollector.errors.isNotEmpty) return null;
    if (documentContents == null) return null;

    var definitionType = _findDefinitionType(documentContents);
    var docsExtractor = YamlDocumentationExtractor(modelSource.yaml);

    if (definitionType == null) return null;

    switch (definitionType) {
      case Keyword.classType:
        return ModelParser.serializeClassFile(
          Keyword.classType,
          modelSource,
          outFileName,
          documentContents,
          docsExtractor,
          extraClasses,
        );
      case Keyword.exceptionType:
        return ModelParser.serializeClassFile(
          Keyword.exceptionType,
          modelSource,
          outFileName,
          documentContents,
          docsExtractor,
          extraClasses,
        );
      case Keyword.enumType:
        return ModelParser.serializeEnumFile(
          modelSource,
          outFileName,
          documentContents,
          docsExtractor,
        );
      default:
        return null;
    }
  }

  /// Resolves dependencies between models, this method mutates the input.
  static void resolveModelDependencies(
    List<SerializableModelDefinition> modelDefinitions,
  ) {
    return ModelDependencyResolver.resolveModelDependencies(
      modelDefinitions,
    );
  }

  /// Validates a yaml file against an expected syntax for model files.
  static void validateYamlDefinition(
    GeneratorConfig config,
    String yaml,
    Uri sourceUri,
    CodeAnalysisCollector collector,
    SerializableModelDefinition? model,
    List<SerializableModelDefinition>? models,
  ) {
    var yamlErrors = ErrorCollector();
    YamlMap? document = _loadYamlMap(yaml, sourceUri, yamlErrors);
    collector.addErrors(yamlErrors.errors);

    if (yamlErrors.errors.isNotEmpty) return;

    var documentContents = document;
    if (documentContents is! YamlMap) {
      var firstLine = yaml.split('\n').first;
      collector.addError(
        SourceSpanSeverityException(
            'The top level object in the class yaml file must be a Map.',
            SourceSpan(
              SourceLocation(0, sourceUrl: sourceUri),
              SourceLocation(firstLine.length, sourceUrl: sourceUri),
              firstLine,
            )),
      );
      return;
    }

    var topErrors = validateTopLevelModelType(
      documentContents,
      _modelClassTypes,
    );
    collector.addErrors(topErrors);

    var definitionType = _findDefinitionType(documentContents);
    if (definitionType == null) return;

    var restrictions = Restrictions(
      config: config,
      documentType: definitionType,
      documentContents: documentContents,
      documentDefinition: model,
      // TODO: move instance creation of EntityRelations to StatefulAnalyzer
      // to resolve n-squared time complexity.
      modelRelations: models != null ? ModelRelations(models) : null,
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

    validateYamlModel(
      definitionType,
      documentStructure,
      documentContents,
      collector,
    );

    return;
  }

  static YamlMap? _loadYamlMap(
    String yaml,
    Uri sourceUri, [
    ErrorCollector? collector,
  ]) {
    YamlDocument document;
    try {
      document = loadYamlDocument(
        yaml,
        sourceUrl: sourceUri,
        errorListener: collector,
        recover: true,
      );
    } on YamlException catch (error) {
      collector?.errors.add(error);
      return null;
    }

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
