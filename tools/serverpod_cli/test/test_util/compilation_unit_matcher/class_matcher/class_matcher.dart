part of '../../compilation_unit_matcher.dart';

class _ClassMatcherImpl implements Matcher, ClassMatcher {
  final String className;
  _ClassMatcherImpl._(this.className);

  @override
  bool matches(Object? item, Map matchState) {
    return _featureValueOf(item) != null;
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
  Description describe(Description description) {
    return description.add('a CompilationUnit containing class "$className"');
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
}

extension _ClassDeclarationExtensions on ClassDeclaration {
  bool _hasMatchingClass(String name) {
    return this.name.lexeme == name;
  }
}
