import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/keywords.dart';
import 'package:yaml/yaml.dart';

import '../converter/converter.dart';
import 'validate_node.dart';

class ProtocolValidator {
  static void validate(
    String documentType,
    Set<ValidateNode> documentStructure,
    YamlMap documentContents,
    CodeAnalysisCollector collector,
  ) {
    _collectInvalidKeyErrors(
      documentType,
      documentStructure,
      documentContents,
      collector,
    );

    _collectMutuallyExclusiveKeyErrors(
      documentStructure,
      documentContents,
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

    _collectKeyRestrictionErrors(
      documentStructure,
      documentContents,
      collector,
    );

    _collectValueValidationErrors(
      documentStructure,
      documentContents,
      collector,
    );

    var nodesWithNestedNodes =
        documentStructure.where((node) => node.nested.isNotEmpty);
    var anyNodes =
        nodesWithNestedNodes.where((node) => node.key == Keyword.any);

    for (var node in anyNodes) {
      for (var document in documentContents.nodes.entries) {
        var content = document.value.value;

        if (content is String? && node.allowStringifiedNestedValue) {
          content = convertStringifiedNestedNodesToYamlMap(
            content,
            document.value,
            node,
            onDuplicateKey: (key, span) {
              collector.addError(SourceSpanException(
                'The field option "$key" is defined more than once.',
                span,
              ));
            },
          );
        } 
        
        if (content is! YamlMap) {
          var requiredKeys =
              node.nested.where((e) => e.isRequired).map((e) => e.key);

          if (requiredKeys.isNotEmpty) {
            collector.addError(SourceSpanException(
              'The "${document.key}" property is missing required keys $requiredKeys.',
              documentContents.span,
            ));
          }

          continue;
        }

        validate(
          document.key.toString(),
          node.nested,
          content,
          collector,
        );
      }
    }

    var specificNodes = nodesWithNestedNodes.where(
      (node) => documentContents.containsKey(node.key),
    );

    for (var node in specificNodes) {
      var document = documentContents[node.key];

      if (document is! YamlMap) {
        var requiredKeys =
            node.nested.where((e) => e.isRequired).map((e) => e.key);

        if (requiredKeys.isNotEmpty) {
          collector.addError(SourceSpanException(
            'The "${document.key}" property is missing required keys $requiredKeys.',
            documentContents.span,
          ));
        }

        continue;
      }
      validate(
        node.key,
        node.nested,
        document,
        collector,
      );
    }
  }

  static void _collectInvalidKeyErrors(
    String documentType,
    Set<ValidateNode> documentStructure,
    YamlMap documentMap,
    CodeAnalysisCollector collector,
  ) {
    var validKeys = documentStructure.map((e) => e.key).toSet();
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

  static void _collectMutuallyExclusiveKeyErrors(
    Set<ValidateNode> documentStructure,
    YamlMap documentContents,
    CodeAnalysisCollector collector,
  ) {
    for (var node in documentStructure) {
      if (_shouldCheckMutuallyExclusiveKeys(node, documentContents)) {
        for (var mutuallyExclusiveKey in node.mutuallyExclusiveKeys) {
          if (documentContents.containsKey(mutuallyExclusiveKey)) {
            collector.addError(SourceSpanException(
              'The "${node.key}" property is mutually exclusive with the "$mutuallyExclusiveKey" property.',
              documentContents.nodes[node.key]?.span,
            ));
          }
        }
      }
    }
  }

  static bool _shouldCheckMutuallyExclusiveKeys(
    ValidateNode node,
    YamlMap documentContents,
  ) {
    return documentContents.containsKey(node.key) &&
        node.mutuallyExclusiveKeys.isNotEmpty;
  }

  static void _collectMissingRequiredKeyErrors(
    Set<ValidateNode> documentStructure,
    YamlMap documentContents,
    CodeAnalysisCollector collector,
  ) {
    for (var node in documentStructure) {
      if (_isMissingRequiredKey(node, documentContents)) {
        collector.addError(SourceSpanException(
          'No "${node.key}" property is defined.',
          documentContents.nodes[node.key]?.span,
        ));
      }
    }
  }

  static bool _isMissingRequiredKey(
      ValidateNode node, YamlMap documentContents) {
    return node.isRequired && !documentContents.containsKey(node.key);
  }

  static void _collectRequiredChildrenErrors(
    Set<ValidateNode> documentStructure,
    YamlMap documentContents,
    CodeAnalysisCollector collector,
  ) {
    for (var node in documentStructure) {
      var content = documentContents[node.key];
      var span = documentContents.nodes[node.key]?.span;

      if (documentContents.containsKey(node.key) &&
          node.nested.isNotEmpty &&
          content is! YamlMap) {
        collector.addError(SourceSpanException(
          'The "${node.key}" property must have at least one value.',
          span,
        ));
      }
    }
  }

  static void _collectKeyRestrictionErrors(
    Set<ValidateNode> documentStructure,
    YamlMap documentContents,
    CodeAnalysisCollector collector,
  ) {
    var validateNode = documentStructure.where(
      (node) => node.keyRestriction != null,
    );

    for (var node in validateNode) {
      for (var document in documentContents.nodes.entries) {
        node.keyRestriction?.call(
          document.key.toString(),
          document.key.span,
          collector,
        );
      }
    }
  }

  static void _collectValueValidationErrors(
    Set<ValidateNode> documentStructure,
    YamlMap documentContents,
    CodeAnalysisCollector collector,
  ) {
    for (var node in documentStructure) {
      var content = documentContents[node.key];
      var span = documentContents.nodes[node.key]?.span;

      if (documentContents.containsKey(node.key)) {
        node.valueRestriction?.call(content, span, collector);
      }
    }
  }
}
