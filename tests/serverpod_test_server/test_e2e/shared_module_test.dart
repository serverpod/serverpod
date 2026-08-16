import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_shared_module_client/serverpod_test_shared_module_client.dart'
    as shared_module;
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  group('Given a table model owned by the shared package of a module,', () {
    late shared_module.SharedModuleTable table;

    setUp(() {
      table = shared_module.SharedModuleTable(
        name: 'over the wire',
        data: null,
      );
    });

    test(
      'when round-tripping it through an endpoint that accepts and returns it, '
      'then the modified table is echoed back.',
      () async {
        var result = await client.moduleSerialization.modifySharedModuleTable(
          table,
        );

        expect(result.name, 'over the wire');
        expect(result.data, {'modified': true});
      },
    );
  });
}
