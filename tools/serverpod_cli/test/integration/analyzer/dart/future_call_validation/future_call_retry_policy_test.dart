import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/future_calls_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';
import '../../../../test_util/builders/type_definition_builder.dart';
import '../../../../test_util/endpoint_validation_helpers.dart';
import '../../../../test_util/file_system_entity_helpers.dart';

final config = GeneratorConfigBuilder().build();
late Directory testProjectDirectory;

/// Writes [files] to a new directory in the test project and returns it.
Directory _createDirectoryWithFiles(Map<String, String> files) {
  var directory = Directory(
    path.join(testProjectDirectory.path, const Uuid().v4()),
  );
  for (var MapEntry(key: fileName, value: contents) in files.entries) {
    File(path.join(directory.path, fileName))
      ..createSync(recursive: true)
      ..writeAsStringSync(contents);
  }
  return directory;
}

void main() {
  setUpAll(() async {
    testProjectDirectory = Directory.systemTemp.createTempSync('cli_test_');
    await createTestEnvironment(testProjectDirectory);
  });

  tearDownAll(() async {
    await testProjectDirectory.deleteWithRetry(recursive: true);
  });

  group(
    'Given retry policy classes with a fromJson constructor whose only positional parameter is a Map<String, dynamic>,'
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();
      late FutureCallsAnalyzer analyzer;

      setUpAll(() async {
        var directory = _createDirectoryWithFiles({
          'retry_policies.dart': '''
import 'package:serverpod/serverpod.dart';

abstract class _TestPolicy extends FutureCallRetryPolicy {
  @override
  Duration? nextDelay(FutureCallRetryContext context) => null;

  @override
  Map<String, dynamic> toJson() => {};
}

class FactoryPolicy extends _TestPolicy {
  FactoryPolicy();
  factory FactoryPolicy.fromJson(Map<String, dynamic> json) => FactoryPolicy();
}

class GenerativePolicy extends _TestPolicy {
  GenerativePolicy.fromJson(Map<String, dynamic> json);
}

class OptionalNamedParameterPolicy extends _TestPolicy {
  OptionalNamedParameterPolicy.fromJson(
    Map<String, dynamic> json, {
    int extra = 0,
  });
}
''',
        });

        analyzer = FutureCallsAnalyzer(directory: directory);
        await analyzer.analyze(
          collector: collector,
          analyzedModels: StatefulAnalyzer(config, []).validateAll(),
        );
      });

      test('then no errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then every concrete retry policy class is registered.', () {
        expect(
          analyzer.retryPolicies.map((type) => type.className),
          unorderedEquals([
            'FactoryPolicy',
            'GenerativePolicy',
            'OptionalNamedParameterPolicy',
          ]),
        );
      });
    },
  );

  group(
    'Given abstract and sealed retry policy classes without a fromJson constructor,'
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();
      late FutureCallsAnalyzer analyzer;

      setUpAll(() async {
        var directory = _createDirectoryWithFiles({
          'retry_policies.dart': '''
import 'package:serverpod/serverpod.dart';

abstract class AbstractPolicy extends FutureCallRetryPolicy {}

sealed class SealedPolicy extends FutureCallRetryPolicy {}
''',
        });

        analyzer = FutureCallsAnalyzer(directory: directory);
        await analyzer.analyze(
          collector: collector,
          analyzedModels: StatefulAnalyzer(config, []).validateAll(),
        );
      });

      test('then no errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then no retry policy is registered.', () {
        expect(analyzer.retryPolicies, isEmpty);
      });
    },
  );

  group(
    'Given a retry policy class that extends another retry policy class,'
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();
      late FutureCallsAnalyzer analyzer;

      setUpAll(() async {
        var directory = _createDirectoryWithFiles({
          'base_policy.dart': '''
import 'package:serverpod/serverpod.dart';

class BasePolicy extends FutureCallRetryPolicy {
  BasePolicy();
  factory BasePolicy.fromJson(Map<String, dynamic> json) => BasePolicy();

  @override
  Duration? nextDelay(FutureCallRetryContext context) => null;

  @override
  Map<String, dynamic> toJson() => {};
}
''',
          'sub_policy.dart': '''
import 'base_policy.dart';

class SubPolicy extends BasePolicy {
  SubPolicy();
  factory SubPolicy.fromJson(Map<String, dynamic> json) => SubPolicy();
}
''',
        });

        analyzer = FutureCallsAnalyzer(directory: directory);
        await analyzer.analyze(
          collector: collector,
          analyzedModels: StatefulAnalyzer(config, []).validateAll(),
        );
      });

      test('then no errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then both classes are registered.', () {
        expect(
          analyzer.retryPolicies.map((type) => type.className),
          unorderedEquals(['SubPolicy', 'BasePolicy']),
        );
      });
    },
  );

  group(
    'Given retry policy classes whose fromJson constructor is missing or has the wrong shape,'
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();
      late FutureCallsAnalyzer analyzer;

      setUpAll(() async {
        var directory = _createDirectoryWithFiles({
          'retry_policies.dart': '''
import 'package:serverpod/serverpod.dart';

class BasePolicy extends FutureCallRetryPolicy {
  BasePolicy();
  factory BasePolicy.fromJson(Map<String, dynamic> json) => BasePolicy();

  @override
  Duration? nextDelay(FutureCallRetryContext context) => null;

  @override
  Map<String, dynamic> toJson() => {};
}

class MissingFromJsonPolicy extends BasePolicy {}

class NoParameterPolicy extends BasePolicy {
  NoParameterPolicy.fromJson();
}

class NamedParameterPolicy extends BasePolicy {
  NamedParameterPolicy.fromJson({required Map<String, dynamic> json});
}

class StringPolicy extends BasePolicy {
  StringPolicy.fromJson(String json);
}

class UntypedMapPolicy extends BasePolicy {
  UntypedMapPolicy.fromJson(Map json);
}

class NullableMapPolicy extends BasePolicy {
  NullableMapPolicy.fromJson(Map<String, dynamic>? json);
}

class ObjectPolicy extends BasePolicy {
  ObjectPolicy.fromJson(Object? json);
}

class DynamicPolicy extends BasePolicy {
  DynamicPolicy.fromJson(dynamic json);
}

class ExtraRequiredPositionalPolicy extends BasePolicy {
  ExtraRequiredPositionalPolicy.fromJson(Map<String, dynamic> json, int extra);
}

class ExtraOptionalPositionalPolicy extends BasePolicy {
  ExtraOptionalPositionalPolicy.fromJson(
    Map<String, dynamic> json, [
    int extra = 0,
  ]);
}

class OptionalMapPolicy extends BasePolicy {
  OptionalMapPolicy.fromJson([Map<String, dynamic> json = const {}]);
}

class RequiredNamedParameterPolicy extends BasePolicy {
  RequiredNamedParameterPolicy.fromJson(
    Map<String, dynamic> json, {
    required int extra,
  });
}
''',
        });

        analyzer = FutureCallsAnalyzer(directory: directory);
        await analyzer.analyze(
          collector: collector,
          analyzedModels: StatefulAnalyzer(config, []).validateAll(),
        );
      });

      test('then an error is reported for each of them.', () {
        expect(collector.errors, hasLength(12));
      });

      test(
        'then the error for the class without fromJson says it is missing and how to add it.',
        () {
          expect(
            collector.errors.map((e) => e.message),
            contains(
              'MissingFromJsonPolicy extends FutureCallRetryPolicy but has no '
              'fromJson constructor. Add `factory MissingFromJsonPolicy.fromJson('
              'Map<String, dynamic> json)` so the policy can be loaded when a '
              'retry is due.',
            ),
          );
        },
      );

      test(
        'then the error for a fromJson without a positional parameter says so.',
        () {
          expect(
            collector.errors.map((e) => e.message),
            contains(
              startsWith(
                'The fromJson constructor of NoParameterPolicy has no positional '
                'parameter for the JSON map.',
              ),
            ),
          );
        },
      );

      test(
        'then the error for a fromJson that takes the map as a named parameter says it has no positional parameter.',
        () {
          expect(
            collector.errors.map((e) => e.message),
            contains(
              startsWith(
                'The fromJson constructor of NamedParameterPolicy has no '
                'positional parameter for the JSON map.',
              ),
            ),
          );
        },
      );

      for (var (className, parameterType) in [
        ('StringPolicy', 'String'),
        ('UntypedMapPolicy', 'Map<dynamic, dynamic>'),
        ('NullableMapPolicy', 'Map<String, dynamic>?'),
        ('ObjectPolicy', 'Object?'),
        ('DynamicPolicy', 'dynamic'),
      ]) {
        test(
          'then the error for $className whose fromJson takes a $parameterType names that type.',
          () {
            expect(
              collector.errors.map((e) => e.message),
              contains(
                startsWith(
                  'The fromJson constructor of $className takes a $parameterType '
                  'instead of a Map<String, dynamic>.',
                ),
              ),
            );
          },
        );
      }

      for (var className in [
        'ExtraRequiredPositionalPolicy',
        'ExtraOptionalPositionalPolicy',
      ]) {
        test(
          'then the error for $className whose fromJson has a second positional parameter says so.',
          () {
            expect(
              collector.errors.map((e) => e.message),
              contains(
                startsWith(
                  'The fromJson constructor of $className has more than one '
                  'positional parameter.',
                ),
              ),
            );
          },
        );
      }

      test(
        'then the error for a fromJson that takes the map as an optional parameter says so.',
        () {
          expect(
            collector.errors.map((e) => e.message),
            contains(
              startsWith(
                'The fromJson constructor of OptionalMapPolicy takes the JSON map '
                'as an optional parameter.',
              ),
            ),
          );
        },
      );

      test(
        'then the error for a fromJson with a required named parameter says so.',
        () {
          expect(
            collector.errors.map((e) => e.message),
            contains(
              startsWith(
                'The fromJson constructor of RequiredNamedParameterPolicy has a '
                'required named parameter.',
              ),
            ),
          );
        },
      );

      test('then only the valid policy is registered.', () {
        expect(
          analyzer.retryPolicies.map((type) => type.className),
          ['BasePolicy'],
        );
      });
    },
  );

  group(
    'Given a private retry policy class,'
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();
      late FutureCallsAnalyzer analyzer;

      setUpAll(() async {
        var directory = _createDirectoryWithFiles({
          'retry_policies.dart': '''
import 'package:serverpod/serverpod.dart';

class _PrivatePolicy extends FutureCallRetryPolicy {
  _PrivatePolicy();
  factory _PrivatePolicy.fromJson(Map<String, dynamic> json) =>
      _PrivatePolicy();

  @override
  Duration? nextDelay(FutureCallRetryContext context) => null;

  @override
  Map<String, dynamic> toJson() => {};
}
''',
        });

        analyzer = FutureCallsAnalyzer(directory: directory);
        await analyzer.analyze(
          collector: collector,
          analyzedModels: StatefulAnalyzer(config, []).validateAll(),
        );
      });

      test('then an error says the class must be public.', () {
        expect(
          collector.errors.map((e) => e.message),
          [
            'The retry policy class _PrivatePolicy must be public, so that the '
                'generated protocol can refer to it.',
          ],
        );
      });

      test('then the policy is not registered.', () {
        expect(analyzer.retryPolicies, isEmpty);
      });
    },
  );

  group(
    'Given retry policy classes named like another retry policy, an extra class and a model,'
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();
      late FutureCallsAnalyzer analyzer;

      setUpAll(() async {
        String policyClass(String className) =>
            '''
class $className extends FutureCallRetryPolicy {
  $className();
  factory $className.fromJson(Map<String, dynamic> json) => $className();

  @override
  Duration? nextDelay(FutureCallRetryContext context) => null;

  @override
  Map<String, dynamic> toJson() => {};
}
''';

        var directory = _createDirectoryWithFiles({
          'first_policies.dart':
              '''
import 'package:serverpod/serverpod.dart';

${policyClass('DuplicatePolicy')}
${policyClass('ExtraClassName')}
${policyClass('ModelName')}
${policyClass('UniquePolicy')}
''',
          'second_policies.dart':
              '''
import 'package:serverpod/serverpod.dart';

${policyClass('DuplicatePolicy')}
''',
        });

        analyzer = FutureCallsAnalyzer(
          directory: directory,
          extraClasses: [
            TypeDefinitionBuilder().withClassName('ExtraClassName').build(),
          ],
        );
        await analyzer.analyze(
          collector: collector,
          analyzedModels: StatefulAnalyzer(config, [
            ModelSourceBuilder().withYaml('''
class: ModelName
fields:
  name: String
''').build(),
          ]).validateAll(),
        );
      });

      test('then a name clash error is reported for each clashing class.', () {
        var clashingClassNames = [
          for (var error in collector.errors)
            if (error.message.contains('has the same name as another class'))
              RegExp(r'retry policy class (\w+)').firstMatch(error.message)![1],
        ];

        expect(
          clashingClassNames,
          unorderedEquals([
            'DuplicatePolicy',
            'DuplicatePolicy',
            'ExtraClassName',
            'ModelName',
          ]),
        );
      });

      test('then only the policy with a unique name is registered.', () {
        expect(
          analyzer.retryPolicies.map((type) => type.className),
          ['UniquePolicy'],
        );
      });
    },
  );

  group('Given an analyzed directory without retry policies,', () {
    late Directory directory;
    late FutureCallsAnalyzer analyzer;

    setUp(() async {
      directory = _createDirectoryWithFiles({
        'unrelated.dart': 'class Unrelated {}\n',
      });

      analyzer = FutureCallsAnalyzer(directory: directory);
      await analyzer.analyze(
        collector: CodeGenerationCollector(),
        analyzedModels: StatefulAnalyzer(config, []).validateAll(),
      );
    });

    test(
      'when a retry policy file is added and the file context is updated,'
      'then it returns true.',
      () async {
        var policyFile = File(path.join(directory.path, 'retry_policy.dart'))
          ..writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class AddedPolicy extends FutureCallRetryPolicy {
  AddedPolicy();
  factory AddedPolicy.fromJson(Map<String, dynamic> json) => AddedPolicy();

  @override
  Duration? nextDelay(FutureCallRetryContext context) => null;

  @override
  Map<String, dynamic> toJson() => {};
}
''');

        var result = await analyzer.updateFileContexts({policyFile.path});

        expect(result, isTrue);
      },
    );

    test(
      'when an unrelated Dart file is changed and the file context is updated,'
      'then it returns false.',
      () async {
        var unrelatedFile = File(path.join(directory.path, 'unrelated.dart'))
          ..writeAsStringSync('class Unrelated { int value = 0; }\n');

        var result = await analyzer.updateFileContexts({unrelatedFile.path});

        expect(result, isFalse);
      },
    );
  });

  group('Given an analyzed directory with a retry policy,', () {
    late File policyFile;
    late FutureCallsAnalyzer analyzer;

    setUp(() async {
      var directory = _createDirectoryWithFiles({
        'retry_policy.dart': '''
import 'package:serverpod/serverpod.dart';

class RemovedPolicy extends FutureCallRetryPolicy {
  RemovedPolicy();
  factory RemovedPolicy.fromJson(Map<String, dynamic> json) => RemovedPolicy();

  @override
  Duration? nextDelay(FutureCallRetryContext context) => null;

  @override
  Map<String, dynamic> toJson() => {};
}
''',
      });
      policyFile = File(path.join(directory.path, 'retry_policy.dart'));

      analyzer = FutureCallsAnalyzer(directory: directory);
      await analyzer.analyze(
        collector: CodeGenerationCollector(),
        analyzedModels: StatefulAnalyzer(config, []).validateAll(),
      );
    });

    test(
      'when the retry policy file is deleted and the file context is updated,'
      'then true is returned and the policy is no longer registered.',
      () async {
        policyFile.deleteSync();

        var result = await analyzer.updateFileContexts({policyFile.path});

        expect(result, isTrue);
        expect(analyzer.retryPolicies, isEmpty);
      },
    );
  });
}
