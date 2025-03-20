part of '../../compilation_unit_matcher.dart';

class _FieldMatcherImpl extends Matcher implements FieldMatcher {
  final ChainableMatcher<Iterable<FieldDeclaration>> parent;
  final String fieldName;
  final bool? isNullable;
  _FieldMatcherImpl._(this.parent, this.fieldName, {this.isNullable});

  @override
  Description describe(Description description) {
    var nullable = isNullable != null
        ? '${isNullable == true ? '' : 'non-'}nullable '
        : '';
    return parent.describe(description).add(
          ' with a ${nullable}field "$fieldName"',
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

    return mismatchDescription.add(
        'contains field "$fieldName" but the field is ${isNullable == true ? 'non-nullable' : 'nullable'}');
  }

  @override
  bool matches(item, Map matchState) {
    var field = _featureValueOf(item);
    if (field is! FieldDeclaration) return false;

    return field._hasMatchingNullable(isNullable);
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

  bool _hasMatchingVariable(String name) {
    return fields.variables.any((variable) => variable.name.toString() == name);
  }
}
