import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/sql_query_builder.dart';
import 'package:test/test.dart';

class TableWithMaxFieldName extends Table {
  late final ColumnString
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo;
  TableWithMaxFieldName(String tableName) : super(tableName: tableName) {
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo =
        ColumnString(
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo',
      this,
    );
  }

  @override
  List<Column> get columns => [
        id,
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
      ];
}

void main() {
  // Field name is 61 characters long causing field alias to be over 63 characters
  // which is the maximum length for identifiers in Postgres.
  var table = TableWithMaxFieldName('table');
  group('Given SelectQueryBuilder', () {
    test(
        'when selecting from table with long field name then field alias is truncated',
        () {
      var query = SelectQueryBuilder(table: table).build();
      expect(
          query,
          contains(
              '"table"."thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo" AS "table.thisFieldIsExactly61CharactersLongAndIsThereforeValid9e99"'));
    });
  });
}
