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
import '../../auth_user/models/auth_user.dart' as _i2;
import 'dart:typed_data' as _i3;
import 'package:serverpod_auth_core_server/src/generated/protocol.dart' as _i4;

/// Server-side authentication session.
abstract class ServerSideSession
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
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
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required Set<String> scopeNames,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    DateTime? expiresAt,
    Duration? expireAfterUnusedFor,
    required _i3.ByteData sessionKeyHash,
    required _i3.ByteData sessionKeySalt,
    required String method,
  }) = _ServerSideSessionImpl;

  factory ServerSideSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServerSideSession(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.AuthUser>(
              jsonSerialization['authUser'],
            ),
      scopeNames: _i4.Protocol().deserialize<Set<String>>(
        jsonSerialization['scopeNames'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      lastUsedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastUsedAt'],
      ),
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      expireAfterUnusedFor: jsonSerialization['expireAfterUnusedFor'] == null
          ? null
          : _i1.DurationJsonExtension.fromJson(
              jsonSerialization['expireAfterUnusedFor'],
            ),
      sessionKeyHash: _i1.ByteDataJsonExtension.fromJson(
        jsonSerialization['sessionKeyHash'],
      ),
      sessionKeySalt: _i1.ByteDataJsonExtension.fromJson(
        jsonSerialization['sessionKeySalt'],
      ),
      method: jsonSerialization['method'] as String,
    );
  }

  static final t = ServerSideSessionTable();

  static const db = ServerSideSessionRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this session belongs to
  _i2.AuthUser? authUser;

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
  _i3.ByteData sessionKeyHash;

  /// The salt used for computing the [sessionKeyHash].
  ///
  /// Per default uses 16 bytes of random data.
  _i3.ByteData sessionKeySalt;

  /// The method through which this session was created.
  ///
  /// This can be either an email or social login, a personal access token, service account etc.
  String method;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ServerSideSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ServerSideSession copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    Set<String>? scopeNames,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    DateTime? expiresAt,
    Duration? expireAfterUnusedFor,
    _i3.ByteData? sessionKeyHash,
    _i3.ByteData? sessionKeySalt,
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

  static ServerSideSessionInclude include({_i2.AuthUserInclude? authUser}) {
    return ServerSideSessionInclude._(authUser: authUser);
  }

  static ServerSideSessionIncludeList includeList({
    _i1.WhereExpressionBuilder<ServerSideSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ServerSideSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServerSideSessionTable>? orderByList,
    ServerSideSessionInclude? include,
  }) {
    return ServerSideSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ServerSideSession.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ServerSideSession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServerSideSessionImpl extends ServerSideSession {
  _ServerSideSessionImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required Set<String> scopeNames,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    DateTime? expiresAt,
    Duration? expireAfterUnusedFor,
    required _i3.ByteData sessionKeyHash,
    required _i3.ByteData sessionKeySalt,
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
  @_i1.useResult
  @override
  ServerSideSession copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Set<String>? scopeNames,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    Object? expiresAt = _Undefined,
    Object? expireAfterUnusedFor = _Undefined,
    _i3.ByteData? sessionKeyHash,
    _i3.ByteData? sessionKeySalt,
    String? method,
  }) {
    return ServerSideSession(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
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
    extends _i1.UpdateTable<ServerSideSessionTable> {
  ServerSideSessionUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authUserId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<Set<String>, Set<String>> scopeNames(Set<String> value) =>
      _i1.ColumnValue(
        table.scopeNames,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> lastUsedAt(DateTime value) =>
      _i1.ColumnValue(
        table.lastUsedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime? value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<Duration, Duration> expireAfterUnusedFor(Duration? value) =>
      _i1.ColumnValue(
        table.expireAfterUnusedFor,
        value,
      );

  _i1.ColumnValue<_i3.ByteData, _i3.ByteData> sessionKeyHash(
    _i3.ByteData value,
  ) => _i1.ColumnValue(
    table.sessionKeyHash,
    value,
  );

  _i1.ColumnValue<_i3.ByteData, _i3.ByteData> sessionKeySalt(
    _i3.ByteData value,
  ) => _i1.ColumnValue(
    table.sessionKeySalt,
    value,
  );

  _i1.ColumnValue<String, String> method(String value) => _i1.ColumnValue(
    table.method,
    value,
  );
}

class ServerSideSessionTable extends _i1.Table<_i1.UuidValue?> {
  ServerSideSessionTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_core_session') {
    updateTable = ServerSideSessionUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    scopeNames = _i1.ColumnSerializable<Set<String>>(
      'scopeNames',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    lastUsedAt = _i1.ColumnDateTime(
      'lastUsedAt',
      this,
      hasDefault: true,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    expireAfterUnusedFor = _i1.ColumnDuration(
      'expireAfterUnusedFor',
      this,
    );
    sessionKeyHash = _i1.ColumnByteData(
      'sessionKeyHash',
      this,
    );
    sessionKeySalt = _i1.ColumnByteData(
      'sessionKeySalt',
      this,
    );
    method = _i1.ColumnString(
      'method',
      this,
    );
  }

  late final ServerSideSessionUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this session belongs to
  _i2.AuthUserTable? _authUser;

  /// The scopes this session provides access to.
  late final _i1.ColumnSerializable<Set<String>> scopeNames;

  /// The time when this session was created.
  late final _i1.ColumnDateTime createdAt;

  /// The time when this access session was last used.
  ///
  /// Operates only with minute resolution, to avoid excessive writes to the database.
  late final _i1.ColumnDateTime lastUsedAt;

  /// The time after which this session can not be used anymore.
  ///
  /// If `null`, the session can be used indefinitely.
  late final _i1.ColumnDateTime expiresAt;

  /// The maximum duration this session can go unused.
  ///
  /// If set, and the session is used after [lastUsed] + [expireAfterUnusedFor], then it will be rejected.
  ///
  /// If `null`, the session is valid until [expiresAt].
  late final _i1.ColumnDuration expireAfterUnusedFor;

  /// Hashed version of the session key.
  ///
  /// The clients authentication header will be compared against this to check the validity of the session.
  late final _i1.ColumnByteData sessionKeyHash;

  /// The salt used for computing the [sessionKeyHash].
  ///
  /// Per default uses 16 bytes of random data.
  late final _i1.ColumnByteData sessionKeySalt;

  /// The method through which this session was created.
  ///
  /// This can be either an email or social login, a personal access token, service account etc.
  late final _i1.ColumnString method;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: ServerSideSession.t.authUserId,
      foreignField: _i2.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_i1.Column> get columns => [
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
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class ServerSideSessionInclude extends _i1.IncludeObject {
  ServerSideSessionInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => ServerSideSession.t;
}

class ServerSideSessionIncludeList extends _i1.IncludeList {
  ServerSideSessionIncludeList._({
    _i1.WhereExpressionBuilder<ServerSideSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ServerSideSession.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ServerSideSession.t;
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServerSideSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ServerSideSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServerSideSessionTable>? orderByList,
    _i1.Transaction? transaction,
    ServerSideSessionInclude? include,
  }) async {
    return session.db.find<ServerSideSession>(
      where: where?.call(ServerSideSession.t),
      orderBy: orderBy?.call(ServerSideSession.t),
      orderByList: orderByList?.call(ServerSideSession.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServerSideSessionTable>? where,
    int? offset,
    _i1.OrderByBuilder<ServerSideSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServerSideSessionTable>? orderByList,
    _i1.Transaction? transaction,
    ServerSideSessionInclude? include,
  }) async {
    return session.db.findFirstRow<ServerSideSession>(
      where: where?.call(ServerSideSession.t),
      orderBy: orderBy?.call(ServerSideSession.t),
      orderByList: orderByList?.call(ServerSideSession.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ServerSideSession] by its [id] or null if no such row exists.
  Future<ServerSideSession?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    ServerSideSessionInclude? include,
  }) async {
    return session.db.findById<ServerSideSession>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ServerSideSession]s in the list and returns the inserted rows.
  ///
  /// The returned [ServerSideSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ServerSideSession>> insert(
    _i1.Session session,
    List<ServerSideSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ServerSideSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ServerSideSession] and returns the inserted row.
  ///
  /// The returned [ServerSideSession] will have its `id` field set.
  Future<ServerSideSession> insertRow(
    _i1.Session session,
    ServerSideSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ServerSideSession>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ServerSideSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ServerSideSession>> update(
    _i1.Session session,
    List<ServerSideSession> rows, {
    _i1.ColumnSelections<ServerSideSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ServerSideSession>(
      rows,
      columns: columns?.call(ServerSideSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ServerSideSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ServerSideSession> updateRow(
    _i1.Session session,
    ServerSideSession row, {
    _i1.ColumnSelections<ServerSideSessionTable>? columns,
    _i1.Transaction? transaction,
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
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ServerSideSessionUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ServerSideSession>(
      id,
      columnValues: columnValues(ServerSideSession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ServerSideSession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ServerSideSession>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ServerSideSessionUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ServerSideSessionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ServerSideSessionTable>? orderBy,
    _i1.OrderByListBuilder<ServerSideSessionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ServerSideSession>(
      columnValues: columnValues(ServerSideSession.t.updateTable),
      where: where(ServerSideSession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ServerSideSession.t),
      orderByList: orderByList?.call(ServerSideSession.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ServerSideSession]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ServerSideSession>> delete(
    _i1.Session session,
    List<ServerSideSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ServerSideSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ServerSideSession].
  Future<ServerSideSession> deleteRow(
    _i1.Session session,
    ServerSideSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ServerSideSession>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ServerSideSession>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ServerSideSessionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ServerSideSession>(
      where: where(ServerSideSession.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServerSideSessionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ServerSideSession>(
      where: where?.call(ServerSideSession.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ServerSideSessionAttachRowRepository {
  const ServerSideSessionAttachRowRepository._();

  /// Creates a relation between the given [ServerSideSession] and [AuthUser]
  /// by setting the [ServerSideSession]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    ServerSideSession serverSideSession,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
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
