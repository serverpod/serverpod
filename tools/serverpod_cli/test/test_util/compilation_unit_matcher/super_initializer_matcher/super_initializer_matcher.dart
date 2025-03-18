part of '../../compilation_unit_matcher.dart';

class _SuperInitializerMatcherImpl implements Matcher, SuperInitializerMatcher {
  final ChainableMatcher<Iterable<SuperConstructorInvocation>> parent;

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
    return _featureValueOf(item) != null;
  }

  SuperConstructorInvocation? _featureValueOf(actual) {
    var superConstructorInvocations = parent.matchedFeatureValueOf(actual);
    if (superConstructorInvocations == null) return null;

    return superConstructorInvocations.firstOrNull;
  }
}
