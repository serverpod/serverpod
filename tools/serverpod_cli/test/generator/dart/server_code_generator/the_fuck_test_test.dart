import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/test_util/compilation_unit_helpers.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath =
      path.join('lib', 'src', 'generated', '$testClassFileName.dart');
  group('Given generated code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          //.withSimpleField('name', 'String')
          //.withSimpleField('age', 'int', nullable: true)
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    test('test name', () {
      expect(['a', 'b'], hasLength(1));
    });

    test('test name', () {
      expect(compilationUnit, hasClass('Example'));
      expectClass(compilationUnit, 'Example');
    });

    test('test name', () {
      // expectClassDeclaration(
      //     compilationUnit, 'class Example extends SerializableEntity {}');

      var baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName,
      );
      expect(baseClass, hasField('name'));

      // expectClass(compilationUnit, 'ExampleImpl');
    });
  });
}

class ClassFields {
  final ClassDeclaration classDeclaration;
  ClassFields(this.classDeclaration);

  @override
  String toString() {
    return classDeclaration.members
        .whereType<FieldDeclaration>()
        .map((e) => e.toSource())
        .toString();
  }
}

ClassFields? classFields(ClassDeclaration? classDeclaration) {
  return classDeclaration != null ? ClassFields(classDeclaration) : null;
}

Matcher hasClass(Object? matcher) => _HasClass(wrapMatcher(matcher));

class _HasClass extends Matcher {
  final Matcher _matcher;
  _HasClass(this._matcher);

  @override
  Description describe(Description description) {
    return description;
  }

  @override
  bool matches(Object? item, Map matchState) {
    if (Object is! CompilationUnit) return false;

    var classes =
        (item as CompilationUnit).declarations.whereType<ClassDeclaration>();

    if (classes.isEmpty) return false;

    var matches = classes.where((c) => c.name.toString() == 'Example');

    if (matches.isEmpty) return false;

    return _matcher.matches('Example', matchState);
  }

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! CompilationUnit) {
      return mismatchDescription.add("is not a 'CompilationUnit'");
    }

    var classes =
        (item as CompilationUnit).declarations.whereType<ClassDeclaration>();

    if (classes.isEmpty) {
      return mismatchDescription.add('has no classes');
    }

    var matches = classes.where((c) => c.name.toString() == 'Example');

    if (matches.isEmpty) {
      return mismatchDescription.add(
          'has the classes ${classes.map((e) => e.name.toString())} where none matchers ${_matcher.toString()}');
    }

    return mismatchDescription;
  }
}

Matcher hasField(Object? matcher) => _HasField(wrapMatcher(matcher));

class _HasField extends Matcher {
  final Matcher _matcher;
  _HasField(this._matcher);

  @override
  Description describe(Description description) {
    return description.add('a field name of ').addDescriptionOf(_matcher);
  }

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! ClassDeclaration) {
      return mismatchDescription.add("is not a 'ClassDeclaration'");
    }

    var fields = item.members.whereType<FieldDeclaration>();

    if (fields.isEmpty) {
      return mismatchDescription.add('has no fields');
    }

    var matches =
        fields.where((f) => f.fields.variables.any((e) => e.name == 'name'));

    if (matches.isEmpty) {
      return mismatchDescription
          .add('has no fields named ${_matcher.toString()}');
    }

    return mismatchDescription;
  }

  @override
  bool matches(Object? item, Map matchState) {
    if (item is! ClassDeclaration) return false;

    var fields = item.members.whereType<FieldDeclaration>();
    return _matcher.matches(fields, matchState);
  }
}

/**
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 */

void expectField(ClassDeclaration? actual, String fieldName) {
  if (actual == null) fail('null....');
  var fields = actual.members.whereType<FieldDeclaration>();

  var toFindField = fields.where((element) {
    return element.fields.variables.first.name.toString() == fieldName;
  });

  fields.forEach((element) {
    print(element.toSource());
  });

  if (toFindField.isEmpty) {
    failed(
      fieldName,
      fields.map((e) => e.fields.variables.first.name),
      reason: 'The expected field was not found.',
    );
  }
}

void expectClassDeclaration(CompilationUnit? actual, String classDeclaration) {
  var expectedDeclaration = parseString(content: classDeclaration).unit;

  if (actual == null) {
    fail('is null...');
  }

  var classes = actual.declarations.whereType<ClassDeclaration>();

  var expected = expectedDeclaration.declarations.whereType<ClassDeclaration>();
  if (expected.isEmpty) throw Exception('You fucked up.');

  var source = expected.first.toSource();

  var match = classes.where((c) => c.name == expected.first.name);

  print(classes.first.toSource());

  print(source);
}

void expectClass(CompilationUnit? actual, String className) {
  var classes = actual?.declarations.whereType<ClassDeclaration>();

  var toFindClass = classes?.where((element) {
    return element.name.toString() == className;
  });

  if (toFindClass == null || toFindClass.isEmpty) {
    failed(
      className,
      classes?.map((e) => e.name),
      reason: 'The expected class was not found.',
    );
  }
}

Never failed(String expected, Object? actual, {String? reason}) {
  var buffer = StringBuffer();
  buffer.writeln('Expected: $expected');
  buffer.writeln('  Actual: ${actual.toString()}');
  if (reason != null) buffer.writeln('  Reason: $reason');
  fail(buffer.toString());
}

/// Returns a matcher that matches if an object has a length property
/// that matches [matcher].
Matcher hasLength(Object? matcher) => _HasLength(wrapMatcher(matcher));

class _HasLength extends Matcher {
  final Matcher _matcher;
  const _HasLength(this._matcher);

  @override
  bool matches(Object? item, Map matchState) {
    try {
      final length = (item as dynamic).length;
      return _matcher.matches(length, matchState);
    } catch (e) {
      return false;
    }
  }

  @override
  Description describe(Description description) =>
      description.add('an object with length of ').addDescriptionOf(_matcher);

  @override
  Description describeMismatch(Object? item, Description mismatchDescription,
      Map matchState, bool verbose) {
    try {
      final length = (item as dynamic).length;
      return mismatchDescription.add('has length of ').addDescriptionOf(length);
    } catch (e) {
      return mismatchDescription.add('has no length property');
    }
  }
}
