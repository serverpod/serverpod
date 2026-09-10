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

/// Points `<project>/.fvm/flutter_sdk` at [sdkRoot], the way `fvm use` does.
void _pinFvmFlutter(Directory project, String sdkRoot) {
  final fvmDir = Directory(p.join(project.path, '.fvm'))
    ..createSync(recursive: true);
  Link(p.join(fvmDir.path, 'flutter_sdk')).createSync(sdkRoot);
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

void main() {
  group('Given a project pinned with fvm', () {
    late Directory temp;
    late String cachedSdk;
    late Directory project;

    setUp(() {
      temp = _tempDir();
      cachedSdk = _fakeFlutterSdk(temp, name: 'cached-3.32.0');
      project = Directory(p.join(temp.path, 'project'))..createSync();
      _pinFvmFlutter(project, cachedSdk);
    });

    group('when the Flutter SDK is resolved from the pinned directory', () {
      late ResolvedSdk? resolved;

      setUp(() async {
        resolved = await _resolver(project).flutterSdk;
      });

      test('then it resolves through the symlink to the cached SDK', () {
        expect(resolved?.root, cachedSdk);
      });

      test('then it names the pin it followed as the origin', () {
        expect(resolved?.origin, contains('.fvm/flutter_sdk'));
      });
    });

    group('when the Flutter SDK is resolved from a nested subdirectory', () {
      late ResolvedSdk? resolved;

      setUp(() async {
        final nested = Directory(p.join(project.path, 'apps', 'admin'))
          ..createSync(recursive: true);
        resolved = await _resolver(nested).flutterSdk;
      });

      test('then it finds the same pinned SDK', () {
        expect(resolved?.root, cachedSdk);
      });

      test('then it names the pin it followed as the origin', () {
        expect(resolved?.origin, contains('.fvm/flutter_sdk'));
      });
    });

    group('when the resolution is described', () {
      late String description;

      setUp(() async {
        description = await _resolver(project).describeResolution();
      });

      test('then it names the resolved Flutter SDK', () {
        expect(description, contains(cachedSdk));
      });

      test('then it names the pin the Flutter SDK came from', () {
        expect(description, contains('.fvm/flutter_sdk'));
      });

      test('then it names the Dart SDK derived from it', () {
        expect(description, contains(embeddedDartSdkIn(cachedSdk)));
      });

      test('then it says the Dart SDK came from the Flutter SDK', () {
        expect(description, contains('the resolved Flutter SDK'));
      });
    });
  });

  group(
    'Given a project with fvm pin that sits above a repository boundary',
    () {
      late Directory insideRepository;

      setUp(() {
        final temp = _tempDir();
        final outer = Directory(p.join(temp.path, 'outer'))..createSync();
        _pinFvmFlutter(outer, _fakeFlutterSdk(temp, name: 'outer-cached'));
        // An unrelated repository checked out inside the pinned directory.
        insideRepository = Directory(p.join(outer.path, 'inner'))..createSync();
        Directory(p.join(insideRepository.path, '.git')).createSync();
      });

      group('when the Flutter SDK is resolved from inside the repository', () {
        late ResolvedSdk? resolved;

        setUp(() async {
          resolved = await _resolver(insideRepository).flutterSdk;
        });

        test('then it returns null', () {
          expect(resolved, isNull);
        });
      });
    },
  );

  group(
    'Given a project with fvm pin above a linked-worktree boundary',
    () {
      late Directory insideRepository;

      setUp(() {
        final temp = _tempDir();
        final outer = Directory(p.join(temp.path, 'outer'))..createSync();
        _pinFvmFlutter(outer, _fakeFlutterSdk(temp, name: 'outer-cached'));
        insideRepository = Directory(p.join(outer.path, 'worktree'))
          ..createSync();
        File(
          p.join(insideRepository.path, '.git'),
        ).writeAsStringSync('gitdir: ../.git/worktrees/example\n');
      });

      test(
        'when resolving Flutter then it does not escape the worktree',
        () async {
          final resolved = await _resolver(insideRepository).flutterSdk;

          expect(resolved, isNull);
        },
      );
    },
  );

  group('Given a project whose fvm pin is a dangling symlink', () {
    late Directory project;
    late String sdkOnPath;

    setUp(() {
      final temp = _tempDir();
      project = Directory(p.join(temp.path, 'project'))..createSync();
      _pinFvmFlutter(project, p.join(temp.path, 'was-removed'));
      sdkOnPath = _fakeFlutterSdk(temp, name: 'on-path');
    });

    group('when the Flutter SDK is resolved', () {
      late ResolvedSdk? resolved;

      setUp(() async {
        resolved = await _resolver(
          project,
          pathFlutterRoot: sdkOnPath,
        ).flutterSdk;
      });

      test('then it falls through to PATH instead of failing', () {
        expect(resolved?.root, sdkOnPath);
      });

      test('then it names PATH as the origin', () {
        expect(resolved?.origin, contains('PATH'));
      });
    });
  });

  group(
    'Given a base directory that does not exist yet, pinned by its parent',
    () {
      // `serverpod create` resolves against the directory it is about to
      // create, so the pin has to be found from a path with nothing at it.
      late Directory notYetCreated;
      late String cachedSdk;

      setUp(() {
        final temp = _tempDir();
        cachedSdk = _fakeFlutterSdk(temp, name: 'cached');
        final parent = Directory(p.join(temp.path, 'workspace'))..createSync();
        _pinFvmFlutter(parent, cachedSdk);
        notYetCreated = Directory(p.join(parent.path, 'my_new_app'));
      });

      group('when the Flutter SDK is resolved', () {
        late ResolvedSdk? resolved;

        setUp(() async {
          resolved = await _resolver(notYetCreated).flutterSdk;
        });

        test('then it finds the pinned SDK', () {
          expect(resolved?.root, cachedSdk);
        });

        test('then it names the pin it followed as the origin', () {
          expect(resolved?.origin, contains('.fvm/flutter_sdk'));
        });

        test('then the base directory was never created to make that work', () {
          expect(notYetCreated.existsSync(), isFalse);
        });
      });
    },
  );

  group(
    'Given a base directory that does not exist yet pinned further up',
    () {
      late Directory notYetCreated;
      late String cachedSdk;

      setUp(() {
        final temp = _tempDir();
        cachedSdk = _fakeFlutterSdk(temp, name: 'cached');
        final root = Directory(p.join(temp.path, 'workspace'))..createSync();
        _pinFvmFlutter(root, cachedSdk);
        final nested = Directory(p.join(root.path, 'apps'))..createSync();
        notYetCreated = Directory(p.join(nested.path, 'my_new_app'));
      });

      group('when the Flutter SDK is resolved', () {
        late ResolvedSdk? resolved;

        setUp(() async {
          resolved = await _resolver(notYetCreated).flutterSdk;
        });

        test('then it finds the pinned SDK', () {
          expect(resolved?.root, cachedSdk);
        });
      });
    },
  );

  group('Given a base directory whose parent does not exist either', () {
    late Directory deeplyMissing;

    setUp(() {
      final temp = _tempDir();
      _pinFvmFlutter(temp, _fakeFlutterSdk(temp, name: 'cached'));
      deeplyMissing = Directory(p.join(temp.path, 'missing', 'my_new_app'));
    });

    group('when the Flutter SDK is resolved', () {
      late ResolvedSdk? resolved;

      setUp(() async {
        resolved = await _resolver(deeplyMissing).flutterSdk;
      });

      test('then it returns null', () {
        expect(resolved, isNull);
      });
    });
  });

  group('Given a project without fvm pin and a Flutter SDK on PATH', () {
    late Directory workingDirectory;
    late String sdkOnPath;

    setUp(() {
      workingDirectory = _tempDir();
      sdkOnPath = _fakeFlutterSdk(workingDirectory, name: 'on-path');
    });

    group('when the Flutter SDK is resolved', () {
      late ResolvedSdk? resolved;

      setUp(() async {
        resolved = await _resolver(
          workingDirectory,
          pathFlutterRoot: sdkOnPath,
        ).flutterSdk;
      });

      test('then it resolves to the SDK that PATH reported', () {
        expect(resolved?.root, sdkOnPath);
      });

      test('then it names PATH as the origin', () {
        expect(resolved?.origin, contains('PATH'));
      });
    });

    group('when the Dart SDK is resolved', () {
      late ResolvedSdk resolved;

      setUp(() async {
        resolved = await _resolver(
          workingDirectory,
          pathFlutterRoot: sdkOnPath,
        ).dartSdk;
      });

      test('then it comes from the SDK the Flutter SDK embeds', () {
        expect(resolved.root, embeddedDartSdkIn(sdkOnPath));
      });

      test('then it names the Flutter SDK as the origin', () {
        expect(resolved.origin, contains('the resolved Flutter SDK'));
      });
    });
  });

  group('Given a Flutter SDK on PATH whose bin/cache is cold', () {
    late Directory workingDirectory;
    late String coldSdk;

    setUp(() {
      workingDirectory = _tempDir();
      coldSdk = _fakeFlutterSdk(workingDirectory, withEmbeddedDart: false);
    });

    group('when the Dart SDK is resolved', () {
      late ResolvedSdk resolved;

      setUp(() async {
        resolved = await _resolver(
          workingDirectory,
          pathFlutterRoot: coldSdk,
        ).dartSdk;
      });

      test('then it falls back to the SDK running the CLI', () {
        expect(resolved.root, getSdkPath());
      });

      test('then it names the running SDK as the origin', () {
        expect(resolved.origin, contains('running this CLI'));
      });
    });
  });

  group('Given an environment with no Flutter SDK', () {
    late Directory workingDirectory;

    setUp(() {
      workingDirectory = _tempDir();
    });

    group('when the Flutter SDK is resolved', () {
      late ResolvedSdk? resolved;

      setUp(() async {
        resolved = await _resolver(workingDirectory).flutterSdk;
      });

      test('then no Flutter SDK is reported', () {
        expect(resolved, isNull);
      });
    });

    group('when the Dart SDK is resolved', () {
      late ResolvedSdk resolved;

      setUp(() async {
        resolved = await _resolver(workingDirectory).dartSdk;
      });

      test('then it falls back to the SDK running the CLI', () {
        expect(resolved.root, getSdkPath());
      });

      test('then it names the running SDK as the origin', () {
        expect(resolved.origin, contains('running this CLI'));
      });
    });

    group('when the resolution is described', () {
      late String description;

      setUp(() async {
        description = await _resolver(workingDirectory).describeResolution();
      });

      test(
        'then it says no Flutter SDK was found',
        () {
          expect(description, contains('Flutter SDK  not found'));
        },
      );
    });
  });

  group('Given no Flutter SDK and no locatable running SDK', () {
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
      'then it throws a SdkResolutionException',
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
}
