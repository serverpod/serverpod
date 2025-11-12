@Timeout(Duration(minutes: 12))
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli_e2e_test/src/keyword_search_in_stream.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

const generateWatchCompletionKeywords = [
  'Initial code generation complete. Listening for changes.',
  'Incremental code generation complete.',
];

void main() async {
  var tempPath = path.join(Directory.current.path, 'temp');
  var rootPath = path.join(Directory.current.path, '..', '..');
  var cliPath = path.join(rootPath, 'tools', 'serverpod_cli');

  setUpAll(() async {
    await Process.run(
      'dart',
      ['pub', 'global', 'activate', '-s', 'path', '.'],
      workingDirectory: cliPath,
    );

    // Run command and activate again to force cache pub dependencies.
    await Process.run(
      'serverpod',
      ['version'],
      workingDirectory: cliPath,
    );

    await Process.run(
      'dart',
      ['pub', 'global', 'activate', '-s', 'path', '.'],
      workingDirectory: cliPath,
    );

    Directory(tempPath).createSync(recursive: true);
  });

  tearDownAll(() async {
    Directory(tempPath).deleteSync(recursive: true);
  });

  group('Given a model file that is changed when generate watch is active', () {
    var (projectName, _) = createRandomProjectName(tempPath);
    var (serverDir, _, clientDir) = createProjectFolderPaths(projectName);

    late Process createProcess;
    Process? generateWatch;
    KeywordSearchInStream generateStreamSearch = KeywordSearchInStream(
      keywords: generateWatchCompletionKeywords,
    );
    setUp(() async {
      createProcess = await Process.start(
        'serverpod',
        ['create', projectName, '-v', '--no-analytics'],
        workingDirectory: tempPath,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      createProcess.stdout.transform(const Utf8Decoder()).listen(print);
      createProcess.stderr.transform(const Utf8Decoder()).listen(print);

      var createProjectExitCode = await createProcess.exitCode;
      assert(
        createProjectExitCode == 0,
        'Failed to create the serverpod project.',
      );
    });

    tearDown(() async {
      createProcess.kill();
      generateWatch?.kill();
      generateStreamSearch.cancel();
    });

    test('then the entity files are generated and updated as expected.', () async {
      generateWatch = await Process.start(
        'serverpod',
        ['generate', '--watch', '-v', '--no-analytics'],
        workingDirectory: path.join(tempPath, serverDir),
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      generateStreamSearch = KeywordSearchInStream(
        keywords: generateWatchCompletionKeywords,
      );
      generateWatch!.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen(generateStreamSearch.onData);
      generateWatch!.stderr
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen(print);

      await expectLater(
        generateStreamSearch.keywordFound,
        completion(isTrue),
        reason:
            'Initial code generation did not complete before timeout was reached.',
      );
      // This delay is required to ensure that the generate watch is
      // ready to receive file changes after the initial generation.
      await Future.delayed(const Duration(seconds: 1));

      var protocolFileName = 'test_entity';
      var protocolFile = File(
        createProtocolFileInModelDirectory(
          tempPath,
          serverDir,
          protocolFileName,
        ),
      );
      protocolFile.createSync(recursive: true);
      protocolFile.writeAsStringSync('''
class: TestEntity
fields:
  name: String
''', flush: true);

      await expectLater(
        generateStreamSearch.keywordFound,
        completion(isTrue),
        reason:
            'Incremental code generation did not complete before timeout was reached.',
      );

      // Validate that entity file is generated
      var entityFileName = '$protocolFileName.dart';
      var entityDirectory = Directory(
        createClientModelDirectoryPath(tempPath, clientDir),
      );
      var entityFiles = entityDirectory.listSync();
      expect(
        entityFiles.map((e) => path.basename(e.path)),
        contains(entityFileName),
        reason: 'Entity file not found.',
      );

      // Validate that entity file contains expected content
      var entityFile = entityFiles.firstWhereOrNull(
        (e) => path.basename(e.path) == entityFileName,
      );
      expect(
        entityFile,
        isA<File>(),
        reason: 'Entity file did not have expected type.',
      );
      var entityFileContents = (entityFile as File).readAsStringSync();
      expect(
        entityFileContents,
        contains('class TestEntity'),
        reason: 'Entity file did not contain expected class.',
      );

      // Update model file
      protocolFile.writeAsStringSync('''
class: TestEntity
fields:
  name: String
  age: int
''', flush: true);

      await expectLater(
        generateStreamSearch.keywordFound,
        completion(isTrue),
        reason:
            'Incremental code generation did not complete before timeout was reached.',
      );

      // Validate file is changed to reflect update
      entityFiles = entityDirectory.listSync();
      expect(
        entityFiles.map((e) => path.basename(e.path)),
        contains(entityFileName),
        reason: 'Entity file not found.',
      );
      entityFileContents = entityFile.readAsStringSync();
      expect(
        entityFileContents,
        contains('int age'),
        reason: 'Entity file did not contain the added field.',
      );

      protocolFile.deleteSync();
      await expectLater(
        generateStreamSearch.keywordFound,
        completion(isTrue),
        reason:
            'Incremental code generation did not complete before timeout was reached.',
      );

      entityFiles = entityDirectory.listSync();
      expect(
        entityFiles.map((e) => path.basename(e.path)),
        isNot(contains(entityFileName)),
        reason: 'Entity file still exists found.',
      );
    });
  });

  group(
    'Given a model file in the "lib/src/ directory that is changed when generate watch is active',
    () {
      var (projectName, _) = createRandomProjectName(tempPath);
      var (serverDir, _, clientDir) = createProjectFolderPaths(projectName);

      late Process createProcess;
      Process? generateWatch;
      KeywordSearchInStream generateStreamSearch = KeywordSearchInStream(
        keywords: generateWatchCompletionKeywords,
      );
      setUp(() async {
        createProcess = await Process.start(
          'serverpod',
          ['create', projectName, '-v', '--no-analytics'],
          workingDirectory: tempPath,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        createProcess.stdout.transform(const Utf8Decoder()).listen(print);
        createProcess.stderr.transform(const Utf8Decoder()).listen(print);

        var createProjectExitCode = await createProcess.exitCode;
        assert(
          createProjectExitCode == 0,
          'Failed to create the serverpod project.',
        );
      });

      tearDown(() async {
        createProcess.kill();
        generateWatch?.kill();
        generateStreamSearch.cancel();
      });

      test('then the entity files are generated and updated as expected.', () async {
        generateWatch = await Process.start(
          'serverpod',
          ['generate', '--watch', '-v', '--no-analytics'],
          workingDirectory: path.join(tempPath, serverDir),
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        generateStreamSearch = KeywordSearchInStream(
          keywords: generateWatchCompletionKeywords,
        );
        generateWatch!.stdout
            .transform(const Utf8Decoder())
            .transform(const LineSplitter())
            .listen(generateStreamSearch.onData);
        generateWatch!.stderr
            .transform(const Utf8Decoder())
            .transform(const LineSplitter())
            .listen(print);

        await expectLater(
          generateStreamSearch.keywordFound,
          completion(isTrue),
          reason:
              'Initial code generation did not complete before timeout was reached.',
        );
        // This delay is required to ensure that the generate watch is
        // ready to receive file changes after the initial generation.
        await Future.delayed(const Duration(seconds: 1));

        var protocolFileName = 'test_entity';
        var protocolFile = File(
          createProjectProtocolFile(
            tempPath,
            serverDir,
            protocolFileName,
          ),
        );
        protocolFile.createSync(recursive: true);
        protocolFile.writeAsStringSync('''
class: TestEntity
fields:
  name: String
''', flush: true);

        await expectLater(
          generateStreamSearch.keywordFound,
          completion(isTrue),
          reason:
              'Incremental code generation did not complete before timeout was reached.',
        );

        // Validate that entity file is generated
        var entityFileName = '$protocolFileName.dart';
        var entityDirectory = Directory(
          createClientModelDirectoryPath(tempPath, clientDir),
        );
        var entityFiles = entityDirectory.listSync();
        expect(
          entityFiles.map((e) => path.basename(e.path)),
          contains(entityFileName),
          reason: 'Entity file not found.',
        );

        // Validate that entity file contains expected content
        var entityFile = entityFiles.firstWhereOrNull(
          (e) => path.basename(e.path) == entityFileName,
        );
        expect(
          entityFile,
          isA<File>(),
          reason: 'Entity file did not have expected type.',
        );
        var entityFileContents = (entityFile as File).readAsStringSync();
        expect(
          entityFileContents,
          contains('class TestEntity'),
          reason: 'Entity file did not contain expected class.',
        );

        // Update model file
        protocolFile.writeAsStringSync('''
class: TestEntity
fields:
  name: String
  age: int
''', flush: true);

        await expectLater(
          generateStreamSearch.keywordFound,
          completion(isTrue),
          reason:
              'Incremental code generation did not complete before timeout was reached.',
        );

        // Validate file is changed to reflect update
        entityFiles = entityDirectory.listSync();
        expect(
          entityFiles.map((e) => path.basename(e.path)),
          contains(entityFileName),
          reason: 'Entity file not found.',
        );
        entityFileContents = entityFile.readAsStringSync();
        expect(
          entityFileContents,
          contains('int age'),
          reason: 'Entity file did not contain the added field.',
        );

        protocolFile.deleteSync();
        await expectLater(
          generateStreamSearch.keywordFound,
          completion(isTrue),
          reason:
              'Incremental code generation did not complete before timeout was reached.',
        );

        entityFiles = entityDirectory.listSync();
        expect(
          entityFiles.map((e) => path.basename(e.path)),
          isNot(contains(entityFileName)),
          reason: 'Entity file still exists found.',
        );
      });
    },
  );

  group('Given an endpoint file that is changed when generate watch is active', () {
    var (projectName, _) = createRandomProjectName(tempPath);
    var (serverDir, _, _) = createProjectFolderPaths(projectName);

    late Process createProcess;
    Process? generateWatch;
    KeywordSearchInStream generateStreamSearch = KeywordSearchInStream(
      keywords: generateWatchCompletionKeywords,
    );
    setUp(() async {
      createProcess = await Process.start(
        'serverpod',
        ['create', projectName, '-v', '--no-analytics'],
        workingDirectory: tempPath,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      createProcess.stdout.transform(const Utf8Decoder()).listen(print);
      createProcess.stderr.transform(const Utf8Decoder()).listen(print);

      var createProjectExitCode = await createProcess.exitCode;
      assert(
        createProjectExitCode == 0,
        'Failed to create the serverpod project.',
      );
    });

    tearDown(() async {
      createProcess.kill();
      generateWatch?.kill();
      generateStreamSearch.cancel();
    });
    test('then endpoint dispatcher is generated and updated as expected.', () async {
      generateWatch = await Process.start(
        'serverpod',
        ['generate', '--watch', '-v', '--no-analytics'],
        workingDirectory: path.join(tempPath, serverDir),
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      generateWatch!.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen(generateStreamSearch.onData);
      generateWatch!.stderr
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen(print);

      await expectLater(
        generateStreamSearch.keywordFound,
        completion(isTrue),
        reason:
            'Initial code generation did not complete before timeout was reached.',
      );
      // This delay is required to ensure that the generate watch is
      // ready to receive file changes after the initial generation.
      await Future.delayed(const Duration(seconds: 1));

      var endpointFile = File(
        createProjectDartFilePath(
          tmpFolder: tempPath,
          serverDir: serverDir,
          pathParts: ['endpoints'],
          fileName: 'test_endpoint',
        ),
      );
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class TestEndpoint extends Endpoint {
  Future<String> testEndpointMethod(Session session, String name) async {
    return 'Hello \$name';
  }
}

''', flush: true);

      await expectLater(
        generateStreamSearch.keywordFound,
        completion(isTrue),
        reason:
            'Incremental code generation did not complete before timeout was reached.',
      );

      // Validate endpoint client methods are generated
      var endpointDispatcherFile = File(
        createServerEndpointDispatcherFilePath(
          tempPath,
          serverDir,
        ),
      );
      expect(
        endpointDispatcherFile.existsSync(),
        isTrue,
        reason: 'Endpoint dispatcher file not found.',
      );
      var endpointDispatcherFileContents = endpointDispatcherFile
          .readAsStringSync();
      expect(
        endpointDispatcherFileContents,
        contains('TestEndpoint'),
        reason:
            'Endpoint dispatcher file did not contain added endpoint class.',
      );
      expect(
        endpointDispatcherFileContents,
        contains('testEndpointMethod'),
        reason:
            'Endpoint dispatcher file did not contain the test endpoint method.',
      );

      // Update endpoint file
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class TestEndpoint extends Endpoint {
  Future<String> testEndpointMethod(Session session, String name) async {
    return 'Hello \$name';
  }

  Future<String> newTestEndpointMethod(Session session, String name) async {
    return 'Hello \$name';
  }
}

''', flush: true);

      await expectLater(
        generateStreamSearch.keywordFound,
        completion(isTrue),
        reason:
            'Incremental code generation did not complete before timeout was reached.',
      );

      // Validate that endpoint changes are reflected in endpoint dispatcher
      endpointDispatcherFileContents = endpointDispatcherFile
          .readAsStringSync();
      expect(
        endpointDispatcherFileContents,
        contains('newTestEndpointMethod'),
        reason:
            'Endpoint dispatcher file did not contain the new endpoint method.',
      );

      endpointFile.deleteSync();

      await expectLater(
        generateStreamSearch.keywordFound,
        completion(isTrue),
        reason:
            'Incremental code generation did not complete before timeout was reached.',
      );

      // Validate that endpoint is removed from endpoint dispatcher
      endpointDispatcherFileContents = endpointDispatcherFile
          .readAsStringSync();
      expect(
        endpointDispatcherFileContents,
        isNot(contains('TestEndpoint')),
        reason: 'Endpoint dispatcher still contained removed endpoint.',
      );
    });
  });

  group(
    'Given an endpoint file in the "lib/src" folder that is changed when generate watch is active',
    () {
      var (projectName, _) = createRandomProjectName(tempPath);
      var (serverDir, _, _) = createProjectFolderPaths(projectName);

      late Process createProcess;
      Process? generateWatch;
      KeywordSearchInStream generateStreamSearch = KeywordSearchInStream(
        keywords: generateWatchCompletionKeywords,
      );
      setUp(() async {
        createProcess = await Process.start(
          'serverpod',
          ['create', projectName, '-v', '--no-analytics'],
          workingDirectory: tempPath,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        createProcess.stdout.transform(const Utf8Decoder()).listen(print);
        createProcess.stderr.transform(const Utf8Decoder()).listen(print);

        var createProjectExitCode = await createProcess.exitCode;
        assert(
          createProjectExitCode == 0,
          'Failed to create the serverpod project.',
        );
      });

      tearDown(() async {
        createProcess.kill();
        generateWatch?.kill();
        generateStreamSearch.cancel();
      });

      test('then endpoint dispatcher is generated and updated as expected.', () async {
        generateWatch = await Process.start(
          'serverpod',
          ['generate', '--watch', '-v', '--no-analytics'],
          workingDirectory: path.join(tempPath, serverDir),
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        generateWatch!.stdout
            .transform(const Utf8Decoder())
            .transform(const LineSplitter())
            .listen(generateStreamSearch.onData);
        generateWatch!.stderr
            .transform(const Utf8Decoder())
            .transform(const LineSplitter())
            .listen(print);

        await expectLater(
          generateStreamSearch.keywordFound,
          completion(isTrue),
          reason:
              'Initial code generation did not complete before timeout was reached.',
        );
        // This delay is required to ensure that the generate watch is
        // ready to receive file changes after the initial generation.
        await Future.delayed(const Duration(seconds: 1));

        var endpointFile = File(
          createProjectDartFilePath(
            tmpFolder: tempPath,
            serverDir: serverDir,
            fileName: 'test_endpoint',
          ),
        );
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class TestEndpoint extends Endpoint {
  Future<String> testEndpointMethod(Session session, String name) async {
    return 'Hello \$name';
  }
}

''', flush: true);

        await expectLater(
          generateStreamSearch.keywordFound,
          completion(isTrue),
          reason:
              'Incremental code generation did not complete before timeout was reached.',
        );

        // Validate endpoint client methods are generated
        var endpointDispatcherFile = File(
          createServerEndpointDispatcherFilePath(
            tempPath,
            serverDir,
          ),
        );
        expect(
          endpointDispatcherFile.existsSync(),
          isTrue,
          reason: 'Endpoint dispatcher file not found.',
        );
        var endpointDispatcherFileContents = endpointDispatcherFile
            .readAsStringSync();
        expect(
          endpointDispatcherFileContents,
          contains('TestEndpoint'),
          reason:
              'Endpoint dispatcher file did not contain added endpoint class.',
        );
        expect(
          endpointDispatcherFileContents,
          contains('testEndpointMethod'),
          reason:
              'Endpoint dispatcher file did not contain the test endpoint method.',
        );

        // Update endpoint file
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class TestEndpoint extends Endpoint {
  Future<String> testEndpointMethod(Session session, String name) async {
    return 'Hello \$name';
  }

  Future<String> newTestEndpointMethod(Session session, String name) async {
    return 'Hello \$name';
  }
}

''', flush: true);

        await expectLater(
          generateStreamSearch.keywordFound,
          completion(isTrue),
          reason:
              'Incremental code generation did not complete before timeout was reached.',
        );

        // Validate that endpoint changes are reflected in endpoint dispatcher
        endpointDispatcherFileContents = endpointDispatcherFile
            .readAsStringSync();
        expect(
          endpointDispatcherFileContents,
          contains('newTestEndpointMethod'),
          reason:
              'Endpoint dispatcher file did not contain the new endpoint method.',
        );

        endpointFile.deleteSync();

        await expectLater(
          generateStreamSearch.keywordFound,
          completion(isTrue),
          reason:
              'Incremental code generation did not complete before timeout was reached.',
        );

        // Validate that endpoint is removed from endpoint dispatcher
        endpointDispatcherFileContents = endpointDispatcherFile
            .readAsStringSync();
        expect(
          endpointDispatcherFileContents,
          isNot(contains('TestEndpoint')),
          reason:
              'Endpoint dispatcher still contained removed endpoint in "lib/src".',
        );
      });
    },
  );

  group(
    'Given a serializable model used in an endpoint that is moved to a subfolder when generate watch is active',
    () {
      var (projectName, _) = createRandomProjectName(tempPath);
      var (serverDir, _, clientDir) = createProjectFolderPaths(projectName);

      late Process createProcess;
      Process? generateWatch;
      KeywordSearchInStream generateStreamSearch = KeywordSearchInStream(
        keywords: generateWatchCompletionKeywords,
      );
      setUp(() async {
        createProcess = await Process.start(
          'serverpod',
          ['create', projectName, '-v', '--no-analytics'],
          workingDirectory: tempPath,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        createProcess.stdout.transform(const Utf8Decoder()).listen(print);
        createProcess.stderr.transform(const Utf8Decoder()).listen(print);

        var createProjectExitCode = await createProcess.exitCode;
        assert(
          createProjectExitCode == 0,
          'Failed to create the serverpod project.',
        );
      });

      tearDown(() async {
        createProcess.kill();
        generateWatch?.kill();
        generateStreamSearch.cancel();
      });
      test('then client endpoint dispatcher is updated as expected.', () async {
        var endpointFile = File(
          createProjectDartFilePath(
            tmpFolder: tempPath,
            serverDir: serverDir,
            pathParts: ['endpoints'],
            fileName: 'test_endpoint',
          ),
        );
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class TestEndpoint extends Endpoint {
  Future<TestEntity> testEndpointMethod(Session session, TestEntity testEntity) async {
    return testEntity;
  }
}
''', flush: true);

        var protocolFileName = 'test_entity';
        var protocolFile = File(
          createProtocolFileInModelDirectory(
            tempPath,
            serverDir,
            protocolFileName,
          ),
        );
        protocolFile.createSync(recursive: true);
        protocolFile.writeAsStringSync('''
class: TestEntity
fields:
  name: String
''', flush: true);

        generateWatch = await Process.start(
          'serverpod',
          ['generate', '--watch', '-v', '--no-analytics'],
          workingDirectory: path.join(tempPath, serverDir),
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );

        generateWatch!.stdout
            .transform(const Utf8Decoder())
            .transform(const LineSplitter())
            .listen(generateStreamSearch.onData);
        generateWatch!.stderr
            .transform(const Utf8Decoder())
            .transform(const LineSplitter())
            .listen(print);

        await expectLater(
          generateStreamSearch.keywordFound,
          completion(isTrue),
          reason:
              'Initial code generation did not complete before timeout was reached.',
        );
        // This delay is required to ensure that the generate watch is
        // ready to receive file changes after the initial generation.
        await Future.delayed(const Duration(seconds: 1));

        // Validate both are present
        var entityFileName = '$protocolFileName.dart';
        var entityDirectory = Directory(
          createClientModelDirectoryPath(tempPath, clientDir),
        );
        var entityFiles = entityDirectory.listSync();
        expect(
          entityFiles.map((e) => path.basename(e.path)),
          contains(entityFileName),
          reason: 'Entity file not found.',
        );

        var endpointDispatcherFile = File(
          createClientEndpointDispatcherFilePath(
            tempPath,
            clientDir,
          ),
        );
        expect(
          endpointDispatcherFile.existsSync(),
          isTrue,
          reason: 'Client endpoint dispatcher file not found.',
        );
        var endpointDispatcherFileContents = endpointDispatcherFile
            .readAsStringSync();
        expect(
          endpointDispatcherFileContents,
          contains(
            'import \'package:${projectName}_client/src/protocol/$entityFileName\'',
          ),
          reason:
              'Could not find import for entity file in client endpoint dispatcher.',
        );

        // Move model file to subfolder
        var subFolderName = 'subfolder';
        Directory(
          createModelDirectoryPath(tempPath, serverDir, subFolderName),
        ).createSync(
          recursive: true,
        );
        protocolFile.renameSync(
          createProtocolFileInModelDirectory(
            tempPath,
            serverDir,
            protocolFileName,
            subFolder: subFolderName,
          ),
        );

        await expectLater(
          generateStreamSearch.keywordFound,
          completion(isTrue),
          reason:
              'Incremental code generation did not complete before timeout was reached.',
        );

        // Validate that entity file import is updated
        endpointDispatcherFileContents = endpointDispatcherFile
            .readAsStringSync();
        expect(
          endpointDispatcherFileContents,
          contains(
            'import \'package:${projectName}_client/src/protocol/$subFolderName/$entityFileName\'',
          ),
          reason:
              'Could not find import for moved entity file in client endpoint dispatcher.',
        );
      });
    },
  );

  group('Given a generated file that is changed when generate watch is active', () {
    var (projectName, _) = createRandomProjectName(tempPath);
    var (serverDir, _, clientDir) = createProjectFolderPaths(projectName);

    late Process createProcess;
    Process? generateWatch;
    KeywordSearchInStream generateStreamSearch = KeywordSearchInStream(
      keywords: generateWatchCompletionKeywords,
    );
    setUp(() async {
      createProcess = await Process.start(
        'serverpod',
        ['create', projectName, '-v', '--no-analytics'],
        workingDirectory: tempPath,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      createProcess.stdout.transform(const Utf8Decoder()).listen(print);
      createProcess.stderr.transform(const Utf8Decoder()).listen(print);

      var createProjectExitCode = await createProcess.exitCode;
      assert(
        createProjectExitCode == 0,
        'Failed to create the serverpod project.',
      );
    });

    tearDown(() async {
      createProcess.kill();
      generateWatch?.kill();
      generateStreamSearch.cancel();
    });

    test('then generator is not triggered.', () async {
      generateWatch = await Process.start(
        'serverpod',
        ['generate', '--watch', '-v', '--no-analytics'],
        workingDirectory: path.join(tempPath, serverDir),
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      generateStreamSearch = KeywordSearchInStream(
        keywords: generateWatchCompletionKeywords,
      );
      generateWatch!.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen(generateStreamSearch.onData);
      generateWatch!.stderr
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen(print);

      await expectLater(
        generateStreamSearch.keywordFound,
        completion(isTrue),
        reason:
            'Initial code generation did not complete before timeout was reached.',
      );
      // This delay is required to ensure that the generate watch is
      // ready to receive file changes after the initial generation.
      await Future.delayed(const Duration(seconds: 1));

      var protocolFileName = 'test_entity';
      var protocolFile = File(
        createProtocolFileInModelDirectory(
          tempPath,
          serverDir,
          protocolFileName,
        ),
      );
      protocolFile.createSync(recursive: true);
      protocolFile.writeAsStringSync('''
class: TestEntity
fields:
  name: String
''', flush: true);

      await expectLater(
        generateStreamSearch.keywordFound,
        completion(isTrue),
        reason:
            'Incremental code generation did not complete before timeout was reached.',
      );

      // Validate that entity file is generated
      var entityFileName = '$protocolFileName.dart';
      var entityDirectory = Directory(
        createClientModelDirectoryPath(tempPath, clientDir),
      );
      var entityFiles = entityDirectory.listSync();
      expect(
        entityFiles.map((e) => path.basename(e.path)),
        contains(entityFileName),
        reason: 'Entity file not found.',
      );

      // Read generated file
      var entityFile = entityFiles.firstWhereOrNull(
        (e) => path.basename(e.path) == entityFileName,
      );
      expect(
        entityFile,
        isA<File>(),
        reason: 'Entity file did not have expected type.',
      );

      // Modify generated file
      var entityFileContents = (entityFile as File).readAsStringSync();
      var modifiedEntityFileContents = '''$entityFileContents
\n// Modified
      ''';
      entityFile.writeAsStringSync(modifiedEntityFileContents, flush: true);

      await expectLater(
        generateStreamSearch.keywordFound,
        completion(isFalse),
        reason:
            'Incremental code generation was triggered when generated file was modified.',
      );
    });
  });
}

(String, String) createRandomProjectName(String root) {
  var projectName =
      'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
  var commandRoot = path.join(root, projectName, '${projectName}_server');

  return (projectName, commandRoot);
}

(String, String, String) createProjectFolderPaths(String projectName) {
  var serverDir = path.join(projectName, '${projectName}_server');
  var flutterDir = path.join(projectName, '${projectName}_flutter');
  var clientDir = path.join(projectName, '${projectName}_client');

  return (serverDir, flutterDir, clientDir);
}

String createClientModelDirectoryPath(
  String tmpFolder,
  String clientDir,
) {
  return path.join(tmpFolder, clientDir, 'lib', 'src', 'protocol');
}

String createModelDirectoryPath(
  String tmpFolder,
  String serverDir,
  String? subFolder,
) {
  var basePath = [tmpFolder, serverDir, 'lib', 'src', 'models'];

  if (subFolder == null) {
    return path.joinAll(basePath);
  }

  return path.joinAll([...basePath, subFolder]);
}

String createProtocolFileInModelDirectory(
  String tmpFolder,
  String serverDir,
  String fileName, {
  String? subFolder,
}) {
  return path.join(
    createModelDirectoryPath(tmpFolder, serverDir, subFolder),
    '$fileName.spy.yaml',
  );
}

String createProjectProtocolFile(
  String tmpFolder,
  String serverDir,
  String fileName, {
  List<String>? pathParts,
}) {
  return path.joinAll([
    tmpFolder,
    serverDir,
    'lib',
    'src',
    ...?pathParts,
    '$fileName.spy.yaml',
  ]);
}

String createProjectDartFilePath({
  required String tmpFolder,
  required String serverDir,
  required String fileName,
  List<String>? pathParts,
}) {
  return path.joinAll([
    tmpFolder,
    serverDir,
    'lib',
    'src',
    ...?pathParts,
    '$fileName.dart',
  ]);
}

String createServerEndpointDispatcherFilePath(
  String tmpFolder,
  String serverDir,
) {
  return path.join(
    tmpFolder,
    serverDir,
    'lib',
    'src',
    'generated',
    'endpoints.dart',
  );
}

String createClientEndpointDispatcherFilePath(
  String tmpFolder,
  String clientDir,
) {
  return path.join(
    tmpFolder,
    clientDir,
    'lib',
    'src',
    'protocol',
    'client.dart',
  );
}
