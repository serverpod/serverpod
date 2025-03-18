import 'package:serverpod_cli/src/generator/keywords.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/util/string_manipulation.dart';

/// Attempts to parse a record type from a field type definition
///
/// Returns `null` in case the type does not describe a valid record
TypeDefinition? tryParseRecord(
  String trimmedRecordInput, {
  List<TypeDefinition>? extraClasses,
}) {
  if (!trimmedRecordInput.startsWith('(')) {
    return null;
  }

  if (!trimmedRecordInput.endsWith(')') &&
      !trimmedRecordInput.replaceAll(' ', '').endsWith(')?')) {
    return null;
  }

  var (fieldsString, nullable) = _unwrapRecord(trimmedRecordInput);

  var splitFields = splitIgnoringBracketsAndBracesAndQuotes(
    fieldsString,
    returnEmptyParts: true,
  );

  // Field into split from string must have at least 2 parts,
  // meaning the record is using a `,` even if it has only 1 fields, e.g. `(int,)`
  // or some named parameter like `({String foo})`.
  if ((splitFields.length < 2 || splitFields.every((f) => f.isEmpty)) &&
      !(splitFields.length == 1 &&
          splitFields.single.startsWith('{') &&
          splitFields.single.endsWith('}'))) {
    return null;
  }

  var recordFields =
      splitFields.where((s) => s.isNotEmpty).expand((splitField) {
    if (splitField.startsWith('{') && splitField.endsWith('}')) {
      return _parseNamedRecordFields(
        splitField,
        extraClasses: extraClasses,
      );
    }

    // could be either just a positional type, or a named positional type (like `int` or `int someNumber`, or even `Set<String> someSet`)
    var parts = splitIgnoringBracketsAndBracesAndQuotes(
      splitField,
      separator: ' ',
    );

    if (parts.length > 1 && !parts.last.startsWith('<')) {
      // if the last part is a name (and not a generic parameter), then we need to drop that
      splitField = parts.take(parts.length - 1).join();
    }

    return [
      parseType(
        splitField,
        extraClasses: extraClasses,
      ),
    ];
  }).toList();

  return TypeDefinition(
    className: RecordKeyword.className,
    generics: recordFields,
    nullable: nullable,
  );
}

Iterable<TypeDefinition> _parseNamedRecordFields(
  String namedRecordFieldsPart, {
  List<TypeDefinition>? extraClasses,
}) sync* {
  if (!namedRecordFieldsPart.startsWith('{') ||
      !namedRecordFieldsPart.endsWith('}')) {
    throw Exception(
      '"$namedRecordFieldsPart" does not described the named parameters of a Record',
    );
  }

  var start = namedRecordFieldsPart.indexOf('{');
  var end = namedRecordFieldsPart.lastIndexOf('}');
  var typesMap = namedRecordFieldsPart.substring(start + 1, end);

  var namedFieldWithTypes = splitIgnoringBracketsAndBracesAndQuotes(typesMap);

  for (var namedFieldWithType in namedFieldWithTypes) {
    namedFieldWithType = namedFieldWithType.trim();

    var typeDescription = namedFieldWithType
        .substring(0, namedFieldWithType.lastIndexOf(' '))
        .trim();
    var name = namedFieldWithType
        .substring(namedFieldWithType.lastIndexOf(' '))
        .trim();

    var type = parseType(
      typeDescription,
      extraClasses: extraClasses,
    );

    yield type.asNamedRecordField(name);
  }
}

(String fields, bool nullable) _unwrapRecord(String trimmedRecordInput) {
  var start = trimmedRecordInput.indexOf('(');
  var end = trimmedRecordInput.lastIndexOf(')');
  var nullable = trimmedRecordInput.endsWith('?');
  var fields = trimmedRecordInput.substring(start + 1, end);

  return (fields, nullable);
}
