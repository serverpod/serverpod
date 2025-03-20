part of '../../compilation_unit_matcher.dart';

class _ArgumentMatcherImpl extends Matcher implements ArgumentMatcher {
  final ChainableMatcher<Iterable<Expression>> _parent;
  final String _value;
  final _ParameterType? _parameterType;

  _ArgumentMatcherImpl._(this._parent, this._value, [this._parameterType]);

  @override
  Description describe(Description description) {
    var resolvedArgumentType = _parameterType;
    if (resolvedArgumentType == null) {
      return _parent.describe(description).add(' passed "$_value" argument');
    }

    return switch (resolvedArgumentType) {
      _PositionalParameter _ => _parent
          .describe(description)
          .add(' passed "$_value" positional argument'),
      _NamedParameter argumentType => _parent.describe(description).add(
          ' passed "$_value" argument for "${argumentType.parameterName}" parameter'),
    };
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    var arguments = _parent.matchedFeatureValueOf(item);
    if (arguments == null) {
      return _parent.describeMismatch(
        item,
        mismatchDescription,
        matchState,
        verbose,
      );
    }

    var output = StringBuffer();
    var matchingArguments = _featureValueOf(item);
    if (matchingArguments == null || matchingArguments.isEmpty) {
      output.write(
        'does not contain argument "$_value" in super initializer. Found arguments: [',
      );
      output.writeAll(
        arguments.map((e) => e.toSource()),
        ', ',
      );
      output.write(']');
      return mismatchDescription.add(output.toString());
    }

    output.write('contains argument "$_value" but ');
    switch (_parameterType) {
      case _PositionalParameter _:
        output.write(
          'it is not a positional argument in super initializer',
        );
      case _NamedParameter argumentType:
        output.write(
          'it is not passed to a named parameter "${argumentType.parameterName}" in super initializer',
        );

      case null:
        throw StateError(
          'Either the argument matches purely on name or it should be positional or named argument',
        );
    }

    return mismatchDescription.add(output.toString());
  }

  @override
  bool matches(item, Map matchState) {
    var arguments = _featureValueOf(item);
    if (arguments == null) return false;

    if (arguments.isEmpty) return false;

    var filteredArguments = arguments
        .where((e) => e._hasMatchingParameterType(_parameterType))
        .where((e) => e._hasMatchingNamedParameter(_parameterType));

    return filteredArguments.isNotEmpty;
  }

  Iterable<Expression>? _featureValueOf(actual) {
    var superInitializer = _parent.matchedFeatureValueOf(actual);
    if (superInitializer == null) return null;

    return superInitializer.where((e) => e._hasMatchingValue(_value));
  }
}

final class _NamedParameter extends _ParameterType {
  final String parameterName;
  _NamedParameter(this.parameterName);
}

sealed class _ParameterType {}

final class _PositionalParameter extends _ParameterType {
  _PositionalParameter();
}

extension on Expression {
  bool _hasMatchingNamedParameter(_ParameterType? argumentType) {
    if (argumentType is! _NamedParameter) return true;

    var resolvedThis = this;
    if (resolvedThis is! NamedExpression) return false;

    return resolvedThis.name.label.name == argumentType.parameterName;
  }

  bool _hasMatchingParameterType(_ParameterType? namedArgumentType) {
    if (namedArgumentType == null) return true;

    var resolvedThis = this;

    return switch (namedArgumentType) {
      _PositionalParameter _ => resolvedThis is SimpleIdentifier,
      _NamedParameter _ => resolvedThis is NamedExpression
    };
  }

  bool _hasMatchingValue(String name) {
    var resolvedThis = this;
    if (resolvedThis is NamedExpression) {
      return resolvedThis.expression._hasMatchingValue(name);
    }

    return resolvedThis.toSource() == name;
  }
}
