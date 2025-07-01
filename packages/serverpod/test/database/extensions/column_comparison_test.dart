import 'package:serverpod/src/database/extensions.dart';
import 'package:serverpod/src/database/migrations/table_comparison_warning.dart';
import 'package:test/test.dart';
import 'package:serverpod/protocol.dart';

void main() {
  group('Given tables with different columns', () {
    test(
      'when a column is missing in the target table then mismatches include missing column',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: true,
              dartType: 'int',
            ),
            ColumnDefinition(
              name: 'age',
              columnType: ColumnType.integer,
              isNullable: true,
              dartType: 'int?',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: true,
              dartType: 'int',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isEmpty);
        expect(mismatches.first, isA<ColumnComparisonWarning>());
        expect(mismatches.first.expected, equals('age'));
        expect(mismatches.first.found, isNull);
        expect(mismatches.first.isMissing, isTrue);
        expect(mismatches.first.isAdded, isFalse);
      },
    );

    test(
      'when columns have different types then mismatches include column type mismatch',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'firstname',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'firstname',
              columnType: ColumnType.text,
              isNullable: true,
              dartType: 'String',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isNotEmpty);
        expect(mismatches.first, isA<ColumnComparisonWarning>());
        expect(mismatches.first.subs.first.expected, equals('integer'));
        expect(mismatches.first.subs.first.found, equals('text'));
        expect(mismatches.first.subs.first.isMismatch, isTrue);
      },
    );

    test(
      'when columns have different nullability then mismatches include column nullability mismatch',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'name',
              columnType: ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'name',
              columnType: ColumnType.text,
              isNullable: true,
              dartType: 'String?',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isNotEmpty);
        expect(mismatches.first, isA<ColumnComparisonWarning>());
        expect(mismatches.first.subs.first.expected, equals('false'));
        expect(mismatches.first.subs.first.found, equals('true'));
        expect(mismatches.first.subs.first.isMismatch, isTrue);
      },
    );

    test(
      'when columns have different default values then mismatches include default value mismatch',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
              columnDefault: '1',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
              columnDefault: '2',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(mismatches.length, 1);
        expect(mismatches.first.subs, isNotEmpty);
        expect(mismatches.first, isA<ColumnComparisonWarning>());
        expect(mismatches.first.subs.first.expected, equals('1'));
        expect(mismatches.first.subs.first.found, equals('2'));
        expect(mismatches.first.subs.first.isMismatch, isTrue);
      },
    );
  });

  test(
    'when vector columns have different dimension then mismatches include dimension mismatch.',
    () {
      var tableA = TableDefinition(
        name: 'test_table',
        schema: 'public',
        columns: [
          ColumnDefinition(
            name: 'embedding',
            columnType: ColumnType.vector,
            isNullable: false,
            dartType: 'Vector(512)',
            vectorDimension: 512,
          ),
        ],
        foreignKeys: [],
        indexes: [],
        managed: true,
      );

      var tableB = TableDefinition(
        name: 'test_table',
        schema: 'public',
        columns: [
          ColumnDefinition(
            name: 'embedding',
            columnType: ColumnType.vector,
            isNullable: false,
            dartType: 'Vector(256)',
            vectorDimension: 256,
          ),
        ],
        foreignKeys: [],
        indexes: [],
        managed: true,
      );

      var mismatches = tableA.like(tableB);

      expect(mismatches.length, 1);
      expect(mismatches.first.subs, isNotEmpty);
      expect(mismatches.first, isA<ColumnComparisonWarning>());
      expect(mismatches.first.subs.first.expected, equals('512'));
      expect(mismatches.first.subs.first.found, equals('256'));
      expect(mismatches.first.subs.first.isMismatch, isTrue);
    },
  );

  test(
    'when half vector columns have different dimension then mismatches include dimension mismatch.',
    () {
      var tableA = TableDefinition(
        name: 'test_table',
        schema: 'public',
        columns: [
          ColumnDefinition(
            name: 'embedding',
            columnType: ColumnType.halfvec,
            isNullable: false,
            dartType: 'HalfVector(512)',
            vectorDimension: 512,
          ),
        ],
        foreignKeys: [],
        indexes: [],
        managed: true,
      );

      var tableB = TableDefinition(
        name: 'test_table',
        schema: 'public',
        columns: [
          ColumnDefinition(
            name: 'embedding',
            columnType: ColumnType.halfvec,
            isNullable: false,
            dartType: 'HalfVector(256)',
            vectorDimension: 256,
          ),
        ],
        foreignKeys: [],
        indexes: [],
        managed: true,
      );

      var mismatches = tableA.like(tableB);

      expect(mismatches.length, 1);
      expect(mismatches.first.subs, isNotEmpty);
      expect(mismatches.first, isA<ColumnComparisonWarning>());
      expect(mismatches.first.subs.first.expected, equals('512'));
      expect(mismatches.first.subs.first.found, equals('256'));
      expect(mismatches.first.subs.first.isMismatch, isTrue);
    },
  );

  test(
    'when sparse vector columns have different dimension then mismatches include dimension mismatch.',
    () {
      var tableA = TableDefinition(
        name: 'test_table',
        schema: 'public',
        columns: [
          ColumnDefinition(
            name: 'embedding',
            columnType: ColumnType.sparsevec,
            isNullable: false,
            dartType: 'SparseVector(512)',
            vectorDimension: 512,
          ),
        ],
        foreignKeys: [],
        indexes: [],
        managed: true,
      );

      var tableB = TableDefinition(
        name: 'test_table',
        schema: 'public',
        columns: [
          ColumnDefinition(
            name: 'embedding',
            columnType: ColumnType.sparsevec,
            isNullable: false,
            dartType: 'SparseVector(256)',
            vectorDimension: 256,
          ),
        ],
        foreignKeys: [],
        indexes: [],
        managed: true,
      );

      var mismatches = tableA.like(tableB);

      expect(mismatches.length, 1);
      expect(mismatches.first.subs, isNotEmpty);
      expect(mismatches.first, isA<ColumnComparisonWarning>());
      expect(mismatches.first.subs.first.expected, equals('512'));
      expect(mismatches.first.subs.first.found, equals('256'));
      expect(mismatches.first.subs.first.isMismatch, isTrue);
    },
  );

  test(
    'when bit vector columns have different dimension then mismatches include dimension mismatch.',
    () {
      var tableA = TableDefinition(
        name: 'test_table',
        schema: 'public',
        columns: [
          ColumnDefinition(
            name: 'embedding',
            columnType: ColumnType.bit,
            isNullable: false,
            dartType: 'Bit(512)',
            vectorDimension: 512,
          ),
        ],
        foreignKeys: [],
        indexes: [],
        managed: true,
      );

      var tableB = TableDefinition(
        name: 'test_table',
        schema: 'public',
        columns: [
          ColumnDefinition(
            name: 'embedding',
            columnType: ColumnType.bit,
            isNullable: false,
            dartType: 'Bit(256)',
            vectorDimension: 256,
          ),
        ],
        foreignKeys: [],
        indexes: [],
        managed: true,
      );

      var mismatches = tableA.like(tableB);

      expect(mismatches.length, 1);
      expect(mismatches.first.subs, isNotEmpty);
      expect(mismatches.first, isA<ColumnComparisonWarning>());
      expect(mismatches.first.subs.first.expected, equals('512'));
      expect(mismatches.first.subs.first.found, equals('256'));
      expect(mismatches.first.subs.first.isMismatch, isTrue);
    },
  );
}
