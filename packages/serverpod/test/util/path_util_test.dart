import 'package:serverpod/src/util/path_util.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('For PathUtil.isFileWhitelisted', () {
    group('given a correct path', () {
      test('when in a matching directory return true.', () {
        var result = PathUtil.isFileWhitelisted(
          'mydirectory/myfile.xxx',
          {
            'mydirectory/',
            'otherdirectory/',
            'thirddirectory/',
          },
        );
        expect(result, equals(true));
      });
      test('when has a perfect match return true.', () {
        var result = PathUtil.isFileWhitelisted(
          'mydirectory/myfile.xxx',
          {
            'mydirectory/myfile.xxx',
            'otherdirectory/',
            'thirddirectory/',
          },
        );
        expect(result, equals(true));
      });
    });
    group('given an incorrect path', () {
      test('when there is no matching directory return false.', () {
        var result = PathUtil.isFileWhitelisted(
          'mydirectory/myfile.xxx',
          {
            'otherdirectory/',
          },
        );
        expect(result, equals(false));
      });
      test('when there is no matching directory or perfect match return false.',
          () {
        var result = PathUtil.isFileWhitelisted(
          'mydirectory/myfile.xxx',
          {
            'mydirectory/otherfile.xxx',
          },
        );
        expect(result, equals(false));
      });
    });
  });
  group('For PathUtil.relativePathToPlatformPath', () {
    group('given a unix path', () {
      test('a correct platform specific path is returned.', () {
        var result =
            PathUtil.relativePathToPlatformPath('mydirectory/myfile.xxx');
        expect(result, equals('mydirectory${p.separator}myfile.xxx'));
      });
    });
  });
}
