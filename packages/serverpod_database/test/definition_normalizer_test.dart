import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/definition/definition_normalizer.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  const moduleName = 'test';
  final installedModules = <DatabaseMigrationVersionModel>[];
  const migrationApiVersion = DatabaseConstants.migrationApiVersion;

  test('Given a v2 definition '
      'when normalized '
      'then it is returned unchanged.', () {
    var def = DatabaseDefinition(
      schemaVersion: 2,
      moduleName: moduleName,
      tables: [
        TableDefinition(
          name: 'example',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: defaultPrimaryKeyName,
              columnType: ColumnType.integer,
              isNullable: false,
              columnDefault: defaultIntSerial,
            ),
          ],
          foreignKeys: [],
          indexes: [],
        ),
      ],
      installedModules: installedModules,
      migrationApiVersion: migrationApiVersion,
    );

    var result = normalizeDefinitionToV2(def);

    expect(result.schemaVersion, 2);
    expect(identical(result, def), isTrue);
  });

  test('Given a v1 definition '
      'when normalized '
      'then the schemaVersion is set to 2.', () {
    var def = DatabaseDefinition(
      moduleName: moduleName,
      tables: [
        TableDefinition(
          name: 'example',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: defaultPrimaryKeyName,
              columnType: ColumnType.integer,
              isNullable: false,
            ),
          ],
          foreignKeys: [],
          indexes: [],
        ),
      ],
      installedModules: installedModules,
      migrationApiVersion: migrationApiVersion,
    );

    var result = normalizeDefinitionToV2(def);

    expect(result.schemaVersion, 2);
  });

  test('Given a v1 definition with a serial default '
      'when normalized '
      'then the serial default is converted to "serial".', () {
    var def = DatabaseDefinition(
      moduleName: moduleName,
      tables: [
        TableDefinition(
          name: 'example',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: defaultPrimaryKeyName,
              columnType: ColumnType.integer,
              isNullable: false,
              columnDefault: "nextval('example_id_seq'::regclass)",
            ),
          ],
          foreignKeys: [],
          indexes: [],
        ),
      ],
      installedModules: installedModules,
      migrationApiVersion: migrationApiVersion,
    );

    var result = normalizeDefinitionToV2(def);
    var col = result.tables.first.columns.first;

    expect(col.columnDefault, defaultIntSerial);
    expect(col.isPrimary, isTrue);
  });

  test(
    'Given a v1 definition with an int default '
    'when normalized '
    'then the int default is converted to the original model value.',
    () {
      var def = DatabaseDefinition(
        moduleName: moduleName,
        tables: [
          TableDefinition(
            name: 'example',
            schema: 'public',
            columns: [
              ColumnDefinition(
                name: 'intDefault',
                columnType: ColumnType.integer,
                isNullable: false,
                columnDefault: '1',
                dartType: 'int',
              ),
            ],
            foreignKeys: [],
            indexes: [],
          ),
        ],
        installedModules: installedModules,
        migrationApiVersion: migrationApiVersion,
      );

      var result = normalizeDefinitionToV2(def);
      var col = result.tables.first.columns.first;

      expect(col.columnDefault, '1');
    },
  );

  test(
    'Given a v1 definition with a boolean default '
    'when normalized '
    'then the boolean default is converted to the original model value.',
    () {
      var def = DatabaseDefinition(
        moduleName: moduleName,
        tables: [
          TableDefinition(
            name: 'example',
            schema: 'public',
            columns: [
              ColumnDefinition(
                name: defaultPrimaryKeyName,
                columnType: ColumnType.boolean,
                isNullable: false,
                columnDefault: 'true',
              ),
            ],
            foreignKeys: [],
            indexes: [],
          ),
        ],
        installedModules: installedModules,
        migrationApiVersion: migrationApiVersion,
      );

      var result = normalizeDefinitionToV2(def);
      var col = result.tables.first.columns.first;

      expect(col.columnDefault, 'true');
    },
  );

  test('Given a v1 definition with a "CURRENT_TIMESTAMP" default '
      'when normalized '
      'then the CURRENT_TIMESTAMP default is converted to "now".', () {
    var def = DatabaseDefinition(
      moduleName: moduleName,
      tables: [
        TableDefinition(
          name: 'example',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'created_at',
              columnType: ColumnType.timestampWithoutTimeZone,
              isNullable: false,
              columnDefault: 'CURRENT_TIMESTAMP',
            ),
          ],
          foreignKeys: [],
          indexes: [],
        ),
      ],
      installedModules: installedModules,
      migrationApiVersion: migrationApiVersion,
    );

    var result = normalizeDefinitionToV2(def);
    var col = result.tables.first.columns.first;

    expect(col.columnDefault, defaultDateTimeValueNow);
  });

  test(
    'Given a v1 definition with a formatted DateTime default '
    'when normalized '
    'then the formatted DateTime default is converted to the original model value.',
    () {
      var def = DatabaseDefinition(
        moduleName: moduleName,
        tables: [
          TableDefinition(
            name: 'example',
            schema: 'public',
            columns: [
              ColumnDefinition(
                name: defaultPrimaryKeyName,
                columnType: ColumnType.timestampWithoutTimeZone,
                isNullable: false,
                columnDefault:
                    "'2024-05-01 22:00:00'::timestamp without time zone",
              ),
            ],
            foreignKeys: [],
            indexes: [],
          ),
        ],
        installedModules: installedModules,
        migrationApiVersion: migrationApiVersion,
      );

      var result = normalizeDefinitionToV2(def);
      var col = result.tables.first.columns.first;

      expect(col.columnDefault, '2024-05-01T22:00:00.000Z');
    },
  );

  test(
    'Given a v1 definition with a Duration default '
    'when normalized '
    'then the Duration default is kept as raw milliseconds.',
    () {
      var def = DatabaseDefinition(
        moduleName: moduleName,
        tables: [
          TableDefinition(
            name: 'example',
            schema: 'public',
            columns: [
              ColumnDefinition(
                name: defaultPrimaryKeyName,
                columnType: ColumnType.bigint,
                dartType: 'Duration?',
                isNullable: false,
                columnDefault: '94230100',
              ),
            ],
            foreignKeys: [],
            indexes: [],
          ),
        ],
        installedModules: installedModules,
        migrationApiVersion: migrationApiVersion,
      );

      var result = normalizeDefinitionToV2(def);
      var col = result.tables.first.columns.first;

      expect(col.columnDefault, '94230100');
    },
  );

  test(
    'Given a v1 definition with a BigInt default '
    'when normalized '
    'then the BigInt default is kept as raw text without the type cast.',
    () {
      var def = DatabaseDefinition(
        moduleName: moduleName,
        tables: [
          TableDefinition(
            name: 'example',
            schema: 'public',
            columns: [
              ColumnDefinition(
                name: 'bigintDefault',
                columnType: ColumnType.text,
                dartType: 'BigInt?',
                isNullable: false,
                columnDefault: "'12345678901234567890'::text",
              ),
            ],
            foreignKeys: [],
            indexes: [],
          ),
        ],
        installedModules: installedModules,
        migrationApiVersion: migrationApiVersion,
      );

      var result = normalizeDefinitionToV2(def);
      var col = result.tables.first.columns.first;

      expect(col.columnDefault, "'12345678901234567890'");
    },
  );

  test(
    'Given a v1 definition with an enum default serialized by index '
    'when normalized '
    'then the enum default is kept the index of the default entry.',
    () {
      var def = DatabaseDefinition(
        moduleName: moduleName,
        tables: [
          TableDefinition(
            name: 'example',
            schema: 'public',
            columns: [
              ColumnDefinition(
                name: 'enumDefault',
                columnType: ColumnType.bigint,
                isNullable: true,
                dartType: 'protocol:ByIndexEnum?',
                columnDefault: '1',
              ),
            ],
            foreignKeys: [],
            indexes: [],
          ),
        ],
        installedModules: installedModules,
        migrationApiVersion: migrationApiVersion,
      );

      var result = normalizeDefinitionToV2(def);
      var col = result.tables.first.columns.first;

      expect(col.columnDefault, '1');
    },
  );

  test(
    'Given a v1 definition with an enum default serialized by name '
    'when normalized '
    'then the enum default is converted to the name of the default entry.',
    () {
      var def = DatabaseDefinition(
        moduleName: moduleName,
        tables: [
          TableDefinition(
            name: 'example',
            schema: 'public',
            columns: [
              ColumnDefinition(
                name: 'enumDefault',
                columnType: ColumnType.text,
                isNullable: true,
                dartType: 'protocol:ByNameEnum?',
                columnDefault: "'byName2'::text",
              ),
            ],
            foreignKeys: [],
            indexes: [],
          ),
        ],
        installedModules: installedModules,
        migrationApiVersion: migrationApiVersion,
      );

      var result = normalizeDefinitionToV2(def);
      var col = result.tables.first.columns.first;

      expect(col.columnDefault, "'byName2'");
    },
  );

  test('Given a v1 definition with a String column with a literal default '
      'when normalized '
      'then the literal default is restored to the original model value.', () {
    var def = DatabaseDefinition(
      moduleName: moduleName,
      tables: [
        TableDefinition(
          name: 'example',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'name',
              columnType: ColumnType.text,
              isNullable: false,
              columnDefault: "'test'::text",
            ),
          ],
          foreignKeys: [],
          indexes: [],
        ),
      ],
      installedModules: installedModules,
      migrationApiVersion: migrationApiVersion,
    );

    var result = normalizeDefinitionToV2(def);
    var col = result.tables.first.columns.first;

    expect(col.columnDefault, "'test'");
  });

  test(
    'Given a v1 definition with a String literal default containing escaped single quotes '
    'when normalized '
    'then the full SQL literal is preserved.',
    () {
      var def = DatabaseDefinition(
        moduleName: moduleName,
        tables: [
          TableDefinition(
            name: 'example',
            schema: 'public',
            columns: [
              ColumnDefinition(
                name: 'name',
                columnType: ColumnType.text,
                isNullable: false,
                columnDefault: "'This is a ''default'' value'::text",
              ),
            ],
            foreignKeys: [],
            indexes: [],
          ),
        ],
        installedModules: installedModules,
        migrationApiVersion: migrationApiVersion,
      );

      var result = normalizeDefinitionToV2(def);
      var col = result.tables.first.columns.first;

      expect(col.columnDefault, "'This is a ''default'' value'");
    },
  );

  test('Given a v1 definition with a "gen_random_uuid()" default '
      'when normalized '
      'then the gen_random_uuid default is converted to "random".', () {
    var def = DatabaseDefinition(
      moduleName: moduleName,
      tables: [
        TableDefinition(
          name: 'example',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: defaultPrimaryKeyName,
              columnType: ColumnType.uuid,
              isNullable: false,
              columnDefault: 'gen_random_uuid()',
            ),
          ],
          foreignKeys: [],
          indexes: [],
        ),
      ],
      installedModules: installedModules,
      migrationApiVersion: migrationApiVersion,
    );

    var result = normalizeDefinitionToV2(def);
    var col = result.tables.first.columns.first;

    expect(col.columnDefault, defaultUuidValueRandom);
    expect(col.isPrimary, isTrue);
  });

  test('Given a v1 definition with a "gen_random_uuid_v7()" default '
      'when normalized '
      'then the gen_random_uuid_v7 default is converted to random_v7.', () {
    var def = DatabaseDefinition(
      moduleName: moduleName,
      tables: [
        TableDefinition(
          name: 'example',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: defaultPrimaryKeyName,
              columnType: ColumnType.uuid,
              isNullable: false,
              columnDefault: 'gen_random_uuid_v7()',
            ),
          ],
          foreignKeys: [],
          indexes: [],
        ),
      ],
      installedModules: installedModules,
      migrationApiVersion: migrationApiVersion,
    );

    var result = normalizeDefinitionToV2(def);
    var col = result.tables.first.columns.first;

    expect(col.columnDefault, defaultUuidValueRandomV7);
    expect(col.isPrimary, isTrue);
  });

  test(
    'Given a v1 definition with a UuidValue default '
    'when normalized '
    'then the UuidValue default is converted to the original model value.',
    () {
      var def = DatabaseDefinition(
        moduleName: moduleName,
        tables: [
          TableDefinition(
            name: 'example',
            schema: 'public',
            columns: [
              ColumnDefinition(
                name: defaultPrimaryKeyName,
                columnType: ColumnType.uuid,
                isNullable: false,
                columnDefault: "'550e8400-e29b-41d4-a716-446655440000'::uuid",
              ),
            ],
            foreignKeys: [],
            indexes: [],
          ),
        ],
        installedModules: installedModules,
        migrationApiVersion: migrationApiVersion,
      );

      var result = normalizeDefinitionToV2(def);
      var col = result.tables.first.columns.first;

      expect(col.columnDefault, "'550e8400-e29b-41d4-a716-446655440000'");
    },
  );

  test('Given a v1 definition with a primary key index '
      'when normalized '
      'then the primary key index is removed.', () {
    var def = DatabaseDefinition(
      moduleName: moduleName,
      tables: [
        TableDefinition(
          name: 'example',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: defaultPrimaryKeyName,
              columnType: ColumnType.integer,
              isNullable: false,
              columnDefault: "nextval('example_id_seq'::regclass)",
            ),
          ],
          foreignKeys: [],
          indexes: [
            IndexDefinition(
              indexName: 'example_pkey',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: defaultPrimaryKeyName,
                ),
              ],
              type: 'btree',
              isUnique: true,
              isPrimary: true,
            ),
            IndexDefinition(
              indexName: 'example_name_idx',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'name',
                ),
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
          ],
        ),
      ],
      installedModules: installedModules,
      migrationApiVersion: migrationApiVersion,
    );

    var result = normalizeDefinitionToV2(def);

    expect(result.tables.first.indexes, hasLength(1));
    expect(result.tables.first.indexes.first.indexName, 'example_name_idx');
  });

  test('Given a migration with no alter table actions '
      'when normalized '
      'then it is returned unchanged.', () {
    var migration = DatabaseMigration(
      actions: [
        DatabaseMigrationAction(
          type: DatabaseMigrationActionType.createTable,
          createTable: TableDefinition(
            name: 'example',
            schema: 'public',
            columns: [
              ColumnDefinition(
                name: defaultPrimaryKeyName,
                columnType: ColumnType.integer,
                isNullable: false,
                columnDefault: defaultIntSerial,
              ),
            ],
            foreignKeys: [],
            indexes: [],
          ),
        ),
      ],
      warnings: [],
      migrationApiVersion: migrationApiVersion,
    );

    var targetDefinition = DatabaseDefinition(
      schemaVersion: 2,
      moduleName: moduleName,
      tables: [
        TableDefinition(
          name: 'example',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: defaultPrimaryKeyName,
              columnType: ColumnType.integer,
              isNullable: false,
              columnDefault: defaultIntSerial,
            ),
          ],
          foreignKeys: [],
          indexes: [],
        ),
      ],
      installedModules: installedModules,
      migrationApiVersion: migrationApiVersion,
    );

    var result = normalizeMigrationToV2(migration, targetDefinition);

    expect(result.actions, hasLength(1));
    expect(
      result.actions.first.type,
      DatabaseMigrationActionType.createTable,
    );
    expect(result.warnings, isEmpty);
    expect(result.migrationApiVersion, migrationApiVersion);
  });

  test('Given a migration with alter table that has no changeDefault '
      'when normalized '
      'then the alter table action is returned unchanged.', () {
    var migration = DatabaseMigration(
      actions: [
        DatabaseMigrationAction(
          type: DatabaseMigrationActionType.alterTable,
          alterTable: TableMigration(
            name: 'example',
            schema: 'public',
            addColumns: [],
            deleteColumns: [],
            modifyColumns: [
              ColumnMigration(
                columnName: 'name',
                addNullable: false,
                removeNullable: false,
                changeDefault: false,
              ),
            ],
            addIndexes: [],
            deleteIndexes: [],
            addForeignKeys: [],
            deleteForeignKeys: [],
            warnings: [],
          ),
        ),
      ],
      warnings: [],
      migrationApiVersion: migrationApiVersion,
    );

    var targetDefinition = DatabaseDefinition(
      schemaVersion: 2,
      moduleName: moduleName,
      tables: [
        TableDefinition(
          name: 'example',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: defaultPrimaryKeyName,
              columnType: ColumnType.integer,
              isNullable: false,
              columnDefault: defaultIntSerial,
            ),
            ColumnDefinition(
              name: 'name',
              columnType: ColumnType.text,
              isNullable: false,
            ),
          ],
          foreignKeys: [],
          indexes: [],
        ),
      ],
      installedModules: installedModules,
      migrationApiVersion: migrationApiVersion,
    );

    var result = normalizeMigrationToV2(migration, targetDefinition);

    expect(
      result.actions.first.alterTable!.modifyColumns.first.changeDefault,
      isFalse,
    );
  });

  test(
    'Given a migration with alter table changing CURRENT_TIMESTAMP default '
    'when normalized '
    'then the default is converted to "now".',
    () {
      var migration = DatabaseMigration(
        actions: [
          DatabaseMigrationAction(
            type: DatabaseMigrationActionType.alterTable,
            alterTable: TableMigration(
              name: 'example',
              schema: 'public',
              addColumns: [],
              deleteColumns: [],
              modifyColumns: [
                ColumnMigration(
                  columnName: 'created_at',
                  addNullable: false,
                  removeNullable: false,
                  changeDefault: true,
                  newDefault: 'CURRENT_TIMESTAMP',
                ),
              ],
              addIndexes: [],
              deleteIndexes: [],
              addForeignKeys: [],
              deleteForeignKeys: [],
              warnings: [],
            ),
          ),
        ],
        warnings: [],
        migrationApiVersion: migrationApiVersion,
      );

      var targetDefinition = DatabaseDefinition(
        schemaVersion: 2,
        moduleName: moduleName,
        tables: [
          TableDefinition(
            name: 'example',
            schema: 'public',
            columns: [
              ColumnDefinition(
                name: defaultPrimaryKeyName,
                columnType: ColumnType.integer,
                isNullable: false,
                columnDefault: defaultIntSerial,
              ),
              ColumnDefinition(
                name: 'created_at',
                columnType: ColumnType.timestampWithoutTimeZone,
                isNullable: false,
              ),
            ],
            foreignKeys: [],
            indexes: [],
          ),
        ],
        installedModules: installedModules,
        migrationApiVersion: migrationApiVersion,
      );

      var result = normalizeMigrationToV2(migration, targetDefinition);

      expect(
        result.actions.first.alterTable!.modifyColumns.first.newDefault,
        defaultDateTimeValueNow,
      );
    },
  );

  test(
    'Given a migration with alter table changing gen_random_uuid() default '
    'when normalized '
    'then the default is converted to "random".',
    () {
      var migration = DatabaseMigration(
        actions: [
          DatabaseMigrationAction(
            type: DatabaseMigrationActionType.alterTable,
            alterTable: TableMigration(
              name: 'example',
              schema: 'public',
              addColumns: [],
              deleteColumns: [],
              modifyColumns: [
                ColumnMigration(
                  columnName: defaultPrimaryKeyName,
                  addNullable: false,
                  removeNullable: false,
                  changeDefault: true,
                  newDefault: 'gen_random_uuid()',
                ),
              ],
              addIndexes: [],
              deleteIndexes: [],
              addForeignKeys: [],
              deleteForeignKeys: [],
              warnings: [],
            ),
          ),
        ],
        warnings: [],
        migrationApiVersion: migrationApiVersion,
      );

      var targetDefinition = DatabaseDefinition(
        schemaVersion: 2,
        moduleName: moduleName,
        tables: [
          TableDefinition(
            name: 'example',
            schema: 'public',
            columns: [
              ColumnDefinition(
                name: defaultPrimaryKeyName,
                columnType: ColumnType.uuid,
                isNullable: false,
              ),
            ],
            foreignKeys: [],
            indexes: [],
          ),
        ],
        installedModules: installedModules,
        migrationApiVersion: migrationApiVersion,
      );

      var result = normalizeMigrationToV2(migration, targetDefinition);

      expect(
        result.actions.first.alterTable!.modifyColumns.first.newDefault,
        defaultUuidValueRandom,
      );
    },
  );
}
