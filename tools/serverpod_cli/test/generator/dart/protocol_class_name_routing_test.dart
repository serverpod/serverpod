import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/builders/model_class_definition_builder.dart';
import '../../test_util/builders/module_config_builder.dart';
import '../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../test_util/builders/type_definition_builder.dart';
import '../../test_util/file_system_entity_helpers.dart';

void main() {
  const dependencies = <String, List<String>>{
    'routing_leaf': [],
    'routing_noise': ['routing_leaf'],
    'routing_owner': [],
    'routing_middle': ['routing_noise', 'routing_owner'],
    'routing_outer': ['routing_noise', 'routing_middle'],
    'routing_consumer': [
      'routing_noise',
      'routing_middle',
      'routing_owner',
    ],
  };

  late Directory directory;
  late Directory entryModules;

  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('class_name_routing_');
    entryModules = await _generateModules(
      directory,
      dependencies: dependencies,
      models: {
        'routing_owner': [
          ModelClassDefinitionBuilder()
              .withClassName('Entry')
              .withFileName('entry')
              .withSimpleField('value', 'int')
              .build(),
        ],
      },
    );
  });

  tearDownAll(() async {
    await directory.deleteWithRetry(recursive: true);
  });

  group(
    'Given a server discriminator qualified with its own module prefix,',
    () {
      late String input;

      setUpAll(() {
        input = '''
final payload = {'__className__': 'routing_owner.Entry'};
''';
      });

      group('when the generated helper reads its class name,', () {
        late Object? result;

        setUpAll(() async {
          result = await _run(
            entryModules,
            given: input,
            when: '''
final decoded = serverOwner.Protocol.getClassNameFromObjectJson(payload);
''',
            result: 'decoded',
          );
        });

        test('then the prefix is removed.', () {
          expect(result, 'Entry');
        });
      });
    },
  );

  group(
    'Given a server discriminator qualified with another module prefix,',
    () {
      late String input;

      setUpAll(() {
        input = '''
final payload = {'__className__': 'routing_consumer.Entry'};
''';
      });

      group('when the generated helper reads its class name,', () {
        late Object? result;

        setUpAll(() async {
          result = await _run(
            entryModules,
            given: input,
            when: '''
final decoded = serverOwner.Protocol.getClassNameFromObjectJson(payload);
''',
            result: 'decoded',
          );
        });

        test('then the qualified name is preserved.', () {
          expect(result, 'routing_consumer.Entry');
        });
      });
    },
  );

  group('Given a client discriminator containing its module prefix twice,', () {
    late String input;

    setUpAll(() {
      input = '''
final payload = {'__className__': 'routing_owner.routing_owner.Entry'};
''';
    });

    group('when the generated helper reads its class name,', () {
      late Object? result;

      setUpAll(() async {
        result = await _run(
          entryModules,
          given: input,
          when: '''
final decoded = clientOwner.Protocol.getClassNameFromObjectJson(payload);
''',
          result: 'decoded',
        );
      });

      test('then exactly one prefix is removed.', () {
        expect(result, 'routing_owner.Entry');
      });
    });
  });

  group('Given a server dependency envelope with a qualified class name,', () {
    late String input;

    setUpAll(() {
      input = '''
final model = serverOwner.Entry(value: 7);
final envelope = {
  'className': 'routing_owner.Entry',
  'data': model.toJson(),
};
''';
    });

    group('when the consuming module decodes the envelope,', () {
      late Object? result;

      setUpAll(() async {
        result = await _run(
          entryModules,
          given: input,
          when: '''
final decoded = serverConsumer.Protocol().deserializeByClassName(envelope)
    as serverOwner.Entry;
''',
          result: 'decoded.value',
        );
      });

      test('then the dependency model fields are preserved.', () {
        expect(result, 7);
      });
    });
  });

  group('Given a client dependency envelope with a qualified class name,', () {
    late String input;

    setUpAll(() {
      input = '''
final model = clientOwner.Entry(value: 8);
final envelope = {
  'className': 'routing_owner.Entry',
  'data': model.toJson(),
};
''';
    });

    group('when the consuming module decodes the envelope,', () {
      late Object? result;

      setUpAll(() async {
        result = await _run(
          entryModules,
          given: input,
          when: '''
final decoded = clientConsumer.Protocol().deserializeByClassName(envelope)
    as clientOwner.Entry;
''',
          result: 'decoded.value',
        );
      });

      test('then the dependency model fields are preserved.', () {
        expect(result, 8);
      });
    });
  });

  group(
    'Given a caller-owned server dependency envelope with a qualified class name,',
    () {
      late String input;

      setUpAll(() {
        input = '''
final envelope = {
  'className': 'routing_owner.Entry',
  'data': serverOwner.Entry(value: 7).toJson(),
};
final before = jsonEncode(envelope);
''';
      });

      group('when the consuming module decodes the same envelope twice,', () {
        late Object? result;

        setUpAll(() async {
          result = await _run(
            entryModules,
            given: input,
            when: '''
final first = serverConsumer.Protocol().deserializeByClassName(envelope)
    as serverOwner.Entry;
final second = serverConsumer.Protocol().deserializeByClassName(envelope)
    as serverOwner.Entry;
''',
            result: '''
{
  'values': [first.value, second.value],
  'unchanged': jsonEncode(envelope) == before,
}
''',
          );
        });

        test('then both decodes preserve the dependency model fields.', () {
          expect((result as Map)['values'], [7, 7]);
        });

        test('then the caller-owned envelope remains unchanged.', () {
          expect((result as Map)['unchanged'], isTrue);
        });
      });
    },
  );

  group(
    'Given a caller-owned client dependency envelope with a qualified class name,',
    () {
      late String input;

      setUpAll(() {
        input = '''
final envelope = {
  'className': 'routing_owner.Entry',
  'data': clientOwner.Entry(value: 8).toJson(),
};
final before = jsonEncode(envelope);
''';
      });

      group('when the consuming module decodes the same envelope twice,', () {
        late Object? result;

        setUpAll(() async {
          result = await _run(
            entryModules,
            given: input,
            when: '''
final first = clientConsumer.Protocol().deserializeByClassName(envelope)
    as clientOwner.Entry;
final second = clientConsumer.Protocol().deserializeByClassName(envelope)
    as clientOwner.Entry;
''',
            result: '''
{
  'values': [first.value, second.value],
  'unchanged': jsonEncode(envelope) == before,
}
''',
          );
        });

        test('then both decodes preserve the dependency model fields.', () {
          expect((result as Map)['values'], [8, 8]);
        });

        test('then the caller-owned envelope remains unchanged.', () {
          expect((result as Map)['unchanged'], isTrue);
        });
      });
    },
  );

  group(
    'Given an immutable server dependency envelope with a qualified class name,',
    () {
      late String input;

      setUpAll(() {
        input = '''
final envelope = Map<String, dynamic>.unmodifiable({
  'className': 'routing_owner.Entry',
  'data': serverOwner.Entry(value: 9).toJson(),
});
''';
      });

      group('when the consuming module decodes the envelope,', () {
        late Object? result;

        setUpAll(() async {
          result = await _run(
            entryModules,
            given: input,
            when: '''
final decoded = serverConsumer.Protocol().deserializeByClassName(envelope)
    as serverOwner.Entry;
''',
            result: 'decoded.value',
          );
        });

        test('then the dependency model fields are preserved.', () {
          expect(result, 9);
        });
      });
    },
  );

  group(
    'Given an immutable client dependency envelope with a qualified class name,',
    () {
      late String input;

      setUpAll(() {
        input = '''
final envelope = Map<String, dynamic>.unmodifiable({
  'className': 'routing_owner.Entry',
  'data': clientOwner.Entry(value: 10).toJson(),
});
''';
      });

      group('when the consuming module decodes the envelope,', () {
        late Object? result;

        setUpAll(() async {
          result = await _run(
            entryModules,
            given: input,
            when: '''
final decoded = clientConsumer.Protocol().deserializeByClassName(envelope)
    as clientOwner.Entry;
''',
            result: 'decoded.value',
          );
        });

        test('then the dependency model fields are preserved.', () {
          expect(result, 10);
        });
      });
    },
  );

  group(
    'Given a server model with a loaded dependency subtype in its parent-typed field,',
    () {
      late Directory modules;
      late String input;

      setUpAll(() async {
        final parent = ModelClassDefinitionBuilder()
            .withClassName('Parent')
            .withFileName('parent')
            .withModuleAlias('protocol')
            .withSimpleField('name', 'String')
            .build();
        final child = ModelClassDefinitionBuilder()
            .withClassName('Child')
            .withFileName('child')
            .withExtendsClass(parent)
            .withSimpleField('extra', 'String')
            .build();
        parent.childClasses.add(ResolvedInheritanceDefinition(child));

        modules = await _generateModules(
          directory,
          dependencies: dependencies,
          models: {
            'routing_owner': [parent, child],
            'routing_consumer': [
              ModelClassDefinitionBuilder()
                  .withClassName('Container')
                  .withFileName('container')
                  .withFields([
                    FieldDefinitionBuilder()
                        .withName('child')
                        .withType(
                          TypeDefinitionBuilder()
                              .withClassName('Parent')
                              .withUrl('module:routing_owner')
                              .build(),
                        )
                        .build(),
                  ])
                  .build(),
            ],
          },
        );
        input = '''
final model = serverConsumer.Container(
  child: serverOwner.Child(name: 'parent', extra: 'child'),
);
final payload = model.toJson();
''';
      });

      group('when the generated model decoder reads the payload,', () {
        late Object? result;

        setUpAll(() async {
          result = await _run(
            modules,
            given: input,
            when: '''
final decoded = serverConsumer.Container.fromJson(payload);
''',
            result: '''
{
  'isChild': decoded.child is serverOwner.Child,
  'name': decoded.child.name,
  'extra': (decoded.child as serverOwner.Child).extra,
}
''',
          );
        });

        test('then the nested subtype and its fields are preserved.', () {
          expect(result, {'isChild': true, 'name': 'parent', 'extra': 'child'});
        });
      });
    },
  );

  group(
    'Given a client model with a loaded dependency subtype in its parent-typed field,',
    () {
      late Directory modules;
      late String input;

      setUpAll(() async {
        final parent = ModelClassDefinitionBuilder()
            .withClassName('Parent')
            .withFileName('parent')
            .withModuleAlias('protocol')
            .withSimpleField('name', 'String')
            .build();
        final child = ModelClassDefinitionBuilder()
            .withClassName('Child')
            .withFileName('child')
            .withExtendsClass(parent)
            .withSimpleField('extra', 'String')
            .build();
        parent.childClasses.add(ResolvedInheritanceDefinition(child));

        modules = await _generateModules(
          directory,
          dependencies: dependencies,
          models: {
            'routing_owner': [parent, child],
            'routing_consumer': [
              ModelClassDefinitionBuilder()
                  .withClassName('Container')
                  .withFileName('container')
                  .withFields([
                    FieldDefinitionBuilder()
                        .withName('child')
                        .withType(
                          TypeDefinitionBuilder()
                              .withClassName('Parent')
                              .withUrl('module:routing_owner')
                              .build(),
                        )
                        .build(),
                  ])
                  .build(),
            ],
          },
        );
        input = '''
final model = clientConsumer.Container(
  child: clientOwner.Child(name: 'parent', extra: 'child'),
);
final payload = model.toJson();
''';
      });

      group('when the generated model decoder reads the payload,', () {
        late Object? result;

        setUpAll(() async {
          result = await _run(
            modules,
            given: input,
            when: '''
final decoded = clientConsumer.Container.fromJson(payload);
''',
            result: '''
{
  'isChild': decoded.child is clientOwner.Child,
  'name': decoded.child.name,
  'extra': (decoded.child as clientOwner.Child).extra,
}
''',
          );
        });

        test('then the nested subtype and its fields are preserved.', () {
          expect(result, {'isChild': true, 'name': 'parent', 'extra': 'child'});
        });
      });
    },
  );

  group('Given a tagged transitive server model and a request for Object,', () {
    late String input;

    setUpAll(() {
      input = '''
final payload = serverOwner.Entry(value: 9).toJson();
''';
    });

    group('when the outer module decodes the payload,', () {
      late Object? result;

      setUpAll(() async {
        result = await _run(
          entryModules,
          given: input,
          when: '''
final decoded = serverOuter.Protocol().deserialize<Object>(payload)
    as serverOwner.Entry;
''',
          result: 'decoded.value',
        );
      });

      test(
        'then the class-name route resolves the model without a typed handler.',
        () {
          expect(result, 9);
        },
      );
    });
  });

  group('Given a tagged transitive client model and a request for dynamic,', () {
    late String input;

    setUpAll(() {
      input = '''
final payload = clientOwner.Entry(value: 10).toJson();
''';
    });

    group('when the outer module decodes the payload,', () {
      late Object? result;

      setUpAll(() async {
        result = await _run(
          entryModules,
          given: input,
          when: '''
final decoded = clientOuter.Protocol().deserialize<dynamic>(payload)
    as clientOwner.Entry;
''',
          result: 'decoded.value',
        );
      });

      test(
        'then the class-name route resolves the model without a typed handler.',
        () {
          expect(result, 10);
        },
      );
    });
  });

  group(
    'Given an unknown server dependency subtype and a known parent type,',
    () {
      late Directory modules;
      late String input;

      setUpAll(() async {
        final parent = ModelClassDefinitionBuilder()
            .withClassName('Parent')
            .withFileName('parent')
            .withModuleAlias('protocol')
            .withSimpleField('name', 'String')
            .build();
        final child = ModelClassDefinitionBuilder()
            .withClassName('Child')
            .withFileName('child')
            .withExtendsClass(parent)
            .withSimpleField('extra', 'String')
            .build();
        parent.childClasses.add(ResolvedInheritanceDefinition(child));

        modules = await _generateModules(
          directory,
          dependencies: dependencies,
          models: {
            'routing_owner': [parent, child],
          },
        );
        input = '''
final payload = {
  '__className__': 'routing_owner.FutureChild',
  'name': 'known field',
  'future': 'ignored field',
};
''';
      });

      group('when the consuming module decodes the payload,', () {
        late Object? result;

        setUpAll(() async {
          result = await _run(
            modules,
            given: input,
            when: '''
final decoded = serverConsumer.Protocol().deserialize<serverOwner.Parent>(payload);
''',
            result: 'decoded.name',
          );
        });

        test('then the expected parent fallback preserves known fields.', () {
          expect(result, 'known field');
        });
      });
    },
  );

  group(
    'Given an unqualified transitive client subtype and a request for Object,',
    () {
      late Directory modules;
      late String input;

      setUpAll(() async {
        final parent = ModelClassDefinitionBuilder()
            .withClassName('Parent')
            .withFileName('parent')
            .withModuleAlias('protocol')
            .withSimpleField('name', 'String')
            .build();
        final child = ModelClassDefinitionBuilder()
            .withClassName('Child')
            .withFileName('child')
            .withExtendsClass(parent)
            .withSimpleField('extra', 'String')
            .build();
        parent.childClasses.add(ResolvedInheritanceDefinition(child));

        modules = await _generateModules(
          directory,
          dependencies: dependencies,
          models: {
            'routing_owner': [parent, child],
          },
        );
        input = '''
final payload = {
  '__className__': 'Child',
  'name': 'parent',
  'extra': 'child',
};
''';
      });

      group('when the outer module decodes the payload,', () {
        late Object? result;

        setUpAll(() async {
          result = await _run(
            modules,
            given: input,
            when: '''
final decoded = clientOuter.Protocol().deserialize<Object>(payload)
    as clientOwner.Child;
''',
            result: '''
{'name': decoded.name, 'extra': decoded.extra}
''',
          );
        });

        test('then the class-name fallback preserves the subtype fields.', () {
          expect(result, {'name': 'parent', 'extra': 'child'});
        });
      });
    },
  );

  group('Given a known server dependency class with malformed field data,', () {
    late String input;

    setUpAll(() {
      input = '''
final payload = {
  '__className__': 'routing_owner.Entry',
  'value': 'not an integer',
};
''';
    });

    group('when the consuming module decodes the payload,', () {
      late Object? result;

      setUpAll(() async {
        result = await _run(
          entryModules,
          given: input,
          when: '''
String outcome;
try {
  serverConsumer.Protocol().deserialize<serverOwner.Entry>(payload);
  outcome = 'accepted';
} on TypeError {
  outcome = 'type error';
}
''',
          result: 'outcome',
        );
      });

      test(
        'then the decoding error propagates instead of falling through.',
        () {
          expect(result, 'type error');
        },
      );
    });
  });

  group(
    'Given a tagged transitive client model behind unrelated dependency branches,',
    () {
      late String input;

      setUpAll(() {
        input = '''
final className = 'routing_owner.Entry';
''';
      });

      group('when the outer module resolves the deserialization route,', () {
        late Object? result;

        setUpAll(() async {
          result = await _run(
            entryModules,
            given: input,
            when: '''
final candidates = clientOuter.Protocol()
    .deserializationMetadata
    .modulesForDeserialization(Object, className: className);
''',
            result: '''
candidates.map((module) => module.getModuleName()).toList()
''',
          );
        });

        test('then unrelated dependency branches are excluded.', () {
          expect(result, ['routing_middle']);
        });
      });
    },
  );
}

