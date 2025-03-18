import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_style/dart_style.dart';
import 'package:test/test.dart';

part 'compilation_unit_matcher/class_matcher/class_matcher.dart';

/// A custom matcher that checks if a CompilationUnit contains a class with a
/// specific name.
///
/// The matcher can also be negated:
/// ```dart
/// expect(compilationUnit, isNot(containsClass('NonExistentClass')));
/// ```
ClassMatcher containsClass(String className) => _ClassMatcherImpl._(className);

/// Parses a string of Dart code into a FormattedCompilationUnit.
FormattedCompilationUnit parseCode(String code) =>
    FormattedCompilationUnit(parseString(content: code).unit);

/// A matcher that checks if a CompilationUnit contains a class that matches
/// certain criteria.
abstract interface class ClassMatcher {}

class FormattedCompilationUnit {
  final CompilationUnit compilationUnit;

  FormattedCompilationUnit(this.compilationUnit);

  @override
  String toString() {
    return DartFormatter().format(compilationUnit.toSource());
  }
}
