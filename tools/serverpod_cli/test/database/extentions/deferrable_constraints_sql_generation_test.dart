import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/database/dialects/postgres.dart';
import 'package:serverpod_cli/src/database/dialects/sqlite.dart';
import 'package:serverpod_cli/src/database/sql_generator.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/index_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';
import '../../test_util/builders/model_class_definition_builder.dart';

void main() {
  test(
    'Given a relation marked as deferrable, '
    'when creating a database definition, '
    'then the generated foreign key is initially immediate.',
    () {
      var employee =
          _databaseFromModels(
            deferrable: DeferrableConstraint.initiallyImmediate,
          ).tables.firstWhere(
            (table) => table.name == 'employee',
          );

      expect(
        employee.foreignKeys.single.deferrable,
        DeferrableConstraint.initiallyImmediate,
      );
    },
  );

  test(
    'Given a relation marked as deferred, '
    'when creating a database definition, '
    'then the generated foreign key is initially deferred.',
    () {
      var employee =
          _databaseFromModels(
            deferrable: DeferrableConstraint.initiallyDeferred,
          ).tables.firstWhere(
            (table) => table.name == 'employee',
          );

      expect(
        employee.foreignKeys.single.deferrable,
        DeferrableConstraint.initiallyDeferred,
      );
    },
  );

  test(
    'Given a relation without a deferrability flag, '
    'when creating a database definition, '
    'then the generated foreign key is not deferrable.',
    () {
      var employee = _databaseFromModels().tables.firstWhere(
        (table) => table.name == 'employee',
      );

      expect(employee.foreignKeys.single.deferrable, isNull);
    },
  );

  group('Given a foreign key marked as initiallyImmediate, ', () {
    var database = _databaseWithTables([
      _departmentTable(),
      _employeeTable(deferrable: DeferrableConstraint.initiallyImmediate),
    ]);

    test(
      'when generating Postgres SQL, '
      'then it includes DEFERRABLE INITIALLY IMMEDIATE.',
      () {
        var sql = PostgresSqlGenerator().generateSql(database);

        expect(sql, contains('DEFERRABLE INITIALLY IMMEDIATE'));
      },
    );

    test(
      'when generating SQLite SQL, '
      'then it includes DEFERRABLE INITIALLY IMMEDIATE.',
      () {
        var sql = SqliteSqlGenerator().generateSql(database);

        expect(sql, contains('DEFERRABLE INITIALLY IMMEDIATE'));
      },
    );
  });

  group('Given a foreign key marked as initiallyDeferred, ', () {
    var database = _databaseWithTables([
      _departmentTable(),
      _employeeTable(deferrable: DeferrableConstraint.initiallyDeferred),
    ]);

    test(
      'when generating Postgres SQL, '
      'then it includes DEFERRABLE INITIALLY DEFERRED.',
      () {
        var sql = PostgresSqlGenerator().generateSql(database);

        expect(sql, contains('DEFERRABLE INITIALLY DEFERRED'));
      },
    );

    test(
      'when generating SQLite SQL, '
      'then it includes DEFERRABLE INITIALLY DEFERRED.',
      () {
        var sql = SqliteSqlGenerator().generateSql(database);

        expect(sql, contains('DEFERRABLE INITIALLY DEFERRED'));
      },
    );
  });

  group('Given a non-deferrable foreign key, ', () {
    var database = _databaseWithTables([
      _departmentTable(),
      _employeeTable(),
    ]);

    test(
      'when generating Postgres SQL, '
      'then it does not contain a DEFERRABLE clause.',
      () {
        expect(
          PostgresSqlGenerator().generateSql(database),
          isNot(contains('DEFERRABLE')),
        );
      },
    );

    test(
      'when generating SQLite SQL, '
      'then it does not contain a DEFERRABLE clause.',
      () {
        expect(
          SqliteSqlGenerator().generateSql(database),
          isNot(contains('DEFERRABLE')),
        );
      },
    );
  });
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

extension on SqlGenerator {
  String generateSql(DatabaseDefinition definition) =>
      generateDatabaseDefinitionSql(
        definition,
        installedModules: [
          DatabaseMigrationVersionModel(
            module: definition.moduleName,
            version: '00000000000000',
          ),
        ],
      );
}

DatabaseDefinition _databaseFromModels({DeferrableConstraint? deferrable}) =>
    createDatabaseDefinitionFromModels(
      [
        ModelClassDefinitionBuilder()
            .withClassName('Employee')
            .withFileName('employee')
            .withTableName('employee')
            .withSimpleField('name', 'String')
            .withObjectRelationField(
              'department',
              'Department',
              'department',
              deferrable: deferrable,
            )
            .build(),
        ModelClassDefinitionBuilder()
            .withClassName('Department')
            .withFileName('department')
            .withTableName('department')
            .withSimpleField('name', 'String')
            .build(),
      ],
      'example',
      [],
    );
