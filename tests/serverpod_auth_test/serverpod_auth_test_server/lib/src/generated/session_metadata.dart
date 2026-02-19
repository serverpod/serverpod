/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i2;
import 'package:serverpod_auth_test_server/src/generated/protocol.dart' as _i3;

abstract class SessionMetadata
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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
    required _i1.UuidValue serverSideSessionId,
    _i2.ServerSideSession? serverSideSession,
    required String deviceName,
    String? ipAddress,
    String? userAgent,
    String? metadata,
  }) = _SessionMetadataImpl;

  factory SessionMetadata.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionMetadata(
      id: jsonSerialization['id'] as int?,
      serverSideSessionId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['serverSideSessionId'],
      ),
      serverSideSession: jsonSerialization['serverSideSession'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.ServerSideSession>(
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

  _i1.UuidValue serverSideSessionId;

  /// The [ServerSideSession] this metadata belongs to
  _i2.ServerSideSession? serverSideSession;

  /// Device information for the session
  String deviceName;

  /// IP address from which the session was created
  String? ipAddress;

  /// User agent string
  String? userAgent;

  /// Additional metadata stored as JSON
  String? metadata;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SessionMetadata]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SessionMetadata copyWith({
    int? id,
    _i1.UuidValue? serverSideSessionId,
    _i2.ServerSideSession? serverSideSession,
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
    _i2.ServerSideSessionInclude? serverSideSession,
  }) {
    return SessionMetadataInclude._(serverSideSession: serverSideSession);
  }

  static SessionMetadataIncludeList includeList({
    _i1.WhereExpressionBuilder<SessionMetadataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SessionMetadataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SessionMetadataTable>? orderByList,
    SessionMetadataInclude? include,
  }) {
    return SessionMetadataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionMetadata.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SessionMetadata.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionMetadataImpl extends SessionMetadata {
  _SessionMetadataImpl({
    int? id,
    required _i1.UuidValue serverSideSessionId,
    _i2.ServerSideSession? serverSideSession,
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
  @_i1.useResult
  @override
  SessionMetadata copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? serverSideSessionId,
    Object? serverSideSession = _Undefined,
    String? deviceName,
    Object? ipAddress = _Undefined,
    Object? userAgent = _Undefined,
    Object? metadata = _Undefined,
  }) {
    return SessionMetadata(
      id: id is int? ? id : this.id,
      serverSideSessionId: serverSideSessionId ?? this.serverSideSessionId,
      serverSideSession: serverSideSession is _i2.ServerSideSession?
          ? serverSideSession
          : this.serverSideSession?.copyWith(),
      deviceName: deviceName ?? this.deviceName,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      userAgent: userAgent is String? ? userAgent : this.userAgent,
      metadata: metadata is String? ? metadata : this.metadata,
    );
  }
}

class SessionMetadataUpdateTable extends _i1.UpdateTable<SessionMetadataTable> {
  SessionMetadataUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> serverSideSessionId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.serverSideSessionId,
    value,
  );

  _i1.ColumnValue<String, String> deviceName(String value) => _i1.ColumnValue(
    table.deviceName,
    value,
  );

  _i1.ColumnValue<String, String> ipAddress(String? value) => _i1.ColumnValue(
    table.ipAddress,
    value,
  );

  _i1.ColumnValue<String, String> userAgent(String? value) => _i1.ColumnValue(
    table.userAgent,
    value,
  );

  _i1.ColumnValue<String, String> metadata(String? value) => _i1.ColumnValue(
    table.metadata,
    value,
  );
}

class SessionMetadataTable extends _i1.Table<int?> {
  SessionMetadataTable({super.tableRelation})
    : super(tableName: 'session_metadata') {
    updateTable = SessionMetadataUpdateTable(this);
    serverSideSessionId = _i1.ColumnUuid(
      'serverSideSessionId',
      this,
    );
    deviceName = _i1.ColumnString(
      'deviceName',
      this,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
    userAgent = _i1.ColumnString(
      'userAgent',
      this,
    );
    metadata = _i1.ColumnString(
      'metadata',
      this,
    );
  }

  late final SessionMetadataUpdateTable updateTable;

  late final _i1.ColumnUuid serverSideSessionId;

  /// The [ServerSideSession] this metadata belongs to
  _i2.ServerSideSessionTable? _serverSideSession;

  /// Device information for the session
  late final _i1.ColumnString deviceName;

  /// IP address from which the session was created
  late final _i1.ColumnString ipAddress;

  /// User agent string
  late final _i1.ColumnString userAgent;

  /// Additional metadata stored as JSON
  late final _i1.ColumnString metadata;

  _i2.ServerSideSessionTable get serverSideSession {
    if (_serverSideSession != null) return _serverSideSession!;
    _serverSideSession = _i1.createRelationTable(
      relationFieldName: 'serverSideSession',
      field: SessionMetadata.t.serverSideSessionId,
      foreignField: _i2.ServerSideSession.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ServerSideSessionTable(tableRelation: foreignTableRelation),
    );
    return _serverSideSession!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    serverSideSessionId,
    deviceName,
    ipAddress,
    userAgent,
    metadata,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'serverSideSession') {
      return serverSideSession;
    }
    return null;
  }
}

class SessionMetadataInclude extends _i1.IncludeObject {
  SessionMetadataInclude._({_i2.ServerSideSessionInclude? serverSideSession}) {
    _serverSideSession = serverSideSession;
  }

  _i2.ServerSideSessionInclude? _serverSideSession;

  @override
  Map<String, _i1.Include?> get includes => {
    'serverSideSession': _serverSideSession,
  };

  @override
  _i1.Table<int?> get table => SessionMetadata.t;
}

class SessionMetadataIncludeList extends _i1.IncludeList {
  SessionMetadataIncludeList._({
    _i1.WhereExpressionBuilder<SessionMetadataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SessionMetadata.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SessionMetadata.t;
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SessionMetadataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SessionMetadataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SessionMetadataTable>? orderByList,
    _i1.Transaction? transaction,
    SessionMetadataInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SessionMetadata>(
      where: where?.call(SessionMetadata.t),
      orderBy: orderBy?.call(SessionMetadata.t),
      orderByList: orderByList?.call(SessionMetadata.t),
      orderDescending: orderDescending,
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SessionMetadataTable>? where,
    int? offset,
    _i1.OrderByBuilder<SessionMetadataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SessionMetadataTable>? orderByList,
    _i1.Transaction? transaction,
    SessionMetadataInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SessionMetadata>(
      where: where?.call(SessionMetadata.t),
      orderBy: orderBy?.call(SessionMetadata.t),
      orderByList: orderByList?.call(SessionMetadata.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SessionMetadata] by its [id] or null if no such row exists.
  Future<SessionMetadata?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    SessionMetadataInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
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
  Future<List<SessionMetadata>> insert(
    _i1.Session session,
    List<SessionMetadata> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<SessionMetadata>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [SessionMetadata] and returns the inserted row.
  ///
  /// The returned [SessionMetadata] will have its `id` field set.
  Future<SessionMetadata> insertRow(
    _i1.Session session,
    SessionMetadata row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SessionMetadata>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SessionMetadata]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SessionMetadata>> update(
    _i1.Session session,
    List<SessionMetadata> rows, {
    _i1.ColumnSelections<SessionMetadataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SessionMetadata>(
      rows,
      columns: columns?.call(SessionMetadata.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SessionMetadata]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SessionMetadata> updateRow(
    _i1.Session session,
    SessionMetadata row, {
    _i1.ColumnSelections<SessionMetadataTable>? columns,
    _i1.Transaction? transaction,
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
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<SessionMetadataUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SessionMetadata>(
      id,
      columnValues: columnValues(SessionMetadata.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SessionMetadata]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SessionMetadata>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SessionMetadataUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<SessionMetadataTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SessionMetadataTable>? orderBy,
    _i1.OrderByListBuilder<SessionMetadataTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SessionMetadata>(
      columnValues: columnValues(SessionMetadata.t.updateTable),
      where: where(SessionMetadata.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionMetadata.t),
      orderByList: orderByList?.call(SessionMetadata.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SessionMetadata]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SessionMetadata>> delete(
    _i1.Session session,
    List<SessionMetadata> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SessionMetadata>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SessionMetadata].
  Future<SessionMetadata> deleteRow(
    _i1.Session session,
    SessionMetadata row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SessionMetadata>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SessionMetadata>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SessionMetadataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SessionMetadata>(
      where: where(SessionMetadata.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SessionMetadataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SessionMetadata>(
      where: where?.call(SessionMetadata.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SessionMetadata] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SessionMetadataTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
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
    _i1.Session session,
    SessionMetadata sessionMetadata,
    _i2.ServerSideSession serverSideSession, {
    _i1.Transaction? transaction,
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
