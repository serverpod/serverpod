import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_style/dart_style.dart';
import 'package:test/test.dart';

import 'compilation_unit_matcher/chainable_matcher.dart';

part 'compilation_unit_matcher/argument_matcher/argument_matcher.dart';
part 'compilation_unit_matcher/class_matcher/class_matcher.dart';
part 'compilation_unit_matcher/constructor_matcher/constructor_matcher.dart';
part 'compilation_unit_matcher/extends_matcher/extends_matcher.dart';
part 'compilation_unit_matcher/field_matcher/field_matcher.dart';
part 'compilation_unit_matcher/method_matcher/method_matcher.dart';
part 'compilation_unit_matcher/parameter_matcher/parameter_matcher.dart';
part 'compilation_unit_matcher/super_initializer_matcher/super_initializer_matcher.dart';

/// A custom matcher that checks if a CompilationUnit contains a class with a
/// specific name.
///
/// The matcher can also be negated:
/// ```dart
/// expect(compilationUnit, isNot(containsClass('NonExistentClass')));
/// ```
///
/// The available matchers are:
///   ClassMatcher
///   ├── FieldMatcher
///   ├── ConstructorMatcher
///   │   ├── SuperInitializerMatcher
///   │   │   └── ArgumentMatcher
///   │   └── ParameterMatcher
///   ├── MethodMatcher
///   │   └── ParameterMatcher
///   └── ExtendsMatcher
///
ClassMatcher containsClass(String className) => _ClassMatcherImpl._(className);

/// Parses a string of Dart code into a FormattedCompilationUnit.
FormattedCompilationUnit parseCode(String code) =>
    FormattedCompilationUnit(parseString(content: code).unit);

/// A chainable matcher that matches an argument in a compilation unit.
abstract interface class ArgumentMatcher {}

/// A matcher that checks if a CompilationUnit contains a class that matches
/// certain criteria.
abstract interface class ClassMatcher {
  /// Chains a [ExtendsMatcher] that checks if the class extends a specific class.
  ExtendsMatcher thatExtends(String className);

  /// Chains a [FieldMatcher] that checks if the class contains a field with a
  /// specific name.
  ///
  /// Example:
  ///
  /// ```dart
  /// expect(
  ///  compilationUnit,
  ///  containsClass('User').withField('name'),
  /// );
  /// ```
  ///
  /// Use [isNullable] to match field nullability. If the value is not set, the
  /// matcher will ignore the nullability of the field.
  FieldMatcher withField(String fieldName, {bool? isNullable});

  /// Chains a [MethodMatcher] that checks if the class contains a method with a
  /// specific name.
  ///
  /// Use [isOverride] to match overridden methods. If the value is not set, the
  /// matcher will ignore the override status of the method.
  ///
  /// Use [returnType] to match the return type of the method. The value should
  /// be a string representation of the return type. For example, `void`, `int`
  /// or `Map<String, User>?`. If the value is not set, the matcher will ignore
  /// the return type of the method.
  MethodMatcher withMethod(
    String methodName, {
    bool? isOverride,
    String? returnType,
  });

  /// Chains a [ConstructorMatcher] that checks if the class contains a named
  /// constructor.
  ///
  /// [constructorName] is the name of the constructor to match and can not be
  /// empty.
  ///
  /// Use [isFactory] to match factory constructors. If the value is not set, the
  /// matcher will ignore the factory status of the constructor.
  ConstructorMatcher withNamedConstructor(
    String constructorName, {
    bool? isFactory,
  });

  /// Chains a [ConstructorMatcher] that checks if the class contains an unnamed
  /// constructor.
  ///
  /// Use [isFactory] to match factory constructors. If the value is not set, the
  /// matcher will ignore the factory status of the constructor.
  ConstructorMatcher withUnnamedConstructor({
    bool? isFactory,
  });
}

/// A chainable matcher that matches a constructor in a compilation unit.
abstract interface class ConstructorMatcher {
  /// Chains a [ParameterMatcher] that checks if the constructor contains a
  /// parameter with a specific name that is initialized with an initializer.
  ///
  /// Use [isRequired] to match required parameters. If the value is not set, the
  /// matcher will ignore the requirement of the parameter.
  ParameterMatcher withInitializerParameter(
    String parameterName,
    Initializer initializer, {
    bool? isRequired,
  });

  /// Chains a [ParameterMatcher] that checks if the constructor contains a parameter
  /// with a specific name.
  ///
  /// Use [isRequired] to match required parameters. If the value is not set, the
  /// matcher will ignore the requirement of the parameter.
  ///
  /// Use [withTypedParameter] or has [withInitializerParameter] to match typed or
  /// initializer parameters.
  ParameterMatcher withParameter(
    String parameterName, {
    bool? isRequired,
  });

  /// Chains an [SuperInitializerMatcher] that checks if the constructor has an
  /// initializer.
  SuperInitializerMatcher withSuperInitializer();

  /// Chains a [ParameterMatcher] that checks if the constructor contains a
  /// typed parameter with a specific name.
  ///
  /// Use [isRequired] to match required parameters. If the value is not set, the
  /// matcher will ignore the requirement of the parameter.
  ParameterMatcher withTypedParameter(
    String parameterName,
    String type, {
    bool? isRequired,
  });
}

/// A chainable matcher that matches the extension in a compilation unit.
abstract interface class ExtendsMatcher {}

/// A chainable matcher that matches a field in a compilation unit.
abstract interface class FieldMatcher {}

class FormattedCompilationUnit {
  final CompilationUnit compilationUnit;

  FormattedCompilationUnit(this.compilationUnit);

  @override
  String toString() {
    return DartFormatter().format(compilationUnit.toSource());
  }
}

/// Initializer types for parameters.
enum Initializer {
  /// The parameter is initialized with `this`.
  this_,

  /// The parameter is initialized with `super`.
  super_;

  /// Returns the token representation of the initializer.
  String toToken() {
    switch (this) {
      case Initializer.this_:
        return 'this';
      case Initializer.super_:
        return 'super';
    }
  }
}

/// A matcher that can be chained to a [ClassMatcher] to check if the class
/// contains a method that matches certain criteria.
abstract interface class MethodMatcher {
  /// Chains a [ParameterMatcher] that checks if the constructor contains a parameter
  /// with a specific name.
  ///
  /// Use [isRequired] to match required parameters. If the value is not set, the
  /// matcher will ignore the requirement of the parameter.
  ///
  /// Use [withTypedParameter] or has [withInitializerParameter] to match typed or
  /// initializer parameters.
  ParameterMatcher withParameter(
    String parameterName, {
    String? type,
    bool? isRequired,
  });
}

/// A chainable matcher that matches a parameter in a compilation unit.
abstract interface class ParameterMatcher {}

/// A chainable matcher that matches a super initializer in a compilation unit.
abstract interface class SuperInitializerMatcher {
  /// Chains an [ArgumentMatcher] that checks if the super initializer is called
  /// with a specific literal argument.
  ArgumentMatcher withArgument(String value);

  /// Chains an [ArgumentMatcher] that checks if the super initializer is called
  /// with a specific argument for a named parameter.
  ///
  /// Use [parameterName] to match the name of the super parameter. If the value
  /// is not set, the matcher will ignore the name of the parameter.
  ArgumentMatcher withNamedArgument(String value, String parameterName);

  /// Chains an [ArgumentMatcher] that checks if the super initializer is called
  /// with a specific argument for a positional parameter.
  ArgumentMatcher withPositionalArgument(String value);
}
