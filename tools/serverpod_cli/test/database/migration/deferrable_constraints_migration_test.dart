import 'package:serverpod_cli/src/database/migration.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/index_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';

void main() {
  test(
    'Given a non-deferrable foreign key in the source and a deferrable one in the target, '
    'when generating a migration, '
    'then the foreign key is replaced with the deferrable one.',
    () {
      var source = _databaseWithTables([
        _departmentTable(),
        _employeeTable(),
      ]);
      var target = _databaseWithTables([
        _departmentTable(),
        _employeeTable(deferrable: DeferrableConstraint.initiallyImmediate),
      ]);

      var migration = generateDatabaseMigration(
        databaseSource: source,
        databaseTarget: target,
      );

      var employeeMigration = migration.actions
          .map((action) => action.alterTable)
          .whereType<TableMigration>()
          .firstWhere((table) => table.name == 'employee');

      expect(employeeMigration.deleteForeignKeys, ['employee_fk_0']);
      expect(employeeMigration.addForeignKeys, hasLength(1));
      expect(
        employeeMigration.addForeignKeys.first.deferrable,
        DeferrableConstraint.initiallyImmediate,
      );
    },
  );

  test(
    'Given a foreign key changing from initiallyImmediate to initiallyDeferred, '
    'when generating a migration, '
    'then the foreign key is replaced.',
    () {
      var source = _databaseWithTables([
        _departmentTable(),
        _employeeTable(deferrable: DeferrableConstraint.initiallyImmediate),
      ]);
      var target = _databaseWithTables([
        _departmentTable(),
        _employeeTable(deferrable: DeferrableConstraint.initiallyDeferred),
      ]);

      var migration = generateDatabaseMigration(
        databaseSource: source,
        databaseTarget: target,
      );

      var employeeMigration = migration.actions
          .map((action) => action.alterTable)
          .whereType<TableMigration>()
          .firstWhere((table) => table.name == 'employee');

      expect(employeeMigration.deleteForeignKeys, ['employee_fk_0']);
      expect(
        employeeMigration.addForeignKeys.first.deferrable,
        DeferrableConstraint.initiallyDeferred,
      );
    },
  );

  test(
    'Given identical deferrable foreign keys, '
    'when generating a migration, '
    'then no foreign key changes are generated.',
    () {
      var source = _databaseWithTables([
        _departmentTable(),
        _employeeTable(deferrable: DeferrableConstraint.initiallyImmediate),
      ]);
      var target = _databaseWithTables([
        _departmentTable(),
        _employeeTable(deferrable: DeferrableConstraint.initiallyImmediate),
      ]);

      var migration = generateDatabaseMigration(
        databaseSource: source,
        databaseTarget: target,
      );

      expect(migration.actions, isEmpty);
    },
  );
}

ForeignKeyDefinition _employeeForeignKey({DeferrableConstraint? deferrable}) =>
    ForeignKeyDefinition(
      constraintName: 'employee_fk_0',
      columns: ['departmentId'],
      referenceTable: 'department',
      referenceTableSchema: 'public',
      referenceColumns: ['id'],
      onDelete: ForeignKeyAction.noAction,
      onUpdate: ForeignKeyAction.noAction,
      deferrable: deferrable,
    );

TableDefinition _employeeTable({DeferrableConstraint? deferrable}) =>
    TableDefinitionBuilder()
        .withName('employee')
        .withDartName('Employee')
        .withColumns([
          ColumnDefinitionBuilder().withIdColumn('employee').build(),
          ColumnDefinitionBuilder()
              .withName('departmentId')
              .withColumnType(ColumnType.bigint)
              .build(),
        ])
        .withIndexes([IndexDefinitionBuilder().withIdIndex('employee').build()])
        .withForeignKeys([_employeeForeignKey(deferrable: deferrable)])
        .build();

TableDefinition _departmentTable() => TableDefinitionBuilder()
    .withName('department')
    .withDartName('Department')
    .withColumns([
      ColumnDefinitionBuilder().withIdColumn('department').build(),
    ])
    .withIndexes([IndexDefinitionBuilder().withIdIndex('department').build()])
    .build();

DatabaseDefinition _databaseWithTables(List<TableDefinition> tables) =>
    DatabaseDefinitionBuilder()
        .withModuleName('example')
        .withTables(tables)
        .build();
