/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart'
    as _i2;

abstract class AuthSession
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  AuthSession._({
    this.id,
    required this.authUserId,
    this.authUser,
    DateTime? created,
    required this.scopeNames,
    required this.sessionKeyHash,
    required this.method,
  }) : created = created ?? DateTime.now();

  factory AuthSession({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? created,
    required Set<String> scopeNames,
    required String sessionKeyHash,
    required String method,
  }) = _AuthSessionImpl;

  factory AuthSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthSession(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i2.AuthUser.fromJson(
              (jsonSerialization['authUser'] as Map<String, dynamic>)),
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      scopeNames: _i1.SetJsonExtension.fromJson(
          (jsonSerialization['scopeNames'] as List),
          itemFromJson: (e) => e as String)!,
      sessionKeyHash: jsonSerialization['sessionKeyHash'] as String,
      method: jsonSerialization['method'] as String,
    );
  }

  static final t = AuthSessionTable();

  static const db = AuthSessionRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this session belongs to
  _i2.AuthUser? authUser;

  /// The time when this sesion was created.
  DateTime created;

  /// The scopes this session provides access to.
  Set<String> scopeNames;

  /// Hashed version of the session key.
  ///
  /// The clients authentication header will be compared against this to check the validity of the session.
  String sessionKeyHash;

  /// The method of signing in this key was generated through.
  ///
  /// This can be either email, a social login, etc.
  String method;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AuthSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthSession copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    DateTime? created,
    Set<String>? scopeNames,
    String? sessionKeyHash,
    String? method,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'created': created.toJson(),
      'scopeNames': scopeNames.toJson(),
      'sessionKeyHash': sessionKeyHash,
      'method': method,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id?.toJson()};
  }

  static AuthSessionInclude include({_i2.AuthUserInclude? authUser}) {
    return AuthSessionInclude._(authUser: authUser);
  }

  static AuthSessionIncludeList includeList({
    _i1.WhereExpressionBuilder<AuthSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthSessionTable>? orderByList,
    AuthSessionInclude? include,
  }) {
    return AuthSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthSession.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AuthSession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthSessionImpl extends AuthSession {
  _AuthSessionImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? created,
    required Set<String> scopeNames,
    required String sessionKeyHash,
    required String method,
  }) : super._(
          id: id,
          authUserId: authUserId,
          authUser: authUser,
          created: created,
          scopeNames: scopeNames,
          sessionKeyHash: sessionKeyHash,
          method: method,
        );

  /// Returns a shallow copy of this [AuthSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthSession copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? created,
    Set<String>? scopeNames,
    String? sessionKeyHash,
    String? method,
  }) {
    return AuthSession(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser:
          authUser is _i2.AuthUser? ? authUser : this.authUser?.copyWith(),
      created: created ?? this.created,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
      sessionKeyHash: sessionKeyHash ?? this.sessionKeyHash,
      method: method ?? this.method,
    );
  }
}

class AuthSessionTable extends _i1.Table<_i1.UuidValue?> {
  AuthSessionTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_session') {
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    created = _i1.ColumnDateTime(
      'created',
      this,
      hasDefault: true,
    );
    scopeNames = _i1.ColumnSerializable(
      'scopeNames',
      this,
    );
    sessionKeyHash = _i1.ColumnString(
      'sessionKeyHash',
      this,
    );
    method = _i1.ColumnString(
      'method',
      this,
    );
  }

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this session belongs to
  _i2.AuthUserTable? _authUser;

  /// The time when this sesion was created.
  late final _i1.ColumnDateTime created;

  /// The scopes this session provides access to.
  late final _i1.ColumnSerializable scopeNames;

  /// Hashed version of the session key.
  ///
  /// The clients authentication header will be compared against this to check the validity of the session.
  late final _i1.ColumnString sessionKeyHash;

  /// The method of signing in this key was generated through.
  ///
  /// This can be either email, a social login, etc.
  late final _i1.ColumnString method;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: AuthSession.t.authUserId,
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
        created,
        scopeNames,
        sessionKeyHash,
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

class AuthSessionInclude extends _i1.IncludeObject {
  AuthSessionInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => AuthSession.t;
}

class AuthSessionIncludeList extends _i1.IncludeList {
  AuthSessionIncludeList._({
    _i1.WhereExpressionBuilder<AuthSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuthSession.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AuthSession.t;
}

class AuthSessionRepository {
  const AuthSessionRepository._();

  final attachRow = const AuthSessionAttachRowRepository._();

  /// Returns a list of [AuthSession]s matching the given query parameters.
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
  Future<List<AuthSession>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthSessionTable>? orderByList,
    _i1.Transaction? transaction,
    AuthSessionInclude? include,
  }) async {
    return session.db.find<AuthSession>(
      where: where?.call(AuthSession.t),
      orderBy: orderBy?.call(AuthSession.t),
      orderByList: orderByList?.call(AuthSession.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [AuthSession] matching the given query parameters.
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
  Future<AuthSession?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthSessionTable>? where,
    int? offset,
    _i1.OrderByBuilder<AuthSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthSessionTable>? orderByList,
    _i1.Transaction? transaction,
    AuthSessionInclude? include,
  }) async {
    return session.db.findFirstRow<AuthSession>(
      where: where?.call(AuthSession.t),
      orderBy: orderBy?.call(AuthSession.t),
      orderByList: orderByList?.call(AuthSession.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [AuthSession] by its [id] or null if no such row exists.
  Future<AuthSession?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    AuthSessionInclude? include,
  }) async {
    return session.db.findById<AuthSession>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [AuthSession]s in the list and returns the inserted rows.
  ///
  /// The returned [AuthSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AuthSession>> insert(
    _i1.Session session,
    List<AuthSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AuthSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AuthSession] and returns the inserted row.
  ///
  /// The returned [AuthSession] will have its `id` field set.
  Future<AuthSession> insertRow(
    _i1.Session session,
    AuthSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuthSession>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AuthSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AuthSession>> update(
    _i1.Session session,
    List<AuthSession> rows, {
    _i1.ColumnSelections<AuthSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AuthSession>(
      rows,
      columns: columns?.call(AuthSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuthSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuthSession> updateRow(
    _i1.Session session,
    AuthSession row, {
    _i1.ColumnSelections<AuthSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuthSession>(
      row,
      columns: columns?.call(AuthSession.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AuthSession]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AuthSession>> delete(
    _i1.Session session,
    List<AuthSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AuthSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AuthSession].
  Future<AuthSession> deleteRow(
    _i1.Session session,
    AuthSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuthSession>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AuthSession>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AuthSessionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AuthSession>(
      where: where(AuthSession.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthSessionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AuthSession>(
      where: where?.call(AuthSession.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AuthSessionAttachRowRepository {
  const AuthSessionAttachRowRepository._();

  /// Creates a relation between the given [AuthSession] and [AuthUser]
  /// by setting the [AuthSession]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    AuthSession authSession,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (authSession.id == null) {
      throw ArgumentError.notNull('authSession.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $authSession = authSession.copyWith(authUserId: authUser.id);
    await session.db.updateRow<AuthSession>(
      $authSession,
      columns: [AuthSession.t.authUserId],
      transaction: transaction,
    );
  }
}
