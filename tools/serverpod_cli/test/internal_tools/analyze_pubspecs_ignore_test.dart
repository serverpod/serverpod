import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '../test_util/endpoint_validation_helpers.dart';

late String _driver;

void main() {
  setUpAll(() async {
    final directory = await Directory.systemTemp.createTemp('pubspec-driver-');
    addTearDown(() => directory.delete(recursive: true));
    _driver = p.join(directory.path, 'driver.dill');
    final source = p.join(
      await resolveServerpodRoot(),
      'tools',
      'serverpod_cli',
      'test',
      'test_util',
      'analyze_pubspecs_driver.dart',
    );
    final packageConfig = (await Isolate.packageConfig)!;
    // Compile once; each case still gets a fresh process and repository.
    final result = await _runDart([
      'compile',
      'kernel',
      '--packages=${packageConfig.toFilePath()}',
      source,
      '-o',
      _driver,
    ], timeout: const Duration(minutes: 1));
    expect(result[0], 0, reason: '${result[1]}\n${result[2]}');
  });

  test(
    'Given a release package pinned to the Serverpod version, '
    'when ignore-serverpod is set, then the latest-version check skips it',
    () {
      return _check(
        packages: {
          'packages/serverpod_client': _package(
            name: 'serverpod_client',
            version: '1.0.0',
          ),
        },
        publishablePackages: ['packages/serverpod_client'],
        dependencies: {'serverpod_client': '1.0.0'},
        ignoreServerpodPackages: true,
        expectedMatch: true,
        expectedFetches: [],
      );
    },
  );

  test(
    'Given an outdated unrelated serverpod_* dependency, '
    'when ignore-serverpod is set, then the latest-version check reports it',
    () {
      return _check(
        dependencies: {'serverpod_independent_demo': '1.0.0'},
        ignoreServerpodPackages: true,
        expectedMatch: false,
        expectedFetches: ['serverpod_independent_demo'],
      );
    },
  );

  test(
    'Given an outdated third-party dependency, '
    'when ignore-serverpod is set, then the latest-version check reports it',
    () {
      return _check(
        dependencies: {'independent_demo': '1.0.0'},
        ignoreServerpodPackages: true,
        expectedMatch: false,
        expectedFetches: ['independent_demo'],
      );
    },
  );

  test(
    'Given a release package with a stale dependency pin, '
    'when ignore-serverpod is set, then the latest-version check includes it',
    () {
      return _check(
        packages: {
          'packages/serverpod_client': _package(
            name: 'serverpod_client',
            version: '1.0.0',
          ),
        },
        publishablePackages: ['packages/serverpod_client'],
        dependencies: {'serverpod_client': '0.9.0'},
        ignoreServerpodPackages: true,
        expectedMatch: false,
        expectedFetches: ['serverpod_client'],
      );
    },
  );

  test(
    'Given a release package with a ranged dependency constraint, '
    'when ignore-serverpod is set, then the latest-version check includes it',
    () {
      return _check(
        packages: {
          'packages/serverpod_client': _package(
            name: 'serverpod_client',
            version: '1.0.0',
          ),
        },
        publishablePackages: ['packages/serverpod_client'],
        dependencies: {'serverpod_client': '^1.0.0'},
        ignoreServerpodPackages: true,
        expectedMatch: false,
        expectedFetches: ['serverpod_client'],
      );
    },
  );

  test(
    'Given a listed release package at a different package version, '
    'when ignore-serverpod is set, then the latest-version check includes it',
    () {
      return _check(
        packages: {
          'packages/serverpod_client': _package(
            name: 'serverpod_client',
            version: '0.9.0',
          ),
        },
        publishablePackages: ['packages/serverpod_client'],
        dependencies: {'serverpod_client': '0.9.0'},
        ignoreServerpodPackages: true,
        expectedMatch: false,
        expectedFetches: ['serverpod_client'],
      );
    },
  );

  test(
    'Given a frozen package dependency outside the frozen tree, '
    'when ignore-serverpod is set, then the latest-version check includes it',
    () {
      return _check(
        packages: {
          p.join(
            'modules',
            'legacy',
            'serverpod_chat',
            'serverpod_chat_server',
          ): _package(
            name: 'serverpod_chat_server',
            version: '0.9.0',
          ),
        },
        dependencies: {'serverpod_chat_server': '0.9.0'},
        ignoreServerpodPackages: true,
        expectedMatch: false,
        expectedFetches: ['serverpod_chat_server'],
      );
    },
  );

  test(
    'Given a private package at the Serverpod version, '
    'when ignore-serverpod is set, then the latest-version check includes it',
    () {
      return _check(
        packages: {
          'tests/serverpod_private': _package(
            name: 'serverpod_private',
            version: '1.0.0',
            publishToNone: true,
          ),
        },
        dependencies: {'serverpod_private': '1.0.0'},
        ignoreServerpodPackages: true,
        expectedMatch: false,
        expectedFetches: ['serverpod_private'],
      );
    },
  );

  test('Given a version placeholder template beside a real package, '
      'when ignore-serverpod is set, then the release version is used', () {
    return _check(
      packages: {
        'packages/serverpod_client': _package(
          name: 'serverpod_client',
          version: '1.0.0',
        ),
        p.join('templates', 'pubspecs', 'packages', 'serverpod_client'):
            'name: serverpod_client\nversion: SERVERPOD_VERSION\n',
      },
      publishablePackages: ['packages/serverpod_client'],
      dependencies: {'serverpod_client': '1.0.0'},
      ignoreServerpodPackages: true,
      expectedMatch: true,
      expectedFetches: [],
    );
  });

  test(
    'Given a release package without the ignore flag, '
    'when checking latest versions, then it is checked normally',
    () {
      return _check(
        packages: {
          'packages/serverpod_client': _package(
            name: 'serverpod_client',
            version: '1.0.0',
          ),
        },
        publishablePackages: ['packages/serverpod_client'],
        dependencies: {'serverpod_client': '1.0.0'},
        ignoreServerpodPackages: false,
        expectedMatch: false,
        expectedFetches: ['serverpod_client'],
      );
    },
  );

  test(
    'Given no ignore flag and no release manifest, '
    'when checking latest versions, then ordinary dependencies are checked',
    () {
      return _check(
        dependencies: {'independent_demo': '1.0.0'},
        ignoreServerpodPackages: false,
        writePublishablePackages: false,
        expectedMatch: false,
        expectedFetches: ['independent_demo'],
      );
    },
  );

  test(
    'Given a missing publishable-package manifest, '
    'when ignoring Serverpod packages, then the check fails visibly',
    () {
      return _check(
        dependencies: {'serverpod_client': '1.0.0'},
        ignoreServerpodPackages: true,
        writePublishablePackages: false,
        expectedMatch: false,
        expectedFetches: [],
      );
    },
  );

  test(
    'Given a missing listed package pubspec, '
    'when ignoring Serverpod packages, then the check fails visibly',
    () {
      return _check(
        publishablePackages: ['packages/missing'],
        dependencies: {'serverpod_client': '1.0.0'},
        ignoreServerpodPackages: true,
        expectedMatch: false,
        expectedFetches: [],
      );
    },
  );

  test(
    'Given a dependency version that differs only inside an ignored tree, '
    'when versions are compared, then that tree does not create a mismatch',
    () {
      return _check(
        packages: {
          p.join(
            'modules',
            'legacy',
            'serverpod_chat',
            'serverpod_chat_server',
          ): '''
name: serverpod_chat_server
version: 4.0.0-beta.0
dependencies:
  meta: 9.0.0
''',
        },
        dependencies: {'meta': '1.0.0'},
        ignoreServerpodPackages: false,
        checkLatestVersion: false,
        expectedMatch: true,
        expectedFetches: [],
      );
    },
  );
}

