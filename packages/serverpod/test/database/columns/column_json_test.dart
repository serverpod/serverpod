import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnJson', () {
    var columnName = 'data';
    var column = ColumnJson(
      columnName,
      Table<int?>(tableName: 'test'),
    );

    test(
      'when toString is called then column name within double quotes is returned.',
      () {
        expect(column.toString(), '"test"."$columnName"');
      },
    );

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then JsonValue is returned.', () {
      expect(column.type, JsonValue);
    });

    group('with _NullableColumnDefaultOperations mixin', () {
      test(
        'when equals compared to JsonValue then output is equals expression.',
        () {
          var testJson = JsonValue({'key': 'value'});
          var comparisonExpression = column.equals(testJson);

          expect(
            comparisonExpression.toString(),
            "$column = '{\"key\":\"value\"}'::jsonb",
          );
        },
      );

      test(
        'when equals compared to null then output is IS NULL expression.',
        () {
          var comparisonExpression = column.equals(null);

          expect(
            comparisonExpression.toString(),
            '$column IS NULL',
          );
        },
      );

      test(
        'when NOT equals compared to JsonValue then output is IS DISTINCT FROM expression.',
        () {
          var testJson = JsonValue({'key': 'value'});
          var comparisonExpression = column.notEquals(testJson);

          expect(
            comparisonExpression.toString(),
            "$column IS DISTINCT FROM '{\"key\":\"value\"}'::jsonb",
          );
        },
      );

      test(
        'when NOT equals compared to null then output is IS NOT NULL expression.',
        () {
          var comparisonExpression = column.notEquals(null);

          expect(
            comparisonExpression.toString(),
            '$column IS NOT NULL',
          );
        },
      );

      test(
        'when checking if expression is in value set then output is IN expression.',
        () {
          var comparisonExpression = column.inSet(<JsonValue>{
            JsonValue({'a': 1}),
            JsonValue({'b': 2}),
          });

          expect(
            comparisonExpression.toString(),
            "$column IN ('{\"a\":1}'::jsonb, '{\"b\":2}'::jsonb)",
          );
        },
      );

      test(
        'when checking if expression is in empty value set then output is FALSE expression.',
        () {
          var comparisonExpression = column.inSet(<JsonValue>{});

          expect(comparisonExpression.toString(), 'FALSE');
        },
      );
    });

    group('with JSON key operations', () {
      test(
        'when containsKey is called then output is ? operator expression.',
        () {
          var expression = column.containsKey('myKey');
          expect(
            expression.toString(),
            "$column ? 'myKey'",
          );
        },
      );

      test(
        'when containsAnyKey is called then output is ?| operator expression.',
        () {
          var expression = column.containsAnyKey(['key1', 'key2']);
          expect(
            expression.toString(),
            "$column ?| array['key1','key2']",
          );
        },
      );

      test(
        'when containsAllKeys is called then output is ?& operator expression.',
        () {
          var expression = column.containsAllKeys(['key1', 'key2']);
          expect(
            expression.toString(),
            "$column ?& array['key1','key2']",
          );
        },
      );
    });

    group('with JSON containment operations', () {
      test(
        'when contains is called then output is @> operator expression.',
        () {
          var testJson = JsonValue({'premium': true});
          var expression = column.contains(testJson);
          expect(
            expression.toString(),
            "$column @> '{\"premium\":true}'::jsonb",
          );
        },
      );

      test(
        'when containedBy is called then output is <@ operator expression.',
        () {
          var testJson = JsonValue({'a': 1, 'b': 2});
          var expression = column.containedBy(testJson);
          expect(
            expression.toString(),
            "$column <@ '{\"a\":1,\"b\":2}'::jsonb",
          );
        },
      );
    });

    group('with JSON path navigation', () {
      test(
        'when field is called then output is -> operator expression.',
        () {
          var expression = column.field('settings');
          expect(
            expression.toString(),
            "$column -> 'settings'",
          );
        },
      );

      test(
        'when element is called then output is -> operator expression with index.',
        () {
          var expression = column.element(0);
          expect(
            expression.toString(),
            '$column -> 0',
          );
        },
      );

      test(
        'when path is called then output is #> operator expression.',
        () {
          var expression = column.path(['settings', 'theme', 'color']);
          expect(
            expression.toString(),
            "$column #> '{settings,theme,color}'",
          );
        },
      );

      test(
        'when chaining field calls then output is #> operator with combined path.',
        () {
          var expression = column.field('settings').field('theme').field('color');
          expect(
            expression.toString(),
            "$column #> '{settings,theme,color}'",
          );
        },
      );

      test(
        'when chaining field and element then output is correct path.',
        () {
          var expression = column.field('items').element(0).field('name');
          expect(
            expression.toString(),
            "$column #> '{items,0,name}'",
          );
        },
      );
    });

    group('with JsonPathExpression operations', () {
      test(
        'when exists is called then output checks for IS NOT NULL.',
        () {
          var expression = column.field('optional').exists();
          expect(
            expression.toString(),
            "$column -> 'optional' IS NOT NULL",
          );
        },
      );

      test(
        'when containsKey is called on path then output is correct.',
        () {
          var expression = column.field('settings').containsKey('theme');
          expect(
            expression.toString(),
            "$column -> 'settings' ? 'theme'",
          );
        },
      );

      test(
        'when contains is called on path then output is @> expression.',
        () {
          var testJson = JsonValue({'dark': true});
          var expression = column.field('settings').contains(testJson);
          expect(
            expression.toString(),
            "$column -> 'settings' @> '{\"dark\":true}'::jsonb",
          );
        },
      );

      test(
        'when equalsJson is called on path then output is = expression.',
        () {
          var testJson = JsonValue({'enabled': true});
          var expression = column.field('config').equalsJson(testJson);
          expect(
            expression.toString(),
            "$column -> 'config' = '{\"enabled\":true}'::jsonb",
          );
        },
      );
    });

    group('with JsonTextExpression operations', () {
      test(
        'when asText is called then output is ->> operator.',
        () {
          var expression = column.field('name').asText();
          expect(
            expression.toString(),
            "$column ->> 'name'",
          );
        },
      );

      test(
        'when asText equals is called then output is text comparison.',
        () {
          var expression = column.field('name').asText().equals('John');
          expect(
            expression.toString(),
            "$column ->> 'name' = 'John'",
          );
        },
      );

      test(
        'when asText notEquals is called then output is != comparison.',
        () {
          var expression = column.field('status').asText().notEquals('inactive');
          expect(
            expression.toString(),
            "$column ->> 'status' != 'inactive'",
          );
        },
      );

      test(
        'when asText like is called then output is LIKE expression.',
        () {
          var expression = column.field('email').asText().like('%@example.com');
          expect(
            expression.toString(),
            "$column ->> 'email' LIKE '%@example.com'",
          );
        },
      );

      test(
        'when asText ilike is called then output is ILIKE expression.',
        () {
          var expression = column.field('name').asText().ilike('%john%');
          expect(
            expression.toString(),
            "$column ->> 'name' ILIKE '%john%'",
          );
        },
      );

      test(
        'when asText on nested path is called then output is #>> operator.',
        () {
          var expression = column.field('settings').field('theme').asText();
          expect(
            expression.toString(),
            "$column #>> '{settings,theme}'",
          );
        },
      );

      test(
        'when nested path asText equals is called then output is correct.',
        () {
          var expression =
              column.field('settings').field('theme').asText().equals('dark');
          expect(
            expression.toString(),
            "$column #>> '{settings,theme}' = 'dark'",
          );
        },
      );
    });

    group('with JsonNumericExpression operations', () {
      test(
        'when asInt equals is called then output is cast and comparison.',
        () {
          var expression = column.field('age').asText().asInt().equals(30);
          expect(
            expression.toString(),
            "($column ->> 'age')::integer = 30",
          );
        },
      );

      test(
        'when asInt greaterThan is called then output is correct.',
        () {
          var expression = column.field('age').asText().asInt().greaterThan(18);
          expect(
            expression.toString(),
            "($column ->> 'age')::integer > 18",
          );
        },
      );

      test(
        'when asInt lessThan is called then output is correct.',
        () {
          var expression = column.field('count').asText().asInt().lessThan(100);
          expect(
            expression.toString(),
            "($column ->> 'count')::integer < 100",
          );
        },
      );

      test(
        'when asInt between is called then output is BETWEEN expression.',
        () {
          var expression = column.field('score').asText().asInt().between(0, 100);
          expect(
            expression.toString(),
            "($column ->> 'score')::integer BETWEEN 0 AND 100",
          );
        },
      );

      test(
        'when asDouble equals is called then output uses double precision.',
        () {
          var expression = column.field('price').asText().asDouble().equals(9.99);
          expect(
            expression.toString(),
            "($column ->> 'price')::double precision = 9.99",
          );
        },
      );

      test(
        'when asDouble lessThan is called then output is correct.',
        () {
          var expression =
              column.field('price').asText().asDouble().lessThan(50.0);
          expect(
            expression.toString(),
            "($column ->> 'price')::double precision < 50.0",
          );
        },
      );

      test(
        'when nested path asInt is used then output is correct.',
        () {
          var expression = column
              .field('metrics')
              .field('count')
              .asText()
              .asInt()
              .greaterThan(10);
          expect(
            expression.toString(),
            "($column #>> '{metrics,count}')::integer > 10",
          );
        },
      );
    });

    group('with special character escaping', () {
      test(
        'when value contains single quote then it is escaped.',
        () {
          var expression = column.field('name').asText().equals("O'Brien");
          expect(
            expression.toString(),
            "$column ->> 'name' = 'O''Brien'",
          );
        },
      );

      test(
        'when JSON value contains single quote then it is escaped.',
        () {
          var testJson = JsonValue({"name": "O'Brien"});
          var expression = column.contains(testJson);
          // The JSON encoder produces {"name":"O'Brien"} and then '' escapes '
          expect(
            expression.toString(),
            contains("O''Brien"),
          );
        },
      );
    });
  });
}
