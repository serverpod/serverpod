import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/sdk_resolver.dart';
import 'package:serverpod_shared/process_io.dart';
import 'package:test/test.dart';

/// A throwaway directory, removed when the test finishes.
Directory _tempDir() {
  final dir = Directory.systemTemp.createTempSync('serverpod_sdk_resolver');
  addTearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  // Resolve now: on macOS the system temp dir is itself a symlink, and the
  // resolver reports pins through `resolveSymbolicLinksSync`.
  return Directory(dir.resolveSymbolicLinksSync());
}

/// Creates a directory that passes [isFlutterSdk].
///
/// [withEmbeddedDart] populates `bin/cache/dart-sdk`, which is what
/// distinguishes a warm SDK from a cold `bin/cache`.
String _fakeFlutterSdk(
  Directory parent, {
  String name = 'flutter',
  bool withEmbeddedDart = true,
}) {
  final root = p.join(parent.path, name);
  File(flutterExecutableIn(root)).createSync(recursive: true);
  if (withEmbeddedDart) {
    File(
      dartExecutableIn(embeddedDartSdkIn(root)),
    ).createSync(recursive: true);
  }
  return root;
}

/// Pins [project] to [sdkRoot] for the `fvm_reports_pinned_flutter_root.dart`
/// shim.
///
/// Real fvm writes a version into `.fvmrc` and maps it to its cache. The shim
/// reads the SDK root straight from the file.
void _pinFvmFlutter(Directory project, String sdkRoot) {
  File(p.join(project.path, '.fvmrc')).writeAsStringSync(sdkRoot);
}

/// A resolver that never falls through to a real `flutter` on PATH, so the
/// host machine's own install cannot influence the result.
SdkResolver _resolver(
  Directory baseDirectory, {
  String? pathFlutterRoot,
  String Function()? runningSdkRoot,
}) {
  return SdkResolver(
    baseDirectory: baseDirectory,
    probePathFlutterRoot: () async => pathFlutterRoot,
    runningSdkRoot: runningSdkRoot,
  );
}

/// The command that runs the Dart shim [name] under `test/util/sdk_shims/`,
/// followed by [args].
List<String> _shimCommand(String name, [List<String> args = const []]) => [
  Platform.resolvedExecutable,
  p.join(Directory.current.path, 'test', 'util', 'sdk_shims', name),
  ...args,
];

/// A resolver whose PATH tier runs [flutterCommand] for real.
///
/// A shim is a Dart script compiled on every run, which can take longer than
/// the resolver's own timeout on a slow machine, so these get a generous one.
SdkResolver _shimResolver(
  Directory baseDirectory,
  List<String> flutterCommand,
) {
  return SdkResolver(
    baseDirectory: baseDirectory,
    flutterCommand: flutterCommand,
    probeTimeout: const Duration(minutes: 1),
  );
}

/// A resolver whose PATH tier runs `fvm_reports_pinned_flutter_root.dart` for
/// real, the way a `flutter` on PATH that runs `fvm flutter` would answer,
/// reporting [globalSdk] where there is no pin.
SdkResolver _fvmShimResolver(Directory baseDirectory, {String? globalSdk}) {
  return _shimResolver(
    baseDirectory,
    _shimCommand('fvm_reports_pinned_flutter_root.dart', [
      if (globalSdk != null) '--global=$globalSdk',
    ]),
  );
}

