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
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/src/generated/protocol.dart'
    as _i8reeoob;
import '../../auth_user/models/auth_user.dart' as _ivyervu7;

/// Server-side authentication session.
abstract class ServerSideSession
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ServerSideSession._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.scopeNames,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    this.expiresAt,
    this.expireAfterUnusedFor,
    required this.sessionKeyHash,
    required this.sessionKeySalt,
    required this.method,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastUsedAt = lastUsedAt ?? DateTime.now();

  factory ServerSideSession({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _ivyervu7.AuthUser? authUser,
    required Set<String> scopeNames,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    DateTime? expiresAt,
    Duration? expireAfterUnusedFor,
    required _idt.ByteData sessionKeyHash,
    required _idt.ByteData sessionKeySalt,
    required String method,
  }) = _ServerSideSessionImpl;

  factory ServerSideSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServerSideSession(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i8reeoob.Protocol().deserialize<_ivyervu7.AuthUser>(
              jsonSerialization['authUser'],
            ),
      scopeNames: _i8reeoob.Protocol().deserialize<Set<String>>(
        jsonSerialization['scopeNames'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastUsedAt: jsonSerialization['lastUsedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['lastUsedAt']),
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      expireAfterUnusedFor: jsonSerialization['expireAfterUnusedFor'] == null
          ? null
          : _is.DurationJsonExtension.fromJson(
              jsonSerialization['expireAfterUnusedFor'],
            ),
      sessionKeyHash: _is.ByteDataJsonExtension.fromJson(
        jsonSerialization['sessionKeyHash'],
      ),
      sessionKeySalt: _is.ByteDataJsonExtension.fromJson(
        jsonSerialization['sessionKeySalt'],
      ),
      method: jsonSerialization['method'] as String,
    );
  }

  static final t = ServerSideSessionTable();

  static const db = ServerSideSessionRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue authUserId;

  /// The [AuthUser] this session belongs to
  _ivyervu7.AuthUser? authUser;

  /// The scopes this session provides access to.
  Set<String> scopeNames;

  /// The time when this session was created.
  DateTime createdAt;

  /// The time when this access session was last used.
  ///
  /// Operates only with minute resolution, to avoid excessive writes to the database.
  DateTime lastUsedAt;

  /// The time after which this session can not be used anymore.
  ///
  /// If `null`, the session can be used indefinitely.
  DateTime? expiresAt;

  /// The maximum duration this session can go unused.
  ///
  /// If set, and the session is used after [lastUsed] + [expireAfterUnusedFor], then it will be rejected.
  ///
  /// If `null`, the session is valid until [expiresAt].
  Duration? expireAfterUnusedFor;

  /// Hashed version of the session key.
  ///
  /// The clients authentication header will be compared against this to check the validity of the session.
  _idt.ByteData sessionKeyHash;

  /// The salt used for computing the [sessionKeyHash].
  ///
  /// Per default uses 16 bytes of random data.
  _idt.ByteData sessionKeySalt;

  /// The method through which this session was created.
  ///
  /// This can be either an email or social login, a personal access token, service account etc.
  String method;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ServerSideSession]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ServerSideSession copyWith({
    _is.UuidValue? id,
    _is.UuidValue? authUserId,
    _ivyervu7.AuthUser? authUser,
    Set<String>? scopeNames,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    DateTime? expiresAt,
    Duration? expireAfterUnusedFor,
    _idt.ByteData? sessionKeyHash,
    _idt.ByteData? sessionKeySalt,
    String? method,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_core.ServerSideSession',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'scopeNames': scopeNames.toJson(),
      'createdAt': createdAt.toJson(),
      'lastUsedAt': lastUsedAt.toJson(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      if (expireAfterUnusedFor != null)
        'expireAfterUnusedFor': expireAfterUnusedFor?.toJson(),
      'sessionKeyHash': sessionKeyHash.toJson(),
      'sessionKeySalt': sessionKeySalt.toJson(),
      'method': method,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ServerSideSessionInclude include({
    _ivyervu7.AuthUserInclude? authUser,
    _is.SelectColumnsBuilder<ServerSideSessionTable>? select,
  }) {
    return ServerSideSessionInclude._(
      authUser: authUser,
      selectedColumns: select?.call(ServerSideSession.t),
    );
  }

  static ServerSideSessionIncludeList includeList({
    _is.WhereExpressionBuilder<ServerSideSessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ServerSideSessionTable>? orderBy,
    _is.OrderByListBuilder<ServerSideSessionTable>? orderByList,
    ServerSideSessionInclude? include,
    _is.SelectColumnsBuilder<ServerSideSessionTable>? select,
  }) {
    return ServerSideSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ServerSideSession.t),
      orderByList: orderByList?.call(ServerSideSession.t),
      include: include,
      selectedColumns: select?.call(ServerSideSession.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServerSideSessionImpl extends ServerSideSession {
  _ServerSideSessionImpl({
    _is.UuidValue? id,
    required _is.UuidValue authUserId,
    _ivyervu7.AuthUser? authUser,
    required Set<String> scopeNames,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    DateTime? expiresAt,
    Duration? expireAfterUnusedFor,
    required _idt.ByteData sessionKeyHash,
    required _idt.ByteData sessionKeySalt,
    required String method,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         scopeNames: scopeNames,
         createdAt: createdAt,
         lastUsedAt: lastUsedAt,
         expiresAt: expiresAt,
         expireAfterUnusedFor: expireAfterUnusedFor,
         sessionKeyHash: sessionKeyHash,
         sessionKeySalt: sessionKeySalt,
         method: method,
       );

  /// Returns a shallow copy of this [ServerSideSession]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ServerSideSession copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Set<String>? scopeNames,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    Object? expiresAt = _Undefined,
    Object? expireAfterUnusedFor = _Undefined,
    _idt.ByteData? sessionKeyHash,
    _idt.ByteData? sessionKeySalt,
    String? method,
  }) {
    return ServerSideSession(
      id: id is _is.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _ivyervu7.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      expireAfterUnusedFor: expireAfterUnusedFor is Duration?
          ? expireAfterUnusedFor
          : this.expireAfterUnusedFor,
      sessionKeyHash: sessionKeyHash ?? this.sessionKeyHash.clone(),
      sessionKeySalt: sessionKeySalt ?? this.sessionKeySalt.clone(),
      method: method ?? this.method,
    );
  }
}

class ServerSideSessionUpdateTable
    extends _is.UpdateTable<ServerSideSessionTable> {
  ServerSideSessionUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<Set<String>, Set<String>> scopeNames(Set<String> value) =>
      _is.ColumnValue(
        table.scopeNames,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastUsedAt(DateTime value) =>
      _is.ColumnValue(
        table.lastUsedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime? value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<Duration, Duration> expireAfterUnusedFor(Duration? value) =>
      _is.ColumnValue(
        table.expireAfterUnusedFor,
        value,
      );

  _is.ColumnValue<_idt.ByteData, _idt.ByteData> sessionKeyHash(
    _idt.ByteData value,
  ) => _is.ColumnValue(
    table.sessionKeyHash,
    value,
  );

  _is.ColumnValue<_idt.ByteData, _idt.ByteData> sessionKeySalt(
    _idt.ByteData value,
  ) => _is.ColumnValue(
    table.sessionKeySalt,
    value,
  );

  _is.ColumnValue<String, String> method(String value) => _is.ColumnValue(
    table.method,
    value,
  );
}

class ServerSideSessionTable extends _is.Table<_is.UuidValue?> {
  ServerSideSessionTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_core_session') {
    updateTable = ServerSideSessionUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    scopeNames = _is.ColumnSerializable<Set<String>>(
      'scopeNames',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    lastUsedAt = _is.ColumnDateTime(
      'lastUsedAt',
      this,
      hasDefault: true,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    expireAfterUnusedFor = _is.ColumnDuration(
      'expireAfterUnusedFor',
      this,
    );
    sessionKeyHash = _is.ColumnByteData(
      'sessionKeyHash',
      this,
    );
    sessionKeySalt = _is.ColumnByteData(
      'sessionKeySalt',
      this,
    );
    method = _is.ColumnString(
      'method',
      this,
    );
  }

  late final ServerSideSessionUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// The [AuthUser] this session belongs to
  _ivyervu7.AuthUserTable? _authUser;

  /// The scopes this session provides access to.
  late final _is.ColumnSerializable<Set<String>> scopeNames;

  /// The time when this session was created.
  late final _is.ColumnDateTime createdAt;

  /// The time when this access session was last used.
  ///
  /// Operates only with minute resolution, to avoid excessive writes to the database.
  late final _is.ColumnDateTime lastUsedAt;

  /// The time after which this session can not be used anymore.
  ///
  /// If `null`, the session can be used indefinitely.
  late final _is.ColumnDateTime expiresAt;

  /// The maximum duration this session can go unused.
  ///
  /// If set, and the session is used after [lastUsed] + [expireAfterUnusedFor], then it will be rejected.
  ///
  /// If `null`, the session is valid until [expiresAt].
  late final _is.ColumnDuration expireAfterUnusedFor;

  /// Hashed version of the session key.
  ///
  /// The clients authentication header will be compared against this to check the validity of the session.
  late final _is.ColumnByteData sessionKeyHash;

  /// The salt used for computing the [sessionKeyHash].
  ///
  /// Per default uses 16 bytes of random data.
  late final _is.ColumnByteData sessionKeySalt;

  /// The method through which this session was created.
  ///
  /// This can be either an email or social login, a personal access token, service account etc.
  late final _is.ColumnString method;

  _ivyervu7.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: ServerSideSession.t.authUserId,
      foreignField: _ivyervu7.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ivyervu7.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    scopeNames,
    createdAt,
    lastUsedAt,
    expiresAt,
    expireAfterUnusedFor,
    sessionKeyHash,
    sessionKeySalt,
    method,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class ServerSideSessionInclude extends _is.IncludeObject {
  ServerSideSessionInclude._({
    _ivyervu7.AuthUserInclude? authUser,
    this.selectedColumns,
  }) {
    _authUser = authUser;
  }

  _ivyervu7.AuthUserInclude? _authUser;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<_is.UuidValue?> get table => ServerSideSession.t;
}

class ServerSideSessionIncludeList extends _is.IncludeList {
  ServerSideSessionIncludeList._({
    _is.WhereExpressionBuilder<ServerSideSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ServerSideSession.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ServerSideSession.t;
}

class ServerSideSessionRepository {
  const ServerSideSessionRepository._();

  final attachRow = const ServerSideSessionAttachRowRepository._();

  /// Returns a list of [ServerSideSession]s matching the given query parameters.
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
  Future<List<ServerSideSession>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServerSideSessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ServerSideSessionTable>? orderBy,
    _is.OrderByListBuilder<ServerSideSessionTable>? orderByList,
    _is.Transaction? transaction,
    ServerSideSessionInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ServerSideSession>(
      where: where?.call(ServerSideSession.t),
      orderBy: orderBy?.call(ServerSideSession.t),
      orderByList: orderByList?.call(ServerSideSession.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ServerSideSession] matching the given query parameters.
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
  Future<ServerSideSession?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServerSideSessionTable>? where,
    int? offset,
    _is.OrderByBuilder<ServerSideSessionTable>? orderBy,
    _is.OrderByListBuilder<ServerSideSessionTable>? orderByList,
    _is.Transaction? transaction,
    ServerSideSessionInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ServerSideSession>(
      where: where?.call(ServerSideSession.t),
      orderBy: orderBy?.call(ServerSideSession.t),
      orderByList: orderByList?.call(ServerSideSession.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ServerSideSession] by its [id] or null if no such row exists.
  Future<ServerSideSession?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    ServerSideSessionInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ServerSideSession>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var persons = await Persons.db.findAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.lastName],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServerSideSessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ServerSideSessionTable>? orderBy,
    _is.OrderByListBuilder<ServerSideSessionTable>? orderByList,
    _is.Transaction? transaction,
    ServerSideSessionInclude? include,
    _is.SelectColumnsBuilder<ServerSideSessionTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ServerSideSession>(
      where: where?.call(ServerSideSession.t),
      orderBy: orderBy?.call(ServerSideSession.t),
      orderByList: orderByList?.call(ServerSideSession.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(ServerSideSession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var youngestPerson = await Persons.db.findFirstRowAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.age],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServerSideSessionTable>? where,
    int? offset,
    _is.OrderByBuilder<ServerSideSessionTable>? orderBy,
    _is.OrderByListBuilder<ServerSideSessionTable>? orderByList,
    _is.Transaction? transaction,
    ServerSideSessionInclude? include,
    _is.SelectColumnsBuilder<ServerSideSessionTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ServerSideSession>(
      where: where?.call(ServerSideSession.t),
      orderBy: orderBy?.call(ServerSideSession.t),
      orderByList: orderByList?.call(ServerSideSession.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(ServerSideSession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    ServerSideSessionInclude? include,
    _is.SelectColumnsBuilder<ServerSideSessionTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ServerSideSession>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(ServerSideSession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ServerSideSession]s in the list and returns the inserted rows.
  ///
  /// The returned [ServerSideSession]s will have their `id` fields set.
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
  Future<List<ServerSideSession>> insert(
    _is.DatabaseSession session,
    List<ServerSideSession> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ServerSideSession>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ServerSideSession] and returns the inserted row.
  ///
  /// The returned [ServerSideSession] will have its `id` field set.
  Future<ServerSideSession> insertRow(
    _is.DatabaseSession session,
    ServerSideSession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ServerSideSession>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ServerSideSession]s in the list and returns the resulting rows.
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
  /// The returned [ServerSideSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ServerSideSession>> upsert(
    _is.DatabaseSession session,
    List<ServerSideSession> rows, {
    required _is.ColumnSelections<ServerSideSessionTable> conflictColumns,
    _is.ColumnSelections<ServerSideSessionTable>? updateColumns,
    _is.WhereExpressionBuilder<ServerSideSessionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ServerSideSession>(
      rows,
      conflictColumns: conflictColumns(ServerSideSession.t),
      updateColumns: updateColumns?.call(ServerSideSession.t),
      updateWhere: updateWhere?.call(ServerSideSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ServerSideSession] and returns the resulting row.
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
  /// The returned [ServerSideSession] will have its `id` field set.
  Future<ServerSideSession?> upsertRow(
    _is.DatabaseSession session,
    ServerSideSession row, {
    required _is.ColumnSelections<ServerSideSessionTable> conflictColumns,
    _is.ColumnSelections<ServerSideSessionTable>? updateColumns,
    _is.WhereExpressionBuilder<ServerSideSessionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ServerSideSession>(
      row,
      conflictColumns: conflictColumns(ServerSideSession.t),
      updateColumns: updateColumns?.call(ServerSideSession.t),
      updateWhere: updateWhere?.call(ServerSideSession.t),
      transaction: transaction,
    );
  }

  /// Updates all [ServerSideSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ServerSideSession>> update(
    _is.DatabaseSession session,
    List<ServerSideSession> rows, {
    _is.ColumnSelections<ServerSideSessionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ServerSideSession>(
      rows,
      columns: columns?.call(ServerSideSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ServerSideSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ServerSideSession> updateRow(
    _is.DatabaseSession session,
    ServerSideSession row, {
    _is.ColumnSelections<ServerSideSessionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ServerSideSession>(
      row,
      columns: columns?.call(ServerSideSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ServerSideSession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ServerSideSession?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ServerSideSessionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ServerSideSession>(
      id,
      columnValues: columnValues(ServerSideSession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ServerSideSession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ServerSideSession>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ServerSideSessionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ServerSideSessionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ServerSideSessionTable>? orderBy,
    _is.OrderByListBuilder<ServerSideSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ServerSideSession>(
      columnValues: columnValues(ServerSideSession.t.updateTable),
      where: where(ServerSideSession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ServerSideSession.t),
      orderByList: orderByList?.call(ServerSideSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ServerSideSession]s in the list and returns the deleted rows.
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
  Future<List<ServerSideSession>> delete(
    _is.DatabaseSession session,
    List<ServerSideSession> rows, {
    _is.OrderByBuilder<ServerSideSessionTable>? orderBy,
    _is.OrderByListBuilder<ServerSideSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ServerSideSession>(
      rows,
      orderBy: orderBy?.call(ServerSideSession.t),
      orderByList: orderByList?.call(ServerSideSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ServerSideSession].
  Future<ServerSideSession> deleteRow(
    _is.DatabaseSession session,
    ServerSideSession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ServerSideSession>(
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
  Future<List<ServerSideSession>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ServerSideSessionTable> where,
    _is.OrderByBuilder<ServerSideSessionTable>? orderBy,
    _is.OrderByListBuilder<ServerSideSessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ServerSideSession>(
      where: where(ServerSideSession.t),
      orderBy: orderBy?.call(ServerSideSession.t),
      orderByList: orderByList?.call(ServerSideSession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServerSideSessionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ServerSideSession>(
      where: where?.call(ServerSideSession.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ServerSideSession] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ServerSideSessionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ServerSideSession>(
      where: where(ServerSideSession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ServerSideSessionAttachRowRepository {
  const ServerSideSessionAttachRowRepository._();

  /// Creates a relation between the given [ServerSideSession] and [AuthUser]
  /// by setting the [ServerSideSession]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    ServerSideSession serverSideSession,
    _ivyervu7.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (serverSideSession.id == null) {
      throw ArgumentError.notNull('serverSideSession.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $serverSideSession = serverSideSession.copyWith(
      authUserId: authUser.id,
    );
    await session.db.updateRow<ServerSideSession>(
      $serverSideSession,
      columns: [ServerSideSession.t.authUserId],
      transaction: transaction,
    );
  }
}
