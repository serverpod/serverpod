import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a protocol generated before getOwnTableDefinitions existed, '
    'when getting its own table definitions, '
    'then its target table definitions are returned.',
    () {
      final protocol = _EarlierGeneratedProtocol();

      final ownTables = protocol.getOwnTableDefinitions();

      expect(ownTables.map((table) => table.name), ['example']);
    },
  );
}

/// Only overrides [getTargetTableDefinitions], like the protocols generated
/// before [DatabaseSerializationManager.getOwnTableDefinitions] existed.
class _EarlierGeneratedProtocol extends DatabaseSerializationManager {
  @override
  String getModuleName() => 'example';

  @override
  Table? getTableForType(Type t) => null;

  @override
  List<TableDefinition> getTargetTableDefinitions() => [
    TableDefinition(
      name: 'example',
      schema: 'public',
      columns: [
        ColumnDefinition(
          name: 'id',
          columnType: ColumnType.bigint,
          isNullable: false,
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
  ];
}
