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
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_test_server/src/generated/protocol.dart'
    as _ik2mg1i3;

abstract class SessionMetadata
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SessionMetadata._({
    this.id,
    required this.serverSideSessionId,
    this.serverSideSession,
    required this.deviceName,
    this.ipAddress,
    this.userAgent,
    this.metadata,
  });

  factory SessionMetadata({
    int? id,
    required _is.UuidValue serverSideSessionId,
    _iacs.ServerSideSession? serverSideSession,
    required String deviceName,
    String? ipAddress,
    String? userAgent,
    String? metadata,
  }) = _SessionMetadataImpl;

  factory SessionMetadata.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionMetadata(
      id: jsonSerialization['id'] as int?,
      serverSideSessionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['serverSideSessionId'],
      ),
      serverSideSession: jsonSerialization['serverSideSession'] == null
          ? null
          : _ik2mg1i3.Protocol().deserialize<_iacs.ServerSideSession>(
              jsonSerialization['serverSideSession'],
            ),
      deviceName: jsonSerialization['deviceName'] as String,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      userAgent: jsonSerialization['userAgent'] as String?,
      metadata: jsonSerialization['metadata'] as String?,
    );
  }

  static final t = SessionMetadataTable();

  static const db = SessionMetadataRepository._();

  @override
  int? id;

  _is.UuidValue serverSideSessionId;

  /// The [ServerSideSession] this metadata belongs to
  _iacs.ServerSideSession? serverSideSession;

  /// Device information for the session
  String deviceName;

  /// IP address from which the session was created
  String? ipAddress;

  /// User agent string
  String? userAgent;

  /// Additional metadata stored as JSON
  String? metadata;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SessionMetadata]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SessionMetadata copyWith({
    int? id,
    _is.UuidValue? serverSideSessionId,
    _iacs.ServerSideSession? serverSideSession,
    String? deviceName,
    String? ipAddress,
    String? userAgent,
    String? metadata,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionMetadata',
      if (id != null) 'id': id,
      'serverSideSessionId': serverSideSessionId.toJson(),
      if (serverSideSession != null)
        'serverSideSession': serverSideSession?.toJson(),
      'deviceName': deviceName,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (userAgent != null) 'userAgent': userAgent,
      if (metadata != null) 'metadata': metadata,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SessionMetadataInclude include({
    _iacs.ServerSideSessionInclude? serverSideSession,
    _is.SelectColumnsBuilder<SessionMetadataTable>? select,
  }) {
    return SessionMetadataInclude.internal_(
      serverSideSession: serverSideSession,
      selectedColumns: select?.call(SessionMetadata.t),
    );
  }

  static SessionMetadataIncludeList includeList({
    _is.WhereExpressionBuilder<SessionMetadataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionMetadataTable>? orderBy,
    _is.OrderByListBuilder<SessionMetadataTable>? orderByList,
    SessionMetadataInclude? include,
    _is.SelectColumnsBuilder<SessionMetadataTable>? select,
  }) {
    return SessionMetadataIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionMetadata.t),
      orderByList: orderByList?.call(SessionMetadata.t),
      include: include,
      selectedColumns: select?.call(SessionMetadata.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionMetadataImpl extends SessionMetadata {
  _SessionMetadataImpl({
    int? id,
    required _is.UuidValue serverSideSessionId,
    _iacs.ServerSideSession? serverSideSession,
    required String deviceName,
    String? ipAddress,
    String? userAgent,
    String? metadata,
  }) : super._(
         id: id,
         serverSideSessionId: serverSideSessionId,
         serverSideSession: serverSideSession,
         deviceName: deviceName,
         ipAddress: ipAddress,
         userAgent: userAgent,
         metadata: metadata,
       );

  /// Returns a shallow copy of this [SessionMetadata]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SessionMetadata copyWith({
    Object? id = _Undefined,
    _is.UuidValue? serverSideSessionId,
    Object? serverSideSession = _Undefined,
    String? deviceName,
    Object? ipAddress = _Undefined,
    Object? userAgent = _Undefined,
    Object? metadata = _Undefined,
  }) {
    return SessionMetadata(
      id: id is int? ? id : this.id,
      serverSideSessionId: serverSideSessionId ?? this.serverSideSessionId,
      serverSideSession: serverSideSession is _iacs.ServerSideSession?
          ? serverSideSession
          : this.serverSideSession?.copyWith(),
      deviceName: deviceName ?? this.deviceName,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      userAgent: userAgent is String? ? userAgent : this.userAgent,
      metadata: metadata is String? ? metadata : this.metadata,
    );
  }
}

class SessionMetadataUpdateTable extends _is.UpdateTable<SessionMetadataTable> {
  SessionMetadataUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> serverSideSessionId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.serverSideSessionId,
    value,
  );

  _is.ColumnValue<String, String> deviceName(String value) => _is.ColumnValue(
    table.deviceName,
    value,
  );

  _is.ColumnValue<String, String> ipAddress(String? value) => _is.ColumnValue(
    table.ipAddress,
    value,
  );

  _is.ColumnValue<String, String> userAgent(String? value) => _is.ColumnValue(
    table.userAgent,
    value,
  );

  _is.ColumnValue<String, String> metadata(String? value) => _is.ColumnValue(
    table.metadata,
    value,
  );
}

