import 'dart:convert';

import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as auth;
import 'package:serverpod_test_shared_module_server/serverpod_test_shared_module_server.dart'
    as module;
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart'
    as sqlite;
import 'package:serverpod_test_sqlite_shared/serverpod_test_sqlite_shared.dart'
    as sqlite_shared;
import 'package:test/test.dart';

// A dynamic field on `SharedModuleTable` (a model in the shared package of a
// module) resolves its value by bouncing from the shared package's protocol out
// to the host project's protocol, which then routes to the project itself, its
// shared package, or one of its modules. This exercises that path on the server
// side; the client side lives in a separate file so only one consumer protocol
// is registered on the shared singleton per test isolate.
module.SharedModuleTable _roundTrip(Object? data) {
  final protocol = sqlite.Protocol();
  final table = module.SharedModuleTable(name: 'container', data: data);
  final serialized =
      jsonDecode(protocol.encodeWithType(table)) as Map<String, dynamic>;
  return protocol.deserializeByClassName({...serialized})
      as module.SharedModuleTable;
}

void main() {
  test(
    'Given a project object in the dynamic field of a module shared-package '
    'table, when round-tripping it through the SQLite consumer server '
    'protocol, then the project object survives.',
    () {
      final result = _roundTrip(sqlite.SimpleData(num: 42));

      expect(
        result.data,
        isA<sqlite.SimpleData>().having((data) => data.num, 'num', 42),
      );
    },
  );

  test(
    'Given a project shared-package object in the dynamic field of a module '
    'shared-package table, when round-tripping it through the SQLite consumer '
    'server protocol, then the shared object survives.',
    () {
      final result = _roundTrip(
        sqlite_shared.SharedModel(name: 'shared', data: 7),
      );

      expect(
        result.data,
        isA<sqlite_shared.SharedModel>().having(
          (data) => data.name,
          'name',
          'shared',
        ),
      );
    },
  );

  test(
    'Given a module object in the dynamic field of a module shared-package '
    'table, when round-tripping it through the SQLite consumer server '
    'protocol, then the module object survives.',
    () {
      final result = _roundTrip(
        auth.TokenPair(refreshToken: 'refresh', accessToken: 'access'),
      );

      expect(
        result.data,
        isA<auth.TokenPair>().having(
          (data) => data.accessToken,
          'accessToken',
          'access',
        ),
      );
    },
  );
}
