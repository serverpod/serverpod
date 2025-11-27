part of '../../compilation_unit_matcher.dart';

class _ConstructorMatcherImpl implements Matcher, ConstructorMatcher {
  final ChainableMatcher<Iterable<ConstructorDeclaration>> parent;
  final String _name;
  final bool? _isFactory;
  _ConstructorMatcherImpl._(
    this.parent, {
    required String name,
    required bool? isFactory,
  }) : _name = name,
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
    var match = parent.matchedFeatureValueOf(item);
    if (match == null) {
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
        'does not contain "$_name" named constructor. Found named constructors: [',
      );
      output.writeAll(
        match.value.where((e) => e.name != null).map((c) => c.name?.lexeme),
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
  bool matches(dynamic item, Map matchState) {
    var constructor = _featureValueOf(item);
    return _matches(constructor);
  }

  @override
  InitializerMatcher withFieldInitializer(String fieldName) {
    return _InitializerMatcherImpl._(
      ChainableMatcher.createMatcher(
        this,
        resolveMatch: _matchedFeatureValueOf,
        extractValue: (constructorDeclaration) => constructorDeclaration
            .initializers
            .whereType<ConstructorFieldInitializer>(),
      ),
      fieldName,
    );
  }

  @override
  ParameterMatcher withInitializerParameter(
    String parameterName,
    Initializer initializer, {
    bool? isRequired,
  }) {
    return _withParameter(
      parameterName,
      initializer: initializer,
      isRequired: isRequired,
    );
  }

  @override
  ParameterMatcher withParameter(
    String parameterName, {
    bool? isRequired,
  }) {
    return _withParameter(
      parameterName,
      isRequired: isRequired,
    );
  }

  @override
  SuperInitializerMatcher withSuperInitializer() {
    return _SuperInitializerMatcherImpl._(
      ChainableMatcher.createMatcher(
        this,
        resolveMatch: _matchedFeatureValueOf,
        extractValue: (constructorDeclaration) => constructorDeclaration
            .initializers
            .whereType<SuperConstructorInvocation>()
            .firstOrNull,
      ),
    );
  }

  @override
  ParameterMatcher withTypedParameter(
    String parameterName,
    String type, {
    bool? isRequired,
  }) {
    return _withParameter(
      parameterName,
      type: type,
      isRequired: isRequired,
    );
  }

  ConstructorDeclaration? _featureValueOf(dynamic actual) {
    var match = parent.matchedFeatureValueOf(actual);
    if (match == null) return null;

    return match.value.where((c) => c._hasMatchingName(_name)).firstOrNull;
  }

  ConstructorDeclaration? _matchedFeatureValueOf(dynamic actual) {
    var constructorDecl = _featureValueOf(actual);
    if (constructorDecl == null) return null;

    if (!_matches(constructorDecl)) return null;

    return constructorDecl;
  }

  bool _matches(ConstructorDeclaration? constructor) {
    if (constructor is! ConstructorDeclaration) return false;

    if (!constructor._hasMatchingFactory(_isFactory)) return false;

    return true;
  }

  ParameterMatcher _withParameter(
    String parameterName, {
    bool? isRequired,
    String? type,
    Initializer? initializer,
  }) {
    return _ParameterMatcherImpl._(
      ChainableMatcher.createMatcher(
        this,
        resolveMatch: _matchedFeatureValueOf,
        extractValue: (constructorDeclaration) =>
            constructorDeclaration.parameters.parameters,
      ),
      parameterName,
      type: type,
      isRequired: isRequired,
      initializer: initializer,
    );
  }
}

extension on ConstructorDeclaration {
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
