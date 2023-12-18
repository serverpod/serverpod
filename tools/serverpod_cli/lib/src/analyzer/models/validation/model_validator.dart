import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/util/extensions.dart';
import 'package:yaml/yaml.dart';

import 'package:serverpod_cli/src/analyzer/models/converter/converter.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/validate_node.dart';

/// Validates that only one top level model type is defined.
List<SourceSpanSeverityException> validateTopLevelModelType(
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
void validateYamlModel(
  String documentType,
  Set<ValidateNode> documentStructure,
  YamlMap documentContents,
  CodeAnalysisCollector collector, {
  NodeContext? context,
}) {
  context ??= NodeContext(
    documentType,
    false,
  );

  _collectInvalidKeyErrors(
    documentType,
    documentStructure,
    documentContents,
    collector,
  );

  for (var node in documentStructure) {
    _collectKeyRestrictionErrors(
      context,
      node,
      documentContents,
      collector,
    );

    _collectValueRestrictionErrors(
      context,
      node,
      documentContents,
      collector,
    );

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

    _collectDeprecatedKeyErrors(
      node,
      documentContents,
      collector,
    );

    _collectNodesWithNestedNodesErrors(
      context,
      node,
      documentContents,
      collector,
      validateNestedNodes: validateYamlModel, // Recursion
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
      continue;
    }

    var parsedKey = key.startsWith('!') ? key.substring(1) : key;
    if (!(validKeys.contains(Keyword.any) || validKeys.contains(parsedKey))) {
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
      !node.allowEmptyNestedValue &&
      content is! YamlMap) {
    collector.addError(SourceSpanSeverityException(
      'The "${node.key}" property must have at least one value.',
      span,
    ));
  }
}

void _collectDeprecatedKeyErrors(
  ValidateNode node,
  YamlMap documentContents,
  CodeAnalysisCollector collector,
) {
  if (node.isDeprecated && documentContents.containsKey(node.key)) {
    var severity = SourceSpanSeverity.info;
    if (node.isRemoved) {
      severity = SourceSpanSeverity.error;
    }

    collector.addError(SourceSpanSeverityException(
      'The "${node.key}" property is deprecated. ${node.alternativeUsageMessage}',
      documentContents.key(node.key)?.span,
      severity: severity,
      tags: [SourceSpanTag.deprecated],
    ));
  }
}

void _collectKeyRestrictionErrors(
  NodeContext context,
  ValidateNode node,
  YamlMap documentContents,
  CodeAnalysisCollector collector,
) {
  if (node.keyRestriction == null) return;

  if (node.key == Keyword.any) {
    for (var document in documentContents.nodes.entries) {
      var errors = node.keyRestriction?.call(
        context.parentNodeName,
        document.key.toString(),
        document.key.span,
      );

      if (errors != null) {
        collector.addErrors(errors);
      }
    }
  } else if (documentContents.containsKey(node.key)) {
    var errors = node.keyRestriction?.call(
      context.parentNodeName,
      node.key,
      documentContents.key(node.key)?.span,
    );

    if (errors != null) {
      collector.addErrors(errors);
    }
  }
}

void _collectValueRestrictionErrors(
  NodeContext context,
  ValidateNode node,
  YamlMap documentContents,
  CodeAnalysisCollector collector,
) {
  if (documentContents.containsKey(node.key)) {
    var content = documentContents[node.key];
    var span = documentContents.nodes[node.key]?.span;

    var errors =
        node.valueRestriction?.call(context.parentNodeName, content, span);

    if (errors != null) {
      collector.addErrors(errors);
    }
  }
}

void _collectNodesWithNestedNodesErrors(
  NodeContext context,
  ValidateNode node,
  YamlMap documentContents,
  CodeAnalysisCollector collector, {
  void Function(
    String documentType,
    Set<ValidateNode> documentStructure,
    YamlMap documentContents,
    CodeAnalysisCollector collector, {
    NodeContext? context,
  })? validateNestedNodes,
}) {
  if (node.nested.isEmpty) return;

  var documentNodes = _extractDocumentNodesToCheck(documentContents, node);

  for (var document in documentNodes) {
    var content = _extractNodeValue(document.value, node, collector);

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

    var nodeKey = document.key.toString();

    var nodeContext = context.shouldPropagateContext
        ? context
        : NodeContext(nodeKey, node.isContextualParentNode);

    validateNestedNodes?.call(
      nodeKey,
      node.nested,
      content,
      collector,
      context: nodeContext,
    );
  }
}

dynamic _extractNodeValue(
  YamlNode? contentNode,
  ValidateNode node,
  CodeAnalysisCollector collector,
) {
  var content = contentNode?.value;

  if (contentNode != null && _isStringifiedNode(contentNode, node, content)) {
    String? firstKey;

    if (node.allowStringifiedNestedValue.hasImplicitFirstKey) {
      firstKey = node.nested.first.key;
    }

    content = convertStringifiedNestedNodesToYamlMap(
      content,
      contentNode.span,
      firstKey: firstKey,
      onDuplicateKey: (key, span) {
        collector.addError(SourceSpanSeverityException(
          'The field option "$key" is defined more than once.',
          span,
        ));
      },
      onNegatedKeyWithValue: (key, span) {
        collector.addError(SourceSpanSeverityException(
          'Negating a key with a value is not allowed.',
          span,
        ));
      },
    );
  }
  return content;
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
  if (!node.allowStringifiedNestedValue.isAllowed) return false;

  return (content is String || content == null);
}
