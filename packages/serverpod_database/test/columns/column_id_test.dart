import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/value_encoder.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

void main() {
  ValueEncoder.set(const PostgresValueEncoder());

  group('Given the id column of a table with a nullable int id', () {
    var table = Table<int?>(tableName: 'test');
    var column = table.id;

    test(
      'when checking if the id is in a set literal then output is IN expression.',
      () {
        var expression = column.inSet({1, 2});

        expect(expression.toString(), '$column IN (1, 2)');
      },
    );

    test(
      'when checking if the id is in an empty set then output is FALSE expression.',
      () {
        var expression = column.inSet({});

        expect(expression.toString(), 'FALSE');
      },
    );

    test(
      'when checking if the id is in a set with null then output also matches null.',
      () {
        var expression = column.inSet({1, null});

        expect(
          expression.toString(),
          '($column IN (1) OR $column IS NULL)',
        );
      },
    );

    test(
      'when checking if the id is in a set with only null then output is IS NULL expression.',
      () {
        var expression = column.inSet({null});

        expect(expression.toString(), '$column IS NULL');
      },
    );

    test(
      'when checking if the id is NOT in a set literal then output is NOT IN expression.',
      () {
        var expression = column.notInSet({1, 2});

        expect(
          expression.toString(),
          '($column NOT IN (1, 2) OR $column IS NULL)',
        );
      },
    );

    test(
      'when checking if the id is NOT in an empty set then output is TRUE expression.',
      () {
        var expression = column.notInSet({});

        expect(expression.toString(), 'TRUE');
      },
    );

    test(
      'when checking if the id is NOT in a set with null then output excludes null.',
      () {
        var expression = column.notInSet({1, null});

        expect(
          expression.toString(),
          '($column NOT IN (1) AND $column IS NOT NULL)',
        );
      },
    );

    test(
      'when checking if the id is NOT in a set with only null then output is IS NOT NULL expression.',
      () {
        var expression = column.notInSet({null});

        expect(expression.toString(), '$column IS NOT NULL');
      },
    );
  });

  group('Given the id column of a table with a nullable UuidValue id', () {
    var table = Table<UuidValue?>(tableName: 'test');
    var column = table.id;
    var first = UuidValue.fromString('0193a4a0-0000-7000-8000-000000000001');
    var second = UuidValue.fromString('0193a4a0-0000-7000-8000-000000000002');

    test(
      'when checking if the id is in a set literal then output is IN expression.',
      () {
        var expression = column.inSet({first, second});

        expect(
          expression.toString(),
          "$column IN ('$first', '$second')",
        );
      },
    );

    test(
      'when checking if the id is NOT in a set literal then output is NOT IN expression.',
      () {
        var expression = column.notInSet({first, second});

        expect(
          expression.toString(),
          "($column NOT IN ('$first', '$second') OR $column IS NULL)",
        );
      },
    );
  });

  group('Given the id column of a table with a non-nullable UuidValue id', () {
    var table = Table<UuidValue>(tableName: 'test');
    var column = table.id;
    var first = UuidValue.fromString('0193a4a0-0000-7000-8000-000000000001');

    test(
      'when checking if the id is in a set literal then output is IN expression.',
      () {
        var expression = column.inSet({first});

        expect(expression.toString(), "$column IN ('$first')");
      },
    );
  });
}
