part of '../../compilation_unit_matcher.dart';

class _ConstructorMatcherImpl implements Matcher, ConstructorMatcher {
  final ChainableMatcher<Iterable<ConstructorDeclaration>> parent;
  final String _name;
  final bool? _isFactory;
  _ConstructorMatcherImpl._(
    this.parent, {
    required String name,
    required bool? isFactory,
  })  : _name = name,
        _isFactory = isFactory;

  @override
  Description describe(Description description) {
    var output = StringBuffer(' with');

    if (_name.isEmpty) {
      output.write(' an unnamed');
    } else {
      output.write(' a "$_name" named');
    }

    if (_isFactory != null) {
      output.write(' factory');
    }

    output.write(' constructor');
    return parent.describe(description).add(output.toString());
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    var classConstructors = parent.matchedFeatureValueOf(item);
    if (classConstructors == null) {
      return parent.describeMismatch(
        item,
        mismatchDescription,
        matchState,
        verbose,
      );
    }

    var constructorDecl = _featureValueOf(item);
    if (constructorDecl is! ConstructorDeclaration && _name.isEmpty) {
      return mismatchDescription.add('does not contain an unnamed constructor');
    }

    if (constructorDecl is! ConstructorDeclaration) {
      var output = StringBuffer();
      output.write(
          'does not contain "$_name" named constructor. Found named constructors: [');
      output.writeAll(
        classConstructors
            .where((e) => e.name != null)
            .map((c) => c.name?.lexeme),
        ', ',
      );
      output.write(']');

      return mismatchDescription.add(output.toString());
    }

    return mismatchDescription.add(
      'contains constructor but it is not a factory constructor',
    );
  }

  @override
  bool matches(item, Map matchState) {
    var constructor = _featureValueOf(item);
    if (constructor is! ConstructorDeclaration) return false;

    if (!constructor._hasMatchingFactory(_isFactory)) return false;

    return true;
  }

  ConstructorDeclaration? _featureValueOf(actual) {
    var classConstructors = parent.matchedFeatureValueOf(actual);
    if (classConstructors == null) return null;

    return classConstructors
        .where((c) => c._hasMatchingName(_name))
        .firstOrNull;
  }
}

extension _ConstructorDeclarationExtensions on ConstructorDeclaration {
  bool _hasMatchingFactory(bool? isFactory) {
    if (isFactory == null) return true;

    return (factoryKeyword != null) == isFactory;
  }

  bool _hasMatchingName(String name) {
    // If the constructor name is null it has no name.
    var constructorName = this.name?.lexeme ?? '';
    return constructorName == name;
  }
}
