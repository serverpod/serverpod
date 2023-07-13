import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/keywords.dart';
import 'package:serverpod_cli/src/util/extensions.dart';
import 'package:yaml/yaml.dart';

import 'package:serverpod_cli/src/analyzer/entities/converter/converter.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/validate_node.dart';

/// Validates that only one top level entity type is defined.
List<SourceSpanSeverityException> validateTopLevelEntityType(
  YamlNode documentContents,
  Set<String> classTypes,
) {
  if (documentContents is! YamlMap) return [];

  var typeNodes = _findNodesByKeys(
    documentContents,
    classTypes,
  );

  if (typeNodes.length == 1) return [];

  if (typeNodes.isEmpty) {
    return [
      SourceSpanSeverityException(
        'No $classTypes type is defined.',
        documentContents.span,
      )
    ];
  }

  var formattedKeys = _formatNodeKeys(typeNodes);
  var errors = typeNodes
      .skip(1)
      .map(
        (e) => SourceSpanSeverityException(
            'Multiple entity types ($formattedKeys) found for a single entity. Only one type per entity allowed.',
            documentContents.key(e.key.toString())?.span),
      )
      .toList();

  return errors;
}

/// Recursively validates a yaml document against a set of [ValidateNode]s.
/// The [documentType] represents the parent key of the [documentContents],
/// in the initial processing this is expected to be the top level entity type
/// we are checking. E.g. 'class', 'enum', 'exception', etc.
void validateYamlProtocol(
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

  for (var node in documentStructure) {
    _collectMutuallyExclusiveKeyErrors(
      node,
      documentContents,
      collector,
    );

    _collectMissingRequiredKeyErrors(
      node,
      documentContents,
      collector,
    );

    _collectMissingRequiredChildrenErrors(
      node,
      documentContents,
      collector,
    );

    _collectKeyRestrictionErrors(
      node,
      documentContents,
      collector,
    );

    _collectValueRestrictionErrors(
      node,
      documentContents,
      collector,
    );

    _collectNodesWithNestedNodesErrors(
      node,
      documentContents,
      collector,
      validateNestedNodes: validateYamlProtocol, // Recursion
    );
  }
}

void _collectInvalidKeyErrors(
  String documentType,
  Set<ValidateNode> documentStructure,
  YamlMap documentContents,
  CodeAnalysisCollector collector,
) {
  var validKeys = documentStructure.map((e) => e.key).toSet();
  for (var keyNode in documentContents.nodes.keys) {
    if (keyNode is! YamlScalar) {
      collector.addError(SourceSpanSeverityException(
        'Key must be of type String.',
        keyNode.span,
      ));
    }

    var key = keyNode.value;
    if (key is! String) {
      collector.addError(SourceSpanSeverityException(
        'Key must be of type String.',
        keyNode.span,
      ));
    }

    if (!(validKeys.contains(Keyword.any) || validKeys.contains(key))) {
      collector.addError(SourceSpanSeverityException(
        'The "$key" property is not allowed for $documentType type. Valid keys are $validKeys.',
        keyNode.span,
      ));
    }
  }
}

void _collectMutuallyExclusiveKeyErrors(
  ValidateNode node,
  YamlMap documentContents,
  CodeAnalysisCollector collector,
) {
  if (_shouldCheckMutuallyExclusiveKeys(node, documentContents)) {
    for (var mutuallyExclusiveKey in node.mutuallyExclusiveKeys) {
      if (documentContents.containsKey(mutuallyExclusiveKey)) {
        collector.addError(SourceSpanSeverityException(
          'The "${node.key}" property is mutually exclusive with the "$mutuallyExclusiveKey" property.',
          documentContents.key(node.key)?.span,
        ));
      }
    }
  }
}

void _collectMissingRequiredKeyErrors(
  ValidateNode node,
  YamlMap documentContents,
  CodeAnalysisCollector collector,
) {
  if (_isMissingRequiredKey(node, documentContents)) {
    collector.addError(SourceSpanSeverityException(
        'No "${node.key}" property is defined.',
        documentContents.nodes[node.key]?.span));
  }
}

void _collectMissingRequiredChildrenErrors(
  ValidateNode node,
  YamlMap documentContents,
  CodeAnalysisCollector collector,
) {
  var content = documentContents[node.key];
  var span = documentContents.nodes[node.key]?.span;

  if (documentContents.containsKey(node.key) &&
      node.nested.isNotEmpty &&
      content is! YamlMap) {
    collector.addError(SourceSpanSeverityException(
      'The "${node.key}" property must have at least one value.',
      span,
    ));
  }
}

void _collectKeyRestrictionErrors(
  ValidateNode node,
  YamlMap documentContents,
  CodeAnalysisCollector collector,
) {
  if (node.keyRestriction == null) return;

  for (var document in documentContents.nodes.entries) {
    var errors =
        node.keyRestriction?.call(document.key.toString(), document.key.span);

    if (errors != null) {
      collector.addErrors(errors);
    }
  }
}

void _collectValueRestrictionErrors(
  ValidateNode node,
  YamlMap documentContents,
  CodeAnalysisCollector collector,
) {
  var content = documentContents[node.key];
  var span = documentContents.nodes[node.key]?.span;

  if (documentContents.containsKey(node.key)) {
    var errors = node.valueRestriction?.call(content, span);

    if (errors != null) {
      collector.addErrors(errors);
    }
  }
}

void _collectNodesWithNestedNodesErrors(
  ValidateNode node,
  YamlMap documentContents,
  CodeAnalysisCollector collector, {
  void Function(
    String documentType,
    Set<ValidateNode> documentStructure,
    YamlMap documentContents,
    CodeAnalysisCollector collector,
  )? validateNestedNodes,
}) {
  if (node.nested.isEmpty) return;

  var documentNodes = _extractDocumentNodesToCheck(documentContents, node);

  for (var document in documentNodes) {
    var contentNode = document.value;
    var content = contentNode?.value;

    if (contentNode != null && _isStringifiedNode(contentNode, node, content)) {
      content = convertStringifiedNestedNodesToYamlMap(
        content,
        contentNode,
        node,
        onDuplicateKey: (key, span) {
          collector.addError(SourceSpanSeverityException(
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
        collector.addError(SourceSpanSeverityException(
          'The "${document.key}" property is missing required keys $requiredKeys.',
          documentContents.span,
        ));
      }

      continue;
    }

    validateNestedNodes?.call(
      document.key.toString(),
      node.nested,
      content,
      collector,
    );
  }
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

bool _isMissingRequiredKey(ValidateNode node, YamlMap documentContents) {
  return node.isRequired && !documentContents.containsKey(node.key);
}

bool _shouldCheckMutuallyExclusiveKeys(
  ValidateNode node,
  YamlMap documentContents,
) {
  return documentContents.containsKey(node.key) &&
      node.mutuallyExclusiveKeys.isNotEmpty;
}

Iterable<MapEntry<dynamic, YamlNode?>> _extractDocumentNodesToCheck(
    YamlMap documentContents, ValidateNode node) {
  if (node.key == Keyword.any) {
    return documentContents.nodes.entries;
  }

  var key = documentContents.key(node.key);
  var value = documentContents.nodes[node.key];

  return [MapEntry(key, value)];
}

bool _isStringifiedNode(YamlNode? contentNode, ValidateNode node, content) {
  if (!node.allowStringifiedNestedValue) return false;

  return (content is String || content == null);
}
