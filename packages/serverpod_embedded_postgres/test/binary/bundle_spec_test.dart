import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_embedded_postgres/src/binary/bundle_spec.dart';
import 'package:serverpod_embedded_postgres/src/exceptions.dart';
import 'package:test/test.dart';

void main() {
  group('Given the published bundle specs', () {
    test(
      'when resolving a published PG version, '
      'then the spec carries a revisioned bundle id and release tag.',
      () {
        var spec = bundleSpecFor(Version(16, 13, 0));

        expect(spec.bom, '16.13.0');
        expect(spec.bundleId, '16.13.0-r${spec.revision}');
        expect(spec.releaseTag, 'embedded-postgres-v${spec.bundleId}');
      },
    );

    test(
      'when resolving a PG version with no published bundle, '
      'then UnsupportedVersionException lists the published versions.',
      () {
        expect(
          () => bundleSpecFor(Version(16, 14, 0)),
          throwsA(
            isA<UnsupportedVersionException>().having(
              (e) => e.message,
              'message',
              allOf(
                contains(
                  'No Serverpod PostgreSQL bundle is published '
                  'for version 16.14.0',
                ),
                contains('16.13.0'),
              ),
            ),
          ),
        );
      },
    );
  });

  group('Given the canonical versions.env of the build scripts', () {
    late Map<String, String> env;

    setUp(() {
      var lines = File(
        'tool/build_postgres/versions.env',
      ).readAsLinesSync();
      env = {
        for (var line in lines)
          if (line.isNotEmpty && !line.startsWith('#'))
            line.split('=').first: line.split('=').last,
      };
    });

    test(
      'when compared against the Dart-side bundle specs, '
      'then the identity and extension versions agree (shell and Dart cannot drift).',
      () {
        var spec = bundleSpecFor(Version.parse(env['PG_BOM']!));

        expect(spec.revision, int.parse(env['BUNDLE_REVISION']!));
        expect(spec.postgisVersion, env['POSTGIS_VERSION']);
        expect(spec.pgvectorVersion, env['PGVECTOR_VERSION']);
      },
    );

    test(
      'when comparing the upstream PG version against the BOM, '
      'then the BOM is the upstream version plus a patch component.',
      () {
        var bom = Version.parse(env['PG_BOM']!);

        expect('${bom.major}.${bom.minor}', env['PG_UPSTREAM_VERSION']);
      },
    );
  });
}
