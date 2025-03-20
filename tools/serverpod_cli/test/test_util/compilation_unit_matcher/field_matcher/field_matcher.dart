part of '../../compilation_unit_matcher.dart';

class _FieldMatcherImpl extends Matcher implements FieldMatcher {
  final ChainableMatcher<Iterable<FieldDeclaration>> parent;
  final String fieldName;
  final bool? isNullable;
  final bool? isFinal;
  _FieldMatcherImpl._(
    this.parent,
    this.fieldName, {
    required this.isNullable,
    required this.isFinal,
  });

  @override
  Description describe(Description description) {
    var output = StringBuffer(' with a ');
    output.writeAll([
      if (isNullable != null) isNullable == true ? 'nullable' : 'non-nullable',
      if (isFinal != null) isFinal == true ? 'final' : 'non-final',
      'field "$fieldName"',
    ], ' ');
    return parent.describe(description).add(
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
          'does not contain field "$fieldName". Found fields: [$fieldNames]');
    }

    var output = StringBuffer('contains field "$fieldName" but the field is ');
    output.writeAll(
      [
        if (!fieldDecl._hasMatchingFinal(isFinal))
          isFinal == true ? 'non-final' : 'final',
        if (!fieldDecl._hasMatchingNullable(isNullable))
          isNullable == true ? 'non-nullable' : 'nullable',
      ],
      ' and ',
    );

    return mismatchDescription.add(output.toString());
  }

  @override
  bool matches(item, Map matchState) {
    var field = _featureValueOf(item);
    if (field is! FieldDeclaration) return false;

    if (!field._hasMatchingNullable(isNullable)) return false;
    if (!field._hasMatchingFinal(isFinal)) return false;
    return true;
  }

  FieldDeclaration? _featureValueOf(actual) {
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

  bool _hasMatchingVariable(String name) {
    return fields.variables.any((variable) => variable.name.toString() == name);
  }
}
