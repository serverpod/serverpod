import 'package:test/test.dart';

/// Helper method to construct a [Match] object.
///
/// In order to construct a [Match] object, the [matchedItem] must be non-null.
/// If the [matchedItem] is null, this method will return null.
///
/// [extractValue] is used to extract the value from the [matchedItem]
/// that is then stored in the constructed [Match] object.
Match<T>? _createMatch<T, V>({
  required V? Function() resolveMatch,
  required T Function(V value) extractValue,
}) {
  var matchedItem = resolveMatch();
  if (matchedItem == null) return null;

  return Match(extractValue(matchedItem));
}

typedef MatchedFeatureValueOf<T> = Match<T>? Function(dynamic actual);

/// A matcher that can be chained with other matchers.
class ChainableMatcher<T> {
  final Matcher _matcher;
  final MatchedFeatureValueOf<T> _matchedFeatureValueOf;

  ChainableMatcher._(this._matcher, this._matchedFeatureValueOf);

  /// Creates a matcher that can be chained with other matchers.
  /// The [matcher] is the matcher that is chained.
  ///
  /// The [resolveMatch] function is used to determine if the contained matcher
  /// matches the [actual] value. If the matcher matches, this should return the
  /// resolved match. If the matcher does not match, this should return null.
  ///
  /// The [extractValue] function is used to extract the value from the resolved
  /// match. This value is then stored in the [Match] object.
  static ChainableMatcher<T> createMatcher<T, V>(
    Matcher matcher, {
    required V? Function(dynamic item) resolveMatch,
    required T Function(V value) extractValue,
  }) {
    return ChainableMatcher<T>._(
      matcher,
      (actual) => _createMatch<T, V>(
        resolveMatch: () => resolveMatch(actual),
        extractValue: extractValue,
      ),
    );
  }

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
  /// Returns a [Match] object if the matcher matches the [actual] value.
  /// If the matcher does not match, this method should return null and the call
  /// to describeMismatch should be delegated to the matcher.
  Match<T>? matchedFeatureValueOf(dynamic actual) =>
      _matchedFeatureValueOf(actual);
}

/// A match that contains the value requested by the matcher.
class Match<T> {
  final T value;
  Match(this.value);
}
