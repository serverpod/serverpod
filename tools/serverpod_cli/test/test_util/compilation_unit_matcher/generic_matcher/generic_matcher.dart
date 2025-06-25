part of '../../compilation_unit_matcher.dart';

class _GenericMatcherImpl implements Matcher, GenericMatcher {
  final ChainableMatcher<Iterable<TypeAnnotation>> _parent;
  final String _generic;

  _GenericMatcherImpl._(this._parent, this._generic);

  @override
  Description describe(Description description) {
    return _parent.describe(description).add(' with generic "$_generic"');
  }

  @override
  Description describeMismatch(
    item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    var match = _parent.matchedFeatureValueOf(item);
    if (match == null) {
      return _parent.describeMismatch(
        item,
        mismatchDescription,
        matchState,
        verbose,
      );
    }

    var typeParameters = match.value;
    if (typeParameters.isEmpty) {
      return mismatchDescription.add('does not have any generics');
    }

    return mismatchDescription.add(
      'does not have the generic "$_generic". Found generics: [${typeParameters.map((e) => e.toSource()).join(', ')}]',
    );
  }

  @override
  bool matches(item, Map matchState) {
    var typeParameters = _featureValueOf(item);
    if (typeParameters == null) return false;

    return typeParameters.where((e) => e.toSource() == _generic).isNotEmpty;
  }

  Iterable<TypeAnnotation>? _featureValueOf(actual) {
    var match = _parent.matchedFeatureValueOf(actual);
    if (match == null) return null;

    return match.value;
  }
}