class SessionMetadataTable extends _is.Table<int?> {
  SessionMetadataTable({super.tableRelation})
    : super(tableName: 'session_metadata') {
    updateTable = SessionMetadataUpdateTable(this);
    serverSideSessionId = _is.ColumnUuid(
      'serverSideSessionId',
      this,
    );
    deviceName = _is.ColumnString(
      'deviceName',
      this,
    );
    ipAddress = _is.ColumnString(
      'ipAddress',
      this,
    );
    userAgent = _is.ColumnString(
      'userAgent',
      this,
    );
    metadata = _is.ColumnString(
      'metadata',
      this,
    );
  }

  late final SessionMetadataUpdateTable updateTable;

  late final _is.ColumnUuid serverSideSessionId;

  /// The [ServerSideSession] this metadata belongs to
  _iacs.ServerSideSessionTable? _serverSideSession;

  /// Device information for the session
  late final _is.ColumnString deviceName;

  /// IP address from which the session was created
  late final _is.ColumnString ipAddress;

  /// User agent string
  late final _is.ColumnString userAgent;

  /// Additional metadata stored as JSON
  late final _is.ColumnString metadata;

  _iacs.ServerSideSessionTable get serverSideSession {
    if (_serverSideSession != null) return _serverSideSession!;
    _serverSideSession = _is.createRelationTable(
      relationFieldName: 'serverSideSession',
      field: SessionMetadata.t.serverSideSessionId,
      foreignField: _iacs.ServerSideSession.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.ServerSideSessionTable(tableRelation: foreignTableRelation),
    );
    return _serverSideSession!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    serverSideSessionId,
    deviceName,
    ipAddress,
    userAgent,
    metadata,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'serverSideSession') {
      return serverSideSession;
    }
    return null;
  }
}

class SessionMetadataInclude extends _is.IncludeObject {
  SessionMetadataInclude.internal_({
    _iacs.ServerSideSessionInclude? serverSideSession,
    this.selectedColumns,
  }) {
    _serverSideSession = serverSideSession;
  }

  _iacs.ServerSideSessionInclude? _serverSideSession;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'serverSideSession': _serverSideSession,
  };

  @override
  _is.Table<int?> get table => SessionMetadata.t;
}

