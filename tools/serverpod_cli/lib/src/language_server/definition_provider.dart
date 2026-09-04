import 'package:lsp_server/lsp_server.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/language_server/model_navigation_utils.dart';

/// Provides Go to Definition (CTRL+Click) resolution for Serverpod model files.
class DefinitionProvider {
  /// Resolves the definition location for a symbol at [position] in the document at [documentUri].
  static Either3<Location, List<Location>, List<LocationLink>>?
  resolveDefinition({
    required StatefulAnalyzer analyzer,
    required Uri documentUri,
    required Position position,
    required bool linkSupport,
  }) {
    var source = analyzer.getModelSource(documentUri);
    if (source == null) return null;

    var lines = source.yaml.split('\n');
    if (position.line < 0 || position.line >= lines.length) return null;

    var line = lines[position.line];
    var wordMatch = extractWordAt(line, position.character);
    if (wordMatch == null) return null;

    var token = wordMatch.word;

    var originSelectionRange = Range(
      start: Position(line: position.line, character: wordMatch.startColumn),
      end: Position(line: position.line, character: wordMatch.endColumn),
    );

    // 1. Check if token is a reference to a field in the current model
    // e.g. relation(field=authorId) or fields: authorId in index.
    // This runs before the keyword skip so that fields named like keywords
    // (e.g. `name`) stay navigable.
    var currentModel = analyzer.getModel(documentUri);
    if (currentModel is ClassDefinition &&
        isFieldReferenceContext(line, wordMatch.startColumn)) {
      var field = currentModel.findField(token);
      if (field != null) {
        var fieldLocation = findFieldDefinitionRange(lines, token);
        if (fieldLocation != null) {
          return _buildResult(
            targetUri: documentUri,
            targetSelectionRange: fieldLocation,
            targetRange: Range(
              start: Position(line: fieldLocation.start.line, character: 0),
              end: Position(
                line: fieldLocation.start.line,
                character: lines[fieldLocation.start.line].length,
              ),
            ),
            originSelectionRange: originSelectionRange,
            linkSupport: linkSupport,
          );
        }
      }
    }

    // 2. Only values reference models. Keys name the model syntax itself and
    // sequence entries only ever hold enum values or index field names.
    if (!isValuePosition(line, wordMatch.startColumn)) return null;

    // 3. Skip primitive types and common keywords
    if (primitiveTypes.contains(token) || ignoredKeywords.contains(token)) {
      return null;
    }

    // 4. Parse potential model / class target from token.
    // `project:` and `package:` tokens denote plain Dart classes and can
    // never resolve to a model.
    var modelToken = parseModelToken(token);
    if (modelToken == null) return null;

    // 5. Search model by className and moduleAlias
    var targetModel = analyzer.findModelByName(
      modelToken.className,
      moduleAlias: modelToken.moduleAlias,
    );

    // 6. If not found by class name, try searching by database table name
    // e.g. parentTable=citizen
    targetModel ??= analyzer.findModelByTableName(token);

    if (targetModel == null) return null;

    var targetSource = analyzer.getModelSourceForModel(targetModel);
    if (targetSource == null) return null;

    var targetLines = targetSource.yaml.split('\n');
    var targetSelectionRange = findModelDefinitionRange(
      targetLines,
      targetModel.className,
    );

    var targetRange = Range(
      start: Position(line: targetSelectionRange.start.line, character: 0),
      end: Position(
        line: targetSelectionRange.start.line,
        character: targetLines[targetSelectionRange.start.line].length,
      ),
    );

    return _buildResult(
      targetUri: targetSource.yamlSourceUri,
      targetSelectionRange: targetSelectionRange,
      targetRange: targetRange,
      originSelectionRange: originSelectionRange,
      linkSupport: linkSupport,
    );
  }

  /// Resolves the location of the model declaration for [className],
  /// optionally qualified with [moduleAlias].
  ///
  /// Backs the `serverpod/modelDefinition` custom request, which lets the
  /// editor navigate from generated Dart code back to the model file.
  static Location? resolveModelByName({
    required StatefulAnalyzer analyzer,
    required String className,
    String? moduleAlias,
  }) {
    var model = analyzer.findModelByName(className, moduleAlias: moduleAlias);
    if (model == null) return null;

    var source = analyzer.getModelSourceForModel(model);
    if (source == null) return null;

    var range = findModelDefinitionRange(
      source.yaml.split('\n'),
      model.className,
    );
    return Location(uri: source.yamlSourceUri, range: range);
  }

  static Either3<Location, List<Location>, List<LocationLink>> _buildResult({
    required Uri targetUri,
    required Range targetSelectionRange,
    required Range targetRange,
    required Range originSelectionRange,
    required bool linkSupport,
  }) {
    if (linkSupport) {
      return Either3.t3([
        LocationLink(
          originSelectionRange: originSelectionRange,
          targetUri: targetUri,
          targetRange: targetRange,
          targetSelectionRange: targetSelectionRange,
        ),
      ]);
    }

    return Either3.t1(
      Location(
        uri: targetUri,
        range: targetSelectionRange,
      ),
    );
  }
}
