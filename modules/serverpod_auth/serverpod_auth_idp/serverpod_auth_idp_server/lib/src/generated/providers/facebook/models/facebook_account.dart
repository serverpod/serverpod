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

/// A fully configured Facebook account to be used for logins.\
abstract class FacebookAccount
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  FacebookAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    DateTime? createdAt,
    required this.userIdentifier,
    this.email,
    this.fullName,
    this.firstName,
    this.lastName,
  }) : createdAt = createdAt ?? DateTime.now();

  factory FacebookAccount({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? createdAt,
    required String userIdentifier,
    String? email,
    String? fullName,
    String? firstName,
    String? lastName,
  }) = _FacebookAccountImpl;

  factory FacebookAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return FacebookAccount(
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
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      email: jsonSerialization['email'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      firstName: jsonSerialization['firstName'] as String?,
      lastName: jsonSerialization['lastName'] as String?,
    );
  }

  static final t = FacebookAccountTable();

  static const db = FacebookAccountRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUser? authUser;

  /// The time when this authentication was created.
  DateTime createdAt;

  /// The Facebook-provided user identifier (Facebook User ID).
  String userIdentifier;

  /// The verified email of the user, as received from Facebook.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups and user profile creation.
  ///
  /// Stored in lower-case.
  ///
  /// This may be null if the user hasn't granted email permission.
  String? email;

  /// The user's full name from Facebook.
  ///
  /// Combined first and last name as provided by Facebook.
  String? fullName;

  /// The user's first name from Facebook.
  String? firstName;

  /// The user's last name from Facebook.
  String? lastName;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [FacebookAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FacebookAccount copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    DateTime? createdAt,
    String? userIdentifier,
    String? email,
    String? fullName,
    String? firstName,
    String? lastName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.FacebookAccount',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'createdAt': createdAt.toJson(),
      'userIdentifier': userIdentifier,
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static FacebookAccountInclude include({_i2.AuthUserInclude? authUser}) {
    return FacebookAccountInclude._(authUser: authUser);
  }

  static FacebookAccountIncludeList includeList({
    _i1.WhereExpressionBuilder<FacebookAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FacebookAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FacebookAccountTable>? orderByList,
    FacebookAccountInclude? include,
  }) {
    return FacebookAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FacebookAccount.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FacebookAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FacebookAccountImpl extends FacebookAccount {
  _FacebookAccountImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? createdAt,
    required String userIdentifier,
    String? email,
    String? fullName,
    String? firstName,
    String? lastName,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         createdAt: createdAt,
         userIdentifier: userIdentifier,
         email: email,
         fullName: fullName,
         firstName: firstName,
         lastName: lastName,
       );

  /// Returns a shallow copy of this [FacebookAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FacebookAccount copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? createdAt,
    String? userIdentifier,
    Object? email = _Undefined,
    Object? fullName = _Undefined,
    Object? firstName = _Undefined,
    Object? lastName = _Undefined,
  }) {
    return FacebookAccount(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      email: email is String? ? email : this.email,
      fullName: fullName is String? ? fullName : this.fullName,
      firstName: firstName is String? ? firstName : this.firstName,
      lastName: lastName is String? ? lastName : this.lastName,
    );
  }
}

class FacebookAccountUpdateTable extends _i1.UpdateTable<FacebookAccountTable> {
  FacebookAccountUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authUserId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
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

  _i1.ColumnValue<String, String> fullName(String? value) => _i1.ColumnValue(
    table.fullName,
    value,
  );

  _i1.ColumnValue<String, String> firstName(String? value) => _i1.ColumnValue(
    table.firstName,
    value,
  );

  _i1.ColumnValue<String, String> lastName(String? value) => _i1.ColumnValue(
    table.lastName,
    value,
  );
}

class FacebookAccountTable extends _i1.Table<_i1.UuidValue?> {
  FacebookAccountTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_facebook_account') {
    updateTable = FacebookAccountUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
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
    fullName = _i1.ColumnString(
      'fullName',
      this,
    );
    firstName = _i1.ColumnString(
      'firstName',
      this,
    );
    lastName = _i1.ColumnString(
      'lastName',
      this,
    );
  }

  late final FacebookAccountUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUserTable? _authUser;

  /// The time when this authentication was created.
  late final _i1.ColumnDateTime createdAt;

  /// The Facebook-provided user identifier (Facebook User ID).
  late final _i1.ColumnString userIdentifier;

  /// The verified email of the user, as received from Facebook.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups and user profile creation.
  ///
  /// Stored in lower-case.
  ///
  /// This may be null if the user hasn't granted email permission.
  late final _i1.ColumnString email;

  /// The user's full name from Facebook.
  ///
  /// Combined first and last name as provided by Facebook.
  late final _i1.ColumnString fullName;

  /// The user's first name from Facebook.
  late final _i1.ColumnString firstName;

  /// The user's last name from Facebook.
  late final _i1.ColumnString lastName;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: FacebookAccount.t.authUserId,
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
    createdAt,
    userIdentifier,
    email,
    fullName,
    firstName,
    lastName,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class FacebookAccountInclude extends _i1.IncludeObject {
  FacebookAccountInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => FacebookAccount.t;
}

