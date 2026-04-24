import 'package:meta/meta.dart';

import '../../../serverpod_database.dart';

/// PostgreSQL implementation of [ReactiveTriggerManager].
///
/// Creates triggers that write change events to the
/// `serverpod_reactive_db_call` outbox table.
@internal
class PostgresReactiveTriggerManager implements ReactiveTriggerManager {
  const PostgresReactiveTriggerManager();

  static const _triggerPrefix = '_serverpod_reactive_';

  @override
  Future<void> createTrigger(
    DatabaseSession session, {
    required String handlerName,
    required String tableName,
    required Expression? condition,
  }) async {
    final triggerName = '$_triggerPrefix$handlerName';
    final functionName = '${triggerName}_fn';

    await session.db.unsafeExecute(
      _buildFunctionSql(functionName, handlerName),
    );
    await session.db.unsafeExecute(
      _buildTriggerSql(
        triggerName: triggerName,
        functionName: functionName,
        tableName: tableName,
        condition: condition,
      ),
    );
  }

  @override
  Future<void> cleanupOrphanedTriggers(
    DatabaseSession session, {
    required Set<String> registeredHandlers,
  }) async {
    final result = await session.db.unsafeQuery(
      'SELECT tgname, relname FROM pg_trigger '
      'JOIN pg_class ON pg_trigger.tgrelid = pg_class.oid '
      "WHERE tgname LIKE '$_triggerPrefix%' "
      'AND NOT tgisinternal;',
    );

    for (final row in result) {
      final triggerName = row[0] as String;
      final sourceTable = row[1] as String;
      final handlerName = triggerName.replaceFirst(_triggerPrefix, '');

      if (!registeredHandlers.contains(handlerName)) {
        await session.db.unsafeExecute(
          'DROP TRIGGER IF EXISTS "$triggerName" ON "$sourceTable";',
        );
        await session.db.unsafeExecute(
          'DROP FUNCTION IF EXISTS "${triggerName}_fn"();',
        );
      }
    }
  }

  @override
  Future<List<String>> listTriggerHandlers(DatabaseSession session) async {
    final result = await session.db.unsafeQuery(
      'SELECT tgname FROM pg_trigger '
      "WHERE tgname LIKE '$_triggerPrefix%' "
      'AND NOT tgisinternal;',
    );

    return [
      for (final row in result)
        (row[0] as String).replaceFirst(_triggerPrefix, ''),
    ];
  }

  @override
  Future<void> dropAllTriggers(DatabaseSession session) async {
    final result = await session.db.unsafeQuery(
      'SELECT tgname, relname FROM pg_trigger '
      'JOIN pg_class ON pg_trigger.tgrelid = pg_class.oid '
      "WHERE tgname LIKE '$_triggerPrefix%' "
      'AND NOT tgisinternal;',
    );

    for (final row in result) {
      final triggerName = row[0] as String;
      final tableName = row[1] as String;

      await session.db.unsafeExecute(
        'DROP TRIGGER IF EXISTS "$triggerName" ON "$tableName";',
      );
      await session.db.unsafeExecute(
        'DROP FUNCTION IF EXISTS "${triggerName}_fn"();',
      );
    }
  }

  String _buildFunctionSql(String functionName, String handlerName) {
    return '''
CREATE OR REPLACE FUNCTION "$functionName"()
RETURNS TRIGGER AS \$\$
BEGIN
  INSERT INTO "serverpod_reactive_db_call"
    ("handlerName", "sourceTable", "operation", "rowData", "createdAt")
  VALUES (
    '$handlerName',
    TG_TABLE_NAME,
    TG_OP,
    CASE WHEN TG_OP = 'DELETE' THEN row_to_json(OLD.*) ELSE row_to_json(NEW.*) END,
    NOW()
  );
  RETURN CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
END;
\$\$ LANGUAGE plpgsql;''';
  }

  String _buildTriggerSql({
    required String triggerName,
    required String functionName,
    required String tableName,
    required Expression? condition,
  }) {
    final triggerEvents = _resolveTriggerEvents(condition, tableName);
    var whenClause = '';
    if (condition != null) {
      whenClause =
          '\nWHEN (${_convertExpressionToWhenClause(condition, tableName)})';
    }

    return '''
CREATE OR REPLACE TRIGGER "$triggerName"
AFTER $triggerEvents ON "$tableName"
FOR EACH ROW$whenClause
EXECUTE FUNCTION "$functionName"();''';
  }

  /// Determines which trigger events to listen for based on the condition.
  ///
  /// - `hasChanged()` in condition: `UPDATE` only
  /// - Condition references NEW. columns: `INSERT OR UPDATE`
  /// - No condition or no NEW. references: `INSERT OR UPDATE OR DELETE`
  String _resolveTriggerEvents(Expression? condition, String tableName) {
    if (condition == null) return 'INSERT OR UPDATE OR DELETE';

    final hasChanged = condition.depthFirst.any(
      (e) => e is HasChangedExpression,
    );
    if (hasChanged) return 'UPDATE';

    final whenClause = _convertExpressionToWhenClause(condition, tableName);
    if (whenClause.contains('NEW.')) return 'INSERT OR UPDATE';

    return 'INSERT OR UPDATE OR DELETE';
  }

  /// Converts a condition [Expression] to a trigger WHEN clause string.
  ///
  /// Replaces table-qualified column references with `NEW.` prefix.
  /// [HasChangedExpression]s already output `OLD."col" IS DISTINCT FROM
  /// NEW."col"` and are left unchanged.
  String _convertExpressionToWhenClause(
    Expression expression,
    String tableName,
  ) {
    var sql = expression.toString();
    sql = sql.replaceAll('"$tableName".', 'NEW.');
    return sql;
  }
}
