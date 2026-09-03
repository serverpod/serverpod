import 'package:lsp_server/lsp_server.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Provides Go to Definition (CTRL+Click) resolution for Serverpod model files.
class DefinitionProvider {
  static final Set<String> _primitiveTypes = {
    ...autoSerializedTypes,
    ...extensionSerializedTypes,
    'dynamic',
    'void',
    'num',
  };

  static final Set<String> _ignoredKeywords = {
    /// All valid YAML keywords defined for model files.
    Keyword.classType,
    Keyword.exceptionType,
    Keyword.enumType,
    Keyword.serializationDataType,
    Keyword.serialized,
    Keyword.isSealed,
    Keyword.isImmutable,
    Keyword.extendsClass,
    Keyword.serverOnly,
    Keyword.table,
    Keyword.managedMigration,
    Keyword.fields,
    Keyword.indexes,
    Keyword.properties,
    Keyword.values,
    Keyword.type,
    Keyword.unique,
    Keyword.nullsDistinct,
    Keyword.per,
    Keyword.operatorClass,
    Keyword.distanceFunction,
    Keyword.parameters,
    Keyword.parent,
    Keyword.relation,
    Keyword.field,
    Keyword.onUpdate,
    Keyword.onDelete,
    Keyword.deferrable,
    Keyword.deferred,
    Keyword.name,
    Keyword.api,
    Keyword.database,
    Keyword.optional,
    Keyword.fk,
    Keyword.scope,
    Keyword.persist,
    Keyword.requiredKey,
    Keyword.tail,
    Keyword.defaultKey,
    Keyword.defaultModelKey,
    Keyword.defaultPersistKey,
    Keyword.columnKey,
    Keyword.jsonKey,
    ...ForeignKeyAction.values.expand(
      (e) => [e.name, '${e.name[0].toUpperCase()}${e.name.substring(1)}'],
    ),
    ...ModelDatabaseDefinition.values.map((e) => e.name),
    ...ModelFieldScopeDefinition.values.map((e) => e.name),
    defaultBooleanTrue,
    defaultBooleanFalse,
    'null',
  };

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
    var wordMatch = _extractWordAt(line, position.character);
    if (wordMatch == null) return null;

    var token = wordMatch.word;

    // Skip primitive types and common keywords
    if (_primitiveTypes.contains(token) || _ignoredKeywords.contains(token)) {
      return null;
    }

    var originSelectionRange = Range(
      start: Position(line: position.line, character: wordMatch.startColumn),
      end: Position(line: position.line, character: wordMatch.endColumn),
    );

    // 1. Check if token is a reference to a field in the current model
    // e.g. relation(field=authorId) or fields: authorId in index
    var currentModel = analyzer.getModel(documentUri);
    if (currentModel is ClassDefinition &&
        _isFieldReferenceContext(line, wordMatch)) {
      var field = currentModel.findField(token);
      if (field != null) {
        var fieldLocation = _findFieldDefinitionRange(lines, token);
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
    // e.g. parentTable=citizen
    targetModel ??= analyzer.findModelByTableName(token);

    if (targetModel == null) return null;

    var targetSource = analyzer.getModelSourceForModel(targetModel);
    if (targetSource == null) return null;

    var targetLines = targetSource.yaml.split('\n');
    var targetSelectionRange = _findModelDefinitionRange(
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

  /// Extracts the word / identifier at the given column position in [line].
  static _WordMatch? _extractWordAt(String line, int column) {
    if (line.isEmpty || column < 0) return null;

    // Adjust column if at end of line or right after a word character
    int col = column;
    if (col >= line.length) {
      if (col > 0 && _isWordChar(line, col - 1)) {
        col = col - 1;
      } else {
        return null;
      }
    }

    if (!_isWordChar(line, col)) {
      if (col > 0 && _isWordChar(line, col - 1)) {
        col = col - 1;
      } else {
        return null;
      }
    }

    int start = col;
    while (start > 0 && _isWordChar(line, start - 1)) {
      start--;
    }

    int end = col;
    while (end < line.length && _isWordChar(line, end)) {
      end++;
    }

    var word = line.substring(start, end);
    if (word.isEmpty) return null;

    return _WordMatch(
      word: word,
      startColumn: start,
      endColumn: end,
    );
  }

  static bool _isWordChar(String line, int index) {
    var char = line[index];
    var code = char.codeUnitAt(0);

    // A-Z, a-z, 0-9, _
    if ((code >= 65 && code <= 90) ||
        (code >= 97 && code <= 122) ||
        (code >= 48 && code <= 57) ||
        code == 95) {
      return true;
    }

    // Allow ':' only if it connects identifier parts (like module:auth:User)
    if (char == ':') {
      var hasPrev = index > 0 && _isIdentifierChar(line[index - 1]);
      var hasNext =
          index + 1 < line.length && _isIdentifierChar(line[index + 1]);
      return hasPrev && hasNext;
    }

    return false;
  }

  static bool _isIdentifierChar(String char) {
    var code = char.codeUnitAt(0);
    return (code >= 65 && code <= 90) ||
        (code >= 97 && code <= 122) ||
        (code >= 48 && code <= 57) ||
        code == 95;
  }

  static bool _isFieldReferenceContext(String line, _WordMatch wordMatch) {
    var beforeWord = line.substring(0, wordMatch.startColumn);
    if (beforeWord.contains('field=') ||
        beforeWord.contains('field:') ||
        beforeWord.contains('fields:')) {
      return true;
    }
    return false;
  }

  static Range? _findFieldDefinitionRange(
    List<String> lines,
    String fieldName,
  ) {
    var fieldRegex = RegExp(r'^\s*' + RegExp.escape(fieldName) + r'\s*:');
    for (var i = 0; i < lines.length; i++) {
      var l = lines[i];
      if (fieldRegex.hasMatch(l)) {
        var col = l.indexOf(fieldName);
        return Range(
          start: Position(line: i, character: col >= 0 ? col : 0),
          end: Position(
            line: i,
            character: col >= 0 ? col + fieldName.length : l.length,
          ),
        );
      }
    }
    return null;
  }

  static Range _findModelDefinitionRange(
    List<String> targetLines,
    String targetClassName,
  ) {
    var defRegex = RegExp(
      r'^(class|enum|exception)\s*:\s*' +
          RegExp.escape(targetClassName) +
          r'\b',
    );
    for (var i = 0; i < targetLines.length; i++) {
      var l = targetLines[i];
      if (defRegex.hasMatch(l)) {
        var col = l.indexOf(targetClassName);
        return Range(
          start: Position(line: i, character: col >= 0 ? col : 0),
          end: Position(
            line: i,
            character: col >= 0 ? col + targetClassName.length : l.length,
          ),
        );
      }
    }
    return Range(
      start: Position(line: 0, character: 0),
      end: Position(line: 0, character: 0),
    );
  }
}

class _WordMatch {
  final String word;
  final int startColumn;
  final int endColumn;

  _WordMatch({
    required this.word,
    required this.startColumn,
    required this.endColumn,
  });
}
