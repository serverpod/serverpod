import 'package:serverpod/protocol.dart' as serverpod;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart'
    as auth_bridge;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as auth_core;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as auth_idp;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart'
    as auth_migration;
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    as legacy_auth;
import 'package:serverpod_auth_test_server/src/generated/endpoints.dart';
import 'package:serverpod_auth_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  // The auth modules of this project depend on each other: migration depends
  // on bridge, idp and core, bridge on idp and core, and idp on core.
  group('Given a project whose modules depend on each other,', () {
    group('when getting its target table definitions,', () {
      late List<String> tableNames;

      setUpAll(() {
        tableNames = [
          for (final table in Protocol.targetTableDefinitions)
            '${table.schema}.${table.name}',
        ];
      });

      test('then each table is defined once.', () {
        expect(tableNames, hasLength(tableNames.toSet().length));
      });

      test('then the tables of every module are included.', () {
        final moduleTableNames = {
          for (final protocol in <DatabaseSerializationManager>[
            auth_bridge.Protocol(),
            auth_core.Protocol(),
            auth_idp.Protocol(),
            auth_migration.Protocol(),
            legacy_auth.Protocol(),
            serverpod.Protocol(),
          ])
            for (final table in protocol.getTargetTableDefinitions())
              '${table.schema}.${table.name}',
        };

        expect(tableNames, containsAll(moduleTableNames));
      });
    });

    group('when creating its server,', () {
      late Serverpod pod;

      setUpAll(() {
        pod = Serverpod(
          [],
          Protocol(),
          Endpoints(),
          config: ServerpodConfig(
            apiServer: ServerConfig(
              port: 0,
              publicScheme: 'http',
              publicHost: 'localhost',
              publicPort: 0,
            ),
          ),
        );
      });

      tearDownAll(() async {
        await pod.shutdown(exitProcess: false);
      });

      test('then every module is hooked up to the project endpoints.', () {
        expect(
          pod.endpoints.modules.keys,
          unorderedEquals([
            'serverpod_auth_bridge',
            'serverpod_auth_core',
            'serverpod_auth_idp',
            'serverpod_auth_migration',
            'serverpod_auth',
          ]),
        );
      });

      test('then the module endpoints do not hook up their own modules.', () {
        expect(
          pod.endpoints.modules.values.map((module) => module.modules),
          everyElement(isEmpty),
        );
      });

      test('then the endpoints of a module are reachable.', () {
        expect(
          pod.endpoints.getConnectorByName('serverpod_auth_core.status'),
          isNotNull,
        );
      });
    });
  });
}
