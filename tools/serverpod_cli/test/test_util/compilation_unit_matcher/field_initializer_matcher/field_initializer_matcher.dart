part of '../../compilation_unit_matcher.dart';

class _InitializerMatcherImpl implements Matcher, InitializerMatcher {
  final ChainableMatcher<Iterable<ConstructorFieldInitializer>> parent;
  final String fieldName;

  _InitializerMatcherImpl._(this.parent, this.fieldName);

  @override
  Description describe(Description description) {
    return parent
        .describe(description)
        .add(
          ' with field initializer for "$fieldName"',
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

    return mismatchDescription.add(
      'does not have a field initializer for "$fieldName". Found initializers: [${match.value.map((e) => e.fieldName.name).join(', ')}]',
    );
  }

  @override
  bool matches(dynamic item, Map matchState) {
    return _matches(_featureValueOf(item));
  }

  @override
  ArgumentMatcher withArgument(String value) {
    return _withArgument(value);
  }

  @override
  ArgumentMatcher withNamedArgument(String value, String parameterName) {
    return _withArgument(value, parameterType: _NamedParameter(parameterName));
  }

  @override
  ArgumentMatcher withPositionalArgument(String value) {
    return _withArgument(value, parameterType: _PositionalParameter());
  }

  ConstructorFieldInitializer? _featureValueOf(dynamic actual) {
    var match = parent.matchedFeatureValueOf(actual);
    if (match == null) return null;

    return match.value.where((e) => e._hasMatchingName(fieldName)).firstOrNull;
  }

  ConstructorFieldInitializer? _matchedFeatureValueOf(dynamic actual) {
    var initializer = _featureValueOf(actual);
    if (initializer == null) return null;

    if (!_matches(initializer)) return null;

    return initializer;
  }

  bool _matches(dynamic item) {
    return item != null;
  }

  ArgumentMatcher _withArgument(String value, {_ParameterType? parameterType}) {
    return _ArgumentMatcherImpl._(
      ChainableMatcher.createMatcher(
        this,
        resolveMatch: _matchedFeatureValueOf,
        extractValue: (initializer) => [initializer.expression],
      ),
      value,
      parameterType,
    );
  }
}

extension on ConstructorFieldInitializer {
  bool _hasMatchingName(String name) {
    return fieldName.name == name;
  }
}
