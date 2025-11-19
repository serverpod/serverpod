part of '../../compilation_unit_matcher.dart';

class _ClassMatcherImpl implements Matcher, ClassMatcher {
  final String _className;

  _ClassMatcherImpl._(this._className);

  @override
  Description describe(Description description) {
    return description.add('a CompilationUnit containing class "$_className"');
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
      return mismatchDescription.add(
        '"${item.runtimeType}" is not a CompilationUnit',
      );
    }

    final classNames = resolvedItem.declarations
        .whereType<ClassDeclaration>()
        .map((d) => d.name.lexeme)
        .join(', ');

    return mismatchDescription.add(
      'does not contain class "$_className". Found classes: [$classNames]',
    );
  }

  @override
  bool matches(Object? item, Map matchState) {
    return _matches(_featureValueOf(item));
  }

  @override
  ExtendsMatcher thatExtends(String className) {
    return _ExtendsMatcherImpl._(
      ChainableMatcher.createMatcher(
        this,
        resolveMatch: _matchedFeatureValueOf,
        extractValue: (classDeclaration) => classDeclaration.extendsClause,
      ),
      name: className,
    );
  }

  @override
  FieldMatcher withField(
    String fieldName, {
    bool? isNullable,
    bool? isFinal,
    bool? isLate,
    bool? isOverride,
    String? type,
  }) {
    return _FieldMatcherImpl._(
      ChainableMatcher.createMatcher(
        this,
        resolveMatch: _matchedFeatureValueOf,
        extractValue: (classDeclaration) =>
            classDeclaration.members.whereType<FieldDeclaration>(),
      ),
      fieldName,
      isNullable: isNullable,
      isFinal: isFinal,
      isLate: isLate,
      isOverride: isOverride,
      type: type,
    );
  }

  @override
  MethodMatcher withMethod(
    String methodName, {
    bool? isOverride,
    String? returnType,
  }) {
    return _MethodMatcherImpl._(
      ChainableMatcher.createMatcher(
        this,
        resolveMatch: _matchedFeatureValueOf,
        extractValue: (classDeclaration) =>
            classDeclaration.members.whereType<MethodDeclaration>(),
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
        .where((d) => d._hasMatchingClass(_className))
        .firstOrNull;
  }

  ClassDeclaration? _matchedFeatureValueOf(dynamic actual) {
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
      ChainableMatcher.createMatcher(
        this,
        resolveMatch: _matchedFeatureValueOf,
        extractValue: (classDeclaration) =>
            classDeclaration.members.whereType<ConstructorDeclaration>(),
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
