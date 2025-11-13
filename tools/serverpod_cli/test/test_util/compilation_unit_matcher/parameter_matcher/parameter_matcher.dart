part of '../../compilation_unit_matcher.dart';

class _ParameterMatcherImpl extends Matcher implements ParameterMatcher {
  final ChainableMatcher<Iterable<FormalParameter>> parent;
  final String parameterName;
  final bool? isRequired;
  final String? type;
  final Initializer? initializer;
  _ParameterMatcherImpl._(
    this.parent,
    this.parameterName, {
    this.isRequired,
    this.type,
    this.initializer,
  }) {
    if (type != null && initializer != null) {
      throw ArgumentError('Cannot specify both type and initializer');
    }
  }

  @override
  Description describe(Description description) {
    var output = StringBuffer(' with a ');
    if (isRequired != null) {
      output.write(isRequired == true ? 'required ' : 'optional ');
    }
    output.write('"$parameterName" parameter');

    if (type != null) {
      output.write(' with type "$type"');
    }
    if (initializer != null) {
      output.write(' initialized with "${initializer?.toToken()}"');
    }

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

    var parameterDecl = _featureValueOf(item);
    if (parameterDecl is! FormalParameter) {
      final parameterNames = match.value
          .map((p) => p.name?.lexeme)
          .where((e) => e != null)
          .join(', ');

      return mismatchDescription.add(
        'does not contain parameter "$parameterName". Found parameters: [$parameterNames]',
      );
    }

    var output = StringBuffer();
    output.write('contains parameter "$parameterName" but ');

    var deviations = <String>[];
    if (!parameterDecl._hasMatchingRequired(isRequired)) {
      deviations.add(
        'it is ${parameterDecl.isRequired == true ? 'required' : 'optional'}',
      );
    }

    if (!parameterDecl._hasMatchingType(type)) {
      var initializer = parameterDecl._getInitializer();
      if (initializer != null) {
        deviations.add('it uses initializer "${initializer.toToken()}"');
      } else {
        deviations.add('it is of type "${parameterDecl._getType()}"');
      }
    }

    if (!parameterDecl._hasMatchingInitializer(initializer)) {
      if (parameterDecl._getType() != null) {
        deviations.add('it is of type "${parameterDecl._getType()}"');
      } else {
        deviations.add(
          'it is initialized with "${parameterDecl._getInitializer()?.toToken()}"',
        );
      }
    }

    output.write(deviations.join(' and '));

    return mismatchDescription.add(output.toString());
  }

  @override
  bool matches(dynamic item, Map matchState) {
    var parameter = _featureValueOf(item);
    if (parameter is! FormalParameter) return false;

    if (!parameter._hasMatchingInitializer(initializer)) return false;
    if (!parameter._hasMatchingRequired(isRequired)) return false;
    if (!parameter._hasMatchingType(type)) return false;

    return true;
  }

  FormalParameter? _featureValueOf(dynamic actual) {
    var match = parent.matchedFeatureValueOf(actual);
    if (match == null) return null;

    return match.value
        .where((p) => p.name?.lexeme == parameterName)
        .firstOrNull;
  }
}

extension on FormalParameter {
  Initializer? _getInitializer() {
    var resolvedThis = this;
    if (resolvedThis is DefaultFormalParameter) {
      return resolvedThis.parameter._getInitializer();
    }

    if (resolvedThis is SuperFormalParameter) {
      return Initializer.super_;
    }

    if (resolvedThis is FieldFormalParameter) {
      return Initializer.this_;
    }

    return null;
  }

  String? _getType() {
    var resolvedThis = this;
    if (resolvedThis is DefaultFormalParameter) {
      return resolvedThis.parameter._getType();
    }

    if (resolvedThis is SimpleFormalParameter) {
      return resolvedThis.type.toString();
    }

    return null;
  }

  bool _hasMatchingInitializer(Initializer? initializer) {
    if (initializer == null) return true;

    var parameterInitializer = _getInitializer();

    return switch (initializer) {
      Initializer.this_ => parameterInitializer == initializer,
      Initializer.super_ => parameterInitializer == initializer,
    };
  }

  bool _hasMatchingRequired(bool? isRequired) {
    if (isRequired == null) return true;

    return this.isRequired == (isRequired == true);
  }

  bool _hasMatchingType(String? type) {
    if (type == null) return true;

    return _getType() == type;
  }
}
