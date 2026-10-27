import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/protocol_deserialization_generator.dart';
import 'package:serverpod_cli/src/runner/line_sink.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';
import 'package:vm_service/vm_service.dart' show InstanceRef;

import '../../test_util/file_system_entity_helpers.dart';

const _runtime = 'package:serverpod_serialization/serverpod_serialization.dart';

void main() {
  late Directory directory;
  late KernelCompiler compiler;
  late ServerProcess serverProcess;
  late String isolateId;
  late String libraryId;
  final output = <String>[];

  setUpAll(() {
    initializeLogger();
  });

  tearDownAll(() async {
    await closeLogger();
  });

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('protocol_hot_reload_');
    output.clear();
    final packages = await Isolate.packageConfig;
    compiler = KernelCompiler(
      entryPoint: '${directory.path}/main.dart',
      outputDill: '${directory.path}/.dart_tool/serverpod/server.dill',
      packagesPath: packages!.toFilePath(),
    );
    serverProcess = ServerProcess(
      serverDir: directory.path,
      serverArgs: [],
      dartExecutable: compiler.dartExecutable,
      enableVmService: true,
      vmServiceInfoFile: '${directory.path}/.dart_tool/serverpod/service.json',
      stdoutSink: LineSink(output.add),
      stderrSink: LineSink(output.add),
    );
  });

  tearDown(() async {
    await serverProcess.stop();
    await compiler.dispose();
    await directory.deleteWithRetry(recursive: true);
  });

  Future<String> compile() async {
    final changedPaths = await directory
        .list(recursive: true)
        .where((entry) => entry is File && entry.path.endsWith('.dart'))
        .map((entry) => entry.path)
        .toSet();
    final result = await compiler.compile(changedPaths: changedPaths);
    if (result.errorCount > 0) {
      throw StateError(result.compilerOutputLines.join('\n'));
    }
    await compiler.accept();

    return result.dillOutput!;
  }

  Future<void> start() async {
    await File('${directory.path}/models.dart').writeAsString(_models);
    await File('${directory.path}/main.dart').writeAsString(_main);
    await compiler.start();
    await serverProcess.start(dillPath: await compile());
    await serverProcess.connectToVmService();

    final service = serverProcess.vmService;
    if (service == null) {
      throw StateError('VM service did not connect:\n${output.join('\n')}');
    }
    final vm = await service.getVM();
    isolateId = vm.isolates!.singleWhere((item) => item.name == 'main').id!;
    final mainIsolate = await service.getIsolate(isolateId);
    libraryId = mainIsolate.rootLib!.id!;
  }

  Future<void> reload() async {
    final reloaded = await serverProcess.reload(await compile());
    if (!reloaded) {
      throw StateError('Hot reload failed:\n${output.join('\n')}');
    }
  }

  Future<Map<String, dynamic>> readOutcome(String command) async {
    final result = await serverProcess.vmService!.evaluate(
      isolateId,
      libraryId,
      'jsonEncode(run(${jsonEncode(command)}))',
    );
    if (result is! InstanceRef || result.valueAsString == null) {
      throw StateError('Protocol evaluation failed: ${result.json}');
    }

    return jsonDecode(result.valueAsString!) as Map<String, dynamic>;
  }

  group('Given cached misses and a later owner behind an unchanged parent,', () {
    late Map<String, dynamic> before;
    late Map<String, dynamic> after;

    setUp(() async {
      await _writeProtocol(directory, 'first', types: []);
      await _writeProtocol(
        directory,
        'second',
        types: [refer('Choice')],
        decoder: 'if (t == Choice) return Choice.second as T;',
      );
      await _writeProtocol(directory, 'middle', modules: ['first']);
      await _writeProtocol(directory, 'root', modules: ['middle', 'second']);
      await start();
      before = await readOutcome('warm');
    });

    group('when a transitive module gains handlers during hot reload,', () {
      setUp(() async {
        await File('${directory.path}/models.dart').writeAsString('''
$_models
class NewModel {
  @override
  String toString() => 'NewModel';
}
''');
        await File('${directory.path}/main.dart').writeAsString(
          _main.replaceFirst(
            "'check' => {",
            "'check' => {'newModel': outcome<NewModel>(),",
          ),
        );
        await _writeProtocol(
          directory,
          'first',
          types: [
            refer('Choice'),
            refer('Added'),
            refer('NewModel'),
            refer('getType').call([], {}, [refer('Added?')]),
            refer('getType').call([], {}, [refer('List<Added?>?')]),
            refer('getType').call([], {}, [refer('(String, int)')]),
          ],
          decoder: '''
            if (t == Choice) return Choice.first as T;
            if (t == Added) return Added() as T;
            if (t == NewModel) return NewModel() as T;
            if (t == getType<Added?>()) return null as T;
            if (t == getType<List<Added?>?>()) return <Added?>[Added(), null] as T;
            if (t == getType<(String, int)>()) return ('record', 1) as T;
          ''',
        );
        await reload();
        after = await readOutcome('check');
      });

      test(
        'then both cached and previously unrequested types use the new handlers.',
        () {
          expect(before, {
            'choice': 'Choice.second',
            'added': 'type not found',
          });
          expect(after, {
            'choice': 'Choice.first',
            'added': 'Added',
            'newModel': 'NewModel',
            'nullable': 'null',
            'list': '[Added, null]',
            'record': '(record, 1)',
          });
        },
      );
    });
  });

  group('Given cached routing through a module list,', () {
    late Map<String, dynamic> before;
    late Map<String, dynamic> added;
    late Map<String, dynamic> reordered;
    late Map<String, dynamic> removed;

    setUp(() async {
      await _writeProtocol(
        directory,
        'first',
        types: [refer('Choice')],
        decoder: 'if (t == Choice) return Choice.first as T;',
      );
      await _writeProtocol(
        directory,
        'second',
        types: [refer('Choice')],
        decoder: 'if (t == Choice) return Choice.second as T;',
      );
      await _writeProtocol(directory, 'root', modules: ['first']);
      await start();
      before = await readOutcome('order');
    });

    group('when hot reload adds reorders and removes modules,', () {
      setUp(() async {
        await _writeProtocol(directory, 'root', modules: ['second', 'first']);
        await reload();
        added = await readOutcome('order');

        await _writeProtocol(directory, 'root', modules: ['first', 'second']);
        await reload();
        reordered = await readOutcome('order');

        await _writeProtocol(directory, 'root', modules: ['second']);
        await reload();
        removed = await readOutcome('order');
      });

      test(
        'then typed and tagged fallback follow the current module order.',
        () {
          expect(before, {'typed': 'Choice.first', 'tagged': 'Choice.first'});
          expect(added, {'typed': 'Choice.second', 'tagged': 'Choice.second'});
          expect(reordered, {
            'typed': 'Choice.first',
            'tagged': 'Choice.first',
          });
          expect(removed, {
            'typed': 'Choice.second',
            'tagged': 'Choice.second',
          });
        },
      );
    });
  });

  group('Given a cached route to an existing decoder,', () {
    late Map<String, dynamic> before;
    late Map<String, dynamic> after;

    setUp(() async {
      await _writeProtocol(
        directory,
        'first',
        types: [refer('Choice')],
        decoder: 'if (t == Choice) return Choice.first as T;',
      );
      await _writeProtocol(directory, 'root', modules: ['first']);
      await start();
      before = await readOutcome('order');
    });

    group('when hot reload changes only the decoder body,', () {
      setUp(() async {
        await _writeProtocol(
          directory,
          'first',
          types: [refer('Choice')],
          decoder: 'if (t == Choice) return Choice.second as T;',
        );
        await reload();
        after = await readOutcome('order');
      });

      test(
        'then the existing route executes the updated decoder.',
        () {
          expect(before, {'typed': 'Choice.first', 'tagged': 'Choice.first'});
          expect(after, {'typed': 'Choice.second', 'tagged': 'Choice.second'});
        },
      );
    });
  });
}

