import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

extension DatabaseMigrationPgSqlGenerator on DatabaseMigration {
  String toPgSql() {
    var out = '';

    for (var action in actions) {
      out += action.toPgSql();
    }

    return out;
  }
}

extension TableMigrationPgSqlGenerator on TableMigration {
  String toPgSql() {
    return '';
  }
}
