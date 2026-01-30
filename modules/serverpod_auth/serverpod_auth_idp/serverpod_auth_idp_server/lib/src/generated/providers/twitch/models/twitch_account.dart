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

abstract class TwitchAccount
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  TwitchAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.userIdentifier,
    required this.login,
    required this.displayName,
    this.email,
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
    DateTime? created,
  }) : created = created ?? DateTime.now();

  factory TwitchAccount({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String userIdentifier,
    required String login,
    required String displayName,
    String? email,
    required String accessToken,
    required int expiresIn,
    required String refreshToken,
    DateTime? created,
  }) = _TwitchAccountImpl;

  factory TwitchAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return TwitchAccount(
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
      login: jsonSerialization['login'] as String,
      displayName: jsonSerialization['displayName'] as String,
      email: jsonSerialization['email'] as String?,
      accessToken: jsonSerialization['accessToken'] as String,
      expiresIn: jsonSerialization['expiresIn'] as int,
      refreshToken: jsonSerialization['refreshToken'] as String,
      created: jsonSerialization['created'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
    );
  }

  static final t = TwitchAccountTable();

  static const db = TwitchAccountRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUser? authUser;

  /// The unique identifier for the user from Twitch
  String userIdentifier;

  String login;

  String displayName;

  /// The email of the user on Twitch
  String? email;

  /// Original access token exchanged by code
  String accessToken;

  /// Token expiry in timestamp format
  int expiresIn;

  /// Saved refresh token after first authentication with code exchange
  String refreshToken;

  /// The date and time when this authentication was created.
  DateTime created;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [TwitchAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TwitchAccount copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    String? userIdentifier,
    String? login,
    String? displayName,
    String? email,
    String? accessToken,
    int? expiresIn,
    String? refreshToken,
    DateTime? created,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.TwitchAccount',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'userIdentifier': userIdentifier,
      'login': login,
      'displayName': displayName,
      if (email != null) 'email': email,
      'accessToken': accessToken,
      'expiresIn': expiresIn,
      'refreshToken': refreshToken,
      'created': created.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static TwitchAccountInclude include({_i2.AuthUserInclude? authUser}) {
    return TwitchAccountInclude._(authUser: authUser);
  }

  static TwitchAccountIncludeList includeList({
    _i1.WhereExpressionBuilder<TwitchAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TwitchAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TwitchAccountTable>? orderByList,
    TwitchAccountInclude? include,
  }) {
    return TwitchAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TwitchAccount.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TwitchAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TwitchAccountImpl extends TwitchAccount {
  _TwitchAccountImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String userIdentifier,
    required String login,
    required String displayName,
    String? email,
    required String accessToken,
    required int expiresIn,
    required String refreshToken,
    DateTime? created,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         userIdentifier: userIdentifier,
         login: login,
         displayName: displayName,
         email: email,
         accessToken: accessToken,
         expiresIn: expiresIn,
         refreshToken: refreshToken,
         created: created,
       );

  /// Returns a shallow copy of this [TwitchAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TwitchAccount copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? userIdentifier,
    String? login,
    String? displayName,
    Object? email = _Undefined,
    String? accessToken,
    int? expiresIn,
    String? refreshToken,
    DateTime? created,
  }) {
    return TwitchAccount(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      userIdentifier: userIdentifier ?? this.userIdentifier,
      login: login ?? this.login,
      displayName: displayName ?? this.displayName,
      email: email is String? ? email : this.email,
      accessToken: accessToken ?? this.accessToken,
      expiresIn: expiresIn ?? this.expiresIn,
      refreshToken: refreshToken ?? this.refreshToken,
      created: created ?? this.created,
    );
  }
}

class TwitchAccountUpdateTable extends _i1.UpdateTable<TwitchAccountTable> {
  TwitchAccountUpdateTable(super.table);

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

  _i1.ColumnValue<String, String> login(String value) => _i1.ColumnValue(
    table.login,
    value,
  );

  _i1.ColumnValue<String, String> displayName(String value) => _i1.ColumnValue(
    table.displayName,
    value,
  );