class FacebookAccountIncludeList extends _i1.IncludeList {
  FacebookAccountIncludeList._({
    _i1.WhereExpressionBuilder<FacebookAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FacebookAccount.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => FacebookAccount.t;
}

class FacebookAccountRepository {
  const FacebookAccountRepository._();

  final attachRow = const FacebookAccountAttachRowRepository._();

  /// Returns a list of [FacebookAccount]s matching the given query parameters.
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
  Future<List<FacebookAccount>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FacebookAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FacebookAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FacebookAccountTable>? orderByList,
    _i1.Transaction? transaction,
    FacebookAccountInclude? include,
  }) async {
    return session.db.find<FacebookAccount>(
      where: where?.call(FacebookAccount.t),
      orderBy: orderBy?.call(FacebookAccount.t),
      orderByList: orderByList?.call(FacebookAccount.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [FacebookAccount] matching the given query parameters.
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
  Future<FacebookAccount?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FacebookAccountTable>? where,
    int? offset,
    _i1.OrderByBuilder<FacebookAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FacebookAccountTable>? orderByList,
    _i1.Transaction? transaction,
    FacebookAccountInclude? include,
  }) async {
    return session.db.findFirstRow<FacebookAccount>(
      where: where?.call(FacebookAccount.t),
      orderBy: orderBy?.call(FacebookAccount.t),
      orderByList: orderByList?.call(FacebookAccount.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [FacebookAccount] by its [id] or null if no such row exists.
  Future<FacebookAccount?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    FacebookAccountInclude? include,
  }) async {
    return session.db.findById<FacebookAccount>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [FacebookAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [FacebookAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<FacebookAccount>> insert(
    _i1.Session session,
    List<FacebookAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<FacebookAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [FacebookAccount] and returns the inserted row.
  ///
  /// The returned [FacebookAccount] will have its `id` field set.
  Future<FacebookAccount> insertRow(
    _i1.Session session,
    FacebookAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FacebookAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FacebookAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FacebookAccount>> update(
    _i1.Session session,
    List<FacebookAccount> rows, {
    _i1.ColumnSelections<FacebookAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FacebookAccount>(
      rows,
      columns: columns?.call(FacebookAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FacebookAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FacebookAccount> updateRow(
    _i1.Session session,
    FacebookAccount row, {
    _i1.ColumnSelections<FacebookAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FacebookAccount>(
      row,
      columns: columns?.call(FacebookAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FacebookAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FacebookAccount?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<FacebookAccountUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FacebookAccount>(
      id,
      columnValues: columnValues(FacebookAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FacebookAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FacebookAccount>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<FacebookAccountUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<FacebookAccountTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FacebookAccountTable>? orderBy,
    _i1.OrderByListBuilder<FacebookAccountTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FacebookAccount>(
      columnValues: columnValues(FacebookAccount.t.updateTable),
      where: where(FacebookAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FacebookAccount.t),
      orderByList: orderByList?.call(FacebookAccount.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FacebookAccount]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FacebookAccount>> delete(
    _i1.Session session,
    List<FacebookAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FacebookAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FacebookAccount].
  Future<FacebookAccount> deleteRow(
    _i1.Session session,
    FacebookAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FacebookAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FacebookAccount>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FacebookAccountTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FacebookAccount>(
      where: where(FacebookAccount.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FacebookAccountTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FacebookAccount>(
      where: where?.call(FacebookAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class FacebookAccountAttachRowRepository {
  const FacebookAccountAttachRowRepository._();

  /// Creates a relation between the given [FacebookAccount] and [AuthUser]
  /// by setting the [FacebookAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    FacebookAccount facebookAccount,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (facebookAccount.id == null) {
      throw ArgumentError.notNull('facebookAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $facebookAccount = facebookAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<FacebookAccount>(
      $facebookAccount,
      columns: [FacebookAccount.t.authUserId],
      transaction: transaction,
    );
  }
}
