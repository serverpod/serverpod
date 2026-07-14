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

  group('Given a class missing "fromJson()" method', () {
    late CustomClassAnalyzer analyzer;
    late CodeGenerationCollector collector;

    var trackedDirectory = Directory(
      p.join(testSharedProjectDirectory.path, const Uuid().v4()),
    );

    setUp(() {
      collector = CodeGenerationCollector();
      analyzer = CustomClassAnalyzer(testSharedProjectDirectory);
    });

    test('then a validation error is reported that there is a missing a "fromJson" method.', () async {
      var extraClassFile = File(
        p.join(trackedDirectory.path, 'no_from_json.dart'),
      );
      extraClassFile.createSync(recursive: true);
      extraClassFile.writeAsStringSync(
        'class NoFromJson { int toJson() => 1; copyWith() => this; }',
      );

      await analyzer.analyze(
        collector: collector,
        extraClasses: [
          TypeDefinition(
            className: 'NoFromJson',
            nullable: false,
            sourcePath: extraClassFile.path,
            packageRoot: testSharedProjectDirectory.path,
            customClass: true,
          ),
        ],
      );
      expect(collector.errors.isNotEmpty, isTrue);
      expect(
        collector.errors.any((e) => e.message.contains('missing a "fromJson"')),
        isTrue,
      );
    });
  });

  group('Given a class missing "toJson()" method', () {
    late CustomClassAnalyzer analyzer;
    late CodeGenerationCollector collector;

    var trackedDirectory = Directory(
      p.join(testSharedProjectDirectory.path, const Uuid().v4()),
    );

    setUp(() {
      collector = CodeGenerationCollector();
      analyzer = CustomClassAnalyzer(testSharedProjectDirectory);
    });

    test('then a validation error is reported that there is a missing a "toJson()" method.', () async {
      var extraClassFile = File(p.join(trackedDirectory.path, 'no_to_json.dart'));
      extraClassFile.createSync(recursive: true);
      extraClassFile.writeAsStringSync('''
class NoToJson {
  factory NoToJson.fromJson(dynamic json) => throw UnimplementedError();
  NoToJson copyWith() => this;
}
''');

      await analyzer.analyze(
        collector: collector,
        extraClasses: [
          TypeDefinition(
            className: 'NoToJson',
            nullable: false,
            sourcePath: extraClassFile.path,
            packageRoot: testSharedProjectDirectory.path,
            customClass: true,
          ),
        ],
      );

      expect(collector.errors.isNotEmpty, isTrue);
      expect(
        collector.errors.any((e) => e.message.contains('missing a "toJson()" method')),
        isTrue,
      );
    });
  });

  group('Given a class with an async Future "toJson()" method', () {
    late CustomClassAnalyzer analyzer;
    late CodeGenerationCollector collector;
    var trackedDirectory = Directory(
      p.join(testSharedProjectDirectory.path, const Uuid().v4()),
    );

    setUp(() {
      collector = CodeGenerationCollector();
      analyzer = CustomClassAnalyzer(testSharedProjectDirectory);
    });

    test('then a validation error is reported that "toJson()" method return type must be synchronous.', () async {
      var extraClassFile = File(p.join(trackedDirectory.path, 'future_to_json.dart'));
      extraClassFile.createSync(recursive: true);
      extraClassFile.writeAsStringSync('''
import 'dart:async';
class FutureToJson {
  Future<int> toJson() async => 1;
  factory FutureToJson.fromJson(dynamic json) => throw UnimplementedError();
  FutureToJson copyWith() => this;
}
''');

      await analyzer.analyze(
        collector: collector,
        extraClasses: [
          TypeDefinition(
            className: 'FutureToJson',
            nullable: false,
            sourcePath: extraClassFile.path,
            packageRoot: testSharedProjectDirectory.path,
            customClass: true,
          ),
        ],
      );

      expect(
        collector.errors.any((e) => e.message.contains('must be synchronous')),
        isTrue,
      );
    });
  });

  group('Given a class with an async Stream "toJson()" method', () {
    late CustomClassAnalyzer analyzer;
    late CodeGenerationCollector collector;
    var trackedDirectory = Directory(
      p.join(testSharedProjectDirectory.path, const Uuid().v4()),
    );

    setUp(() {
      collector = CodeGenerationCollector();
      analyzer = CustomClassAnalyzer(testSharedProjectDirectory);
    });

    test('then a validation error is reported that "toJson()" method return type must be synchronous.', () async {
      var extraClassFile = File(p.join(trackedDirectory.path, 'stream_to_json.dart'));
      extraClassFile.createSync(recursive: true);
      extraClassFile.writeAsStringSync('''
import 'dart:async';
class StreamToJson {
  Stream<int> toJson() async* { yield 1; }
  factory StreamToJson.fromJson(dynamic json) => throw UnimplementedError();
  StreamToJson copyWith() => this;
}
''');

      await analyzer.analyze(
        collector: collector,
        extraClasses: [
          TypeDefinition(
            className: 'StreamToJson',
            nullable: false,
            sourcePath: extraClassFile.path,
            packageRoot: testSharedProjectDirectory.path,
            customClass: true,
          ),
        ],
      );

      expect(
        collector.errors.any((e) => e.message.contains('must be synchronous')),
        isTrue,
      );
    });
  });

  group('Given a class with a "toJson()" method returning void', () {
    late CustomClassAnalyzer analyzer;
    late CodeGenerationCollector collector;
    var trackedDirectory = Directory(
      p.join(testSharedProjectDirectory.path, const Uuid().v4()),
    );

    setUp(() {
      collector = CodeGenerationCollector();
      analyzer = CustomClassAnalyzer(testSharedProjectDirectory);
    });

    test('then a validation error is reported that "toJson()" method cannot return void.', () async {
      var extraClassFile = File(p.join(trackedDirectory.path, 'void_to_json.dart'));
      extraClassFile.createSync(recursive: true);
      extraClassFile.writeAsStringSync('''
class VoidToJson {
  void toJson() {}
  factory VoidToJson.fromJson(dynamic json) => throw UnimplementedError();
  VoidToJson copyWith() => this;
}
''');

      await analyzer.analyze(
        collector: collector,
        extraClasses: [
          TypeDefinition(
            className: 'VoidToJson',
            nullable: false,
            sourcePath: extraClassFile.path,
            packageRoot: testSharedProjectDirectory.path,
            customClass: true,
          ),
        ],
      );

      expect(
        collector.errors.any((e) => e.message.contains('cannot return void')),
        isTrue,
      );
    });
  });

  group('Given a class with a "toJson()" method returning an unsupported type', () {
    late CustomClassAnalyzer analyzer;
    late CodeGenerationCollector collector;
    var trackedDirectory = Directory(
      p.join(testSharedProjectDirectory.path, const Uuid().v4()),
    );

    setUp(() {
      collector = CodeGenerationCollector();
      analyzer = CustomClassAnalyzer(testSharedProjectDirectory);
    });

    test('then a validation error is reported that "toJson()" method return type is not supported.', () async {
      var extraClassFile = File(p.join(trackedDirectory.path, 'unsupported_to_json.dart'));
      extraClassFile.createSync(recursive: true);
      // 'Object' is not a supported type and triggers a FromDartTypeClassNameException
      extraClassFile.writeAsStringSync('''
class UnsupportedToJson {
  Object toJson() => () {};
  factory UnsupportedToJson.fromJson(dynamic json) => throw UnimplementedError();
  UnsupportedToJson copyWith() => this;
}
''');

      await analyzer.analyze(
        collector: collector,
        extraClasses: [
          TypeDefinition(
            className: 'UnsupportedToJson',
            nullable: false,
            sourcePath: extraClassFile.path,
            packageRoot: testSharedProjectDirectory.path,
            customClass: true,
          ),
        ],
      );

      expect(
        collector.errors.any((e) => e.message.contains('is not a supported "toJson()" return type')),
        isTrue,
      );
    });
  });
}
