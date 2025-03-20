part of '../../compilation_unit_matcher.dart';

class _ExtendsMatcherImpl implements Matcher, ExtendsMatcher {
  final ChainableMatcher<ExtendsClause?> _parent;
  final String _name;

  _ExtendsMatcherImpl._(this._parent, {required String name}) : _name = name;

  @override
  Description describe(Description description) {
    return _parent.describe(description).add(' that extends "$_name"');
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

    var extendsClause = match.value;
    if (extendsClause == null) {
      return mismatchDescription.add('does not extend any class');
    }

    return mismatchDescription.add(
      'extends the class "${extendsClause._getExtendedTypeName()}"',
    );
  }

  @override
  bool matches(item, Map matchState) {
    var extendsClause = _featureValueOf(item);
    if (extendsClause is! ExtendsClause) return false;

    return extendsClause._hasMatchingClassName(_name);
  }

  ExtendsClause? _featureValueOf(actual) {
    var match = _parent.matchedFeatureValueOf(actual);
    if (match == null) return null;

    return match.value;
  }
}

extension on ExtendsClause {
  String? _getExtendedTypeName() {
    return superclass.name2.lexeme;
  }

  bool _hasMatchingClassName(String className) {
    return _getExtendedTypeName() == className;
  }
}