  _i1.ColumnValue<String, String> email(String? value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> accessToken(String value) => _i1.ColumnValue(
    table.accessToken,
    value,
  );

  _i1.ColumnValue<int, int> expiresIn(int value) => _i1.ColumnValue(
    table.expiresIn,
    value,
  );

  _i1.ColumnValue<String, String> refreshToken(String value) => _i1.ColumnValue(
    table.refreshToken,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> created(DateTime value) =>
      _i1.ColumnValue(
        table.created,
        value,
      );
}

class TwitchAccountTable extends _i1.Table<_i1.UuidValue?> {
  TwitchAccountTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_twitch_account') {
    updateTable = TwitchAccountUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    userIdentifier = _i1.ColumnString(
      'userIdentifier',
      this,
    );
    login = _i1.ColumnString(
      'login',
      this,
    );
    displayName = _i1.ColumnString(
      'displayName',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    accessToken = _i1.ColumnString(
      'accessToken',
      this,
    );
    expiresIn = _i1.ColumnInt(
      'expiresIn',
      this,
    );
    refreshToken = _i1.ColumnString(
      'refreshToken',
      this,
    );
    created = _i1.ColumnDateTime(
      'created',
      this,
    );
  }

  late final TwitchAccountUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUserTable? _authUser;

  /// The unique identifier for the user from Twitch
  late final _i1.ColumnString userIdentifier;

  late final _i1.ColumnString login;

  late final _i1.ColumnString displayName;

  /// The email of the user on Twitch
  late final _i1.ColumnString email;

  /// Original access token exchanged by code
  late final _i1.ColumnString accessToken;

  /// Token expiry in timestamp format
  late final _i1.ColumnInt expiresIn;

  /// Saved refresh token after first authentication with code exchange
  late final _i1.ColumnString refreshToken;

  /// The date and time when this authentication was created.
  late final _i1.ColumnDateTime created;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: TwitchAccount.t.authUserId,
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
    login,
    displayName,
    email,
    accessToken,
    expiresIn,
    refreshToken,
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

class TwitchAccountInclude extends _i1.IncludeObject {
  TwitchAccountInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => TwitchAccount.t;
}

class TwitchAccountIncludeList extends _i1.IncludeList {
  TwitchAccountIncludeList._({
    _i1.WhereExpressionBuilder<TwitchAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TwitchAccount.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => TwitchAccount.t;
}

class TwitchAccountRepository {
  const TwitchAccountRepository._();

  final attachRow = const TwitchAccountAttachRowRepository._();

  /// Returns a list of [TwitchAccount]s matching the given query parameters.
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
  Future<List<TwitchAccount>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TwitchAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TwitchAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TwitchAccountTable>? orderByList,
    _i1.Transaction? transaction,
    TwitchAccountInclude? include,
  }) async {
    return session.db.find<TwitchAccount>(
      where: where?.call(TwitchAccount.t),
      orderBy: orderBy?.call(TwitchAccount.t),
      orderByList: orderByList?.call(TwitchAccount.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [TwitchAccount] matching the given query parameters.
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
  Future<TwitchAccount?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TwitchAccountTable>? where,
    int? offset,
    _i1.OrderByBuilder<TwitchAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TwitchAccountTable>? orderByList,
    _i1.Transaction? transaction,
    TwitchAccountInclude? include,
  }) async {
    return session.db.findFirstRow<TwitchAccount>(
      where: where?.call(TwitchAccount.t),
      orderBy: orderBy?.call(TwitchAccount.t),
      orderByList: orderByList?.call(TwitchAccount.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [TwitchAccount] by its [id] or null if no such row exists.
  Future<TwitchAccount?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    TwitchAccountInclude? include,
  }) async {
    return session.db.findById<TwitchAccount>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [TwitchAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [TwitchAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TwitchAccount>> insert(
    _i1.Session session,
    List<TwitchAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TwitchAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TwitchAccount] and returns the inserted row.
  ///
  /// The returned [TwitchAccount] will have its `id` field set.
  Future<TwitchAccount> insertRow(
    _i1.Session session,
    TwitchAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TwitchAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TwitchAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TwitchAccount>> update(
    _i1.Session session,
    List<TwitchAccount> rows, {
    _i1.ColumnSelections<TwitchAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TwitchAccount>(
      rows,
      columns: columns?.call(TwitchAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TwitchAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TwitchAccount> updateRow(
    _i1.Session session,
    TwitchAccount row, {
    _i1.ColumnSelections<TwitchAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TwitchAccount>(
      row,
      columns: columns?.call(TwitchAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TwitchAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TwitchAccount?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<TwitchAccountUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TwitchAccount>(
      id,
      columnValues: columnValues(TwitchAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TwitchAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TwitchAccount>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TwitchAccountUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TwitchAccountTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TwitchAccountTable>? orderBy,
    _i1.OrderByListBuilder<TwitchAccountTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TwitchAccount>(
      columnValues: columnValues(TwitchAccount.t.updateTable),
      where: where(TwitchAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TwitchAccount.t),
      orderByList: orderByList?.call(TwitchAccount.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TwitchAccount]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TwitchAccount>> delete(
    _i1.Session session,
    List<TwitchAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TwitchAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TwitchAccount].
  Future<TwitchAccount> deleteRow(
    _i1.Session session,
    TwitchAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TwitchAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TwitchAccount>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TwitchAccountTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TwitchAccount>(
      where: where(TwitchAccount.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TwitchAccountTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TwitchAccount>(
      where: where?.call(TwitchAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class TwitchAccountAttachRowRepository {
  const TwitchAccountAttachRowRepository._();

  /// Creates a relation between the given [TwitchAccount] and [AuthUser]
  /// by setting the [TwitchAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    TwitchAccount twitchAccount,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (twitchAccount.id == null) {
      throw ArgumentError.notNull('twitchAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $twitchAccount = twitchAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<TwitchAccount>(
      $twitchAccount,
      columns: [TwitchAccount.t.authUserId],
      transaction: transaction,
    );
  }
}
