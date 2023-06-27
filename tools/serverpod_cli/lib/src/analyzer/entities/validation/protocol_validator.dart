import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/keywords.dart';
import 'package:yaml/yaml.dart';

import 'validate_node.dart';

class ProtocolValidator {
  static void validate(
    String documentType,
    Set<ValidateNode> documentStructure,
    YamlMap documentContents,
    CodeAnalysisCollector collector,
  ) {
    wrapper(
      documentType,
      documentStructure,
      documentContents,
      collector,
    );

    _collectInvalidKeyErrors(
      documentType,
      documentContents,
      documentStructure.map((e) => e.key).toSet(),
      collector,
    );

    _collectMissingRequiredKeyErrors(
      documentStructure,
      documentContents,
      collector,
    );

    _collectRequiredChildrenErrors(
      documentStructure,
      documentContents,
      collector,
    );

    _collectValueValidationErrors(
      documentStructure,
      documentContents,
      collector,
    );
  }

  static void wrapper(
    String documentType,
    Set<ValidateNode> documentStructure,
    YamlMap documentMap,
    CodeAnalysisCollector collector,
  ) {
    var validKeys = documentStructure.map((e) => e.key).toSet();
    _collectInvalidKeyErrors(
      documentType,
      documentMap,
      validKeys,
      collector,
    );

    for (var validateKey in documentStructure) {
      if (validateKey.nested.isNotEmpty &&
          documentMap.containsKey(validateKey.key) &&
          documentMap[validateKey.key] is YamlMap) {
        wrapper(
          validateKey.key,
          validateKey.nested,
          documentMap[validateKey.key],
          collector,
        );
      }
    }
  }

  static void _collectInvalidKeyErrors(
    String documentType,
    YamlMap documentMap,
    Set<String> validKeys,
    CodeAnalysisCollector collector,
  ) {
    for (var keyNode in documentMap.nodes.keys) {
      if (keyNode is! YamlScalar) {
        collector.addError(SourceSpanException(
          'Key must be of type String.',
          keyNode.span,
        ));
      }

      var key = keyNode.value;
      if (key is! String) {
        collector.addError(SourceSpanException(
          'Key must be of type String.',
          keyNode.span,
        ));
      }

      if (!(validKeys.contains(Keyword.any) || validKeys.contains(key))) {
        collector.addError(SourceSpanException(
          'The "$key" property is not allowed for $documentType type. Valid keys are $validKeys.',
          keyNode.span,
        ));
      }
    }
  }

  static void _collectMissingRequiredKeyErrors(
    Set<ValidateNode> documentStructure,
    YamlMap documentContents,
    CodeAnalysisCollector collector,
  ) {
    for (var validateKey in documentStructure) {
      if (validateKey.isRequired &&
          !documentContents.containsKey(validateKey.key)) {
        collector.addError(SourceSpanException(
          'No "${validateKey.key}" property is defined.',
          documentContents.nodes[validateKey.key]?.span,
        ));
      }
    }
  }

  static void _collectRequiredChildrenErrors(
    Set<ValidateNode> documentStructure,
    YamlMap documentContents,
    CodeAnalysisCollector collector,
  ) {
    for (var validateKey in documentStructure) {
      var content = documentContents[validateKey.key];
      var span = documentContents.nodes[validateKey.key]?.span;

      if (documentContents.containsKey(validateKey.key) &&
          validateKey.nested.isNotEmpty &&
          content is! YamlMap) {
        collector.addError(SourceSpanException(
          'The "${validateKey.key}" property must have at least one value.',
          span,
        ));
      }
    }
  }

  static void _collectValueValidationErrors(
    Set<ValidateNode> documentStructure,
    YamlMap documentContents,
    CodeAnalysisCollector collector,
  ) {
    for (var validateKey in documentStructure) {
      var content = documentContents[validateKey.key];
      var span = documentContents.nodes[validateKey.key]?.span;

      if (content != null) {
        validateKey.valueRestriction?.call(content, span, collector);
      }
    }
  }
}
