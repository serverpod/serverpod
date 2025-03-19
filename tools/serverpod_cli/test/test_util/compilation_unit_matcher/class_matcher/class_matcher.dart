part of '../../compilation_unit_matcher.dart';

class _ClassMatcherImpl implements Matcher, ClassMatcher {
  final String className;
  _ClassMatcherImpl._(this.className);

  @override
  Description describe(Description description) {
    return description.add('a CompilationUnit containing class "$className"');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    var resolvedItem = item;
    if (resolvedItem is FormattedCompilationUnit) {
      resolvedItem = resolvedItem.compilationUnit;
    }

    if (resolvedItem is! CompilationUnit) {
      return mismatchDescription
          .add('"${item.runtimeType}" is not a CompilationUnit');
    }

    final classNames = resolvedItem.declarations
        .whereType<ClassDeclaration>()
        .map((d) => d.name.lexeme)
        .join(', ');

    return mismatchDescription.add(
        'does not contain class "$className". Found classes: [$classNames]');
  }

  @override
  bool matches(Object? item, Map matchState) {
    return _matches(_featureValueOf(item));
  }

  @override
  FieldMatcher withField(String fieldName, {bool? isNullable}) {
    return _FieldMatcherImpl._(
      ChainableMatcher(
        this,
        (actual) => _matchedFeatureValueOf(actual)
            ?.members
            .whereType<FieldDeclaration>(),
      ),
      fieldName,
      isNullable: isNullable,
    );
  }

  @override
  MethodMatcher withMethod(
    String methodName, {
    bool? isOverride,
    String? returnType,
  }) {
    return _MethodMatcherImpl._(
      ChainableMatcher(
        this,
        (actual) => _matchedFeatureValueOf(actual)
            ?.members
            .whereType<MethodDeclaration>(),
      ),
      methodName,
      isOverride: isOverride,
      returnType: returnType,
    );
  }

  @override
  ConstructorMatcher withNamedConstructor(
    String constructorName, {
    bool? isFactory,
  }) {
    if (constructorName.isEmpty) {
      throw ArgumentError('constructorName cannot be empty');
    }

    return _withConstructor(constructorName, isFactory: isFactory);
  }

  @override
  ConstructorMatcher withUnnamedConstructor({
    bool? isFactory,
  }) {
    return _withConstructor('', isFactory: isFactory);
  }

  ClassDeclaration? _featureValueOf(dynamic actual) {
    var resolvedActual = actual;
    if (resolvedActual is FormattedCompilationUnit) {
      resolvedActual = resolvedActual.compilationUnit;
    }

    if (resolvedActual is! CompilationUnit) return null;

    return resolvedActual.declarations
        .whereType<ClassDeclaration>()
        .where((d) => d._hasMatchingClass(className))
        .firstOrNull;
  }

  ClassDeclaration? _matchedFeatureValueOf(actual) {
    var classDecl = _featureValueOf(actual);
    if (classDecl == null) return null;

    if (!_matches(classDecl)) return null;

    return classDecl;
  }

  bool _matches(Object? item) {
    return item != null;
  }

  ConstructorMatcher _withConstructor(
    String constructorName, {
    bool? isFactory,
  }) {
    return _ConstructorMatcherImpl._(
      ChainableMatcher(
        this,
        (actual) => _matchedFeatureValueOf(actual)
            ?.members
            .whereType<ConstructorDeclaration>(),
      ),
      name: constructorName,
      isFactory: isFactory,
    );
  }
}

extension on ClassDeclaration {
  bool _hasMatchingClass(String name) {
    return this.name.lexeme == name;
  }
}