Future<Directory> _generateModules(
  Directory root, {
  required Map<String, List<String>> dependencies,
  required Map<String, List<SerializableModelDefinition>> models,
}) async {
  final directory = await root.createTemp('modules_');
  final packageConfigUri = (await Isolate.packageConfig)!;
  final packageConfig =
      jsonDecode(
            await File.fromUri(packageConfigUri).readAsString(),
          )
          as Map<String, dynamic>;
  final packages = (packageConfig['packages'] as List).cast<Map>();
  for (final package in packages) {
    package['rootUri'] = packageConfigUri
        .resolve(package['rootUri'] as String)
        .toString();
  }

  Future<void> writeModule(
    String name, {
    List<String> dependencies = const [],
    List<SerializableModelDefinition> models = const [],
  }) async {
    final config = GeneratorConfigBuilder()
        .withName(name)
        .withPackageType(PackageType.module)
        .withServerPackageDirectoryPathParts([directory.path, '${name}_server'])
        .withModules([
          for (final dependency in dependencies)
            ModuleConfigBuilder(dependency).build(),
        ])
        .build();
    final definition = ProtocolDefinition(
      endpoints: [],
      models: models,
      futureCalls: [],
    );
    const serverGenerator = DartServerCodeGenerator();
    const clientGenerator = DartClientCodeGenerator();
    final files = {
      ...serverGenerator.generateSerializableModelsCode(
        models: models,
        config: config,
      ),
      ...serverGenerator.generateProtocolCode(
        protocolDefinition: definition,
        config: config,
      ),
      ...clientGenerator.generateSerializableModelsCode(
        models: models,
        config: config,
      ),
      ...clientGenerator.generateProtocolCode(
        protocolDefinition: definition,
        config: config,
      ),
    };
    for (final entry in files.entries) {
      final file = File(entry.key);
      await file.parent.create(recursive: true);
      await file.writeAsString(entry.value);
    }
    for (final side in ['server', 'client']) {
      final packageName = '${name}_$side';
      final root = Directory('${directory.path}/$packageName');
      final modelPath = side == 'server' ? 'generated' : 'protocol';
      await File('${root.path}/lib/$packageName.dart').writeAsString(
        "export 'src/$modelPath/protocol.dart';\n",
      );
      packages.add({
        'name': packageName,
        'rootUri': root.uri.toString(),
        'packageUri': 'lib/',
        'languageVersion': '3.12',
      });
    }
  }

  for (final module in dependencies.entries) {
    await writeModule(
      module.key,
      dependencies: module.value,
      models: models[module.key] ?? [],
    );
  }

  await File('${directory.path}/package_config.json').writeAsString(
    jsonEncode(packageConfig),
  );

  return directory;
}

Future<Object?> _run(
  Directory directory, {
  required String given,
  required String when,
  required String result,
}) async {
  final runDirectory = await directory.createTemp('run_');
  final script = File('${runDirectory.path}/main.dart');
  await script.writeAsString('''
import 'dart:convert';
import 'package:routing_consumer_server/routing_consumer_server.dart' as serverConsumer;
import 'package:routing_owner_server/routing_owner_server.dart' as serverOwner;
import 'package:routing_outer_server/routing_outer_server.dart' as serverOuter;
import 'package:routing_consumer_client/routing_consumer_client.dart' as clientConsumer;
import 'package:routing_owner_client/routing_owner_client.dart' as clientOwner;
import 'package:routing_outer_client/routing_outer_client.dart' as clientOuter;

void main() {
  $given

  $when

  final result = $result;
  print(jsonEncode(result));
}
''');
  final process = await Process.run(Platform.resolvedExecutable, [
    '--packages=${directory.path}/package_config.json',
    script.path,
  ]);
  if (process.exitCode != 0) {
    throw StateError('${process.stdout}\n${process.stderr}');
  }

  return jsonDecode(process.stdout as String);
}