void main() {
  group(
    'Given a flutter on PATH that runs fvm, a project pinned with fvm and a global fvm version,',
    () {
      late Directory temp;
      late String pinnedSdk;
      late String globalSdk;
      late Directory project;

      setUp(() {
        temp = _tempDir();
        pinnedSdk = _fakeFlutterSdk(temp, name: 'pinned-3.32.0');
        globalSdk = _fakeFlutterSdk(temp, name: 'global');
        project = Directory(p.join(temp.path, 'project'))..createSync();
        _pinFvmFlutter(project, pinnedSdk);
      });

      group('when the Flutter SDK is resolved from the pinned directory,', () {
        late String? resolved;

        setUp(() async {
          resolved = await _fvmShimResolver(
            project,
            globalSdk: globalSdk,
          ).flutterSdk;
        });

        test('then it resolves the pinned SDK.', () {
          expect(resolved, pinnedSdk);
        });
      });

      group('when the Flutter SDK is resolved from a nested subdirectory,', () {
        late String? resolved;

        setUp(() async {
          final nested = Directory(p.join(project.path, 'apps', 'admin'))
            ..createSync(recursive: true);
          resolved = await _fvmShimResolver(
            nested,
            globalSdk: globalSdk,
          ).flutterSdk;
        });

        test('then it resolves the same pinned SDK.', () {
          expect(resolved, pinnedSdk);
        });
      });

      group('when the Flutter SDK is resolved from an unpinned directory,', () {
        late String? resolved;

        setUp(() async {
          final unpinned = Directory(p.join(temp.path, 'other'))..createSync();
          resolved = await _fvmShimResolver(
            unpinned,
            globalSdk: globalSdk,
          ).flutterSdk;
        });

        test('then it resolves the global fvm version.', () {
          expect(resolved, globalSdk);
        });
      });
    },
  );

  group(
    'Given a base directory that does not exist yet, pinned by its parent,',
    () {
      // `serverpod create` resolves against the directory it is about to
      // create, so the pin has to be found from a path with nothing at it.
      late Directory notYetCreated;
      late String pinnedSdk;

      setUp(() {
        final temp = _tempDir();
        pinnedSdk = _fakeFlutterSdk(temp, name: 'pinned');
        final parent = Directory(p.join(temp.path, 'workspace'))..createSync();
        _pinFvmFlutter(parent, pinnedSdk);
        notYetCreated = Directory(p.join(parent.path, 'my_new_app'));
      });

      group('when the Flutter SDK is resolved,', () {
        late String? resolved;

        setUp(() async {
          resolved = await _fvmShimResolver(notYetCreated).flutterSdk;
        });

        test('then it resolves the pinned SDK.', () {
          expect(resolved, pinnedSdk);
        });

        test(
          'then the base directory was never created to make that work.',
          () {
            expect(notYetCreated.existsSync(), isFalse);
          },
        );
      });
    },
  );

  group(
    'Given a parent-pinned project whose pubspec comments out workspace,',
    () {
      // `serverpod create` copies the template before it resolves, so the
      // pubspec is on disk with its workspace lines still commented out.
      late Directory projectDirectory;
      late String cachedSdk;

      setUp(() {
        final temp = _tempDir();
        cachedSdk = _fakeFlutterSdk(temp, name: 'cached');
        final parent = Directory(p.join(temp.path, 'workspace'))..createSync();
        _pinFvmFlutter(parent, cachedSdk);
        projectDirectory = Directory(p.join(parent.path, 'my_new_app'))
          ..createSync();
        File(p.join(projectDirectory.path, 'pubspec.yaml')).writeAsStringSync(
          'name: my_new_app\n'
          '\n'
          '#workspace: #--UNCOMMENT_LINE--#\n'
          '#  - my_new_app_server #--UNCOMMENT_LINE--#\n',
        );
      });

      group('when the Flutter SDK is resolved,', () {
        late String? resolved;

        setUp(() async {
          resolved = await _fvmShimResolver(projectDirectory).flutterSdk;
        });

        test('then it finds the pin in the parent directory.', () {
          expect(resolved, cachedSdk);
        });
      });
    },
  );

  group(
    'Given a parent-pinned project holding a workspace pubspec,',
    () {
      // The rendered project root, which `serverpod create` resolves against
      // by the time it runs `flutter create`. docs/design/sdk_resolution.md
      // says it still inherits the pin from the directory above it.
      late Directory projectDirectory;
      late String cachedSdk;

      setUp(() {
        final temp = _tempDir();
        cachedSdk = _fakeFlutterSdk(temp, name: 'cached');
        final parent = Directory(p.join(temp.path, 'workspace'))..createSync();
        _pinFvmFlutter(parent, cachedSdk);
        projectDirectory = Directory(p.join(parent.path, 'my_new_app'))
          ..createSync();
        File(p.join(projectDirectory.path, 'pubspec.yaml')).writeAsStringSync(
          'name: my_new_app\n'
          '\n'
          'workspace:\n'
          '  - my_new_app_server\n',
        );
      });

      group('when the Flutter SDK is resolved,', () {
        late String? resolved;

        setUp(() async {
          resolved = await _fvmShimResolver(projectDirectory).flutterSdk;
        });

        test('then it finds the pin in the parent directory.', () {
          expect(resolved, cachedSdk);
        });
      });
    },
  );

  group(
    'Given a flutter on PATH that reports a root that is not a Flutter SDK,',
    () {
      late Directory workingDirectory;

      setUp(() {
        workingDirectory = _tempDir();
      });

      group('when the Flutter SDK is resolved,', () {
        late String? resolved;

        setUp(() async {
          resolved = await _resolver(
            workingDirectory,
            pathFlutterRoot: p.join(workingDirectory.path, 'was-removed'),
          ).flutterSdk;
        });

        test('then no Flutter SDK is reported.', () {
          expect(resolved, isNull);
        });
      });
    },
  );

  group('Given a Flutter SDK on PATH,', () {
    late Directory workingDirectory;
    late String sdkOnPath;

    setUp(() {
      workingDirectory = _tempDir();
      sdkOnPath = _fakeFlutterSdk(workingDirectory, name: 'on-path');
    });

    group('when the Flutter SDK is resolved,', () {
      late String? resolved;

      setUp(() async {
        resolved = await _resolver(
          workingDirectory,
          pathFlutterRoot: sdkOnPath,
        ).flutterSdk;
      });

      test('then it resolves to the SDK that PATH reported.', () {
        expect(resolved, sdkOnPath);
      });
    });

    group('when the Dart SDK is resolved,', () {
      late String resolved;

      setUp(() async {
        resolved = await _resolver(
          workingDirectory,
          pathFlutterRoot: sdkOnPath,
        ).dartSdk;
      });

      test('then it comes from the SDK the Flutter SDK embeds.', () {
        expect(resolved, embeddedDartSdkIn(sdkOnPath));
      });
    });

    group('when the resolution is described,', () {
      late String description;

      setUp(() async {
        description = await _resolver(
          workingDirectory,
          pathFlutterRoot: sdkOnPath,
        ).describeResolution();
      });

      test('then it names the resolved Flutter SDK.', () {
        expect(description, contains(sdkOnPath));
      });

      test('then it names the Dart SDK derived from it.', () {
        expect(description, contains(embeddedDartSdkIn(sdkOnPath)));
      });
    });
  });

  group('Given a Flutter SDK on PATH whose bin/cache is cold,', () {
    late Directory workingDirectory;
    late String coldSdk;

    setUp(() {
      workingDirectory = _tempDir();
      coldSdk = _fakeFlutterSdk(workingDirectory, withEmbeddedDart: false);
    });

    group('when the Dart SDK is resolved,', () {
      late String resolved;

      setUp(() async {
        resolved = await _resolver(
          workingDirectory,
          pathFlutterRoot: coldSdk,
        ).dartSdk;
      });

      test('then it falls back to the SDK running the CLI.', () {
        expect(resolved, getSdkPath());
      });
    });
  });

  group('Given an environment with no Flutter SDK,', () {
    late Directory workingDirectory;

    setUp(() {
      workingDirectory = _tempDir();
    });

    group('when the Flutter SDK is resolved,', () {
      late String? resolved;

      setUp(() async {
        resolved = await _resolver(workingDirectory).flutterSdk;
      });

      test('then no Flutter SDK is reported.', () {
        expect(resolved, isNull);
      });
    });

    group('when the Dart SDK is resolved,', () {
      late String resolved;

      setUp(() async {
        resolved = await _resolver(workingDirectory).dartSdk;
      });

      test('then it falls back to the SDK running the CLI.', () {
        expect(resolved, getSdkPath());
      });
    });

    group('when the resolution is described,', () {
      late String description;

      setUp(() async {
        description = await _resolver(workingDirectory).describeResolution();
      });

      test(
        'then it says no Flutter SDK was found.',
        () {
          expect(description, contains('Flutter SDK  not found'));
        },
      );
    });
  });

  group('Given no Flutter SDK and no locatable running SDK,', () {
    // Reachable in released builds: those are AOT-compiled, so the last resort
    // locates `dart` by spawning it rather than by reading
    // Platform.resolvedExecutable, and there may be none to spawn.
    late SdkResolver resolver;
    final exception = StateError('no dart on PATH');

    setUp(() {
      resolver = _resolver(
        _tempDir(),
        runningSdkRoot: () => throw exception,
      );
    });

    test(
      'when the Dart SDK is resolved, '
      'then it throws a SdkResolutionException.',
      () async {
        await expectLater(
          () => resolver.dartSdk,
          throwsA(
            isA<SdkResolutionException>().having(
              (e) => e.message,
              'message',
              'Could not locate a Dart SDK. You need to have dart installed '
                  'and in your \$PATH. ($exception)',
            ),
          ),
        );
      },
    );
  });

  group(
    'Given a flutter shim that reports the SDK a directory is bound to, '
    'and another SDK in unbound directories,',
    () {
      late Directory project;
      late String projectSdk;
      late List<String> flutterCommand;

      setUp(() {
        final temp = _tempDir();
        projectSdk = _fakeFlutterSdk(temp, name: 'project-sdk');
        final unboundSdk = _fakeFlutterSdk(temp, name: 'unbound-sdk');
        project = Directory(p.join(temp.path, 'project'))..createSync();
        // Bound the way `puro use` binds a directory to an environment.
        File(
          p.join(project.path, '.flutter_env'),
        ).writeAsStringSync(projectSdk);
        flutterCommand = _shimCommand('reports_bound_flutter_root.dart', [
          '--unbound=$unboundSdk',
        ]);
      });

      group('when the Flutter SDK is resolved for a bound project,', () {
        late String? resolved;

        setUp(() async {
          resolved = await _shimResolver(project, flutterCommand).flutterSdk;
        });

        test('then it resolves the SDK the project is bound to.', () {
          expect(resolved, projectSdk);
        });
      });
    },
  );

  group(
    'Given a flutter wrapper that prints a notice before its machine JSON,',
    () {
      late Directory project;
      late String sdkOnPath;
      late List<String> flutterCommand;

      setUp(() {
        final temp = _tempDir();
        sdkOnPath = _fakeFlutterSdk(temp, name: 'on-path');
        project = Directory(p.join(temp.path, 'project'))..createSync();
        flutterCommand = _shimCommand(
          'prints_notices_around_machine_json.dart',
          [
            '--root=$sdkOnPath',
            '--before=A new version of puro is available.',
          ],
        );
      });

      group('when the Flutter SDK is resolved,', () {
        late String? resolved;

        setUp(() async {
          resolved = await _shimResolver(project, flutterCommand).flutterSdk;
        });

        test('then it resolves the SDK the wrapper reported.', () {
          expect(resolved, sdkOnPath);
        });
      });
    },
  );

  group(
    'Given a flutter wrapper that prints a JSON notice before its machine JSON,',
    () {
      late Directory project;
      late String sdkOnPath;
      late List<String> flutterCommand;

      setUp(() {
        final temp = _tempDir();
        sdkOnPath = _fakeFlutterSdk(temp, name: 'on-path');
        project = Directory(p.join(temp.path, 'project'))..createSync();
        flutterCommand = _shimCommand(
          'prints_notices_around_machine_json.dart',
          [
            '--root=$sdkOnPath',
            '--before={"notice": "A new version of puro is available."}',
          ],
        );
      });

      group('when the Flutter SDK is resolved,', () {
        late String? resolved;

        setUp(() async {
          resolved = await _shimResolver(project, flutterCommand).flutterSdk;
        });

        test('then it resolves the SDK the wrapper reported.', () {
          expect(resolved, sdkOnPath);
        });
      });
    },
  );

  group(
    'Given a flutter wrapper that prints a JSON notice after its machine JSON,',
    () {
      late Directory project;
      late String sdkOnPath;
      late List<String> flutterCommand;

      setUp(() {
        final temp = _tempDir();
        sdkOnPath = _fakeFlutterSdk(temp, name: 'on-path');
        project = Directory(p.join(temp.path, 'project'))..createSync();
        flutterCommand = _shimCommand(
          'prints_notices_around_machine_json.dart',
          [
            '--root=$sdkOnPath',
            '--after={"notice": "A new version of puro is available."}',
          ],
        );
      });

      group('when the Flutter SDK is resolved,', () {
        late String? resolved;

        setUp(() async {
          resolved = await _shimResolver(project, flutterCommand).flutterSdk;
        });

        test('then it resolves the SDK the wrapper reported.', () {
          expect(resolved, sdkOnPath);
        });
      });
    },
  );

  group(
    'Given a flutter wrapper that prints notices with stray braces around its machine JSON,',
    () {
      late Directory project;
      late String sdkOnPath;
      late List<String> flutterCommand;

      setUp(() {
        final temp = _tempDir();
        sdkOnPath = _fakeFlutterSdk(temp, name: 'on-path');
        project = Directory(p.join(temp.path, 'project'))..createSync();
        flutterCommand = _shimCommand(
          'prints_notices_around_machine_json.dart',
          [
            '--root=$sdkOnPath',
            '--before=Run `puro upgrade` {to update',
            '--after=} was not closed',
          ],
        );
      });

      group('when the Flutter SDK is resolved,', () {
        late String? resolved;

        setUp(() async {
          resolved = await _shimResolver(project, flutterCommand).flutterSdk;
        });

        test('then it resolves the SDK the wrapper reported.', () {
          expect(resolved, sdkOnPath);
        });
      });
    },
  );

  group('Given a flutter on PATH that never answers,', () {
    const timeout = Duration(milliseconds: 500);
    // Well short of how long the shim hangs for.
    const upperBound = Duration(seconds: 2);
    late SdkResolver resolver;

    setUp(() {
      resolver = SdkResolver(
        baseDirectory: Directory.systemTemp,
        flutterCommand: _shimCommand('never_answers.dart'),
        probeTimeout: timeout,
      );
    });

    group('when the Flutter SDK is resolved,', () {
      late String? resolved;
      late Duration elapsed;

      setUp(() async {
        final stopwatch = Stopwatch()..start();
        resolved = await resolver.flutterSdk;
        elapsed = stopwatch.elapsed;
      });

      test('then no Flutter SDK is reported.', () {
        expect(resolved, isNull);
      });

      test('then it gives up once the timeout has passed.', () {
        expect(elapsed, greaterThanOrEqualTo(timeout));
        expect(elapsed, lessThan(upperBound));
      });
    });

    group('when the Dart SDK is resolved,', () {
      late Object? error;
      late Duration elapsed;

      setUp(() async {
        final stopwatch = Stopwatch()..start();
        try {
          await resolver.dartSdk;
          error = null;
        } catch (e) {
          error = e;
        }
        elapsed = stopwatch.elapsed;
      });

      test('then it throws a SdkResolutionTimeoutException.', () {
        expect(error, isA<SdkResolutionTimeoutException>());
      });

      test(
        'then it gives up once the timeout has passed.',
        () {
          expect(elapsed, greaterThanOrEqualTo(timeout));
          expect(elapsed, lessThan(upperBound));
        },
      );
    });

    test(
      'when checking whether flutter is installed, '
      'then it throws a SdkResolutionTimeoutException.',
      () async {
        await expectLater(
          () => resolver.isFlutterInstalled,
          throwsA(isA<SdkResolutionTimeoutException>()),
        );
      },
    );
  });

  group(
    'Given a flutter on PATH that hangs on the probe and answers a plain --version,',
    () {
      late SdkResolver resolver;

      setUp(() {
        resolver = SdkResolver(
          baseDirectory: Directory.systemTemp,
          flutterCommand: _shimCommand('hangs_on_machine_flag.dart'),
          probeTimeout: const Duration(seconds: 1),
        );
      });

      test(
        'when checking whether flutter is installed, '
        'then it is reported as installed.',
        () async {
          final installed = await resolver.isFlutterInstalled;

          expect(installed, isTrue);
        },
      );
    },
  );

  group(
    'Given a flutter on PATH that reports no SDK root and hangs on a plain --version,',
    () {
      const timeout = Duration(milliseconds: 500);
      late SdkResolver resolver;

      setUp(() {
        resolver = SdkResolver(
          baseDirectory: _tempDir(),
          // The probe is stubbed to report no root, so only the fallback
          // check runs the shim.
          probePathFlutterRoot: () async => null,
          flutterCommand: _shimCommand('never_answers.dart'),
          probeTimeout: timeout,
        );
      });

      group('when checking whether flutter is installed,', () {
        late Object? error;
        late Duration elapsed;

        setUp(() async {
          final stopwatch = Stopwatch()..start();
          try {
            await resolver.isFlutterInstalled;
            error = null;
          } catch (e) {
            error = e;
          }
          elapsed = stopwatch.elapsed;
        });

        test('then it throws a SdkResolutionTimeoutException.', () {
          expect(error, isA<SdkResolutionTimeoutException>());
        });

        test('then it gives up once the timeout has passed.', () {
          expect(elapsed, greaterThanOrEqualTo(timeout));
          expect(elapsed, lessThan(const Duration(seconds: 5)));
        });
      });
    },
  );

  group(
    'Given a flutter wrapper that exits while a child keeps its output open,',
    () {
      late String sdkOnPath;
      late SdkResolver resolver;

      setUp(() {
        final temp = _tempDir();
        sdkOnPath = _fakeFlutterSdk(temp, name: 'on-path');
        resolver = _shimResolver(
          temp,
          _shimCommand('exits_with_stdout_held_open.dart', [
            '--root=$sdkOnPath',
          ]),
        );
      });

      group('when the Flutter SDK is resolved,', () {
        late String? resolved;
        late Duration elapsed;

        setUp(() async {
          final stopwatch = Stopwatch()..start();
          resolved = await resolver.flutterSdk;
          elapsed = stopwatch.elapsed;
        });

        test('then it resolves the SDK the wrapper reported.', () {
          expect(resolved, sdkOnPath);
        });

        test('then it does not wait for the child to let go.', () {
          // The child holds the output open for 30 seconds.
          expect(elapsed, lessThan(const Duration(seconds: 5)));
        });
      });
    },
  );
}
