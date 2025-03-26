part of '../../compilation_unit_matcher.dart';

class _SuperInitializerMatcherImpl implements Matcher, SuperInitializerMatcher {
  final ChainableMatcher<SuperConstructorInvocation?> parent;

  _SuperInitializerMatcherImpl._(this.parent);

  @override
  Description describe(Description description) {
    return parent.describe(description).add(
          ' with a super initializer',
        );
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    var superConstructorInvocations = parent.matchedFeatureValueOf(item);
    if (superConstructorInvocations == null) {
      return parent.describeMismatch(
        item,
        mismatchDescription,
        matchState,
        verbose,
      );
    }

    return mismatchDescription.add(
      'does not have a super initializer',
    );
  }

  @override
  bool matches(item, Map matchState) {
    return _matches(_featureValueOf(item));
  }

  @override
  ArgumentMatcher withArgument(String name) {
    return _withArgument(name);
  }

  @override
  ArgumentMatcher withNamedArgument(String name, String parameterName) {
    return _withArgument(name, parameterType: _NamedParameter(parameterName));
  }

  @override
  ArgumentMatcher withPositionalArgument(String name) {
    return _withArgument(name, parameterType: _PositionalParameter());
  }

  SuperConstructorInvocation? _featureValueOf(actual) {
    var match = parent.matchedFeatureValueOf(actual);
    if (match == null) return null;

    return match.value;
  }

  SuperConstructorInvocation? _matchedFeatureValueOf(actual) {
    var superConstructorInvocation = _featureValueOf(actual);
    if (superConstructorInvocation == null) return null;

    if (!_matches(superConstructorInvocation)) return null;

    return superConstructorInvocation;
  }

  bool _matches(item) {
    return item != null;
  }

  ArgumentMatcher _withArgument(String name, {_ParameterType? parameterType}) {
    return _ArgumentMatcherImpl._(
        ChainableMatcher.createMatcher(
          this,
          resolveMatch: _matchedFeatureValueOf,
          extractValue: (superInitializer) =>
              superInitializer.argumentList.arguments,
        ),
        name,
        parameterType);
  }
}
