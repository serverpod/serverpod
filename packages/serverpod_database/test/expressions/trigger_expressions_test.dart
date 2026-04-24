import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/value_encoder.dart';
import 'package:test/test.dart';

void main() {
  ValueEncoder.set(const PostgresValueEncoder());

  group('Given a HasChangedExpression', () {
    var table = Table<int?>(tableName: 'test');

    test(
      'when created from a ColumnInt then output is OLD IS DISTINCT FROM NEW expression.',
      () {
        var column = ColumnInt('age', table);
        var expression = column.hasChanged();

        expect(
          expression.toString(),
          'OLD."age" IS DISTINCT FROM NEW."age"',
        );
      },
    );

    test(
      'when created from a ColumnString then output is OLD IS DISTINCT FROM NEW expression.',
      () {
        var column = ColumnString('name', table);
        var expression = column.hasChanged();

        expect(
          expression.toString(),
          'OLD."name" IS DISTINCT FROM NEW."name"',
        );
      },
    );

    test(
      'when created from a ColumnBool then output is OLD IS DISTINCT FROM NEW expression.',
      () {
        var column = ColumnBool('active', table);
        var expression = column.hasChanged();

        expect(
          expression.toString(),
          'OLD."active" IS DISTINCT FROM NEW."active"',
        );
      },
    );

    test(
      'when created from a ColumnDateTime then output is OLD IS DISTINCT FROM NEW expression.',
      () {
        var column = ColumnDateTime('createdAt', table);
        var expression = column.hasChanged();

        expect(
          expression.toString(),
          'OLD."createdAt" IS DISTINCT FROM NEW."createdAt"',
        );
      },
    );

    test(
      'when created from a ColumnDouble then output is OLD IS DISTINCT FROM NEW expression.',
      () {
        var column = ColumnDouble('height', table);
        var expression = column.hasChanged();

        expect(
          expression.toString(),
          'OLD."height" IS DISTINCT FROM NEW."height"',
        );
      },
    );

    test(
      'when combined with AND operator then output is correct composite expression.',
      () {
        var column1 = ColumnInt('age', table);
        var column2 = ColumnString('name', table);
        var expression = column1.hasChanged() & column2.hasChanged();

        expect(
          expression.toString(),
          '(OLD."age" IS DISTINCT FROM NEW."age" AND OLD."name" IS DISTINCT FROM NEW."name")',
        );
      },
    );

    test(
      'when combined with OR operator then output is correct composite expression.',
      () {
        var column1 = ColumnInt('age', table);
        var column2 = ColumnString('name', table);
        var expression = column1.hasChanged() | column2.hasChanged();

        expect(
          expression.toString(),
          '(OLD."age" IS DISTINCT FROM NEW."age" OR OLD."name" IS DISTINCT FROM NEW."name")',
        );
      },
    );

    test(
      'when combined with equals expression then output is correct composite expression.',
      () {
        var column = ColumnString('status', table);
        var expression = column.hasChanged() & column.equals('Confirmed');

        expect(
          expression.toString(),
          '(OLD."status" IS DISTINCT FROM NEW."status" AND "test"."status" = \'Confirmed\')',
        );
      },
    );

    test(
      'when combined with greaterThan expression then output is correct composite expression.',
      () {
        var heightColumn = ColumnDouble('height', table);
        var tempColumn = ColumnDouble('temperature', table);
        var expression = heightColumn.hasChanged() & (tempColumn > 100.0);

        expect(
          expression.toString(),
          '(OLD."height" IS DISTINCT FROM NEW."height" AND "test"."temperature" > 100.0)',
        );
      },
    );

    test(
      'when using complex composition then output preserves operator precedence.',
      () {
        var col1 = ColumnInt('a', table);
        var col2 = ColumnInt('b', table);
        var col3 = ColumnInt('c', table);
        var expression = col1.hasChanged() & (col2.hasChanged() | (col3 > 100));

        expect(
          expression.toString(),
          '(OLD."a" IS DISTINCT FROM NEW."a" AND (OLD."b" IS DISTINCT FROM NEW."b" OR "test"."c" > 100))',
        );
      },
    );

    test(
      'when columns getter is called then returns the column.',
      () {
        var column = ColumnInt('age', table);
        var expression = HasChangedExpression(column);

        expect(expression.columns, [column]);
      },
    );
  });
}
