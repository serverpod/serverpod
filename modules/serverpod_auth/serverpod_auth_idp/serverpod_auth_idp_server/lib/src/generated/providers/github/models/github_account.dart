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
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart' as _i3;

/// A fully configured GitHub account to be used for logins.
abstract class GitHubAccount
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  GitHubAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.userIdentifier,
    this.email,
    DateTime? created,
  }) : created = created ?? DateTime.now();

  factory GitHubAccount({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String userIdentifier,
    String? email,
    DateTime? created,
  }) = _GitHubAccountImpl;

  factory GitHubAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return GitHubAccount(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.AuthUser>(
              jsonSerialization['authUser'],
            ),
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      email: jsonSerialization['email'] as String?,
      created: jsonSerialization['created'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
    );
  }

  static final t = GitHubAccountTable();

  static const db = GitHubAccountRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUser? authUser;

  /// The user identifier given by GitHub for this account.
  String userIdentifier;

  /// The verified email of the user, as received from GitHub.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups.
  ///
  /// Stored in lower-case.
  ///
  /// This may be null if the user's email is not public or verified.
  String? email;

  /// The time when this authentication was created.
  DateTime created;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [GitHubAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GitHubAccount copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    String? userIdentifier,
    String? email,
    DateTime? created,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.GitHubAccount',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'userIdentifier': userIdentifier,
      if (email != null) 'email': email,
      'created': created.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static GitHubAccountInclude include({_i2.AuthUserInclude? authUser}) {
    return GitHubAccountInclude._(authUser: authUser);
  }

  static GitHubAccountIncludeList includeList({
    _i1.WhereExpressionBuilder<GitHubAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GitHubAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GitHubAccountTable>? orderByList,
    GitHubAccountInclude? include,
  }) {
    return GitHubAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GitHubAccount.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(GitHubAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GitHubAccountImpl extends GitHubAccount {
  _GitHubAccountImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String userIdentifier,
    String? email,
    DateTime? created,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         userIdentifier: userIdentifier,
         email: email,
         created: created,
       );

  /// Returns a shallow copy of this [GitHubAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GitHubAccount copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? userIdentifier,
    Object? email = _Undefined,
    DateTime? created,
  }) {
    return GitHubAccount(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      userIdentifier: userIdentifier ?? this.userIdentifier,
      email: email is String? ? email : this.email,
      created: created ?? this.created,
    );
  }
}

class GitHubAccountUpdateTable extends _i1.UpdateTable<GitHubAccountTable> {
  GitHubAccountUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authUserId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<String, String> userIdentifier(String value) =>
      _i1.ColumnValue(
        table.userIdentifier,
        value,
      );

  _i1.ColumnValue<String, String> email(String? value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> created(DateTime value) =>
      _i1.ColumnValue(
        table.created,
        value,
      );
}

class GitHubAccountTable extends _i1.Table<_i1.UuidValue?> {
  GitHubAccountTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_github_account') {
    updateTable = GitHubAccountUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    userIdentifier = _i1.ColumnString(
      'userIdentifier',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    created = _i1.ColumnDateTime(
      'created',
      this,
    );
  }

  late final GitHubAccountUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUserTable? _authUser;

  /// The user identifier given by GitHub for this account.
  late final _i1.ColumnString userIdentifier;

  /// The verified email of the user, as received from GitHub.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups.
  ///
  /// Stored in lower-case.
  ///
  /// This may be null if the user's email is not public or verified.
  late final _i1.ColumnString email;

  /// The time when this authentication was created.
  late final _i1.ColumnDateTime created;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: GitHubAccount.t.authUserId,
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
    userIdentifier,
    email,
    created,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class GitHubAccountInclude extends _i1.IncludeObject {
  GitHubAccountInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => GitHubAccount.t;
}

class GitHubAccountIncludeList extends _i1.IncludeList {
  GitHubAccountIncludeList._({
    _i1.WhereExpressionBuilder<GitHubAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(GitHubAccount.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => GitHubAccount.t;
}

class GitHubAccountRepository {
  const GitHubAccountRepository._();

  final attachRow = const GitHubAccountAttachRowRepository._();

  /// Returns a list of [GitHubAccount]s matching the given query parameters.
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
  Future<List<GitHubAccount>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GitHubAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GitHubAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GitHubAccountTable>? orderByList,
    _i1.Transaction? transaction,
    GitHubAccountInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<GitHubAccount>(
      where: where?.call(GitHubAccount.t),
      orderBy: orderBy?.call(GitHubAccount.t),
      orderByList: orderByList?.call(GitHubAccount.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [GitHubAccount] matching the given query parameters.
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
  Future<GitHubAccount?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GitHubAccountTable>? where,
    int? offset,
    _i1.OrderByBuilder<GitHubAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GitHubAccountTable>? orderByList,
    _i1.Transaction? transaction,
    GitHubAccountInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<GitHubAccount>(
      where: where?.call(GitHubAccount.t),
      orderBy: orderBy?.call(GitHubAccount.t),
      orderByList: orderByList?.call(GitHubAccount.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [GitHubAccount] by its [id] or null if no such row exists.
  Future<GitHubAccount?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    GitHubAccountInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<GitHubAccount>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [GitHubAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [GitHubAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<GitHubAccount>> insert(
    _i1.Session session,
    List<GitHubAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<GitHubAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [GitHubAccount] and returns the inserted row.
  ///
  /// The returned [GitHubAccount] will have its `id` field set.
  Future<GitHubAccount> insertRow(
    _i1.Session session,
    GitHubAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<GitHubAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [GitHubAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<GitHubAccount>> update(
    _i1.Session session,
    List<GitHubAccount> rows, {
    _i1.ColumnSelections<GitHubAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<GitHubAccount>(
      rows,
      columns: columns?.call(GitHubAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GitHubAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<GitHubAccount> updateRow(
    _i1.Session session,
    GitHubAccount row, {
    _i1.ColumnSelections<GitHubAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<GitHubAccount>(
      row,
      columns: columns?.call(GitHubAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GitHubAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<GitHubAccount?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<GitHubAccountUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<GitHubAccount>(
      id,
      columnValues: columnValues(GitHubAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [GitHubAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<GitHubAccount>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<GitHubAccountUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<GitHubAccountTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GitHubAccountTable>? orderBy,
    _i1.OrderByListBuilder<GitHubAccountTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<GitHubAccount>(
      columnValues: columnValues(GitHubAccount.t.updateTable),
      where: where(GitHubAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GitHubAccount.t),
      orderByList: orderByList?.call(GitHubAccount.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [GitHubAccount]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<GitHubAccount>> delete(
    _i1.Session session,
    List<GitHubAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<GitHubAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [GitHubAccount].
  Future<GitHubAccount> deleteRow(
    _i1.Session session,
    GitHubAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<GitHubAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<GitHubAccount>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<GitHubAccountTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<GitHubAccount>(
      where: where(GitHubAccount.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GitHubAccountTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<GitHubAccount>(
      where: where?.call(GitHubAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [GitHubAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<GitHubAccountTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<GitHubAccount>(
      where: where(GitHubAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class GitHubAccountAttachRowRepository {
  const GitHubAccountAttachRowRepository._();

  /// Creates a relation between the given [GitHubAccount] and [AuthUser]
  /// by setting the [GitHubAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    GitHubAccount gitHubAccount,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (gitHubAccount.id == null) {
      throw ArgumentError.notNull('gitHubAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $gitHubAccount = gitHubAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<GitHubAccount>(
      $gitHubAccount,
      columns: [GitHubAccount.t.authUserId],
      transaction: transaction,
    );
  }
}