class SessionMetadataIncludeList extends _is.IncludeList {
  SessionMetadataIncludeList.internal_({
    _is.WhereExpressionBuilder<SessionMetadataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(SessionMetadata.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SessionMetadata.t;
}

class SessionMetadataRepository {
  const SessionMetadataRepository._();

  final attachRow = const SessionMetadataAttachRowRepository._();

  /// Returns a list of [SessionMetadata]s matching the given query parameters.
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
  Future<List<SessionMetadata>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SessionMetadataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionMetadataTable>? orderBy,
    _is.OrderByListBuilder<SessionMetadataTable>? orderByList,
    _is.Transaction? transaction,
    SessionMetadataInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SessionMetadata>(
      where: where?.call(SessionMetadata.t),
      orderBy: orderBy?.call(SessionMetadata.t),
      orderByList: orderByList?.call(SessionMetadata.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SessionMetadata] matching the given query parameters.
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
  Future<SessionMetadata?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SessionMetadataTable>? where,
    int? offset,
    _is.OrderByBuilder<SessionMetadataTable>? orderBy,
    _is.OrderByListBuilder<SessionMetadataTable>? orderByList,
    _is.Transaction? transaction,
    SessionMetadataInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SessionMetadata>(
      where: where?.call(SessionMetadata.t),
      orderBy: orderBy?.call(SessionMetadata.t),
      orderByList: orderByList?.call(SessionMetadata.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SessionMetadata] by its [id] or null if no such row exists.
  Future<SessionMetadata?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    SessionMetadataInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SessionMetadata>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SessionMetadata]s in the list and returns the inserted rows.
  ///
  /// The returned [SessionMetadata]s will have their `id` fields set.
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
  Future<List<SessionMetadata>> insert(
    _is.DatabaseSession session,
    List<SessionMetadata> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SessionMetadata>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SessionMetadata] and returns the inserted row.
  ///
  /// The returned [SessionMetadata] will have its `id` field set.
  Future<SessionMetadata> insertRow(
    _is.DatabaseSession session,
    SessionMetadata row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SessionMetadata>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SessionMetadata]s in the list and returns the resulting rows.
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
  /// The returned [SessionMetadata]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionMetadata>> upsert(
    _is.DatabaseSession session,
    List<SessionMetadata> rows, {
    required _is.ColumnSelections<SessionMetadataTable> conflictColumns,
    _is.ColumnSelections<SessionMetadataTable>? updateColumns,
    _is.WhereExpressionBuilder<SessionMetadataTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SessionMetadata>(
      rows,
      conflictColumns: conflictColumns(SessionMetadata.t),
      updateColumns: updateColumns?.call(SessionMetadata.t),
      updateWhere: updateWhere?.call(SessionMetadata.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SessionMetadata] and returns the resulting row.
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
  /// The returned [SessionMetadata] will have its `id` field set.
  Future<SessionMetadata?> upsertRow(
    _is.DatabaseSession session,
    SessionMetadata row, {
    required _is.ColumnSelections<SessionMetadataTable> conflictColumns,
    _is.ColumnSelections<SessionMetadataTable>? updateColumns,
    _is.WhereExpressionBuilder<SessionMetadataTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SessionMetadata>(
      row,
      conflictColumns: conflictColumns(SessionMetadata.t),
      updateColumns: updateColumns?.call(SessionMetadata.t),
      updateWhere: updateWhere?.call(SessionMetadata.t),
      transaction: transaction,
    );
  }

  /// Updates all [SessionMetadata]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionMetadata>> update(
    _is.DatabaseSession session,
    List<SessionMetadata> rows, {
    _is.ColumnSelections<SessionMetadataTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SessionMetadata>(
      rows,
      columns: columns?.call(SessionMetadata.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SessionMetadata]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SessionMetadata> updateRow(
    _is.DatabaseSession session,
    SessionMetadata row, {
    _is.ColumnSelections<SessionMetadataTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SessionMetadata>(
      row,
      columns: columns?.call(SessionMetadata.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SessionMetadata] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SessionMetadata?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SessionMetadataUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SessionMetadata>(
      id,
      columnValues: columnValues(SessionMetadata.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SessionMetadata]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionMetadata>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SessionMetadataUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<SessionMetadataTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionMetadataTable>? orderBy,
    _is.OrderByListBuilder<SessionMetadataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SessionMetadata>(
      columnValues: columnValues(SessionMetadata.t.updateTable),
      where: where(SessionMetadata.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionMetadata.t),
      orderByList: orderByList?.call(SessionMetadata.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SessionMetadata]s in the list and returns the deleted rows.
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
  Future<List<SessionMetadata>> delete(
    _is.DatabaseSession session,
    List<SessionMetadata> rows, {
    _is.OrderByBuilder<SessionMetadataTable>? orderBy,
    _is.OrderByListBuilder<SessionMetadataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SessionMetadata>(
      rows,
      orderBy: orderBy?.call(SessionMetadata.t),
      orderByList: orderByList?.call(SessionMetadata.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SessionMetadata].
  Future<SessionMetadata> deleteRow(
    _is.DatabaseSession session,
    SessionMetadata row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SessionMetadata>(
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
  Future<List<SessionMetadata>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SessionMetadataTable> where,
    _is.OrderByBuilder<SessionMetadataTable>? orderBy,
    _is.OrderByListBuilder<SessionMetadataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SessionMetadata>(
      where: where(SessionMetadata.t),
      orderBy: orderBy?.call(SessionMetadata.t),
      orderByList: orderByList?.call(SessionMetadata.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SessionMetadataTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SessionMetadata>(
      where: where?.call(SessionMetadata.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SessionMetadata] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SessionMetadataTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SessionMetadata>(
      where: where(SessionMetadata.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class SessionMetadataAttachRowRepository {
  const SessionMetadataAttachRowRepository._();

  /// Creates a relation between the given [SessionMetadata] and [ServerSideSession]
  /// by setting the [SessionMetadata]'s foreign key `serverSideSessionId` to refer to the [ServerSideSession].
  Future<void> serverSideSession(
    _is.DatabaseSession session,
    SessionMetadata sessionMetadata,
    _iacs.ServerSideSession serverSideSession, {
    _is.Transaction? transaction,
  }) async {
    if (sessionMetadata.id == null) {
      throw ArgumentError.notNull('sessionMetadata.id');
    }
    if (serverSideSession.id == null) {
      throw ArgumentError.notNull('serverSideSession.id');
    }

    var $sessionMetadata = sessionMetadata.copyWith(
      serverSideSessionId: serverSideSession.id,
    );
    await session.db.updateRow<SessionMetadata>(
      $sessionMetadata,
      columns: [SessionMetadata.t.serverSideSessionId],
      transaction: transaction,
    );
  }
}
