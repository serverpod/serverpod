import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_shared_module_server/serverpod_test_shared_module_server.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    rollbackDatabase: RollbackDatabase.disabled,
    'Given a table model declared in the shared package of a module,',
    (sessionBuilder, _) {
      late Session session;
      setUp(() => session = sessionBuilder.build());

      test(
        'when inserting the table through the module server package, '
        'then the record is persisted.',
        () async {
          final inserted = await SharedModuleTable.db.insertRow(
            session,
            SharedModuleTable(
              name: 'shared module table',
              data: {'source': 'shared module'},
            ),
          );

          final persisted = await SharedModuleTable.db.findById(
            session,
            inserted.id!,
          );

          expect(persisted?.name, 'shared module table');
          expect(persisted?.data, {'source': 'shared module'});
        },
      );
    },
  );
}