String _package({
  required String name,
  required String version,
  bool publishToNone = false,
}) {
  var publish = publishToNone ? 'publish_to: none\n' : '';
  return 'name: $name\nversion: $version\n$publish';
}

Future<void> _check({
  Map<String, String> packages = const {},
  List<String> publishablePackages = const [],
  required Map<String, String> dependencies,
  required bool ignoreServerpodPackages,
  required bool expectedMatch,
  required List<String> expectedFetches,
  bool checkLatestVersion = true,
  bool writePublishablePackages = true,
}) {
  return _withFixture((root) async {
    Directory(p.join(root.path, 'packages')).createSync();
    Directory(
      p.join(root.path, 'templates', 'pubspecs'),
    ).createSync(recursive: true);
    File(p.join(root.path, 'packages', 'serverpod', 'pubspec.yaml'))
      ..parent.createSync(recursive: true)
      ..writeAsStringSync(_package(name: 'serverpod', version: '1.0.0'));
    if (writePublishablePackages) {
      var paths = ['packages/serverpod', ...publishablePackages];
      File(p.join(root.path, 'PUBLISHABLE_PACKAGES')).writeAsStringSync(
        '${paths.join('\n')}\n',
      );
    }
    for (var entry in packages.entries) {
      var pubspec = File(p.join(root.path, entry.key, 'pubspec.yaml'));
      pubspec.parent.createSync(recursive: true);
      pubspec.writeAsStringSync(entry.value);
    }

    var dependencyLines = dependencies.entries
        .map((entry) => '  ${entry.key}: ${entry.value}')
        .join('\n');
    File(p.join(root.path, 'pubspec.yaml')).writeAsStringSync('''
name: synthetic_root
dependencies:
$dependencyLines
''');
    // Directory.current is process-wide, including across test isolates.
    // Give the real checker its own process instead of changing the runner's cwd.
    final results = await _runDart(
      [_driver, '$checkLatestVersion', '$ignoreServerpodPackages'],
      workingDirectory: root.path,
    );
    expect(results[0], 0, reason: '${results[1]}\n${results[2]}');
    final result =
        jsonDecode(
              File(p.join(root.path, 'result.json')).readAsStringSync(),
            )
            as Map<String, dynamic>;
    expect(result['match'], expectedMatch);
    expect(result['fetched'], expectedFetches);
  });
}

Future<void> _withFixture(Future<void> Function(Directory) check) async {
  final root = await Directory.systemTemp.createTemp('analyze-pubspecs-');
  try {
    await check(root);
  } finally {
    await root.delete(recursive: true);
  }
}

Future<List<Object>> _runDart(
  List<String> arguments, {
  String? workingDirectory,
  Duration timeout = const Duration(seconds: 30),
}) async {
  final process = await Process.start(
    Platform.resolvedExecutable,
    arguments,
    workingDirectory: workingDirectory,
  );
  var exited = false;
  final exitCode = process.exitCode.then((code) {
    exited = true;
    return code;
  });
  final output = utf8.decoder.bind(process.stdout).join();
  final errors = utf8.decoder.bind(process.stderr).join();
  try {
    return await Future.wait<Object>([
      exitCode,
      output,
      errors,
    ]).timeout(timeout);
  } finally {
    if (!exited) {
      process.kill(ProcessSignal.sigkill);
      await exitCode.timeout(const Duration(seconds: 5));
    }
  }
}
