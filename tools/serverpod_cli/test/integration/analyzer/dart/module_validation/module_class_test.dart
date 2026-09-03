import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/modules_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../../../test_util/endpoint_validation_helpers.dart';

var testProjectDirectory = Directory.systemTemp.createTempSync('cli_test_');

void main() {
  setUpAll(() async {
    await createTestEnvironment(testProjectDirectory);
  });

  tearDownAll(() {
    testProjectDirectory.deleteSync(recursive: true);
  });

  group('Given no Module class when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<ModuleDefinition> definitions;

    setUpAll(() async {
      var dartFile = File(path.join(testDirectory.path, 'empty.dart'));
      dartFile.createSync(recursive: true);
      dartFile.writeAsStringSync('''
class NotAModule {}
''');

      var analyzer = ModulesAnalyzer(directory: testDirectory);
      definitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then no module definitions are created.', () {
      expect(definitions, isEmpty);
    });

    test('then selectPackageModule returns null.', () {
      expect(ModulesAnalyzer.selectPackageModule(definitions), isNull);
    });
  });

  group('Given one concrete Module class when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<ModuleDefinition> definitions;

    setUpAll(() async {
      var dartFile = File(path.join(testDirectory.path, 'my_module.dart'));
      dartFile.createSync(recursive: true);
      dartFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class MyModule extends Module {
  @override
  Future<void> onStartup(Session session) async {}
}
''');

      var analyzer = ModulesAnalyzer(directory: testDirectory);
      definitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then a module definition is created.', () {
      expect(definitions, hasLength(1));
      expect(definitions.first.className, 'MyModule');
      expect(definitions.first.isAbstract, isFalse);
    });

    test('then selectPackageModule returns the definition.', () {
      expect(
        ModulesAnalyzer.selectPackageModule(definitions)?.className,
        'MyModule',
      );
    });
  });

  group('Given two concrete Module classes when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<ModuleDefinition> definitions;

    setUpAll(() async {
      var first = File(path.join(testDirectory.path, 'first_module.dart'));
      first.createSync(recursive: true);
      first.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class FirstModule extends Module {}
''');

      var second = File(path.join(testDirectory.path, 'second_module.dart'));
      second.createSync(recursive: true);
      second.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class SecondModule extends Module {}
''');

      var analyzer = ModulesAnalyzer(directory: testDirectory);
      definitions = await analyzer.analyze(collector: collector);
    });

    test('then a severe cardinality error is reported.', () {
      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.any(
          (e) => e.message.contains(
            'A package may define at most one Module class',
          ),
        ),
        isTrue,
      );
    });

    test('then selectPackageModule returns null.', () {
      expect(ModulesAnalyzer.selectPackageModule(definitions), isNull);
    });
  });

  group('Given only an abstract Module subclass when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<ModuleDefinition> definitions;

    setUpAll(() async {
      var dartFile = File(path.join(testDirectory.path, 'base_module.dart'));
      dartFile.createSync(recursive: true);
      dartFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

abstract class BaseModule extends Module {}
''');

      var analyzer = ModulesAnalyzer(directory: testDirectory);
      definitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then an abstract module definition is created.', () {
      expect(definitions, hasLength(1));
      expect(definitions.first.isAbstract, isTrue);
    });

    test('then selectPackageModule returns null.', () {
      expect(ModulesAnalyzer.selectPackageModule(definitions), isNull);
    });
  });

  group('Given a non-constructable concrete Module when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    setUpAll(() async {
      var dartFile = File(path.join(testDirectory.path, 'bad_module.dart'));
      dartFile.createSync(recursive: true);
      dartFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class BadModule extends Module {
  BadModule._();
}
''');

      var analyzer = ModulesAnalyzer(directory: testDirectory);
      await analyzer.analyze(collector: collector);
    });

    test('then a constructability error is reported.', () {
      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.any(
          (e) => e.message.contains('must be default-constructable'),
        ),
        isTrue,
      );
    });
  });
}
