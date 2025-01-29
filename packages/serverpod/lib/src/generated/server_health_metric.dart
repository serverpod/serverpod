/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Represents a snapshot of a specific health metric. An entry is written every
/// minute for each server. All health data can be accessed through Serverpod
/// Insights.
abstract class ServerHealthMetric
    implements _i1.TableRow, _i1.ProtocolSerialization {
  ServerHealthMetric._({
    this.id,
    required this.name,
    required this.serverId,
    required this.timestamp,
    required this.isHealthy,
    required this.value,
    required this.granularity,
  });

  factory ServerHealthMetric({
    int? id,
    required String name,
    required String serverId,
    required DateTime timestamp,
    required bool isHealthy,
    required double value,
    required int granularity,
  }) = _ServerHealthMetricImpl;

  factory ServerHealthMetric.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServerHealthMetric(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      serverId: jsonSerialization['serverId'] as String,
      timestamp:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
      isHealthy: jsonSerialization['isHealthy'] as bool,
      value: (jsonSerialization['value'] as num).toDouble(),
      granularity: jsonSerialization['granularity'] as int,
    );
  }

  static final t = ServerHealthMetricTable();

  static const db = ServerHealthMetricRepository._();

  @override
  int? id;

  /// The name of the metric.
  String name;

  /// The server associated with this metric.
  String serverId;

  /// The time when the connections was checked, granularity is one minute.
  DateTime timestamp;

  /// True if the metric is healthy.
  bool isHealthy;

  /// The value of the metric.
  double value;

  /// The granularity of this timestamp, null represents 1 minute, other valid
  /// values are 60 minutes and 1440 minutes (one day).
  int granularity;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [ServerHealthMetric]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ServerHealthMetric copyWith({
    int? id,
    String? name,
    String? serverId,
    DateTime? timestamp,
    bool? isHealthy,
    double? value,
    int? granularity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'serverId': serverId,
      'timestamp': timestamp.toJson(),
      'isHealthy': isHealthy,
      'value': value,
      'granularity': granularity,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'serverId': serverId,
      'timestamp': timestamp.toJson(),
      'isHealthy': isHealthy,
      'value': value,
      'granularity': granularity,
    };
  }

  static ServerHealthMetricInclude include() {
    return ServerHealthMetricInclude._();
  }

  static ServerHealthMetricIncludeList includeList({
    _i1.WhereExpressionBuilder<ServerHealthMetricTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ServerHealthMetricTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServerHealthMetricTable>? orderByList,
    ServerHealthMetricInclude? include,
  }) {
    return ServerHealthMetricIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ServerHealthMetric.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ServerHealthMetric.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServerHealthMetricImpl extends ServerHealthMetric {
  _ServerHealthMetricImpl({
    int? id,
    required String name,
    required String serverId,
    required DateTime timestamp,
    required bool isHealthy,
    required double value,
    required int granularity,
  }) : super._(
          id: id,
          name: name,
          serverId: serverId,
          timestamp: timestamp,
          isHealthy: isHealthy,
          value: value,
          granularity: granularity,
        );

  /// Returns a shallow copy of this [ServerHealthMetric]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ServerHealthMetric copyWith({
    Object? id = _Undefined,
    String? name,
    String? serverId,
    DateTime? timestamp,
    bool? isHealthy,
    double? value,
    int? granularity,
  }) {
    return ServerHealthMetric(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      serverId: serverId ?? this.serverId,
      timestamp: timestamp ?? this.timestamp,
      isHealthy: isHealthy ?? this.isHealthy,
      value: value ?? this.value,
      granularity: granularity ?? this.granularity,
    );
  }
}