Future<void> _writeProtocol(
  Directory directory,
  String name, {
  List<Expression> types = const [],
  List<String> modules = const [],
  String decoder = '',
}) async {
  final generator = ProtocolDeserializationGenerator(runtimeUrl: _runtime);
  final metadata = generator
      .metadata(
        types: types,
        modules: [
          for (final module in modules) refer('$module.Protocol'),
        ],
      )
      .accept(DartEmitter());
  final fallback = generator.moduleFallback().accept(DartEmitter());
  final imports = modules.map((module) => "import '$module.dart' as $module;");

  await File('${directory.path}/$name.dart').writeAsString('''
import '$_runtime';
import 'models.dart';
${imports.join('\n')}

class Protocol extends SerializationManager
    implements ProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  $metadata;

  @override
  T deserialize<T>(dynamic data, [Type? t]) {
    t ??= T;

    final dataClassName = data is Map<String, dynamic>
        ? data['__className__']
        : null;

    $decoder

    $fallback

    return super.deserialize<T>(data, t);
  }
}
''');
}

const _models = '''
enum Choice { first, second }

class Added {
  @override
  String toString() => 'Added';
}
''';

const _main =
    '''
import 'dart:convert';
import 'dart:io';

import '$_runtime';

import 'models.dart';
import 'root.dart';

String outcome<T>([bool tagged = false]) {
  try {
    final data = <String, dynamic>{
      if (tagged) '__className__': 'Choice',
    };

    return Protocol().deserialize<T>(data).toString();
  } on DeserializationTypeNotFoundException {
    return 'type not found';
  }
}

Map<String, String> run(String command) => switch (command) {
  'warm' => {
    'choice': outcome<Choice>(),
    'added': outcome<Added>(),
  },
  'check' => {
    'choice': outcome<Choice>(),
    'added': outcome<Added>(),
    'nullable': outcome<Added?>(),
    'list': outcome<List<Added?>?>(),
    'record': outcome<(String, int)>(),
  },
  'order' => {
    'typed': outcome<Choice>(),
    'tagged': outcome<Choice>(true),
  },
  _ => throw ArgumentError.value(command),
};

void main() {
  ProcessSignal.sigint.watch().listen((_) => exit(0));
  Future<void>.delayed(const Duration(hours: 1));
}
''';
