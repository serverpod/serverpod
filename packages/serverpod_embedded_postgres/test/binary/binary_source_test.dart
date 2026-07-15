import 'dart:io';

import 'package:serverpod_embedded_postgres/src/binary/binary_source.dart';
import 'package:test/test.dart';

void main() {
  final envSource = Platform.environment['SERVERPOD_PG_SOURCE'];

  group('Given no explicit binary source', () {
    test(
      'when resolving with no SERVERPOD_PG_SOURCE in the environment, '
      'then the default is download (a missing asset must fail, not build).',
      skip: envSource != null
          ? 'SERVERPOD_PG_SOURCE=$envSource is set in this environment'
          : false,
      () {
        expect(resolveBinarySource(), BinarySource.download);
      },
    );
  });

  group('Given an explicit binary source', () {
    test('when resolving, then the explicit value wins over everything.', () {
      expect(
        resolveBinarySource(BinarySource.build),
        BinarySource.build,
      );
      expect(
        resolveBinarySource(BinarySource.auto),
        BinarySource.auto,
      );
    });
  });
}
