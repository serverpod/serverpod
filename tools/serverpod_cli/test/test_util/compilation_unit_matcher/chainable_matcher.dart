import 'package:test/test.dart';

typedef MatchedFeatureValueOf<T> = T? Function(dynamic actual);

/// A matcher that can be chained with other matchers.
class ChainableMatcher<T> {
  final Matcher _matcher;
  final MatchedFeatureValueOf<T> _matchedFeatureValueOf;

  ChainableMatcher(this._matcher, this._matchedFeatureValueOf);

  /// Describes the contained matcher. This is used to describe the matcher in
  /// the context of the chain.
  Description describe(Description description) =>
      _matcher.describe(description);

  /// Describes the mismatch of the contained matcher. This is used to describe
  /// the mismatch in the context of the chain.
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) =>
      _matcher.describeMismatch(
        item,
        mismatchDescription,
        matchState,
        verbose,
      );

  /// Checks if the matcher matches the given [actual] value.
  ///
  /// If null is returned, this means that the contained matcher did not match
  /// and the call to describeMismatch should be delegated to the matcher.
  T? matchedFeatureValueOf(dynamic actual) => _matchedFeatureValueOf(actual);
}