class ServerHealthMetricTable extends _i1.Table {
  ServerHealthMetricTable({super.tableRelation})
      : super(tableName: 'serverpod_health_metric') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    serverId = _i1.ColumnString(
      'serverId',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
    );
    isHealthy = _i1.ColumnBool(
      'isHealthy',
      this,
    );
    value = _i1.ColumnDouble(
      'value',
      this,
    );
    granularity = _i1.ColumnInt(
      'granularity',
      this,
    );
  }

  /// The name of the metric.
  late final _i1.ColumnString name;

  /// The server associated with this metric.
  late final _i1.ColumnString serverId;

  /// The time when the connections was checked, granularity is one minute.
  late final _i1.ColumnDateTime timestamp;

  /// True if the metric is healthy.
  late final _i1.ColumnBool isHealthy;

  /// The value of the metric.
  late final _i1.ColumnDouble value;

  /// The granularity of this timestamp, null represents 1 minute, other valid
  /// values are 60 minutes and 1440 minutes (one day).
  late final _i1.ColumnInt granularity;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        serverId,
        timestamp,
        isHealthy,
        value,
        granularity,
      ];
}

class ServerHealthMetricInclude extends _i1.IncludeObject {
  ServerHealthMetricInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ServerHealthMetric.t;
}

class ServerHealthMetricIncludeList extends _i1.IncludeList {
  ServerHealthMetricIncludeList._({
    _i1.WhereExpressionBuilder<ServerHealthMetricTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ServerHealthMetric.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ServerHealthMetric.t;
}

class ServerHealthMetricRepository {
  const ServerHealthMetricRepository._();

  /// Returns a list of [ServerHealthMetric]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ServerHealthMetric>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServerHealthMetricTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ServerHealthMetricTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServerHealthMetricTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ServerHealthMetric>(
      where: where?.call(ServerHealthMetric.t),
      orderBy: orderBy?.call(ServerHealthMetric.t),
      orderByList: orderByList?.call(ServerHealthMetric.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ServerHealthMetric] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ServerHealthMetric?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServerHealthMetricTable>? where,
    int? offset,
    _i1.OrderByBuilder<ServerHealthMetricTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServerHealthMetricTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ServerHealthMetric>(
      where: where?.call(ServerHealthMetric.t),
      orderBy: orderBy?.call(ServerHealthMetric.t),
      orderByList: orderByList?.call(ServerHealthMetric.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ServerHealthMetric] by its [id] or null if no such row exists.
  Future<ServerHealthMetric?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ServerHealthMetric>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ServerHealthMetric]s in the list and returns the inserted rows.
  ///
  /// The returned [ServerHealthMetric]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ServerHealthMetric>> insert(
    _i1.Session session,
    List<ServerHealthMetric> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ServerHealthMetric>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ServerHealthMetric] and returns the inserted row.
  ///
  /// The returned [ServerHealthMetric] will have its `id` field set.
  Future<ServerHealthMetric> insertRow(
    _i1.Session session,
    ServerHealthMetric row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ServerHealthMetric>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ServerHealthMetric]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ServerHealthMetric>> update(
    _i1.Session session,
    List<ServerHealthMetric> rows, {
    _i1.ColumnSelections<ServerHealthMetricTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ServerHealthMetric>(
      rows,
      columns: columns?.call(ServerHealthMetric.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ServerHealthMetric]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ServerHealthMetric> updateRow(
    _i1.Session session,
    ServerHealthMetric row, {
    _i1.ColumnSelections<ServerHealthMetricTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ServerHealthMetric>(
      row,
      columns: columns?.call(ServerHealthMetric.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ServerHealthMetric]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ServerHealthMetric>> delete(
    _i1.Session session,
    List<ServerHealthMetric> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ServerHealthMetric>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ServerHealthMetric].
  Future<ServerHealthMetric> deleteRow(
    _i1.Session session,
    ServerHealthMetric row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ServerHealthMetric>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ServerHealthMetric>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ServerHealthMetricTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ServerHealthMetric>(
      where: where(ServerHealthMetric.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServerHealthMetricTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ServerHealthMetric>(
      where: where?.call(ServerHealthMetric.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
