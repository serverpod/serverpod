import 'package:serverpod_cli/src/util/locate_modules.dart';
import 'package:test/test.dart';

void main() {
  group('Locate modules', () {
    test('moduleNameFromServerPackageName', () {
      var moduleName = moduleNameFromServerPackageName('test_server');
      expect(moduleName, 'test');

      moduleName = moduleNameFromServerPackageName('test2_server');
      expect(moduleName, 'test2');

      moduleName = moduleNameFromServerPackageName('serverpod');
      expect(moduleName, 'serverpod');

      moduleName = moduleNameFromServerPackageName('test_server-1.1.1');
      expect(moduleName, 'test');

      moduleName = moduleNameFromServerPackageName('serverpod-1.1.1');
      expect(moduleName, 'serverpod');
    });
  });
}
