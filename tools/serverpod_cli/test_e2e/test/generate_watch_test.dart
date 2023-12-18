@Timeout(Duration(minutes: 8))

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
  var rootPath = path.join(Directory.current.path, '..', '..', '..');
  var cliPath = path.join(rootPath, 'tools', 'serverpod_cli');

  setUpAll(() async {
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
    var (projectName, commandRoot) = createRandomProjectName(tempPath);
    var (serverDir, _, clientDir) = createProjectFolderPaths(projectName);

    late Process createProcess;
    Process? generateWatch;
    KeywordSearchInStream? generateStreamSearch;
    setUp(() async {
      // Create project
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
      generateStreamSearch?.close();

      await Process.run(
        'docker',
        ['compose', 'down', '-v'],
        workingDirectory: commandRoot,
      );

      while (!await isNetworkPortAvailable(8090)) {}
    });

    test('then the entity files are generated and updated as expected.',
        () async {
      // Start generate watch
      generateWatch = await Process.start(
        'serverpod',
        ['generate', '--watch', '-v', '--no-analytics'],
        workingDirectory: path.join(tempPath, serverDir),
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      var stdoutStream = generateWatch!.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter());
      generateWatch!.stderr
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen(print);

      generateStreamSearch = KeywordSearchInStream(
        stdoutStream,
        keywords: generateWatchCompletionKeywords,
      ).startListen();

      await expectLater(
        generateStreamSearch?.keywordFound,
        completion(isTrue),
        reason:
            'Initial code generation did not complete before timeout was reached.',
      );
      // This delay is required to ensure that the generate watch is
      // ready to receive file changes after the initial generation.
      await Future.delayed(const Duration(seconds: 1));

      // Add model file
      var protocolFileName = 'test_entity';
      var protocolFile = File(createProtocolFilePath(
        tempPath,
        serverDir,
        protocolFileName,
      ));
      protocolFile.createSync(recursive: true);
      protocolFile.writeAsStringSync('''
class: TestEntity
fields:
  name: String
''', flush: true);

      await expectLater(
        generateStreamSearch?.keywordFound,
        completion(isTrue),
        reason:
            'Incremental code generation did not complete before timeout was reached.',
      );

      // Validate that entity file is generated
      var entityFileName = '$protocolFileName.dart';
      var entityDirectory =
          Directory(createClientModelDirectoryPath(tempPath, clientDir));
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
        generateStreamSearch?.keywordFound,
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

      // Remove model file
      protocolFile.deleteSync();
      await expectLater(
        generateStreamSearch?.keywordFound,
        completion(isTrue),
        reason:
            'Incremental code generation did not complete before timeout was reached.',
      );

      // Validate file is removed
      entityFiles = entityDirectory.listSync();
      expect(
        entityFiles.map((e) => path.basename(e.path)),
        isNot(contains(entityFileName)),
        reason: 'Entity file still exists found.',
      );
    });
  });

  group('Given an endpoint file that is changed when generate watch is active',
      () {
    var (projectName, commandRoot) = createRandomProjectName(tempPath);
    var (serverDir, _, _) = createProjectFolderPaths(projectName);

    late Process createProcess;
    Process? generateWatch;
    KeywordSearchInStream? generateStreamSearch;
    setUp(() async {
      // Create project
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
      generateStreamSearch?.close();

      await Process.run(
        'docker',
        ['compose', 'down', '-v'],
        workingDirectory: commandRoot,
      );

      while (!await isNetworkPortAvailable(8090)) {}
    });
    test('then endpoint dispatcher is generated and updated as expected.',
        () async {
      // Start generate watch
      generateWatch = await Process.start(
        'serverpod',
        ['generate', '--watch', '-v', '--no-analytics'],
        workingDirectory: path.join(tempPath, serverDir),
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      var stdoutStream = generateWatch!.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter());
      generateWatch!.stderr
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen(print);

      generateStreamSearch = KeywordSearchInStream(
        stdoutStream,
        keywords: generateWatchCompletionKeywords,
      ).startListen();

      await expectLater(
        generateStreamSearch?.keywordFound,
        completion(isTrue),
        reason:
            'Initial code generation did not complete before timeout was reached.',
      );
      // This delay is required to ensure that the generate watch is
      // ready to receive file changes after the initial generation.
      await Future.delayed(const Duration(seconds: 1));

      // Add endpoint file
      var endpointFile = File(createEndpointFilePath(
        tempPath,
        serverDir,
        'test_endpoint',
      ));
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
        generateStreamSearch?.keywordFound,
        completion(isTrue),
        reason:
            'Incremental code generation did not complete before timeout was reached.',
      );

      // Validate endpoint client methods are generated
      var endpointDispatcherFile = File(createServerEndpointDispatcherFilePath(
        tempPath,
        serverDir,
      ));
      expect(
        endpointDispatcherFile.existsSync(),
        isTrue,
        reason: 'Endpoint dispatcher file not found.',
      );
      var endpointDispatcherFileContents =
          endpointDispatcherFile.readAsStringSync();
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
        generateStreamSearch?.keywordFound,
        completion(isTrue),
        reason:
            'Incremental code generation did not complete before timeout was reached.',
      );

      // Validate that endpoint changes are reflected in endpoint dispatcher
      endpointDispatcherFileContents =
          endpointDispatcherFile.readAsStringSync();
      expect(
        endpointDispatcherFileContents,
        contains('newTestEndpointMethod'),
        reason:
            'Endpoint dispatcher file did not contain the new endpoint method.',
      );

      // Remove endpoint file
      endpointFile.deleteSync();

      await expectLater(
        generateStreamSearch?.keywordFound,
        completion(isTrue),
        reason:
            'Incremental code generation did not complete before timeout was reached.',
      );

      // Validate that endpoint is removed from endpoint dispatcher
      endpointDispatcherFileContents =
          endpointDispatcherFile.readAsStringSync();
      expect(
        endpointDispatcherFileContents,
        isNot(contains('TestEndpoint')),
        reason: 'Endpoint dispatcher still contained removed endpoint.',
      );
    });
  });

  group(
      'Given a serializable entity used in an endpoint that is moved to a subfolder when generate watch is active',
      () {
    var (projectName, commandRoot) = createRandomProjectName(tempPath);
    var (serverDir, _, clientDir) = createProjectFolderPaths(projectName);

    late Process createProcess;
    Process? generateWatch;
    KeywordSearchInStream? generateStreamSearch;
    setUp(() async {
      // Create project
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
      generateStreamSearch?.close();

      await Process.run(
        'docker',
        ['compose', 'down', '-v'],
        workingDirectory: commandRoot,
      );

      while (!await isNetworkPortAvailable(8090)) {}
    });
    test('then client endpoint dispatcher is updated as expected.', () async {
      // Add endpoint file
      var endpointFile = File(createEndpointFilePath(
        tempPath,
        serverDir,
        'test_endpoint',
      ));
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

      // Add model file
      var protocolFileName = 'test_entity';
      var protocolFile = File(createProtocolFilePath(
        tempPath,
        serverDir,
        protocolFileName,
      ));
      protocolFile.createSync(recursive: true);
      protocolFile.writeAsStringSync('''
class: TestEntity
fields:
  name: String
''', flush: true);

      // Start generate watch
      generateWatch = await Process.start(
        'serverpod',
        ['generate', '--watch', '-v', '--no-analytics'],
        workingDirectory: path.join(tempPath, serverDir),
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      var stdoutStream = generateWatch!.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter());
      generateWatch!.stderr
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen(print);

      generateStreamSearch = KeywordSearchInStream(
        stdoutStream,
        keywords: generateWatchCompletionKeywords,
      ).startListen();

      await expectLater(
        generateStreamSearch?.keywordFound,
        completion(isTrue),
        reason:
            'Initial code generation did not complete before timeout was reached.',
      );
      // This delay is required to ensure that the generate watch is
      // ready to receive file changes after the initial generation.
      await Future.delayed(const Duration(seconds: 1));

      // Validate both are present
      var entityFileName = '$protocolFileName.dart';
      var entityDirectory =
          Directory(createClientModelDirectoryPath(tempPath, clientDir));
      var entityFiles = entityDirectory.listSync();
      expect(
        entityFiles.map((e) => path.basename(e.path)),
        contains(entityFileName),
        reason: 'Entity file not found.',
      );

      var endpointDispatcherFile = File(createClientEndpointDispatcherFilePath(
        tempPath,
        clientDir,
      ));
      expect(
        endpointDispatcherFile.existsSync(),
        isTrue,
        reason: 'Client endpoint dispatcher file not found.',
      );
      var endpointDispatcherFileContents =
          endpointDispatcherFile.readAsStringSync();
      expect(
        endpointDispatcherFileContents,
        contains(
            'import \'package:${projectName}_client/src/protocol/$entityFileName\''),
        reason:
            'Could not find import for entity file in client endpoint dispatcher.',
      );

      // Move model file to subfolder
      var subFolderName = 'subfolder';
      Directory(createModelDirectoryPath(tempPath, serverDir, subFolderName))
          .createSync(
        recursive: true,
      );
      protocolFile.renameSync(createProtocolFilePath(
        tempPath,
        serverDir,
        protocolFileName,
        subFolder: subFolderName,
      ));

      await expectLater(
        generateStreamSearch?.keywordFound,
        completion(isTrue),
        reason:
            'Incremental code generation did not complete before timeout was reached.',
      );

      // Validate that entity file import is updated
      endpointDispatcherFileContents =
          endpointDispatcherFile.readAsStringSync();
      expect(
        endpointDispatcherFileContents,
        contains(
            'import \'package:${projectName}_client/src/protocol/$subFolderName/$entityFileName\''),
        reason:
            'Could not find import for moved entity file in client endpoint dispatcher.',
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
  var basePath = [tmpFolder, serverDir, 'lib', 'src', 'model'];

  if (subFolder == null) {
    return path.joinAll(basePath);
  }

  return path.joinAll([...basePath, subFolder]);
}

String createProtocolFilePath(
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

String createEndpointFilePath(
  String tmpFolder,
  String serverDir,
  String fileName,
) {
  return path.join(
    tmpFolder,
    serverDir,
    'lib',
    'src',
    'endpoints',
    '$fileName.dart',
  );
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

Future<bool> isNetworkPortAvailable(int port) async {
  try {
    var socket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    await socket.close();
    return true;
  } catch (e) {
    return false;
  }
}
