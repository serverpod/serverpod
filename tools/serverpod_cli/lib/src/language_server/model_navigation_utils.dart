import 'package:lsp_server/lsp_server.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Types that can never resolve to a Serverpod model definition.
final primitiveTypes = {
  ...autoSerializedTypes,
  ...extensionSerializedTypes,
  'dynamic',
  'void',
  'num',
};

/// All valid YAML keywords and literal values defined for model files.
/// These can never resolve to a model or field definition.
final ignoredKeywords = {
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

final _keyRegex = RegExp(r'^\s*([A-Za-z_][A-Za-z0-9_]*)\s*:');

/// Returns the mapping key declared on [line], or null when [line] is not a
/// mapping entry (a sequence entry such as `- alpha`, for instance).
String? lineKey(String line) => _keyRegex.firstMatch(line)?.group(1);

/// Returns true when [column] in [line] sits in the value of a mapping entry.
///
/// Sequence entries are deliberately excluded: only enum values and index
/// field lists live there, and neither references a model. Values of the
/// `values` key are excluded for the same reason.
bool isValuePosition(String line, int column) {
  var keyMatch = _keyRegex.firstMatch(line);
  if (keyMatch == null) return false;
  if (column < keyMatch.end) return false;
  return keyMatch.group(1) != Keyword.values;
}

/// A word extracted from a line of text, with its column span.
class WordMatch {
  /// Creates a [WordMatch].
  WordMatch({
    required this.word,
    required this.startColumn,
    required this.endColumn,
  });

  /// The extracted word.
  final String word;

  /// The column where the word starts (inclusive).
  final int startColumn;

  /// The column where the word ends (exclusive).
  final int endColumn;
}

/// Extracts the word / identifier at the given column position in [line].
///
/// Colons are considered word characters when they connect identifier parts,
/// so qualified references such as `module:auth:User` are extracted as a
/// single word.
WordMatch? extractWordAt(String line, int column) {
  if (line.isEmpty || column < 0) return null;

  // Adjust column if at end of line or right after a word character.
  var col = column;
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

  var start = col;
  while (start > 0 && _isWordChar(line, start - 1)) {
    start--;
  }

  var end = col;
  while (end < line.length && _isWordChar(line, end)) {
    end++;
  }

  var word = line.substring(start, end);
  if (word.isEmpty) return null;

  return WordMatch(
    word: word,
    startColumn: start,
    endColumn: end,
  );
}

bool _isWordChar(String line, int index) {
  var char = line[index];
  if (_isIdentifierChar(char)) return true;

  // Allow ':' only if it connects identifier parts (like module:auth:User).
  if (char == ':') {
    var hasPrev = index > 0 && _isIdentifierChar(line[index - 1]);
    var hasNext = index + 1 < line.length && _isIdentifierChar(line[index + 1]);
    return hasPrev && hasNext;
  }

  return false;
}

bool _isIdentifierChar(String char) {
  var code = char.codeUnitAt(0);
  // A-Z, a-z, 0-9, _
  return (code >= 65 && code <= 90) ||
      (code >= 97 && code <= 122) ||
      (code >= 48 && code <= 57) ||
      code == 95;
}

/// Returns true if the word at [column] in [line] is positioned where a field
/// of the current model is referenced, e.g. `relation(field=authorId)`,
/// `field: authorId`, or `fields: authorId` in an index.
bool isFieldReferenceContext(String line, int column) {
  var beforeWord = line.substring(0, column);
  return beforeWord.endsWith('field=') ||
      beforeWord.contains(RegExp(r'\bfield:\s*$')) ||
      beforeWord.contains(RegExp(r'\bfields:'));
}

/// Returns the column at which [fieldName] is declared on [line]
/// (i.e. the line has the shape `<indent><fieldName>:`), or null.
int? fieldDeclarationColumn(String line, String fieldName) {
  var declRegex = RegExp(r'^\s*' + RegExp.escape(fieldName) + r'\s*:');
  if (!declRegex.hasMatch(line)) return null;
  return line.indexOf(fieldName);
}

/// Returns the column at which [className] is declared on [line]
/// (i.e. the line has the shape `class|enum|exception: <className>`), or null.
int? modelDeclarationColumn(String line, String className) {
  var declRegex = RegExp(
    r'^\s*(?:class|enum|exception)\s*:\s*' + RegExp.escape(className) + r'\b',
  );
  if (!declRegex.hasMatch(line)) return null;
  return line.indexOf(className);
}

/// Finds the range of the declaration of the field [fieldName] in [lines],
/// or null if the field is not declared.
Range? findFieldDefinitionRange(List<String> lines, String fieldName) {
  for (var i = 0; i < lines.length; i++) {
    var col = fieldDeclarationColumn(lines[i], fieldName);
    if (col == null) continue;
    return Range(
      start: Position(line: i, character: col),
      end: Position(line: i, character: col + fieldName.length),
    );
  }
  return null;
}

/// Finds the range of the declaration of the model [className] in [lines].
/// Falls back to the start of the document if no declaration is found.
Range findModelDefinitionRange(List<String> lines, String className) {
  for (var i = 0; i < lines.length; i++) {
    var col = modelDeclarationColumn(lines[i], className);
    if (col == null) continue;
    return Range(
      start: Position(line: i, character: col),
      end: Position(line: i, character: col + className.length),
    );
  }
  return Range(
    start: Position(line: 0, character: 0),
    end: Position(line: 0, character: 0),
  );
}

/// Parses a navigation [token] (e.g. `User`, `module:auth:User`) into its
/// optional module alias and class name, reusing the analyzer's type parser.
///
/// Returns null for `project:` and `package:` tokens, which denote plain
/// Dart classes and can never resolve to a Serverpod model.
({String? moduleAlias, String className})? parseModelToken(String token) {
  var type = parseType(token, extraClasses: null);
  var url = type.url;
  if (url != null &&
      (url.startsWith('project:') || url.startsWith('package:'))) {
    return null;
  }
  return (moduleAlias: type.moduleAlias, className: type.className);
}
