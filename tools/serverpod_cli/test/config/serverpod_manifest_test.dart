import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/serverpod_manifest.dart';
import 'package:test/test.dart';

void main() {
  late Directory temporaryDirectory;
  late File manifestFile;

  setUp(() {
    temporaryDirectory = Directory.systemTemp.createTempSync(
      'serverpod_manifest_test_',
    );
    manifestFile = File(
      path.join(temporaryDirectory.path, ServerpodManifest.fileName),
    );
  });

  tearDown(() {
    temporaryDirectory.deleteSync(recursive: true);
  });

  test(
    'Given Serverpod manifest metadata, '
    'when serializing it, '
    'then valid versioned YAML is returned.',
    () {
      var manifest = ServerpodManifest(
        sharedPackages: ['first_shared', 'second_shared'],
      );

      expect(manifest.toYaml(), '''
version: 1
shared_packages:
  - first_shared
  - second_shared
''');
    },
  );

  test(
    'Given a valid Serverpod manifest, '
    'when loading it, '
    'then its metadata is returned.',
    () {
      manifestFile.writeAsStringSync('''
version: 1
shared_packages:
  - first_shared
  - second_shared
''');

      var manifest = ServerpodManifest.tryLoadSync(manifestFile);

      expect(manifest?.sharedPackages, ['first_shared', 'second_shared']);
    },
  );

  test(
    'Given a Serverpod manifest without shared package metadata, '
    'when loading it, '
    'then its shared package list is empty.',
    () {
      manifestFile.writeAsStringSync('''
version: 1
future_metadata: value
''');

      var manifest = ServerpodManifest.tryLoadSync(manifestFile);

      expect(manifest?.sharedPackages, isEmpty);
    },
  );

  test(
    'Given no Serverpod manifest, '
    'when loading it, '
    'then no metadata is returned.',
    () {
      var manifest = ServerpodManifest.tryLoadSync(manifestFile);

      expect(manifest, isNull);
    },
  );

  test(
    'Given malformed Serverpod manifest YAML, '
    'when loading it, '
    'then a manifest exception is thrown.',
    () {
      manifestFile.writeAsStringSync('version: [');

      expect(
        () => ServerpodManifest.tryLoadSync(manifestFile),
        throwsA(isA<ServerpodManifestException>()),
      );
    },
  );

  test(
    'Given a Serverpod manifest with an unsupported version, '
    'when loading it, '
    'then a manifest exception identifies the version.',
    () {
      manifestFile.writeAsStringSync('''
version: 2
shared_packages: []
''');

      expect(
        () => ServerpodManifest.tryLoadSync(manifestFile),
        throwsA(
          isA<ServerpodManifestException>().having(
            (exception) => exception.message,
            'message',
            contains('Unsupported Serverpod manifest version 2'),
          ),
        ),
      );
    },
  );

  test(
    'Given a Serverpod manifest whose shared packages are not a list, '
    'when loading it, '
    'then a manifest exception is thrown.',
    () {
      manifestFile.writeAsStringSync('''
version: 1
shared_packages: first_shared
''');

      expect(
        () => ServerpodManifest.tryLoadSync(manifestFile),
        throwsA(isA<ServerpodManifestException>()),
      );
    },
  );

  test(
    'Given a Serverpod manifest with a non-string shared package, '
    'when loading it, '
    'then a manifest exception is thrown.',
    () {
      manifestFile.writeAsStringSync('''
version: 1
shared_packages:
  - 1
''');

      expect(
        () => ServerpodManifest.tryLoadSync(manifestFile),
        throwsA(isA<ServerpodManifestException>()),
      );
    },
  );
}
