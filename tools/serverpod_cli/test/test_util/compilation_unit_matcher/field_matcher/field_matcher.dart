part of '../../compilation_unit_matcher.dart';

class _FieldMatcherImpl extends Matcher implements FieldMatcher {
  final ChainableMatcher<Iterable<FieldDeclaration>> parent;
  final String fieldName;
  final bool? isNullable;
  final bool? isFinal;
  final bool? isLate;
  final bool? isOverride;
  final String? type;

  _FieldMatcherImpl._(
    this.parent,
    this.fieldName, {
    required this.isNullable,
    required this.isFinal,
    required this.isLate,
    required this.isOverride,
    required this.type,
  });

  @override
  Description describe(Description description) {
    var output = StringBuffer(' with a ');
    output.writeAll([
      if (isNullable != null) isNullable == true ? 'nullable' : 'non-nullable',
      if (isLate != null) isLate == true ? 'late' : 'non-late',
      if (isFinal != null) isFinal == true ? 'final' : 'non-final',
      if (isOverride != null) isOverride == true ? 'override' : 'non-override',
      if (type != null) '$type',
      'field "$fieldName"',
    ], ' ');
    return parent
        .describe(description)
        .add(
          output.toString(),
        );
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    var match = parent.matchedFeatureValueOf(item);
    if (match == null) {
      return parent.describeMismatch(
        item,
        mismatchDescription,
        matchState,
        verbose,
      );
    }

    var fieldDecl = _featureValueOf(item);
    if (fieldDecl is! FieldDeclaration) {
      final fieldNames = match.value
          .expand((f) => f.fields.variables)
          .map((v) => v.name.lexeme)
          .join(', ');

      return mismatchDescription.add(
        'does not contain field "$fieldName". Found fields: [$fieldNames]',
      );
    }

    var output = StringBuffer('contains field "$fieldName" but the field is ');
    output.writeAll(
      [
        if (!fieldDecl._hasMatchingNullable(isNullable))
          isNullable == true ? 'non-nullable' : 'nullable',
        if (!fieldDecl._hasMatchingLate(isLate))
          isLate == true ? 'non-late' : 'late',
        if (!fieldDecl._hasMatchingFinal(isFinal))
          isFinal == true ? 'non-final' : 'final',
        if (!fieldDecl._hasMatchingOverride(isOverride))
          isOverride == true ? 'non-override' : 'override',
        if (!fieldDecl._hasMatchingType(type))
          'of type "${fieldDecl._getType()}" instead of "$type"',
      ],
      ' and ',
    );

    return mismatchDescription.add(output.toString());
  }

  @override
  bool matches(dynamic item, Map matchState) {
    var field = _featureValueOf(item);
    if (field is! FieldDeclaration) return false;

    if (!field._hasMatchingNullable(isNullable)) return false;
    if (!field._hasMatchingFinal(isFinal)) return false;
    if (!field._hasMatchingLate(isLate)) return false;
    if (!field._hasMatchingOverride(isOverride)) return false;
    if (!field._hasMatchingType(type)) return false;
    return true;
  }

  FieldDeclaration? _featureValueOf(dynamic actual) {
    var match = parent.matchedFeatureValueOf(actual);
    if (match == null) return null;

    return match.value
        .where((f) => f._hasMatchingVariable(fieldName))
        .firstOrNull;
  }
}

extension on FieldDeclaration {
  bool _hasMatchingNullable(bool? isNullable) {
    if (isNullable == null) return true;

    return fields.type?.question == null ? !isNullable : isNullable;
  }

  bool _hasMatchingFinal(bool? isFinal) {
    if (isFinal == null) return true;

    return fields.isFinal == isFinal;
  }

  bool _hasMatchingLate(bool? isLate) {
    if (isLate == null) return true;

    return fields.isLate == isLate;
  }

  bool _hasMatchingVariable(String name) {
    return fields.variables.any((variable) => variable.name.toString() == name);
  }

  bool _hasMatchingOverride(bool? isOverride) {
    if (isOverride == null) return true;

    return switch (isOverride) {
      true => metadata.any((m) => m.name.name == 'override'),
      false => metadata.every((m) => m.name.name != 'override'),
    };
  }

  bool _hasMatchingType(String? type) {
    if (type == null) return true;

    return _getType() == type;
  }

  String _getType() {
    TypeAnnotation? type = fields.type;
    return switch (type) {
      null => '',
      GenericFunctionType() => type.toSource(),
      NamedType() => type.name.lexeme,
      RecordTypeAnnotation() => type.toSource(),
    };
  }
}
