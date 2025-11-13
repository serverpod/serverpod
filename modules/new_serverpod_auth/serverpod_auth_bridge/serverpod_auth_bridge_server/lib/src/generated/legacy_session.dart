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

abstract class LegacySession
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  LegacySession._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.scopeNames,
    required this.hash,
    required this.method,
  });

  factory LegacySession({
    int? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required Set<String> scopeNames,
    required String hash,
    required String method,
  }) = _LegacySessionImpl;

  factory LegacySession.fromJson(Map<String, dynamic> jsonSerialization) {
    return LegacySession(
      id: jsonSerialization['id'] as int?,
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i2.AuthUser.fromJson(
              (jsonSerialization['authUser'] as Map<String, dynamic>),
            ),
      scopeNames: _i1.SetJsonExtension.fromJson(
        (jsonSerialization['scopeNames'] as List),
        itemFromJson: (e) => e as String,
      )!,
      hash: jsonSerialization['hash'] as String,
      method: jsonSerialization['method'] as String,
    );
  }

  static final t = LegacySessionTable();

  static const db = LegacySessionRepository._();

  @override
  int? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this session belongs to
  _i2.AuthUser? authUser;

  /// The scopes this session provides access to.
  Set<String> scopeNames;

  /// The hashed version of the key (as the legacy `AuthKey`)
  String hash;

  /// The method through which this session was created.
  ///
  /// This can be either an email or social login, a personal access token, service account etc.
  String method;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [LegacySession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LegacySession copyWith({
    int? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    Set<String>? scopeNames,
    String? hash,
    String? method,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'scopeNames': scopeNames.toJson(),
      'hash': hash,
      'method': method,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static LegacySessionInclude include({_i2.AuthUserInclude? authUser}) {
    return LegacySessionInclude._(authUser: authUser);
  }

  static LegacySessionIncludeList includeList({
    _i1.WhereExpressionBuilder<LegacySessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegacySessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegacySessionTable>? orderByList,
    LegacySessionInclude? include,
  }) {
    return LegacySessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegacySession.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LegacySession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LegacySessionImpl extends LegacySession {
  _LegacySessionImpl({
    int? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required Set<String> scopeNames,
    required String hash,
    required String method,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         scopeNames: scopeNames,
         hash: hash,
         method: method,
       );

  /// Returns a shallow copy of this [LegacySession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LegacySession copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Set<String>? scopeNames,
    String? hash,
    String? method,
  }) {
    return LegacySession(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
      hash: hash ?? this.hash,
      method: method ?? this.method,
    );
  }
}

class LegacySessionUpdateTable extends _i1.UpdateTable<LegacySessionTable> {
  LegacySessionUpdateTable(super.table);

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

  _i1.ColumnValue<String, String> hash(String value) => _i1.ColumnValue(
    table.hash,
    value,
  );

  _i1.ColumnValue<String, String> method(String value) => _i1.ColumnValue(
    table.method,
    value,
  );
}

class LegacySessionTable extends _i1.Table<int?> {
  LegacySessionTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_bridge_session') {
    updateTable = LegacySessionUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    scopeNames = _i1.ColumnSerializable<Set<String>>(
      'scopeNames',
      this,
    );
    hash = _i1.ColumnString(
      'hash',
      this,
    );
    method = _i1.ColumnString(
      'method',
      this,
    );
  }

  late final LegacySessionUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this session belongs to
  _i2.AuthUserTable? _authUser;

  /// The scopes this session provides access to.
  late final _i1.ColumnSerializable<Set<String>> scopeNames;

  /// The hashed version of the key (as the legacy `AuthKey`)
  late final _i1.ColumnString hash;

  /// The method through which this session was created.
  ///
  /// This can be either an email or social login, a personal access token, service account etc.
  late final _i1.ColumnString method;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: LegacySession.t.authUserId,
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
    hash,
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

class LegacySessionInclude extends _i1.IncludeObject {
  LegacySessionInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<int?> get table => LegacySession.t;
}

class LegacySessionIncludeList extends _i1.IncludeList {
  LegacySessionIncludeList._({
    _i1.WhereExpressionBuilder<LegacySessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LegacySession.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => LegacySession.t;
}

class LegacySessionRepository {
  const LegacySessionRepository._();

  final attachRow = const LegacySessionAttachRowRepository._();

  /// Returns a list of [LegacySession]s matching the given query parameters.
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
  Future<List<LegacySession>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegacySessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegacySessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegacySessionTable>? orderByList,
    _i1.Transaction? transaction,
    LegacySessionInclude? include,
  }) async {
    return session.db.find<LegacySession>(
      where: where?.call(LegacySession.t),
      orderBy: orderBy?.call(LegacySession.t),
      orderByList: orderByList?.call(LegacySession.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [LegacySession] matching the given query parameters.
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
  Future<LegacySession?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegacySessionTable>? where,
    int? offset,
    _i1.OrderByBuilder<LegacySessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LegacySessionTable>? orderByList,
    _i1.Transaction? transaction,
    LegacySessionInclude? include,
  }) async {
    return session.db.findFirstRow<LegacySession>(
      where: where?.call(LegacySession.t),
      orderBy: orderBy?.call(LegacySession.t),
      orderByList: orderByList?.call(LegacySession.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [LegacySession] by its [id] or null if no such row exists.
  Future<LegacySession?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    LegacySessionInclude? include,
  }) async {
    return session.db.findById<LegacySession>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [LegacySession]s in the list and returns the inserted rows.
  ///
  /// The returned [LegacySession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<LegacySession>> insert(
    _i1.Session session,
    List<LegacySession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<LegacySession>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [LegacySession] and returns the inserted row.
  ///
  /// The returned [LegacySession] will have its `id` field set.
  Future<LegacySession> insertRow(
    _i1.Session session,
    LegacySession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LegacySession>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LegacySession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LegacySession>> update(
    _i1.Session session,
    List<LegacySession> rows, {
    _i1.ColumnSelections<LegacySessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LegacySession>(
      rows,
      columns: columns?.call(LegacySession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LegacySession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LegacySession> updateRow(
    _i1.Session session,
    LegacySession row, {
    _i1.ColumnSelections<LegacySessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LegacySession>(
      row,
      columns: columns?.call(LegacySession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LegacySession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LegacySession?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<LegacySessionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<LegacySession>(
      id,
      columnValues: columnValues(LegacySession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LegacySession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<LegacySession>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<LegacySessionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<LegacySessionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LegacySessionTable>? orderBy,
    _i1.OrderByListBuilder<LegacySessionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<LegacySession>(
      columnValues: columnValues(LegacySession.t.updateTable),
      where: where(LegacySession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LegacySession.t),
      orderByList: orderByList?.call(LegacySession.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [LegacySession]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LegacySession>> delete(
    _i1.Session session,
    List<LegacySession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LegacySession>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LegacySession].
  Future<LegacySession> deleteRow(
    _i1.Session session,
    LegacySession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LegacySession>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LegacySession>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LegacySessionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LegacySession>(
      where: where(LegacySession.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LegacySessionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LegacySession>(
      where: where?.call(LegacySession.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class LegacySessionAttachRowRepository {
  const LegacySessionAttachRowRepository._();

  /// Creates a relation between the given [LegacySession] and [AuthUser]
  /// by setting the [LegacySession]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    LegacySession legacySession,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (legacySession.id == null) {
      throw ArgumentError.notNull('legacySession.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $legacySession = legacySession.copyWith(authUserId: authUser.id);
    await session.db.updateRow<LegacySession>(
      $legacySession,
      columns: [LegacySession.t.authUserId],
      transaction: transaction,
    );
  }
}
