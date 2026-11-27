import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generator/serverpod_code_generator.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDirectory;

  setUp(() {
    tempDirectory = Directory.systemTemp.createTempSync(
      'serverpod_write_files_test',
    );
  });

  tearDown(() {
    if (tempDirectory.existsSync()) {
      tempDirectory.deleteSync(recursive: true);
    }
  });

  group('Given a CRLF file on disk and the same content with LF endings,', () {
    test(
      'when writing generated files, then the file is left untouched.',
      () async {
        var file = File(p.join(tempDirectory.path, 'generated.dart'));
        file.writeAsStringSync('line one\r\nline two\r\n');

        await ServerpodCodeGenerator.writeFiles({
          file.path: 'line one\nline two\n',
        });

        expect(file.readAsStringSync(), 'line one\r\nline two\r\n');
      },
    );
  });

  group('Given a file on disk with different generated content,', () {
    test('when writing generated files, then the file is rewritten.', () async {
      var file = File(p.join(tempDirectory.path, 'generated.dart'));
      file.writeAsStringSync('old content\r\n');

      await ServerpodCodeGenerator.writeFiles({file.path: 'new content\n'});

      expect(file.readAsStringSync(), 'new content\n');
    });
  });

  group('Given a file that does not exist yet,', () {
    test('when writing generated files, then the file is created.', () async {
      var file = File(p.join(tempDirectory.path, 'fresh.dart'));

      await ServerpodCodeGenerator.writeFiles({file.path: 'hello\n'});

      expect(file.readAsStringSync(), 'hello\n');
    });
  });
}
