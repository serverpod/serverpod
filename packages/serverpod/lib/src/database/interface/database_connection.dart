import 'package:meta/meta.dart';

import '../../server/session.dart';
import '../concepts/column_value.dart';
import '../concepts/columns.dart';
import '../concepts/database_result.dart';
import '../concepts/expressions.dart';
import '../concepts/includes.dart';
import '../concepts/order.dart';
import '../concepts/row_lock.dart';
import '../concepts/table.dart';
import '../concepts/transaction.dart';
import '../query_parameters.dart';
import 'database_pool_manager.dart';

/// A connection to the database. In most cases the [Database] db object in
/// the [Session] object should be used when connecting with the database.
@internal
abstract class DatabaseConnection<D extends DatabasePoolManager> {
  /// Database configuration.
  final D poolManager;

  /// Creates a new database connection from the configuration. For most cases
  /// this shouldn't be called directly, use the db object in the [Session] to
  /// access the database.
  DatabaseConnection(this.poolManager);

  /// Tests the database connection.
  /// Throws an exception if the connection is not working.
  Future<bool> testConnection() async {
    return poolManager.testConnection();
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<T>> find<T extends TableRow>(
    Session session, {
    Expression? where,
    int? limit,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    List<Order>? orderByList,
    Include? include,
    Transaction? transaction,
    LockMode? lockMode,
    LockBehavior? lockBehavior,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<T?> findFirstRow<T extends TableRow>(
    Session session, {
    Expression? where,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    Transaction? transaction,
    Include? include,
    LockMode? lockMode,
    LockBehavior? lockBehavior,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<T?> findById<T extends TableRow>(
    Session session,
    Object id, {
    Transaction? transaction,
    Include? include,
    LockMode? lockMode,
    LockBehavior? lockBehavior,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<void> lockRows<T extends TableRow>(
    Session session, {
    required Expression where,
    required LockMode lockMode,
    required Transaction transaction,
    LockBehavior lockBehavior = LockBehavior.wait,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<T>> insert<T extends TableRow>(
    Session session,
    List<T> rows, {
    Transaction? transaction,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<T> insertRow<T extends TableRow>(
    Session session,
    T row, {
    Transaction? transaction,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<T>> update<T extends TableRow>(
    Session session,
    List<T> rows, {
    List<Column>? columns,
    Transaction? transaction,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<T> updateRow<T extends TableRow>(
    Session session,
    T row, {
    List<Column>? columns,
    Transaction? transaction,
  });

  /// Updates a single row by its ID with the specified column values.
  ///
  /// Returns the updated row or null if no row with the given ID exists.
  /// Throws [ArgumentError] if [columnValues] is empty.
  ///
  /// For most cases use the corresponding method in [Database] instead.
  Future<T> updateById<T extends TableRow>(
    Session session,
    Object id, {
    required List<ColumnValue> columnValues,
    Transaction? transaction,
  });

  /// Updates all rows matching the WHERE expression with the specified column values.
  ///
  /// Returns a list of all updated rows. Returns an empty list if no rows match.
  /// Throws [ArgumentError] if [columnValues] is empty.
  ///
  /// When [limit], [offset], [orderBy], [orderByList], or [orderDescending] are provided,
  /// only the rows selected by these parameters will be updated.
  ///
  /// For most cases use the corresponding method in [Database] instead.
  Future<List<T>> updateWhere<T extends TableRow>(
    Session session, {
    required List<ColumnValue> columnValues,
    required Expression where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    Transaction? transaction,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<T>> delete<T extends TableRow>(
    Session session,
    List<T> rows, {
    Transaction? transaction,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<T> deleteRow<T extends TableRow>(
    Session session,
    T row, {
    Transaction? transaction,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<T>> deleteWhere<T extends TableRow>(
    Session session,
    Expression where, {
    Transaction? transaction,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<int> count<T extends TableRow>(
    Session session, {
    Expression? where,
    int? limit,
    Transaction? transaction,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<DatabaseResult> simpleQuery(
    Session session,
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<DatabaseResult> query(
    Session session,
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
    QueryParameters? parameters,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<int> execute(
    Session session,
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
    QueryParameters? parameters,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<int> simpleExecute(
    Session session,
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<R> transaction<R>(
    TransactionFunction<R> transactionFunction, {
    required TransactionSettings settings,
    required Session session,
  });

  /// For most cases use the corresponding method in [Database] instead.
  Future<void> runMigrations(
    Session session,
    Future<void> Function(Transaction? transaction) action,
  );
}
