import 'package:postgres/postgres.dart';

import 'table.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

class Database {
  PostgreSQLConnection connection;
  SerializationManager _serializationManager;

  Database(SerializationManager serializationManager, String host, int port, String name, String user, String pass) {
    _serializationManager = serializationManager;
    connection = PostgreSQLConnection(host, port, name, username: user, password: pass);
  }

  Future<bool> connect() async {
    await connection.open();
    return !connection.isClosed;
  }

  Future<TableRow> findById(String tableName, int id) async {
    var result = await find(tableName, Expression('id = $id'));
    if (result.length == 0)
      return null;
    return result[0];
  }
  
  Future<List<TableRow>> find(String tableName, Expression exp) async {
    var query = 'SELECT * FROM $tableName WHERE $exp';

    print('query: $query');

    var list = <TableRow>[];
    var result = await connection.mappedResultsQuery(query);

    for (var rawRow in result) {
      list.add(_formatTableRow(tableName, rawRow[tableName]));
    }

    return list;
  }

  TableRow _formatTableRow(String tableName, Map<String, dynamic> rawRow) {
    String className = _serializationManager.tableClassMapping[tableName];
    if (className == null)
      return null;

    var data = <String, dynamic>{};

    for (var columnName in rawRow.keys) {
      var value = rawRow[columnName];
      data[columnName] = value;
    }

    var serialization = <String, dynamic> {'data': data, 'class': className};

    return _serializationManager.createEntityFromSerialization(serialization);
  }

  Future<Null> update(TableRow row) async {
    Map data = row.serialize()['data'];

    int id = data['id'];

    var updatesList = <String>[];

    for(String column in data.keys) {
      if (column == 'id')
        continue;

      updatesList.add('$column = \'${data[column]}\'');
    }
    String updates = updatesList.join(', ');

    var query = 'UPDATE ${row.tableName} SET $updates WHERE id = $id';
    print('$query');

    int affectedRows = await connection.execute(query);
    print('updated $affectedRows rows');
  }
}

class Expression {
  final String expression;

  const Expression(this.expression);

  @override
  String toString() {
    return expression;
  }

  Expression and(Expression other) {
    return Expression('$this AND $other');
  }

  Expression equals(Expression other) {
    return Expression('$this = $other');
  }
}

class Column extends Expression {
  final Type type;
  const Column(String name, this.type) : super(name);
}

class Constant extends Expression {
  const Constant(String value) : super('\'$value\'');
}