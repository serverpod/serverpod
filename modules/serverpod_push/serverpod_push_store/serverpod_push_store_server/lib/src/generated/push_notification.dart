/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_push_core_server/serverpod_push_core_server.dart'
    as _ipcs;
import 'package:serverpod_push_store_server/src/generated/protocol.dart'
    as _idmfqofs;
import 'push_delivery.dart' as _i3bkdlz1;

/// A fan-out of one authored message to N devices.
abstract class PushNotification
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  PushNotification._({
    this.id,
    required this.message,
    int? schemaVersion,
    this.dedupeKey,
    this.dedupeExpiresAt,
    DateTime? createdAt,
    this.deliveries,
  }) : schemaVersion = schemaVersion ?? 1,
       createdAt = createdAt ?? DateTime.now();

  factory PushNotification({
    _is.UuidValue? id,
    required _ipcs.PushMessage message,
    int? schemaVersion,
    String? dedupeKey,
    DateTime? dedupeExpiresAt,
    DateTime? createdAt,
    List<_i3bkdlz1.PushDelivery>? deliveries,
  }) = _PushNotificationImpl;

  factory PushNotification.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushNotification(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      message: _idmfqofs.Protocol().deserialize<_ipcs.PushMessage>(
        jsonSerialization['message'],
      ),
      schemaVersion: jsonSerialization['schemaVersion'] as int?,
      dedupeKey: jsonSerialization['dedupeKey'] as String?,
      dedupeExpiresAt: jsonSerialization['dedupeExpiresAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['dedupeExpiresAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      deliveries: jsonSerialization['deliveries'] == null
          ? null
          : _idmfqofs.Protocol().deserialize<List<_i3bkdlz1.PushDelivery>>(
              jsonSerialization['deliveries'],
            ),
    );
  }

  static final t = PushNotificationTable();

  static const db = PushNotificationRepository._();

  @override
  _is.UuidValue? id;

  _ipcs.PushMessage message;

  /// Discriminator for the JSON column's interior. Written on every row so a
  /// future breaking change to PushMessage has something to branch on.
  int schemaVersion;

  String? dedupeKey;

  /// When the key becomes reusable. Notification retention deletes rows past
  /// this with no remaining deliveries, which is what frees the key.
  DateTime? dedupeExpiresAt;

  DateTime createdAt;

  List<_i3bkdlz1.PushDelivery>? deliveries;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PushNotification]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PushNotification copyWith({
    _is.UuidValue? id,
    _ipcs.PushMessage? message,
    int? schemaVersion,
    String? dedupeKey,
    DateTime? dedupeExpiresAt,
    DateTime? createdAt,
    List<_i3bkdlz1.PushDelivery>? deliveries,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_push_store.PushNotification',
      if (id != null) 'id': id?.toJson(),
      'message': message.toJson(),
      'schemaVersion': schemaVersion,
      if (dedupeKey != null) 'dedupeKey': dedupeKey,
      if (dedupeExpiresAt != null) 'dedupeExpiresAt': dedupeExpiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (deliveries != null)
        'deliveries': deliveries?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PushNotificationInclude include({
    _i3bkdlz1.PushDeliveryIncludeList? deliveries,
  }) {
    return PushNotificationInclude._(deliveries: deliveries);
  }

  static PushNotificationIncludeList includeList({
    _is.WhereExpressionBuilder<PushNotificationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushNotificationTable>? orderBy,
    _is.OrderByListBuilder<PushNotificationTable>? orderByList,
    PushNotificationInclude? include,
  }) {
    return PushNotificationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushNotification.t),
      orderByList: orderByList?.call(PushNotification.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PushNotificationImpl extends PushNotification {
  _PushNotificationImpl({
    _is.UuidValue? id,
    required _ipcs.PushMessage message,
    int? schemaVersion,
    String? dedupeKey,
    DateTime? dedupeExpiresAt,
    DateTime? createdAt,
    List<_i3bkdlz1.PushDelivery>? deliveries,
  }) : super._(
         id: id,
         message: message,
         schemaVersion: schemaVersion,
         dedupeKey: dedupeKey,
         dedupeExpiresAt: dedupeExpiresAt,
         createdAt: createdAt,
         deliveries: deliveries,
       );

  /// Returns a shallow copy of this [PushNotification]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PushNotification copyWith({
    Object? id = _Undefined,
    _ipcs.PushMessage? message,
    int? schemaVersion,
    Object? dedupeKey = _Undefined,
    Object? dedupeExpiresAt = _Undefined,
    DateTime? createdAt,
    Object? deliveries = _Undefined,
  }) {
    return PushNotification(
      id: id is _is.UuidValue? ? id : this.id,
      message: message ?? this.message.copyWith(),
      schemaVersion: schemaVersion ?? this.schemaVersion,
      dedupeKey: dedupeKey is String? ? dedupeKey : this.dedupeKey,
      dedupeExpiresAt: dedupeExpiresAt is DateTime?
          ? dedupeExpiresAt
          : this.dedupeExpiresAt,
      createdAt: createdAt ?? this.createdAt,
      deliveries: deliveries is List<_i3bkdlz1.PushDelivery>?
          ? deliveries
          : this.deliveries?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class PushNotificationUpdateTable
    extends _is.UpdateTable<PushNotificationTable> {
  PushNotificationUpdateTable(super.table);

  _is.ColumnValue<_ipcs.PushMessage, _ipcs.PushMessage> message(
    _ipcs.PushMessage value,
  ) => _is.ColumnValue(
    table.message,
    value,
  );

  _is.ColumnValue<int, int> schemaVersion(int value) => _is.ColumnValue(
    table.schemaVersion,
    value,
  );

  _is.ColumnValue<String, String> dedupeKey(String? value) => _is.ColumnValue(
    table.dedupeKey,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> dedupeExpiresAt(DateTime? value) =>
      _is.ColumnValue(
        table.dedupeExpiresAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class PushNotificationTable extends _is.Table<_is.UuidValue?> {
  PushNotificationTable({super.tableRelation})
    : super(tableName: 'serverpod_push_notification') {
    updateTable = PushNotificationUpdateTable(this);
    message = _is.ColumnSerializable<_ipcs.PushMessage>(
      'message',
      this,
    );
    schemaVersion = _is.ColumnInt(
      'schemaVersion',
      this,
      hasDefault: true,
    );
    dedupeKey = _is.ColumnString(
      'dedupeKey',
      this,
    );
    dedupeExpiresAt = _is.ColumnDateTime(
      'dedupeExpiresAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final PushNotificationUpdateTable updateTable;

  late final _is.ColumnSerializable<_ipcs.PushMessage> message;

  /// Discriminator for the JSON column's interior. Written on every row so a
  /// future breaking change to PushMessage has something to branch on.
  late final _is.ColumnInt schemaVersion;

  late final _is.ColumnString dedupeKey;

  /// When the key becomes reusable. Notification retention deletes rows past
  /// this with no remaining deliveries, which is what frees the key.
  late final _is.ColumnDateTime dedupeExpiresAt;

  late final _is.ColumnDateTime createdAt;

  _i3bkdlz1.PushDeliveryTable? ___deliveries;

  _is.ManyRelation<_i3bkdlz1.PushDeliveryTable>? _deliveries;

  _i3bkdlz1.PushDeliveryTable get __deliveries {
    if (___deliveries != null) return ___deliveries!;
    ___deliveries = _is.createRelationTable(
      relationFieldName: '__deliveries',
      field: PushNotification.t.id,
      foreignField: _i3bkdlz1.PushDelivery.t.notificationId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3bkdlz1.PushDeliveryTable(tableRelation: foreignTableRelation),
    );
    return ___deliveries!;
  }

  _is.ManyRelation<_i3bkdlz1.PushDeliveryTable> get deliveries {
    if (_deliveries != null) return _deliveries!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'deliveries',
      field: PushNotification.t.id,
      foreignField: _i3bkdlz1.PushDelivery.t.notificationId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3bkdlz1.PushDeliveryTable(tableRelation: foreignTableRelation),
    );
    _deliveries = _is.ManyRelation<_i3bkdlz1.PushDeliveryTable>(
      tableWithRelations: relationTable,
      table: _i3bkdlz1.PushDeliveryTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _deliveries!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    message,
    schemaVersion,
    dedupeKey,
    dedupeExpiresAt,
    createdAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'deliveries') {
      return __deliveries;
    }
    return null;
  }
}

class PushNotificationInclude extends _is.IncludeObject {
  PushNotificationInclude._({_i3bkdlz1.PushDeliveryIncludeList? deliveries}) {
    _deliveries = deliveries;
  }

  _i3bkdlz1.PushDeliveryIncludeList? _deliveries;

  @override
  Map<String, _is.Include?> get includes => {'deliveries': _deliveries};

  @override
  _is.Table<_is.UuidValue?> get table => PushNotification.t;
}

class PushNotificationIncludeList extends _is.IncludeList {
  PushNotificationIncludeList._({
    _is.WhereExpressionBuilder<PushNotificationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PushNotification.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => PushNotification.t;
}

class PushNotificationRepository {
  const PushNotificationRepository._();

  final attach = const PushNotificationAttachRepository._();

  final attachRow = const PushNotificationAttachRowRepository._();

  /// Returns a list of [PushNotification]s matching the given query parameters.
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
  Future<List<PushNotification>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushNotificationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushNotificationTable>? orderBy,
    _is.OrderByListBuilder<PushNotificationTable>? orderByList,
    _is.Transaction? transaction,
    PushNotificationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PushNotification>(
      where: where?.call(PushNotification.t),
      orderBy: orderBy?.call(PushNotification.t),
      orderByList: orderByList?.call(PushNotification.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PushNotification] matching the given query parameters.
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
  Future<PushNotification?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushNotificationTable>? where,
    int? offset,
    _is.OrderByBuilder<PushNotificationTable>? orderBy,
    _is.OrderByListBuilder<PushNotificationTable>? orderByList,
    _is.Transaction? transaction,
    PushNotificationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PushNotification>(
      where: where?.call(PushNotification.t),
      orderBy: orderBy?.call(PushNotification.t),
      orderByList: orderByList?.call(PushNotification.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PushNotification] by its [id] or null if no such row exists.
  Future<PushNotification?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    PushNotificationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PushNotification>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PushNotification]s in the list and returns the inserted rows.
  ///
  /// The returned [PushNotification]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushNotification>> insert(
    _is.DatabaseSession session,
    List<PushNotification> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PushNotification>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PushNotification] and returns the inserted row.
  ///
  /// The returned [PushNotification] will have its `id` field set.
  Future<PushNotification> insertRow(
    _is.DatabaseSession session,
    PushNotification row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PushNotification>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PushNotification]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [PushNotification]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushNotification>> upsert(
    _is.DatabaseSession session,
    List<PushNotification> rows, {
    required _is.ColumnSelections<PushNotificationTable> conflictColumns,
    _is.ColumnSelections<PushNotificationTable>? updateColumns,
    _is.WhereExpressionBuilder<PushNotificationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PushNotification>(
      rows,
      conflictColumns: conflictColumns(PushNotification.t),
      updateColumns: updateColumns?.call(PushNotification.t),
      updateWhere: updateWhere?.call(PushNotification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PushNotification] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [PushNotification] will have its `id` field set.
  Future<PushNotification?> upsertRow(
    _is.DatabaseSession session,
    PushNotification row, {
    required _is.ColumnSelections<PushNotificationTable> conflictColumns,
    _is.ColumnSelections<PushNotificationTable>? updateColumns,
    _is.WhereExpressionBuilder<PushNotificationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PushNotification>(
      row,
      conflictColumns: conflictColumns(PushNotification.t),
      updateColumns: updateColumns?.call(PushNotification.t),
      updateWhere: updateWhere?.call(PushNotification.t),
      transaction: transaction,
    );
  }

  /// Updates all [PushNotification]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushNotification>> update(
    _is.DatabaseSession session,
    List<PushNotification> rows, {
    _is.ColumnSelections<PushNotificationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PushNotification>(
      rows,
      columns: columns?.call(PushNotification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PushNotification]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PushNotification> updateRow(
    _is.DatabaseSession session,
    PushNotification row, {
    _is.ColumnSelections<PushNotificationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PushNotification>(
      row,
      columns: columns?.call(PushNotification.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PushNotification] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PushNotification?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<PushNotificationUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PushNotification>(
      id,
      columnValues: columnValues(PushNotification.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PushNotification]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushNotification>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PushNotificationUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<PushNotificationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushNotificationTable>? orderBy,
    _is.OrderByListBuilder<PushNotificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PushNotification>(
      columnValues: columnValues(PushNotification.t.updateTable),
      where: where(PushNotification.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushNotification.t),
      orderByList: orderByList?.call(PushNotification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PushNotification]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushNotification>> delete(
    _is.DatabaseSession session,
    List<PushNotification> rows, {
    _is.OrderByBuilder<PushNotificationTable>? orderBy,
    _is.OrderByListBuilder<PushNotificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PushNotification>(
      rows,
      orderBy: orderBy?.call(PushNotification.t),
      orderByList: orderByList?.call(PushNotification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PushNotification].
  Future<PushNotification> deleteRow(
    _is.DatabaseSession session,
    PushNotification row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PushNotification>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushNotification>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PushNotificationTable> where,
    _is.OrderByBuilder<PushNotificationTable>? orderBy,
    _is.OrderByListBuilder<PushNotificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PushNotification>(
      where: where(PushNotification.t),
      orderBy: orderBy?.call(PushNotification.t),
      orderByList: orderByList?.call(PushNotification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushNotificationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PushNotification>(
      where: where?.call(PushNotification.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PushNotification] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PushNotificationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PushNotification>(
      where: where(PushNotification.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PushNotificationAttachRepository {
  const PushNotificationAttachRepository._();

  /// Creates a relation between this [PushNotification] and the given [PushDelivery]s
  /// by setting each [PushDelivery]'s foreign key `notificationId` to refer to this [PushNotification].
  Future<void> deliveries(
    _is.DatabaseSession session,
    PushNotification pushNotification,
    List<_i3bkdlz1.PushDelivery> pushDelivery, {
    _is.Transaction? transaction,
  }) async {
    if (pushDelivery.any((e) => e.id == null)) {
      throw ArgumentError.notNull('pushDelivery.id');
    }
    if (pushNotification.id == null) {
      throw ArgumentError.notNull('pushNotification.id');
    }

    var $pushDelivery = pushDelivery
        .map((e) => e.copyWith(notificationId: pushNotification.id))
        .toList();
    await session.db.update<_i3bkdlz1.PushDelivery>(
      $pushDelivery,
      columns: [_i3bkdlz1.PushDelivery.t.notificationId],
      transaction: transaction,
    );
  }
}

class PushNotificationAttachRowRepository {
  const PushNotificationAttachRowRepository._();

  /// Creates a relation between this [PushNotification] and the given [PushDelivery]
  /// by setting the [PushDelivery]'s foreign key `notificationId` to refer to this [PushNotification].
  Future<void> deliveries(
    _is.DatabaseSession session,
    PushNotification pushNotification,
    _i3bkdlz1.PushDelivery pushDelivery, {
    _is.Transaction? transaction,
  }) async {
    if (pushDelivery.id == null) {
      throw ArgumentError.notNull('pushDelivery.id');
    }
    if (pushNotification.id == null) {
      throw ArgumentError.notNull('pushNotification.id');
    }

    var $pushDelivery = pushDelivery.copyWith(
      notificationId: pushNotification.id,
    );
    await session.db.updateRow<_i3bkdlz1.PushDelivery>(
      $pushDelivery,
      columns: [_i3bkdlz1.PushDelivery.t.notificationId],
      transaction: transaction,
    );
  }
}
