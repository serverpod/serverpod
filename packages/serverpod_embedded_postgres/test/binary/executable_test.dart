import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_embedded_postgres/src/binary/executable.dart';
import 'package:test/test.dart';

void main() {
  group('Given binExecutable', () {
    var installDir = Directory(p.join('install', '16.13.0'));

    test('when resolving a binary then it lands in the bin/ directory.', () {
      var path = binExecutable(installDir, 'postgres');

      expect(p.dirname(path), p.join(installDir.path, 'bin'));
    });

    test(
      'when on Windows then the name carries the .exe extension, '
      'otherwise the bare name is used.',
      () {
        var name = p.basename(binExecutable(installDir, 'postgres'));

        expect(name, Platform.isWindows ? 'postgres.exe' : 'postgres');
      },
    );
  });
}
