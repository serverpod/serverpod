part of '../../compilation_unit_matcher.dart';

class _MethodMatcherImpl extends Matcher implements MethodMatcher {
  final ChainableMatcher<Iterable<MethodDeclaration>> _parent;
  final String _name;
  final bool? _isOverride;
  final String? _returnType;

  _MethodMatcherImpl._(
    this._parent,
    this._name, {
    required bool? isOverride,
    required String? returnType,
  })  : _isOverride = isOverride,
        _returnType = returnType;

  @override
  Description describe(Description description) {
    var output = StringBuffer(' with ');

    if (_isOverride != null) {
      output.write(_isOverride == true ? 'override ' : 'non-override ');
    }

    output.write('method "$_name"');

    if (_returnType != null) {
      output.write(' returning "$_returnType"');
    }

    return _parent.describe(description).add(output.toString());
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    var methodDeclarations = _parent.matchedFeatureValueOf(item);
    if (methodDeclarations == null) {
      return _parent.describeMismatch(
        item,
        mismatchDescription,
        matchState,
        verbose,
      );
    }

    var methodDecl = _featureValueOf(item);
    var output = StringBuffer();
    if (methodDecl == null) {
      output.write('does not contain method "$_name". Found methods: [');
      output.writeAll(
        methodDeclarations.map((m) => m.name.lexeme),
        ', ',
      );
      output.write(']');
      return mismatchDescription.add(output.toString());
    }

    output.write('contains method "$_name" but it ');
    output.writeAll([
      if (!methodDecl._hasMatchingOverride(_isOverride))
        'is ${_isOverride == true ? 'not overridden' : 'overridden'}',
      if (!methodDecl._hasMatchingReturnType(_returnType))
        'returns "${methodDecl.returnType?.toSource()}"'
    ], ' and ');

    return mismatchDescription.add(output.toString());
  }

  @override
  bool matches(item, Map matchState) {
    var method = _featureValueOf(item);
    if (method is! MethodDeclaration) return false;

    if (!method._hasMatchingOverride(_isOverride)) return false;
    if (!method._hasMatchingReturnType(_returnType)) return false;

    return true;
  }

  MethodDeclaration? _featureValueOf(actual) {
    var methodDeclarations = _parent.matchedFeatureValueOf(actual);
    if (methodDeclarations == null) return null;

    return methodDeclarations.where((m) => m.name.lexeme == _name).firstOrNull;
  }
}

extension _MethodDeclarationExtention on MethodDeclaration {
  bool _hasMatchingOverride(bool? isOverride) {
    if (isOverride == null) return true;

    return switch (isOverride) {
      true => metadata.any((m) => m.name.name == 'override'),
      false => metadata.every((m) => m.name.name != 'override'),
    };
  }

  bool _hasMatchingReturnType(String? returnType) {
    if (returnType == null) return true;

    return returnType == this.returnType?.toSource();
  }
}
