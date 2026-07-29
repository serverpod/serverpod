import 'dart:convert';

import 'package:serverpod_test_shared_module_client/serverpod_test_shared_module_client.dart'
    as module_client;
import 'package:serverpod_test_shared_module_server/serverpod_test_shared_module_server.dart'
    as module_server;
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart'
    as sqlite_client;
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart'
    as sqlite_server;
import 'package:test/test.dart';

void main() {
  group(
    'Given a table model declared in the shared package of a module,',
    () {
      late module_server.SharedModuleTable serverTable;
      late module_client.SharedModuleTable clientTable;

      setUp(() {
        serverTable = module_server.SharedModuleTable(
          name: 'server table',
          data: null,
        );
        clientTable = module_client.SharedModuleTable(
          name: 'client table',
          data: null,
        );
      });

      test(
        'when the owning module server protocol serializes the table, '
        'then it deserializes it under the module identity.',
        () {
          final protocol = module_server.Protocol();
          final serialized =
              jsonDecode(
                    protocol.encodeWithType(serverTable),
                  )
                  as Map<String, dynamic>;
          final deserialized =
              protocol.deserializeByClassName({...serialized})
                  as module_server.SharedModuleTable;

          expect(protocol.getModuleName(), 'serverpod_test_shared_module');
          expect(serialized['className'], 'SharedModuleTable');
          expect(
            deserialized,
            isA<module_server.SharedModuleTable>().having(
              (table) => table.name,
              'name',
              'server table',
            ),
          );
        },
      );

      test(
        'when the owning module client protocol serializes the table, '
        'then it deserializes it under the module identity.',
        () {
          final protocol = module_client.Protocol();
          final serialized =
              jsonDecode(
                    protocol.encodeWithType(clientTable),
                  )
                  as Map<String, dynamic>;
          final deserialized =
              protocol.deserializeByClassName({...serialized})
                  as module_client.SharedModuleTable;

          expect(protocol.getModuleName(), 'serverpod_test_shared_module');
          expect(serialized['className'], 'SharedModuleTable');
          expect(
            deserialized,
            isA<module_client.SharedModuleTable>().having(
              (table) => table.name,
              'name',
              'client table',
            ),
          );
        },
      );

      test(
        'when the SQLite consumer server protocol serializes the table, '
        'then it uses the owning module prefix.',
        () {
          final protocol = sqlite_server.Protocol();
          final serialized =
              jsonDecode(protocol.encodeWithType(serverTable))
                  as Map<String, dynamic>;
          final deserialized =
              protocol.deserializeByClassName({...serialized})
                  as module_server.SharedModuleTable;

          expect(
            protocol.getClassNameForObject(serverTable),
            'serverpod_test_shared_module.SharedModuleTable',
          );
          expect(
            serialized['className'],
            'serverpod_test_shared_module.SharedModuleTable',
          );
          expect(deserialized.name, 'server table');
        },
      );

      test(
        'when the SQLite consumer client protocol serializes the table, '
        'then it uses the owning module prefix.',
        () {
          final protocol = sqlite_client.Protocol();
          final serialized =
              jsonDecode(protocol.encodeWithType(clientTable))
                  as Map<String, dynamic>;
          final deserialized =
              protocol.deserializeByClassName({...serialized})
                  as module_client.SharedModuleTable;

          expect(
            protocol.getClassNameForObject(clientTable),
            'serverpod_test_shared_module.SharedModuleTable',
          );
          expect(
            serialized['className'],
            'serverpod_test_shared_module.SharedModuleTable',
          );
          expect(deserialized.name, 'client table');
        },
      );

      test(
        'when the SQLite consumer reaches the module-owned server table, '
        'then its generated server protocol exposes the module table.',
        () {
          final protocol = sqlite_server.Protocol();
          final definition = protocol.getTargetTableDefinitions().singleWhere(
            (definition) => definition.dartName == 'SharedModuleTable',
          );

          expect(definition.module, 'serverpod_test_shared_module');
          expect(
            protocol.getTableForType(module_server.SharedModuleTable),
            isNotNull,
          );
          expect(
            protocol
                .deserialize<module_server.SharedModuleTable>(
                  serverTable.toJson(),
                )
                .name,
            'server table',
          );
        },
      );

      test(
        'when the SQLite consumer reaches the module-owned client table, '
        'then its generated client protocol exposes the module table.',
        () {
          final protocol = sqlite_client.Protocol();
          final definition = protocol.getTargetTableDefinitions().singleWhere(
            (definition) => definition.dartName == 'SharedModuleTable',
          );

          expect(definition.module, 'serverpod_test_shared_module');
          expect(
            protocol.getTableForType(module_client.SharedModuleTable),
            isNotNull,
          );
          expect(
            protocol
                .deserialize<module_client.SharedModuleTable>(
                  clientTable.toJson(),
                )
                .name,
            'client table',
          );
        },
      );

      test(
        'when the SQLite consumer server protocol serializes the table with a model nested in its dynamic field, '
        'then the nested model survives the round trip under the module prefix.',
        () {
          final protocol = sqlite_server.Protocol();
          final table = module_server.SharedModuleTable(
            name: 'outer table',
            data: module_server.SharedModuleTable(
              name: 'nested table',
              data: null,
            ),
          );

          final serialized =
              jsonDecode(protocol.encodeWithType(table))
                  as Map<String, dynamic>;
          final deserialized =
              protocol.deserializeByClassName({...serialized})
                  as module_server.SharedModuleTable;

          expect(
            serialized['className'],
            'serverpod_test_shared_module.SharedModuleTable',
          );
          expect(deserialized.name, 'outer table');
          expect(
            deserialized.data,
            isA<module_server.SharedModuleTable>().having(
              (nested) => nested.name,
              'name',
              'nested table',
            ),
          );
        },
      );
    },
  );
}
