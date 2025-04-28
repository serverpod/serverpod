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

abstract class UserSession
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  UserSession._({
    this.id,
    required this.authUserId,
    this.authUser,
    DateTime? created,
    required this.scopeNames,
    required this.sessionKeyHash,
    required this.method,
  }) : created = created ?? DateTime.now();

  factory UserSession({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? created,
    required Set<String> scopeNames,
    required String sessionKeyHash,
    required String method,
  }) = _UserSessionImpl;

  factory UserSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserSession(
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

  static final t = UserSessionTable();

  static const db = UserSessionRepository._();

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

  /// Returns a shallow copy of this [UserSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserSession copyWith({
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

  static UserSessionInclude include({_i2.AuthUserInclude? authUser}) {
    return UserSessionInclude._(authUser: authUser);
  }

  static UserSessionIncludeList includeList({
    _i1.WhereExpressionBuilder<UserSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserSessionTable>? orderByList,
    UserSessionInclude? include,
  }) {
    return UserSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserSession.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserSession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserSessionImpl extends UserSession {
  _UserSessionImpl({
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

  /// Returns a shallow copy of this [UserSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserSession copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? created,
    Set<String>? scopeNames,
    String? sessionKeyHash,
    String? method,
  }) {
    return UserSession(
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

class UserSessionTable extends _i1.Table<_i1.UuidValue?> {
  UserSessionTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_session_user_session') {
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
      field: UserSession.t.authUserId,
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

class UserSessionInclude extends _i1.IncludeObject {
  UserSessionInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => UserSession.t;
}

class UserSessionIncludeList extends _i1.IncludeList {
  UserSessionIncludeList._({
    _i1.WhereExpressionBuilder<UserSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserSession.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => UserSession.t;
}

class UserSessionRepository {
  const UserSessionRepository._();

  final attachRow = const UserSessionAttachRowRepository._();

  /// Returns a list of [UserSession]s matching the given query parameters.
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
  Future<List<UserSession>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserSessionTable>? orderByList,
    _i1.Transaction? transaction,
    UserSessionInclude? include,
  }) async {
    return session.db.find<UserSession>(
      where: where?.call(UserSession.t),
      orderBy: orderBy?.call(UserSession.t),
      orderByList: orderByList?.call(UserSession.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [UserSession] matching the given query parameters.
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
  Future<UserSession?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserSessionTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserSessionTable>? orderByList,
    _i1.Transaction? transaction,
    UserSessionInclude? include,
  }) async {
    return session.db.findFirstRow<UserSession>(
      where: where?.call(UserSession.t),
      orderBy: orderBy?.call(UserSession.t),
      orderByList: orderByList?.call(UserSession.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [UserSession] by its [id] or null if no such row exists.
  Future<UserSession?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    UserSessionInclude? include,
  }) async {
    return session.db.findById<UserSession>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [UserSession]s in the list and returns the inserted rows.
  ///
  /// The returned [UserSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserSession>> insert(
    _i1.Session session,
    List<UserSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserSession] and returns the inserted row.
  ///
  /// The returned [UserSession] will have its `id` field set.
  Future<UserSession> insertRow(
    _i1.Session session,
    UserSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserSession>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserSession>> update(
    _i1.Session session,
    List<UserSession> rows, {
    _i1.ColumnSelections<UserSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserSession>(
      rows,
      columns: columns?.call(UserSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserSession> updateRow(
    _i1.Session session,
    UserSession row, {
    _i1.ColumnSelections<UserSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserSession>(
      row,
      columns: columns?.call(UserSession.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UserSession]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserSession>> delete(
    _i1.Session session,
    List<UserSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserSession].
  Future<UserSession> deleteRow(
    _i1.Session session,
    UserSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserSession>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserSession>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserSessionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserSession>(
      where: where(UserSession.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserSessionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserSession>(
      where: where?.call(UserSession.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class UserSessionAttachRowRepository {
  const UserSessionAttachRowRepository._();

  /// Creates a relation between the given [UserSession] and [AuthUser]
  /// by setting the [UserSession]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    UserSession userSession,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (userSession.id == null) {
      throw ArgumentError.notNull('userSession.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $userSession = userSession.copyWith(authUserId: authUser.id);
    await session.db.updateRow<UserSession>(
      $userSession,
      columns: [UserSession.t.authUserId],
      transaction: transaction,
    );
  }
}
