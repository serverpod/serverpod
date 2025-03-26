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
    return _matches(extendsClause);
  }

  ExtendsClause? _featureValueOf(actual) {
    var match = _parent.matchedFeatureValueOf(actual);
    if (match == null) return null;

    return match.value;
  }

  ExtendsClause? _matchedFeatureValueOf(dynamic actual) {
    var extendsDeclaration = _featureValueOf(actual);
    if (extendsDeclaration == null) return null;

    if (!_matches(extendsDeclaration)) return null;

    return extendsDeclaration;
  }

  bool _matches(ExtendsClause? extendsClause) {
    if (extendsClause == null) return false;

    return extendsClause._hasMatchingClassName(_name);
  }

  @override
  GenericMatcher withGeneric(String genericType) {
    return _GenericMatcherImpl._(
      ChainableMatcher.createMatcher(
        this,
        resolveMatch: _matchedFeatureValueOf,
        extractValue: (extendsClause) =>
            extendsClause.superclass.typeArguments?.arguments ?? [],
      ),
      genericType,
    );
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
