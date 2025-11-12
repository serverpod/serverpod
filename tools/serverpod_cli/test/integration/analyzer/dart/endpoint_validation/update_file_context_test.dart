import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/endpoints_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

import '../../../../test_util/endpoint_validation_helpers.dart';

const pathToServerpodRoot = '../../../../../../../..';
var testProjectDirectory = Directory(
  path.joinAll([
    'test',
    'integration',
    'analyzer',
    'dart',
    'endpoint_validation',
    const Uuid().v4(),
  ]),
);

void main() {
  setUpAll(() async {
    await createTestEnvironment(testProjectDirectory, pathToServerpodRoot);
  });

  tearDownAll(() {
    testProjectDirectory.deleteSync(recursive: true);
  });

  group('Given an empty tracked and analyzed directory', () {
    var trackedDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      analyzer = EndpointsAnalyzer(trackedDirectory);
      await analyzer.analyze(collector: CodeGenerationCollector());
    });

    test('when the file context is updated with a file without an endpoint '
        'definition in the tracked directory'
        'then false is returned.', () async {
      var emptyFile = File(path.join(trackedDirectory.path, 'empty_file.dart'));
      emptyFile.createSync(recursive: true);
      emptyFile.writeAsStringSync('');

      await expectLater(
        analyzer.updateFileContexts({emptyFile.path}),
        completion(false),
      );
    });

    test('when the file context is updated with an endpoint file outside '
        'of the tracked directory '
        'then false is returned.', () async {
      var endpointFile = File(
        path.join(testProjectDirectory.path, 'endpoint.dart'),
      );
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');

      await expectLater(
        analyzer.updateFileContexts({endpointFile.path}),
        completion(false),
      );
    });

    test('when the file context is updated with a new endpoint file in the '
        'tracked directory '
        'then true is returned.', () async {
      var endpointFile = File(
        path.join(trackedDirectory.path, 'endpoint.dart'),
      );
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');

      await expectLater(
        analyzer.updateFileContexts({endpointFile.path}),
        completion(true),
      );
    });
  });
  group('Given a tracked and analyzed directory with valid endpoint file', () {
    var trackedDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late File endpointFile;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      endpointFile = File(path.join(trackedDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
      analyzer = EndpointsAnalyzer(trackedDirectory);
      await analyzer.analyze(collector: CodeGenerationCollector());
    });

    test('when the file context is updated with the removal of the tracked '
        'endpoint file '
        'then true is returned.', () async {
      endpointFile.deleteSync();

      await expectLater(
        analyzer.updateFileContexts({endpointFile.path}),
        completion(true),
      );
    });

    test('when the file context is updated with the update of the endpoint '
        'file in the tracked folder '
        'then true is returned.', () async {
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> goodbye(Session session, String name) async {
    return 'Goodbye \$name';
  }
}
''');

      await expectLater(
        analyzer.updateFileContexts({endpointFile.path}),
        completion(true),
      );
    });

    test('when the file context is updated with a non endpoint file '
        'then false is returned.', () async {
      var nonEndpointFile = File(
        path.join(trackedDirectory.path, 'non_endpoint.dart'),
      );
      nonEndpointFile.createSync(recursive: true);
      nonEndpointFile.writeAsStringSync('''
class ExampleClass {}
''');

      await expectLater(
        analyzer.updateFileContexts({nonEndpointFile.path}),
        completion(false),
      );
    });

    test('when the file context is updated with a new endpoint file '
        'then true is returned.', () async {
      var newEndpointFile = File(
        path.join(trackedDirectory.path, 'new_endpoint.dart'),
      );
      newEndpointFile.createSync(recursive: true);
      newEndpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class NewEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  });
}
''');

      await expectLater(
        analyzer.updateFileContexts({newEndpointFile.path}),
        completion(true),
      );
    });
  });

  group(
    'Given a tracked and analyzed directory with valid non-endpoint file',
    () {
      var trackedDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late File trackedFile;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        trackedFile = File(path.join(trackedDirectory.path, 'tracked.dart'));
        trackedFile.createSync(recursive: true);
        trackedFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleClass {
  Future<String> hello(String name) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(trackedDirectory);
        await analyzer.analyze(collector: CodeGenerationCollector());
      });

      test('when the file context is updated with an endpoint definition added '
          'to the tracked file '
          'then true is returned.', () async {
        trackedFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');

        await expectLater(
          analyzer.updateFileContexts({trackedFile.path}),
          completion(true),
        );
      });
    },
  );

  group(
    'Given a tracked and analyzed directory with invalid dart endpoint file',
    () {
      var trackedDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late File endpointFile;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        endpointFile = File(path.join(trackedDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        // Class is missing closing brackets
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
''');
        analyzer = EndpointsAnalyzer(trackedDirectory);
        await analyzer.analyze(collector: CodeGenerationCollector());
      });

      test('when the file context is updated with a valid endpoint definition '
          'added to the tracked file '
          'then true is returned.', () async {
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');

        await expectLater(
          analyzer.updateFileContexts({endpointFile.path}),
          completion(true),
        );
      });
    },
  );

  group(
    'Given a tracked and analyzed endpoint file that depends on an invalid dart file',
    () {
      var trackedDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late File invalidDartFile;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(
          path.join(trackedDirectory.path, 'endpoint.dart'),
        );
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';
import 'invalid_dart.dart';

class ExampleClass extends Endpoint {
  Future<String> hello(Session session, String name) async {
    InvalidClass example = InvalidClass();
    return 'Hello \$name';
  }
}
''');
        invalidDartFile = File(
          path.join(trackedDirectory.path, 'invalid_dart.dart'),
        );
        invalidDartFile.createSync(recursive: true);
        // Class keyword is combined with class name
        invalidDartFile.writeAsStringSync('''
classInvalidClass {}
''');
        analyzer = EndpointsAnalyzer(trackedDirectory);
        await analyzer.analyze(collector: CodeGenerationCollector());
      });

      test(
        'when the file context is updated with a fix for the invalid dart file '
        'then true is returned.',
        () async {
          invalidDartFile.writeAsStringSync('''
class InvalidClass {}
''');

          await expectLater(
            analyzer.updateFileContexts({invalidDartFile.path}),
            completion(true),
          );
        },
      );
    },
  );
}
