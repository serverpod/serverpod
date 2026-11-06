import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Given the client protocol of a project with modules, one of which has the shared_module_table from its shared package, '
    'when getting its target table definitions,',
    () {
      late List<String> tableNames;

      setUpAll(() {
        tableNames = [
          for (final table in Protocol().getTargetTableDefinitions())
            '${table.schema}.${table.name}',
        ];
      });

      test('then each table is defined once.', () {
        expect(tableNames, hasLength(tableNames.toSet().length));
      });

      test('then the shared_module_table of the module is included.', () {
        expect(tableNames, contains('public.shared_module_table'));
      });
    },
  );
}
