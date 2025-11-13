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

/// A fully configured Google account to be used for logins.
abstract class GoogleAccount
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  GoogleAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    DateTime? created,
    required this.email,
    required this.userIdentifier,
  }) : created = created ?? DateTime.now();

  factory GoogleAccount({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? created,
    required String email,
    required String userIdentifier,
  }) = _GoogleAccountImpl;

  factory GoogleAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return GoogleAccount(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i2.AuthUser.fromJson(
              (jsonSerialization['authUser'] as Map<String, dynamic>),
            ),
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      email: jsonSerialization['email'] as String,
      userIdentifier: jsonSerialization['userIdentifier'] as String,
    );
  }

  static final t = GoogleAccountTable();

  static const db = GoogleAccountRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUser? authUser;

  /// The time when this authentication was created.
  DateTime created;

  /// The verified email of the user, as received from Google.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups.
  ///
  /// Stored in lower-case.
  String email;

  /// The user identifier given by Google for this account.
  String userIdentifier;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [GoogleAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GoogleAccount copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    DateTime? created,
    String? email,
    String? userIdentifier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'created': created.toJson(),
      'email': email,
      'userIdentifier': userIdentifier,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static GoogleAccountInclude include({_i2.AuthUserInclude? authUser}) {
    return GoogleAccountInclude._(authUser: authUser);
  }

  static GoogleAccountIncludeList includeList({
    _i1.WhereExpressionBuilder<GoogleAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GoogleAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GoogleAccountTable>? orderByList,
    GoogleAccountInclude? include,
  }) {
    return GoogleAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GoogleAccount.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(GoogleAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GoogleAccountImpl extends GoogleAccount {
  _GoogleAccountImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? created,
    required String email,
    required String userIdentifier,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         created: created,
         email: email,
         userIdentifier: userIdentifier,
       );

  /// Returns a shallow copy of this [GoogleAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GoogleAccount copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? created,
    String? email,
    String? userIdentifier,
  }) {
    return GoogleAccount(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      created: created ?? this.created,
      email: email ?? this.email,
      userIdentifier: userIdentifier ?? this.userIdentifier,
    );
  }
}

class GoogleAccountUpdateTable extends _i1.UpdateTable<GoogleAccountTable> {
  GoogleAccountUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authUserId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> created(DateTime value) =>
      _i1.ColumnValue(
        table.created,
        value,
      );

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> userIdentifier(String value) =>
      _i1.ColumnValue(
        table.userIdentifier,
        value,
      );
}

class GoogleAccountTable extends _i1.Table<_i1.UuidValue?> {
  GoogleAccountTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_google_account') {
    updateTable = GoogleAccountUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    created = _i1.ColumnDateTime(
      'created',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    userIdentifier = _i1.ColumnString(
      'userIdentifier',
      this,
    );
  }

  late final GoogleAccountUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUserTable? _authUser;

  /// The time when this authentication was created.
  late final _i1.ColumnDateTime created;

  /// The verified email of the user, as received from Google.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups.
  ///
  /// Stored in lower-case.
  late final _i1.ColumnString email;

  /// The user identifier given by Google for this account.
  late final _i1.ColumnString userIdentifier;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: GoogleAccount.t.authUserId,
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
    email,
    userIdentifier,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class GoogleAccountInclude extends _i1.IncludeObject {
  GoogleAccountInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => GoogleAccount.t;
}

class GoogleAccountIncludeList extends _i1.IncludeList {
  GoogleAccountIncludeList._({
    _i1.WhereExpressionBuilder<GoogleAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(GoogleAccount.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => GoogleAccount.t;
}

class GoogleAccountRepository {
  const GoogleAccountRepository._();

  final attachRow = const GoogleAccountAttachRowRepository._();

  /// Returns a list of [GoogleAccount]s matching the given query parameters.
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
  Future<List<GoogleAccount>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GoogleAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GoogleAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GoogleAccountTable>? orderByList,
    _i1.Transaction? transaction,
    GoogleAccountInclude? include,
  }) async {
    return session.db.find<GoogleAccount>(
      where: where?.call(GoogleAccount.t),
      orderBy: orderBy?.call(GoogleAccount.t),
      orderByList: orderByList?.call(GoogleAccount.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [GoogleAccount] matching the given query parameters.
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
  Future<GoogleAccount?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GoogleAccountTable>? where,
    int? offset,
    _i1.OrderByBuilder<GoogleAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GoogleAccountTable>? orderByList,
    _i1.Transaction? transaction,
    GoogleAccountInclude? include,
  }) async {
    return session.db.findFirstRow<GoogleAccount>(
      where: where?.call(GoogleAccount.t),
      orderBy: orderBy?.call(GoogleAccount.t),
      orderByList: orderByList?.call(GoogleAccount.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [GoogleAccount] by its [id] or null if no such row exists.
  Future<GoogleAccount?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    GoogleAccountInclude? include,
  }) async {
    return session.db.findById<GoogleAccount>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [GoogleAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [GoogleAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<GoogleAccount>> insert(
    _i1.Session session,
    List<GoogleAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<GoogleAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [GoogleAccount] and returns the inserted row.
  ///
  /// The returned [GoogleAccount] will have its `id` field set.
  Future<GoogleAccount> insertRow(
    _i1.Session session,
    GoogleAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<GoogleAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [GoogleAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<GoogleAccount>> update(
    _i1.Session session,
    List<GoogleAccount> rows, {
    _i1.ColumnSelections<GoogleAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<GoogleAccount>(
      rows,
      columns: columns?.call(GoogleAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GoogleAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<GoogleAccount> updateRow(
    _i1.Session session,
    GoogleAccount row, {
    _i1.ColumnSelections<GoogleAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<GoogleAccount>(
      row,
      columns: columns?.call(GoogleAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GoogleAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<GoogleAccount?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<GoogleAccountUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<GoogleAccount>(
      id,
      columnValues: columnValues(GoogleAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [GoogleAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<GoogleAccount>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<GoogleAccountUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<GoogleAccountTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GoogleAccountTable>? orderBy,
    _i1.OrderByListBuilder<GoogleAccountTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<GoogleAccount>(
      columnValues: columnValues(GoogleAccount.t.updateTable),
      where: where(GoogleAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GoogleAccount.t),
      orderByList: orderByList?.call(GoogleAccount.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [GoogleAccount]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<GoogleAccount>> delete(
    _i1.Session session,
    List<GoogleAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<GoogleAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [GoogleAccount].
  Future<GoogleAccount> deleteRow(
    _i1.Session session,
    GoogleAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<GoogleAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<GoogleAccount>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<GoogleAccountTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<GoogleAccount>(
      where: where(GoogleAccount.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GoogleAccountTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<GoogleAccount>(
      where: where?.call(GoogleAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class GoogleAccountAttachRowRepository {
  const GoogleAccountAttachRowRepository._();

  /// Creates a relation between the given [GoogleAccount] and [AuthUser]
  /// by setting the [GoogleAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    GoogleAccount googleAccount,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (googleAccount.id == null) {
      throw ArgumentError.notNull('googleAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $googleAccount = googleAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<GoogleAccount>(
      $googleAccount,
      columns: [GoogleAccount.t.authUserId],
      transaction: transaction,
    );
  }
}
