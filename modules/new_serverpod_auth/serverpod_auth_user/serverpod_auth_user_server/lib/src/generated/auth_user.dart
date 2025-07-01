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

abstract class AuthUser
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  AuthUser._({
    this.id,
    DateTime? created,
    required this.scopeNames,
    bool? blocked,
  })  : created = created ?? DateTime.now(),
        blocked = blocked ?? false;

  factory AuthUser({
    _i1.UuidValue? id,
    DateTime? created,
    required Set<String> scopeNames,
    bool? blocked,
  }) = _AuthUserImpl;

  factory AuthUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthUser(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      scopeNames: _i1.SetJsonExtension.fromJson(
          (jsonSerialization['scopeNames'] as List),
          itemFromJson: (e) => e as String)!,
      blocked: jsonSerialization['blocked'] as bool,
    );
  }

  static final t = AuthUserTable();

  static const db = AuthUserRepository._();

  @override
  _i1.UuidValue? id;

  /// The time when this user was created.
  DateTime created;

  /// Set of scopes that this user can access.
  Set<String> scopeNames;

  /// If `true` the user will be blocked from signing in.
  bool blocked;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AuthUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthUser copyWith({
    _i1.UuidValue? id,
    DateTime? created,
    Set<String>? scopeNames,
    bool? blocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'created': created.toJson(),
      'scopeNames': scopeNames.toJson(),
      'blocked': blocked,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id?.toJson()};
  }

  static AuthUserInclude include() {
    return AuthUserInclude._();
  }

  static AuthUserIncludeList includeList({
    _i1.WhereExpressionBuilder<AuthUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthUserTable>? orderByList,
    AuthUserInclude? include,
  }) {
    return AuthUserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthUser.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AuthUser.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthUserImpl extends AuthUser {
  _AuthUserImpl({
    _i1.UuidValue? id,
    DateTime? created,
    required Set<String> scopeNames,
    bool? blocked,
  }) : super._(
          id: id,
          created: created,
          scopeNames: scopeNames,
          blocked: blocked,
        );

  /// Returns a shallow copy of this [AuthUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthUser copyWith({
    Object? id = _Undefined,
    DateTime? created,
    Set<String>? scopeNames,
    bool? blocked,
  }) {
    return AuthUser(
      id: id is _i1.UuidValue? ? id : this.id,
      created: created ?? this.created,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toSet(),
      blocked: blocked ?? this.blocked,
    );
  }
}

class AuthUserTable extends _i1.Table<_i1.UuidValue?> {
  AuthUserTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_user') {
    created = _i1.ColumnDateTime(
      'created',
      this,
    );
    scopeNames = _i1.ColumnSerializable(
      'scopeNames',
      this,
    );
    blocked = _i1.ColumnBool(
      'blocked',
      this,
    );
  }

  /// The time when this user was created.
  late final _i1.ColumnDateTime created;

  /// Set of scopes that this user can access.
  late final _i1.ColumnSerializable scopeNames;

  /// If `true` the user will be blocked from signing in.
  late final _i1.ColumnBool blocked;

  @override
  List<_i1.Column> get columns => [
        id,
        created,
        scopeNames,
        blocked,
      ];
}

class AuthUserInclude extends _i1.IncludeObject {
  AuthUserInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AuthUser.t;
}

class AuthUserIncludeList extends _i1.IncludeList {
  AuthUserIncludeList._({
    _i1.WhereExpressionBuilder<AuthUserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuthUser.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AuthUser.t;
}

class AuthUserRepository {
  const AuthUserRepository._();

  /// Returns a list of [AuthUser]s matching the given query parameters.
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
  Future<List<AuthUser>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthUserTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AuthUser>(
      where: where?.call(AuthUser.t),
      orderBy: orderBy?.call(AuthUser.t),
      orderByList: orderByList?.call(AuthUser.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AuthUser] matching the given query parameters.
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
  Future<AuthUser?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthUserTable>? where,
    int? offset,
    _i1.OrderByBuilder<AuthUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthUserTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AuthUser>(
      where: where?.call(AuthUser.t),
      orderBy: orderBy?.call(AuthUser.t),
      orderByList: orderByList?.call(AuthUser.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AuthUser] by its [id] or null if no such row exists.
  Future<AuthUser?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AuthUser>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AuthUser]s in the list and returns the inserted rows.
  ///
  /// The returned [AuthUser]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AuthUser>> insert(
    _i1.Session session,
    List<AuthUser> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AuthUser>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AuthUser] and returns the inserted row.
  ///
  /// The returned [AuthUser] will have its `id` field set.
  Future<AuthUser> insertRow(
    _i1.Session session,
    AuthUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuthUser>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AuthUser]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AuthUser>> update(
    _i1.Session session,
    List<AuthUser> rows, {
    _i1.ColumnSelections<AuthUserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AuthUser>(
      rows,
      columns: columns?.call(AuthUser.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuthUser]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuthUser> updateRow(
    _i1.Session session,
    AuthUser row, {
    _i1.ColumnSelections<AuthUserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuthUser>(
      row,
      columns: columns?.call(AuthUser.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AuthUser]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AuthUser>> delete(
    _i1.Session session,
    List<AuthUser> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AuthUser>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AuthUser].
  Future<AuthUser> deleteRow(
    _i1.Session session,
    AuthUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuthUser>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AuthUser>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AuthUserTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AuthUser>(
      where: where(AuthUser.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthUserTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AuthUser>(
      where: where?.call(AuthUser.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
