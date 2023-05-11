import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

extension DatabaseMigrationPgSqlGenerator on DatabaseMigration {
  String toPgSql() {
    var out = '';

    if (deleteTables.isNotEmpty) {
      out += _header('DROP TABLES');
      for (var deleteTable in deleteTables) {
        out += 'DROP TABLE "$deleteTable"\n';
      }
      out += '\n';
    }

    var migrateTables = <_MigrateTable>[];
    for (var addTable in addTables) {
      migrateTables.add(_MigrateTable(add: addTable));
    }
    for (var modifyTable in modifyTables) {
      migrateTables.add(_MigrateTable(modify: modifyTable));
    }

    if (migrateTables.isNotEmpty) {
      out += _header('INSERT or ALTER TABLES');
      for (var migrateTable in migrateTables) {
        out += migrateTable.toPgSql();
      }
    }

    return out;
  }
}

extension TableMigrationPgSqlGenerator on TableMigration {
  String toPgSql() {
    return '';
  }
}

class _MigrateTable {
  _MigrateTable({
    this.add,
    this.modify,
  }) {
    assert((add != null) ^ (modify != null));
  }

  final TableDefinition? add;
  final TableMigration? modify;

  String get name {
    if (add != null) {
      return add!.name;
    } else {
      return modify!.name;
    }
  }

  String toPgSql() {
    if (add != null) {
      return _toPgSqlDefintion();
    } else {
      return _toPgSqlMigration();
    }
  }

  String _toPgSqlDefintion() {
    var definition = add!;
    String out = '';

    out += _header('Class ${definition.dartName} as table ${definition.name}');
    out += definition.toPgSql();

    return out;
  }

  String _toPgSqlMigration() {
    // var migration = modify!;
    String out = '';

    return out;
  }
}

String _header(String header) {
  var out = '';
  out += '--\n';
  out += '-- $header\n';
  out += '--\n';
  out += '\n';
  return out;
}
