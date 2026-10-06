import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/clean.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

import '../test_util/file_system_entity_helpers.dart';

Future<void> _runClean(List<String> args) async {
  final command = CleanCommand();
  final config = command.resolveConfiguration(command.argParser.parse(args));
  await command.runWithConfig(config);
}

Future<void> _createServerPubspec(Directory directory) async {
  await directory.create(recursive: true);
  await File(p.join(directory.path, 'pubspec.yaml')).writeAsString('''
name: example_server
environment:
  sdk: ^3.12.2
dependencies:
  serverpod: ^4.0.0
''');
}

void main() {
  late Directory serverDir;
  late Directory toolDir;
  late Directory originalDirectory;

  setUpAll(() => initializeLoggerWith(VoidLogger()));

  tearDownAll(closeLogger);

  setUp(() async {
    originalDirectory = Directory.current;
    serverDir = await Directory.systemTemp.createTemp('clean');
    toolDir = Directory(p.join(serverDir.path, '.dart_tool', 'serverpod'));
  });

  tearDown(() async {
    Directory.current = originalDirectory;
    await serverDir.deleteBestEffort(recursive: true);
  });

  test(
    'Given a server directory with a cached kernel and VM service metadata, '
    'when cleaning the kernel cache, '
    'then only the kernel files are deleted.',
    () async {
      await toolDir.create(recursive: true);
      for (final name in [
        'server.dill',
        'server.dill.incremental.dill',
        'server.dill.compiling',
        'server.dill.entrypoint',
        'vm-service-info.json',
      ]) {
        await File(p.join(toolDir.path, name)).create();
      }
      await Directory(p.join(toolDir.path, 'native_assets')).create();

      final cleaned = await cleanKernelCache(serverDir.path);

      expect(cleaned, isTrue);
      expect(
        toolDir.listSync().map((entity) => p.basename(entity.path)),
        unorderedEquals(['vm-service-info.json', 'native_assets']),
      );
    },
  );

  test(
    'Given a server directory without a cached kernel, '
    'when cleaning the kernel cache, '
    'then nothing is reported as cleaned.',
    () async {
      final cleaned = await cleanKernelCache(serverDir.path);

      expect(cleaned, isFalse);
    },
  );

  group('Given a server project with a cached kernel,', () {
    late File kernelFile;

    setUp(() async {
      await _createServerPubspec(serverDir);
      await toolDir.create(recursive: true);
      kernelFile = await File(p.join(toolDir.path, 'server.dill')).create();
    });

    test(
      'when cleaning with --directory, '
      'then the selected server cache is deleted.',
      () async {
        await _runClean(['--directory', serverDir.path]);

        expect(await kernelFile.exists(), isFalse);
        expect(
          await File(p.join(serverDir.path, 'pubspec.yaml')).exists(),
          isTrue,
        );
      },
    );

    test(
      'when cleaning with -d, '
      'then the selected server cache is deleted.',
      () async {
        await _runClean(['-d', serverDir.path]);

        expect(await kernelFile.exists(), isFalse);
      },
    );

    test(
      'when cleaning from its bin directory without a directory option, '
      'then the server is discovered and its cache is deleted.',
      () async {
        final binDir = await Directory(p.join(serverDir.path, 'bin')).create();
        Directory.current = binDir;

        await _runClean([]);

        expect(await kernelFile.exists(), isFalse);
      },
    );
  });

  test(
    'Given a repository without a Serverpod project, '
    'when cleaning its cache, '
    'then the command fails with a CLI error.',
    () async {
      await Directory(p.join(serverDir.path, '.git')).create();

      await expectLater(
        _runClean(['--directory', serverDir.path]),
        throwsA(isA<ExitException>()),
      );
    },
  );

  test(
    'Given a repository with two Serverpod projects, '
    'when cleaning without selecting a project, '
    'then the command fails without prompting or deleting either cache.',
    () async {
      await Directory(p.join(serverDir.path, '.git')).create();
      final firstServer = Directory(p.join(serverDir.path, 'first_server'));
      final secondServer = Directory(p.join(serverDir.path, 'second_server'));
      await _createServerPubspec(firstServer);
      await _createServerPubspec(secondServer);
      final firstKernel = await File(
        p.join(firstServer.path, '.dart_tool', 'serverpod', 'server.dill'),
      ).create(recursive: true);
      final secondKernel = await File(
        p.join(secondServer.path, '.dart_tool', 'serverpod', 'server.dill'),
      ).create(recursive: true);
      Directory.current = serverDir;

      await expectLater(_runClean([]), throwsA(isA<ExitException>()));

      expect(await firstKernel.exists(), isTrue);
      expect(await secondKernel.exists(), isTrue);
    },
  );
}
