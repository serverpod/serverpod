import 'package:lsp_server/lsp_server.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/language_server/definition_provider.dart';

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
    var wordMatch = DefinitionProvider.extractWordAt(line, position.character);
    if (wordMatch == null) return [];

    var token = wordMatch.word;

    // Skip primitive types and common keywords
    if (DefinitionProvider.primitiveTypes.contains(token) ||
        DefinitionProvider.ignoredKeywords.contains(token)) {
      return [];
    }

    // 1. Check if token is a reference to a field in the current model
    var currentModel = analyzer.getModel(documentUri);
    if (currentModel is ClassDefinition) {
      var isField =
          currentModel.findField(token) != null ||
          DefinitionProvider.isFieldReferenceContext(line, wordMatch);
      if (isField && currentModel.findField(token) != null) {
        return _findFieldReferences(
          lines: lines,
          documentUri: documentUri,
          fieldName: token,
          includeDeclaration: context.includeDeclaration,
        );
      }
    }

    // 2. Parse potential model / class target from token
    String? moduleAlias;
    String className = token;

    if (token.startsWith('module:')) {
      var parts = token.split(':');
      if (parts.length >= 3) {
        moduleAlias = parts[1];
        className = parts.sublist(2).join(':');
      }
    } else if (token.startsWith('project:')) {
      var parts = token.split(':');
      if (parts.length >= 3) {
        moduleAlias = parts[1];
        className = parts.sublist(2).join(':');
      }
    } else if (token.contains(':')) {
      var parts = token.split(':');
      if (parts.length == 2) {
        moduleAlias = parts[0];
        className = parts[1];
      }
    }

    // 3. Search model by className and moduleAlias
    var targetModel = analyzer.findModelByName(
      className,
      moduleAlias: moduleAlias,
    );

    // 4. If not found by class name, try searching by database table name
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
      var declRange = DefinitionProvider.findModelDefinitionRange(
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
        if (isDeclarationFile && _isDeclarationLine(rawLine, className)) {
          continue;
        }

        var matches = classRegex.allMatches(rawLine);
        for (var match in matches) {
          var startCol = match.start;
          var endCol = match.end;

          // Ignore matches inside comments
          if (_isCommentIndex(rawLine, startCol)) continue;

          // Must be in a value position (after `:` or `-`)
          if (!_isValuePosition(rawLine, startCol)) continue;

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
      var isDecl = RegExp(
        r'^\s*' + RegExp.escape(fieldName) + r'\s*:',
      ).hasMatch(line);

      if (isDecl) {
        if (includeDeclaration) {
          var col = line.indexOf(fieldName);
          locations.add(
            Location(
              uri: documentUri,
              range: Range(
                start: Position(line: i, character: col >= 0 ? col : 0),
                end: Position(
                  line: i,
                  character: col >= 0 ? col + fieldName.length : line.length,
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

        var before = line.substring(0, match.start);
        var isRef =
            before.contains('field=') ||
            before.contains('fields:') ||
            before.contains('field:') ||
            before.contains('fields=[');

        if (isRef) {
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
    }

    return locations;
  }

  static bool _isDeclarationLine(String line, String className) {
    var defRegex = RegExp(
      r'^\s*(class|enum|exception)\s*:\s*' + RegExp.escape(className) + r'\b',
    );
    return defRegex.hasMatch(line);
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

  static bool _isValuePosition(String line, int index) {
    var colonIdx = line.indexOf(':');
    if (colonIdx >= 0 && index > colonIdx) return true;
    var dashIdx = line.indexOf('-');
    if (dashIdx >= 0 && index > dashIdx) return true;
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
      var word = delimiterIdx >= 0
          ? prefix.substring(delimiterIdx + 1)
          : prefix;
      var parts = word.split(':');
      var alias = parts.length >= 2 && parts[0] == 'module'
          ? parts[1]
          : parts.last;
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
