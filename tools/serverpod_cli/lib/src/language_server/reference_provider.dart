import 'package:lsp_server/lsp_server.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/language_server/model_navigation_utils.dart';

/// Provides Find References resolution for Serverpod model files.
class ReferenceProvider {
  /// Finds all references to the symbol at [position] in [documentUri].
  static List<Location> findReferences({
    required StatefulAnalyzer analyzer,
    required Uri documentUri,
    required Position position,
    required ReferenceContext context,
  }) {
    var source = analyzer.getModelSource(documentUri);
    if (source == null) return [];

    var lines = source.yaml.split('\n');
    if (position.line < 0 || position.line >= lines.length) return [];

    var line = lines[position.line];
    var wordMatch = extractWordAt(line, position.character);
    if (wordMatch == null) return [];

    var token = wordMatch.word;

    // 1. Check if token is a field of the current model. This runs before
    // the keyword skip so that fields named like keywords (e.g. `name`)
    // stay searchable.
    var currentModel = analyzer.getModel(documentUri);
    if (currentModel is ClassDefinition &&
        currentModel.findField(token) != null) {
      return _findFieldReferences(
        lines: lines,
        documentUri: documentUri,
        fieldName: token,
        includeDeclaration: context.includeDeclaration,
      );
    }

    // 2. Only values reference models. Keys name the model syntax itself and
    // sequence entries only ever hold enum values or index field names.
    if (!isValuePosition(line, wordMatch.startColumn)) return [];

    // 3. Skip primitive types and common keywords
    if (primitiveTypes.contains(token) || ignoredKeywords.contains(token)) {
      return [];
    }

    // 4. Parse potential model / class target from token.
    // `project:` and `package:` tokens denote plain Dart classes and can
    // never resolve to a model.
    var modelToken = parseModelToken(token);
    if (modelToken == null) return [];

    // 5. Search model by className and moduleAlias
    var targetModel = analyzer.findModelByName(
      modelToken.className,
      moduleAlias: modelToken.moduleAlias,
    );

    // 6. If not found by class name, try searching by database table name
    targetModel ??= analyzer.findModelByTableName(token);

    if (targetModel == null) return [];

    return _findModelReferences(
      analyzer: analyzer,
      targetModel: targetModel,
      includeDeclaration: context.includeDeclaration,
    );
  }

  static List<Location> _findModelReferences({
    required StatefulAnalyzer analyzer,
    required SerializableModelDefinition targetModel,
    required bool includeDeclaration,
  }) {
    var locations = <Location>[];
    var targetSource = analyzer.getModelSourceForModel(targetModel);
    var targetUri = targetSource?.yamlSourceUri;

    // 1. Declaration site
    if (includeDeclaration && targetSource != null && targetUri != null) {
      var targetLines = targetSource.yaml.split('\n');
      var declRange = findModelDefinitionRange(
        targetLines,
        targetModel.className,
      );
      locations.add(Location(uri: targetUri, range: declRange));
    }

    var className = targetModel.className;
    var classRegex = RegExp(r'\b' + RegExp.escape(className) + r'\b');

    // 2. Search all registered models
    for (var source in analyzer.registeredModelSources) {
      var modelUri = source.yamlSourceUri;
      var isDeclarationFile =
          targetUri != null &&
          p.canonicalize(modelUri.toFilePath()) ==
              p.canonicalize(targetUri.toFilePath());

      var modelLines = source.yaml.split('\n');
      for (var lineIdx = 0; lineIdx < modelLines.length; lineIdx++) {
        var rawLine = modelLines[lineIdx];

        // Skip the declaration line itself in the declaration file (already handled above if includeDeclaration is true)
        if (isDeclarationFile &&
            modelDeclarationColumn(rawLine, className) != null) {
          continue;
        }

        var matches = classRegex.allMatches(rawLine);
        for (var match in matches) {
          var startCol = match.start;
          var endCol = match.end;

          // Ignore matches inside comments
          if (_isCommentIndex(rawLine, startCol)) continue;

          // Must be in a value position, never a key or a sequence entry
          if (!isValuePosition(rawLine, startCol)) continue;

          // Check for module qualification mismatch
          if (!_matchesModule(rawLine, startCol, targetModel)) continue;

          // Not a relation name= parameter
          if (_isRelationNameParam(rawLine, startCol)) continue;

          locations.add(
            Location(
              uri: modelUri,
              range: Range(
                start: Position(line: lineIdx, character: startCol),
                end: Position(line: lineIdx, character: endCol),
              ),
            ),
          );
        }
      }
    }

    return locations;
  }

  static List<Location> _findFieldReferences({
    required List<String> lines,
    required Uri documentUri,
    required String fieldName,
    required bool includeDeclaration,
  }) {
    var locations = <Location>[];
    var fieldRegex = RegExp(r'\b' + RegExp.escape(fieldName) + r'\b');

    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];
      var declColumn = fieldDeclarationColumn(line, fieldName);

      if (declColumn != null) {
        if (includeDeclaration) {
          locations.add(
            Location(
              uri: documentUri,
              range: Range(
                start: Position(line: i, character: declColumn),
                end: Position(
                  line: i,
                  character: declColumn + fieldName.length,
                ),
              ),
            ),
          );
        }
        continue;
      }

      var matches = fieldRegex.allMatches(line);
      for (var match in matches) {
        if (_isCommentIndex(line, match.start)) continue;

        if (!isFieldReferenceContext(line, match.start)) continue;

        locations.add(
          Location(
            uri: documentUri,
            range: Range(
              start: Position(line: i, character: match.start),
              end: Position(line: i, character: match.end),
            ),
          ),
        );
      }
    }

    return locations;
  }

  static bool _isCommentIndex(String line, int index) {
    var inSingleQuote = false;
    var inDoubleQuote = false;
    for (var i = 0; i < line.length && i <= index; i++) {
      var char = line[i];
      if (char == "'" && !inDoubleQuote) {
        inSingleQuote = !inSingleQuote;
      } else if (char == '"' && !inSingleQuote) {
        inDoubleQuote = !inDoubleQuote;
      } else if (char == '#' && !inSingleQuote && !inDoubleQuote) {
        return index >= i;
      }
    }
    return false;
  }

  static bool _matchesModule(
    String line,
    int startCol,
    SerializableModelDefinition targetModel,
  ) {
    if (startCol > 0 && line[startCol - 1] == ':') {
      var prefix = line.substring(0, startCol - 1);
      var delimiterIdx = prefix.lastIndexOf(RegExp(r'[\s,<(?:]'));
      var alias = delimiterIdx >= 0
          ? prefix.substring(delimiterIdx + 1)
          : prefix;
      if (alias.isNotEmpty && targetModel.type.moduleAlias != alias) {
        return false;
      }
    }
    return true;
  }

  static bool _isRelationNameParam(String line, int startCol) {
    var before = line.substring(0, startCol);
    return before.endsWith('name=') || before.endsWith('name: ');
  }
}
