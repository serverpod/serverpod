import 'package:super_string/super_string.dart';

/// Splits a string on the separator token unless the token is inside
/// brackets, angle brackets, ( ) and < >, curly braces, { }, single quotes '', or double quotes "".
List<String> splitIgnoringBracketsAndBracesAndQuotes(
  String input, {
  String separator = ',',
  bool returnEmptyParts = false,
}) {
  List<String> result = [];
  StringBuffer current = StringBuffer();
  int depth = 0;

  bool insideSingleQuote = false;
  bool insideDoubleQuote = false;

  for (var (index, char) in input.iterable.indexed) {
    if (char == separator && depth == 0) {
      var trimmed = current.toString().trim();
      if (trimmed.isNotEmpty || returnEmptyParts) {
        result.add(trimmed);
      }
      current.clear();
    } else {
      current.write(char);

      /// When inside quotes we ignore all depth modification until matching end quote is found.
      if (insideDoubleQuote || insideSingleQuote) {
        var isEscaped = index > 0 && input[index - 1] == '\\';

        if (insideDoubleQuote && char == '"' && !isEscaped) {
          /// If inside "" and non escaped " is found, only descrease depth and switch bool value
          depth--;
          insideDoubleQuote = false;
        } else if (insideSingleQuote && char == '\'' && !isEscaped) {
          /// If inside ' and non escaped ' is found, only descrease depth and switch bool value
          depth--;
          insideSingleQuote = false;
        }
      } else {
        if (char == '<' || char == '(' || char == '{') {
          depth++;
        } else if (char == '>' || char == ')' || char == '}') {
          depth--;
        } else if (char == '"') {
          depth++;
          insideDoubleQuote = true;
        } else if (char == '\'') {
          depth++;
          insideSingleQuote = true;
        }
      }
    }
  }

  var trimmed = current.toString().trim();
  if (trimmed.isNotEmpty || returnEmptyParts) {
    result.add(trimmed);
  }

  return result;
}

/// A registry that maps template names to their content.
/// Template names are the identifiers used in {@template name} directives.
typedef DartDocTemplateRegistry = Map<String, String>;

/// Extracts all {@template name}...{@endtemplate} definitions from documentation
/// and adds them to the provided [registry].
///
/// The template name is the identifier after {@template } and the content is
/// everything between {@template name} and {@endtemplate}.
///
/// Example:
/// ```dart
/// /// {@template example.method}
/// /// This is a method
/// /// {@endtemplate}
/// ```
/// Will add to the registry: {'example.method': '/// This is a method'}
void extractDartDocTemplates(
  String? documentation,
  DartDocTemplateRegistry registry,
) {
  if (documentation == null || documentation.isEmpty) {
    return;
  }

  // Pattern to extract template name and content
  // Matches {@template name}...content...{@endtemplate}
  final templatePattern = RegExp(
    r'^\s*///\s*\{@template\s+([^}]+)\}\s*$',
    multiLine: true,
  );
  final endTemplatePattern = RegExp(
    r'^\s*///\s*\{@endtemplate\}\s*$',
    multiLine: true,
  );

  final lines = documentation.split('\n');
  String? currentTemplateName;
  final contentBuffer = StringBuffer();

  for (final line in lines) {
    final templateMatch = templatePattern.firstMatch(line);
    if (templateMatch != null) {
      // Start of a new template
      currentTemplateName = templateMatch.group(1)?.trim();
      contentBuffer.clear();
      continue;
    }

    if (endTemplatePattern.hasMatch(line)) {
      // End of current template
      if (currentTemplateName != null) {
        var content = contentBuffer.toString().trim();
        if (content.isNotEmpty) {
          registry[currentTemplateName] = content;
        }
      }
      currentTemplateName = null;
      continue;
    }

    if (currentTemplateName != null) {
      // Inside a template, collect content
      if (contentBuffer.isNotEmpty) {
        contentBuffer.write('\n');
      }
      contentBuffer.write(line);
    }
  }
}

/// Removes {@template ...} and {@endtemplate} markers from documentation
/// comments, as they are only needed in source files for documentation
/// generation and should not appear in generated files.
///
/// If a [templateRegistry] is provided, also resolves {@macro name} references
/// by replacing them with the corresponding template content from the registry.
///
/// Example:
/// ```dart
/// /// {@template example.method}
/// /// This is a method
/// /// {@endtemplate}
/// ```
/// becomes:
/// ```dart
/// /// This is a method
/// ```
///
/// And:
/// ```dart
/// /// {@macro example.method}
/// ```
/// becomes (if template is in registry):
/// ```dart
/// /// This is a method
/// ```
String? stripDocumentationTemplateMarkers(
  String? documentation, {
  DartDocTemplateRegistry? templateRegistry,
}) {
  if (documentation == null || documentation.isEmpty) {
    return documentation;
  }

  // Regular expression to match {@template ...} lines and {@endtemplate} lines
  // Match the entire line including the comment markers (///)
  final templateMarkerPattern = RegExp(
    r'^\s*///\s*\{@template\s+[^}]+\}\s*$',
    multiLine: true,
  );
  final endTemplateMarkerPattern = RegExp(
    r'^\s*///\s*\{@endtemplate\}\s*$',
    multiLine: true,
  );

  var result = documentation;

  // Remove {@template ...} lines
  result = result.replaceAll(templateMarkerPattern, '');

  // Remove {@endtemplate} lines
  result = result.replaceAll(endTemplateMarkerPattern, '');

  // Resolve {@macro name} references if template registry is provided
  if (templateRegistry != null && templateRegistry.isNotEmpty) {
    result = _resolveMacroReferences(result, templateRegistry);
  }

  // Clean up any resulting extra blank lines (more than one consecutive blank line)
  result = result.replaceAll(RegExp(r'(\n\s*\n)\s*\n+'), r'$1');

  // Trim leading/trailing whitespace
  result = result.trim();

  return result.isEmpty ? null : result;
}

/// Resolves {@macro name} references in documentation by replacing them with
/// the corresponding template content from the registry.
String _resolveMacroReferences(
  String documentation,
  DartDocTemplateRegistry templateRegistry,
) {
  // Pattern to match entire lines containing only {@macro name}
  // This matches lines like: /// {@macro template.name}
  final macroLinePattern = RegExp(
    r'^(\s*///\s*)\{@macro\s+([^}]+)\}\s*$',
    multiLine: true,
  );

  return documentation.replaceAllMapped(macroLinePattern, (match) {
    final macroName = match.group(2)?.trim();
    if (macroName != null && templateRegistry.containsKey(macroName)) {
      return templateRegistry[macroName]!;
    }
    // If macro is not found in registry, keep the original line
    return match.group(0)!;
  });
}
