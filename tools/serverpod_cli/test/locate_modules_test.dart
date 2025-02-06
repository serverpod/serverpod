import 'package:serverpod_cli/src/util/locate_modules.dart';
import 'package:test/test.dart';

void main() {
  group('Locate modules', () {
    test('moduleNameFromServerPackageName', () async{
      var moduleName = await moduleNameFromServerPackageName('test_server');
      expect(moduleName, 'test');

      moduleName = await moduleNameFromServerPackageName('test2_server');
      expect(moduleName, 'test2');

      moduleName = await moduleNameFromServerPackageName('serverpod');
      expect(moduleName, 'serverpod');

      moduleName = await moduleNameFromServerPackageName('test_server-1.1.1');
      expect(moduleName, 'test');

      moduleName = await moduleNameFromServerPackageName('serverpod-1.1.1');
      expect(moduleName, 'serverpod');
    });
  });
}
