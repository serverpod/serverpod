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

  group('CustomClassAnalyzer Type Extraction', () {
    late CustomClassAnalyzer analyzer;
    late CodeGenerationCollector collector;

    var trackedDirectory = Directory(
      p.join(testSharedProjectDirectory.path, const Uuid().v4()),
    );

    setUp(() {
      collector = CodeGenerationCollector();
      analyzer = CustomClassAnalyzer(testSharedProjectDirectory);
    });

    test('Given toJson returns int then extracts bigint type', () async {
      createClass(trackedDirectory, 'UserId', 'int', body: '1');
      var extraClasses = [
        TypeDefinition(
          className: 'UserId',
          nullable: false,
          sourcePath: p.join(trackedDirectory.path, 'userid.dart'),
          customClass: true,
        ),
      ];

      var results = await analyzer.analyze(
        collector: collector,
        extraClasses: extraClasses,
      );
      expect(results['UserId']?.databaseType, 'bigint');
    });

    test('Given toJson returns String then extracts text type', () async {
      createClass(trackedDirectory, 'UserUuid', 'String', body: '"abc"');
      var extraClasses = [
        TypeDefinition(
          className: 'UserUuid',
          nullable: false,
          sourcePath: p.join(trackedDirectory.path, 'useruuid.dart'),
          customClass: true,
        ),
      ];

      var results = await analyzer.analyze(
        collector: collector,
        extraClasses: extraClasses,
      );
      expect(results['UserUuid']?.databaseType, 'text');
    });

    test('Given toJson returns List<String> then extracts json type', () async {
      createClass(trackedDirectory, 'Tags', 'List<String>', body: '[]');
      var extraClasses = [
        TypeDefinition(
          className: 'Tags',
          nullable: false,
          sourcePath: p.join(trackedDirectory.path, 'tags.dart'),
          customClass: true,
        ),
      ];

      var results = await analyzer.analyze(
        collector: collector,
        extraClasses: extraClasses,
      );
      expect(results['Tags']?.databaseType, 'json');
    });

    test(
      'Given invalid toJson return type (void) then reports error and returns null type',
      () async {
        createClass(trackedDirectory, 'Broken', 'void', body: '');
        var extraClasses = [
          TypeDefinition(
            className: 'Broken',
            nullable: false,
            sourcePath: p.join(trackedDirectory.path, 'broken.dart'),
            customClass: true,
          ),
        ];

        var results = await analyzer.analyze(
          collector: collector,
          extraClasses: extraClasses,
        );
        expect(collector.errors, isNotEmpty);
        expect(results['Broken'], isNull);
      },
    );

    test('Given missing toJson then returns null type', () async {
      var extraClassFile = File(p.join(trackedDirectory.path, 'missing.dart'));
      extraClassFile.createSync(recursive: true);
      extraClassFile.writeAsStringSync(
        'class Missing { factory Missing.fromJson(d) => throw UnimplementedError(); }',
      );

      var extraClasses = [
        TypeDefinition(
          className: 'Missing',
          nullable: false,
          sourcePath: extraClassFile.path,
          customClass: true,
        ),
      ];

      var results = await analyzer.analyze(
        collector: collector,
        extraClasses: extraClasses,
      );
      expect(results['Missing'], isNull);
    });
  });
}

void createClass(
  Directory directory,
  String className,
  String returnType, {
  String? body,
}) {
  var extraClassFile = File(
    p.join(directory.path, '${className.toLowerCase()}.dart'),
  );
  extraClassFile.createSync(recursive: true);
  extraClassFile.writeAsStringSync('''
class $className {
  $returnType toJson() => ${body ?? 'throw UnimplementedError()'};
  factory $className.fromJson(dynamic json) => throw UnimplementedError();
  $className copyWith() => throw UnimplementedError();
}
''');
}
