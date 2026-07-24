import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/custom_class_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../../../test_util/custom_class_validation_helpers.dart';

var testSharedProjectDirectory = Directory.systemTemp.createTempSync(
  'cli_test_',
);

void main() {
  setUpAll(() async {
    await createTestSharedPackageEnvironment(testSharedProjectDirectory);
  });

  tearDownAll(() {
    testSharedProjectDirectory.deleteSync(recursive: true);
  });

  group('Given a CustomClassAnalyzer with tracked extra classes', () {
    late File extraClassFile;
    late List<TypeDefinition> extraClasses;
    late CustomClassAnalyzer analyzer;
    var trackedDirectory = Directory(
      p.join(testSharedProjectDirectory.path, const Uuid().v4()),
    );

    setUp(() async {
      extraClassFile = File(p.join(trackedDirectory.path, 'user_id.dart'));
      extraClassFile.createSync(recursive: true);
      await extraClassFile.writeAsString('''
class UserId {
  final int id;
  UserId(this.id);
  int toJson() => id;
  factory UserId.fromJson(dynamic json) => UserId(json);
  UserId copyWith({int? id}) => UserId(id ?? this.id);
}
''');

      extraClasses = [
        TypeDefinition(
          className: 'UserId',
          nullable: false,
          sourcePath: extraClassFile.path,
          packageRoot: testSharedProjectDirectory.path,
          customClass: true,
        ),
      ];

      analyzer = CustomClassAnalyzer(testSharedProjectDirectory);

      await analyzer.analyze(
        collector: CodeGenerationCollector(),
        extraClasses: extraClasses,
      );
    });

    test(
      'when updating with a file unrelated to extra classes then false is returned.',
      () async {
        var unrelatedFile = File(
          p.join(trackedDirectory.path, 'unrelated.dart'),
        );
        await unrelatedFile.create();

        await expectLater(
          analyzer.updateFileContexts({
            unrelatedFile.path,
          }, extraClasses),
          completion(false),
        );
      },
    );

    test(
      'when updating with a modified extra class file then true is returned.',
      () async {
        await extraClassFile.writeAsString('''
class UserId {
  final int id;
  UserId(this.id);
  // Change 'toJson' return type to String
  String toJson() => id.toString();
  factory UserId.fromJson(dynamic json) => UserId(int.parse(json));
  UserId copyWith({int? id}) => UserId(id ?? this.id);
}
''');

        await expectLater(
          analyzer.updateFileContexts({
            extraClassFile.path,
          }, extraClasses),
          completion(true),
        );
      },
    );

    test(
      'when an extra class file is deleted then true is returned.',
      () async {
        await extraClassFile.delete();

        await expectLater(
          analyzer.updateFileContexts({
            extraClassFile.path,
          }, extraClasses),
          completion(true),
        );
      },
    );

    test(
      'when a file with syntax errors is updated then true is returned.',
      () async {
        await extraClassFile.writeAsString('invalid dart code {');

        await expectLater(
          analyzer.updateFileContexts({
            extraClassFile.path,
          }, extraClasses),
          completion(true),
        );
      },
    );
  });

  group(
    'Given a tracked and analyzed extra class file with a persistently invalid dart syntax',
    () {
      late File extraClassFile;
      late List<TypeDefinition> extraClasses;
      late CustomClassAnalyzer analyzer;
      late File nonCustomClass;

      var trackedDirectory = Directory(
        p.join(testSharedProjectDirectory.path, const Uuid().v4()),
      );

      setUp(() async {
        extraClassFile = File(p.join(trackedDirectory.path, 'user_id.dart'));
        extraClassFile.createSync(recursive: true);
        // Class is missing closing brackets
        await extraClassFile.writeAsString('''
class UserId {
  final int id;
  UserId(this.id);
  int toJson() { 
    return id;
  }
  factory UserId.fromJson(dynamic json) => UserId(json);
  UserId copyWith({int? id}) => UserId(id ?? this.id);
''');

        extraClasses = [
          TypeDefinition(
            className: 'UserId',
            nullable: false,
            sourcePath: extraClassFile.path,
            packageRoot: testSharedProjectDirectory.path,
            customClass: true,
          ),
        ];

        analyzer = CustomClassAnalyzer(
          testSharedProjectDirectory,
        );

        await analyzer.analyze(
          collector: CodeGenerationCollector(),
          extraClasses: extraClasses,
        );
      });

      test(
        'when the file context is updated with an unrelated non custom class file while the error persists '
        'then false is returned.',
        () async {
          nonCustomClass = File(
            p.join(trackedDirectory.path, 'helper.dart'),
          );
          nonCustomClass.createSync(recursive: true);
          nonCustomClass.writeAsStringSync('''
class HelperClass {}
''');

          await expectLater(
            analyzer.updateFileContexts({nonCustomClass.path}, extraClasses),
            completion(false),
          );
        },
      );
    },
  );

  group(
    'Given a tracked and analyzed extra class file that depends on invalid dart file',
    () {
      late File extraClassFile;
      late List<TypeDefinition> extraClasses;
      late CustomClassAnalyzer analyzer;
      late File invalidDartFile;

      var trackedDirectory = Directory(
        p.join(testSharedProjectDirectory.path, const Uuid().v4()),
      );

      setUp(() async {
        extraClassFile = File(p.join(trackedDirectory.path, 'user_id.dart'));
        extraClassFile.createSync(recursive: true);

        await extraClassFile.writeAsString('''
import 'invalid_dart.dart';

class UserId {
  final int id;
  UserId(this.id);
  int toJson() { 
    InvalidClass example = InvalidClass();
    return id;
  }
  factory UserId.fromJson(dynamic json) => UserId(json);
  UserId copyWith({int? id}) => UserId(id ?? this.id);
  }
''');

        invalidDartFile = File(
          p.join(trackedDirectory.path, 'invalid_dart.dart'),
        );
        invalidDartFile.createSync(recursive: true);
        // Class keyword is combined with class name
        invalidDartFile.writeAsStringSync('''
classInvalidClass {}
''');

        extraClasses = [
          TypeDefinition(
            className: 'UserId',
            nullable: false,
            sourcePath: extraClassFile.path,
            packageRoot: testSharedProjectDirectory.path,
            customClass: true,
          ),
        ];

        analyzer = CustomClassAnalyzer(
          testSharedProjectDirectory,
        );

        await analyzer.analyze(
          collector: CodeGenerationCollector(),
          extraClasses: extraClasses,
        );
      });

      test(
        'when the file context is updated with a fix for the invalid dart file '
        'then true is returned.',
        () async {
          invalidDartFile.writeAsStringSync('''
class InvalidClass {}
''');

          await expectLater(
            analyzer.updateFileContexts({invalidDartFile.path}, extraClasses),
            completion(true),
          );
        },
      );
    },
  );
}
