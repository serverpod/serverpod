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

/// A fully configured "Sign in with Apple"-based account to be used for logins.
abstract class AppleAccount
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  AppleAccount._({
    this.id,
    required this.userIdentifier,
    required this.refreshToken,
    required this.refreshTokenRequestedWithBundleIdentifier,
    DateTime? lastRefreshedAt,
    required this.authUserId,
    this.authUser,
    DateTime? createdAt,
    this.email,
    this.isEmailVerified,
    this.isPrivateEmail,
    this.firstName,
    this.lastName,
  })  : lastRefreshedAt = lastRefreshedAt ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  factory AppleAccount({
    _i1.UuidValue? id,
    required String userIdentifier,
    required String refreshToken,
    required bool refreshTokenRequestedWithBundleIdentifier,
    DateTime? lastRefreshedAt,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? createdAt,
    String? email,
    bool? isEmailVerified,
    bool? isPrivateEmail,
    String? firstName,
    String? lastName,
  }) = _AppleAccountImpl;

  factory AppleAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppleAccount(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      refreshToken: jsonSerialization['refreshToken'] as String,
      refreshTokenRequestedWithBundleIdentifier:
          jsonSerialization['refreshTokenRequestedWithBundleIdentifier']
              as bool,
      lastRefreshedAt: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['lastRefreshedAt']),
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i2.AuthUser.fromJson(
              (jsonSerialization['authUser'] as Map<String, dynamic>)),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      email: jsonSerialization['email'] as String?,
      isEmailVerified: jsonSerialization['isEmailVerified'] as bool?,
      isPrivateEmail: jsonSerialization['isPrivateEmail'] as bool?,
      firstName: jsonSerialization['firstName'] as String?,
      lastName: jsonSerialization['lastName'] as String?,
    );
  }

  static final t = AppleAccountTable();

  static const db = AppleAccountRepository._();

  @override
  _i1.UuidValue? id;

  /// The Apple-provided user identifier
  String userIdentifier;

  /// Refresh token for this user, to sync the account details with Apple.
  ///
  /// Only the first one is stored per user.
  String refreshToken;

  /// Whether the refresh token was created on an Apple OS.
  ///
  /// The source of the initial registration needs to be retained throughout
  /// the lifecycle of the account.
  bool refreshTokenRequestedWithBundleIdentifier;

  /// Time when the account data was last received from Apple's servers.
  DateTime lastRefreshedAt;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUser? authUser;

  /// The time when this authentication was created.
  DateTime createdAt;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  ///
  /// Presence depends on whether this was requested with the initial sign-up.
  String? email;

  /// Whether the email has been verified by Apple.
  bool? isEmailVerified;

  /// Whether this email address is a private "relay" email address.
  bool? isPrivateEmail;

  /// The first name given during the initial registration.
  ///
  /// Will only be set if it was requested on sign-up.
  /// The user is free to put in whatever they want here, and this is not
  /// verified by or known to Apple.
  String? firstName;

  /// The last name given during the initial registration.
  ///
  /// Will only be set if it was requested on sign-up.
  /// The user is free to put in whatever they want here, and this is not
  /// verified by or known to Apple.
  String? lastName;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AppleAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppleAccount copyWith({
    _i1.UuidValue? id,
    String? userIdentifier,
    String? refreshToken,
    bool? refreshTokenRequestedWithBundleIdentifier,
    DateTime? lastRefreshedAt,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    DateTime? createdAt,
    String? email,
    bool? isEmailVerified,
    bool? isPrivateEmail,
    String? firstName,
    String? lastName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'userIdentifier': userIdentifier,
      'refreshToken': refreshToken,
      'refreshTokenRequestedWithBundleIdentifier':
          refreshTokenRequestedWithBundleIdentifier,
      'lastRefreshedAt': lastRefreshedAt.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'createdAt': createdAt.toJson(),
      if (email != null) 'email': email,
      if (isEmailVerified != null) 'isEmailVerified': isEmailVerified,
      if (isPrivateEmail != null) 'isPrivateEmail': isPrivateEmail,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AppleAccountInclude include({_i2.AuthUserInclude? authUser}) {
    return AppleAccountInclude._(authUser: authUser);
  }

  static AppleAccountIncludeList includeList({
    _i1.WhereExpressionBuilder<AppleAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppleAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppleAccountTable>? orderByList,
    AppleAccountInclude? include,
  }) {
    return AppleAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppleAccount.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AppleAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppleAccountImpl extends AppleAccount {
  _AppleAccountImpl({
    _i1.UuidValue? id,
    required String userIdentifier,
    required String refreshToken,
    required bool refreshTokenRequestedWithBundleIdentifier,
    DateTime? lastRefreshedAt,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? createdAt,
    String? email,
    bool? isEmailVerified,
    bool? isPrivateEmail,
    String? firstName,
    String? lastName,
  }) : super._(
          id: id,
          userIdentifier: userIdentifier,
          refreshToken: refreshToken,
          refreshTokenRequestedWithBundleIdentifier:
              refreshTokenRequestedWithBundleIdentifier,
          lastRefreshedAt: lastRefreshedAt,
          authUserId: authUserId,
          authUser: authUser,
          createdAt: createdAt,
          email: email,
          isEmailVerified: isEmailVerified,
          isPrivateEmail: isPrivateEmail,
          firstName: firstName,
          lastName: lastName,
        );

  /// Returns a shallow copy of this [AppleAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppleAccount copyWith({
    Object? id = _Undefined,
    String? userIdentifier,
    String? refreshToken,
    bool? refreshTokenRequestedWithBundleIdentifier,
    DateTime? lastRefreshedAt,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? createdAt,
    Object? email = _Undefined,
    Object? isEmailVerified = _Undefined,
    Object? isPrivateEmail = _Undefined,
    Object? firstName = _Undefined,
    Object? lastName = _Undefined,
  }) {
    return AppleAccount(
      id: id is _i1.UuidValue? ? id : this.id,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      refreshToken: refreshToken ?? this.refreshToken,
      refreshTokenRequestedWithBundleIdentifier:
          refreshTokenRequestedWithBundleIdentifier ??
              this.refreshTokenRequestedWithBundleIdentifier,
      lastRefreshedAt: lastRefreshedAt ?? this.lastRefreshedAt,
      authUserId: authUserId ?? this.authUserId,
      authUser:
          authUser is _i2.AuthUser? ? authUser : this.authUser?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      email: email is String? ? email : this.email,
      isEmailVerified:
          isEmailVerified is bool? ? isEmailVerified : this.isEmailVerified,
      isPrivateEmail:
          isPrivateEmail is bool? ? isPrivateEmail : this.isPrivateEmail,
      firstName: firstName is String? ? firstName : this.firstName,
      lastName: lastName is String? ? lastName : this.lastName,
    );
  }
}

class AppleAccountUpdateTable extends _i1.UpdateTable<AppleAccountTable> {
  AppleAccountUpdateTable(super.table);

  _i1.ColumnValue<String, String> userIdentifier(String value) =>
      _i1.ColumnValue(
        table.userIdentifier,
        value,
      );

  _i1.ColumnValue<String, String> refreshToken(String value) => _i1.ColumnValue(
        table.refreshToken,
        value,
      );

  _i1.ColumnValue<bool, bool> refreshTokenRequestedWithBundleIdentifier(
          bool value) =>
      _i1.ColumnValue(
        table.refreshTokenRequestedWithBundleIdentifier,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> lastRefreshedAt(DateTime value) =>
      _i1.ColumnValue(
        table.lastRefreshedAt,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authUserId(
          _i1.UuidValue value) =>
      _i1.ColumnValue(
        table.authUserId,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<String, String> email(String? value) => _i1.ColumnValue(
        table.email,
        value,
      );

  _i1.ColumnValue<bool, bool> isEmailVerified(bool? value) => _i1.ColumnValue(
        table.isEmailVerified,
        value,
      );

  _i1.ColumnValue<bool, bool> isPrivateEmail(bool? value) => _i1.ColumnValue(
        table.isPrivateEmail,
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

class AppleAccountTable extends _i1.Table<_i1.UuidValue?> {
  AppleAccountTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_idp_apple_account') {
    updateTable = AppleAccountUpdateTable(this);
    userIdentifier = _i1.ColumnString(
      'userIdentifier',
      this,
    );
    refreshToken = _i1.ColumnString(
      'refreshToken',
      this,
    );
    refreshTokenRequestedWithBundleIdentifier = _i1.ColumnBool(
      'refreshTokenRequestedWithBundleIdentifier',
      this,
    );
    lastRefreshedAt = _i1.ColumnDateTime(
      'lastRefreshedAt',
      this,
      hasDefault: true,
    );
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    isEmailVerified = _i1.ColumnBool(
      'isEmailVerified',
      this,
    );
    isPrivateEmail = _i1.ColumnBool(
      'isPrivateEmail',
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

  late final AppleAccountUpdateTable updateTable;

  /// The Apple-provided user identifier
  late final _i1.ColumnString userIdentifier;

  /// Refresh token for this user, to sync the account details with Apple.
  ///
  /// Only the first one is stored per user.
  late final _i1.ColumnString refreshToken;

  /// Whether the refresh token was created on an Apple OS.
  ///
  /// The source of the initial registration needs to be retained throughout
  /// the lifecycle of the account.
  late final _i1.ColumnBool refreshTokenRequestedWithBundleIdentifier;

  /// Time when the account data was last received from Apple's servers.
  late final _i1.ColumnDateTime lastRefreshedAt;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUserTable? _authUser;

  /// The time when this authentication was created.
  late final _i1.ColumnDateTime createdAt;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  ///
  /// Presence depends on whether this was requested with the initial sign-up.
  late final _i1.ColumnString email;

  /// Whether the email has been verified by Apple.
  late final _i1.ColumnBool isEmailVerified;

  /// Whether this email address is a private "relay" email address.
  late final _i1.ColumnBool isPrivateEmail;

  /// The first name given during the initial registration.
  ///
  /// Will only be set if it was requested on sign-up.
  /// The user is free to put in whatever they want here, and this is not
  /// verified by or known to Apple.
  late final _i1.ColumnString firstName;

  /// The last name given during the initial registration.
  ///
  /// Will only be set if it was requested on sign-up.
  /// The user is free to put in whatever they want here, and this is not
  /// verified by or known to Apple.
  late final _i1.ColumnString lastName;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: AppleAccount.t.authUserId,
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
        userIdentifier,
        refreshToken,
        refreshTokenRequestedWithBundleIdentifier,
        lastRefreshedAt,
        authUserId,
        createdAt,
        email,
        isEmailVerified,
        isPrivateEmail,
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

class AppleAccountInclude extends _i1.IncludeObject {
  AppleAccountInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => AppleAccount.t;
}

class AppleAccountIncludeList extends _i1.IncludeList {
  AppleAccountIncludeList._({
    _i1.WhereExpressionBuilder<AppleAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppleAccount.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AppleAccount.t;
}

class AppleAccountRepository {
  const AppleAccountRepository._();

  final attachRow = const AppleAccountAttachRowRepository._();

  /// Returns a list of [AppleAccount]s matching the given query parameters.
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
  Future<List<AppleAccount>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppleAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppleAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppleAccountTable>? orderByList,
    _i1.Transaction? transaction,
    AppleAccountInclude? include,
  }) async {
    return session.db.find<AppleAccount>(
      where: where?.call(AppleAccount.t),
      orderBy: orderBy?.call(AppleAccount.t),
      orderByList: orderByList?.call(AppleAccount.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [AppleAccount] matching the given query parameters.
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
  Future<AppleAccount?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppleAccountTable>? where,
    int? offset,
    _i1.OrderByBuilder<AppleAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppleAccountTable>? orderByList,
    _i1.Transaction? transaction,
    AppleAccountInclude? include,
  }) async {
    return session.db.findFirstRow<AppleAccount>(
      where: where?.call(AppleAccount.t),
      orderBy: orderBy?.call(AppleAccount.t),
      orderByList: orderByList?.call(AppleAccount.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [AppleAccount] by its [id] or null if no such row exists.
  Future<AppleAccount?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    AppleAccountInclude? include,
  }) async {
    return session.db.findById<AppleAccount>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [AppleAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [AppleAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AppleAccount>> insert(
    _i1.Session session,
    List<AppleAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AppleAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AppleAccount] and returns the inserted row.
  ///
  /// The returned [AppleAccount] will have its `id` field set.
  Future<AppleAccount> insertRow(
    _i1.Session session,
    AppleAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppleAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AppleAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AppleAccount>> update(
    _i1.Session session,
    List<AppleAccount> rows, {
    _i1.ColumnSelections<AppleAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AppleAccount>(
      rows,
      columns: columns?.call(AppleAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppleAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppleAccount> updateRow(
    _i1.Session session,
    AppleAccount row, {
    _i1.ColumnSelections<AppleAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppleAccount>(
      row,
      columns: columns?.call(AppleAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppleAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppleAccount?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<AppleAccountUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AppleAccount>(
      id,
      columnValues: columnValues(AppleAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppleAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AppleAccount>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AppleAccountUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AppleAccountTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppleAccountTable>? orderBy,
    _i1.OrderByListBuilder<AppleAccountTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AppleAccount>(
      columnValues: columnValues(AppleAccount.t.updateTable),
      where: where(AppleAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppleAccount.t),
      orderByList: orderByList?.call(AppleAccount.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AppleAccount]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AppleAccount>> delete(
    _i1.Session session,
    List<AppleAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AppleAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AppleAccount].
  Future<AppleAccount> deleteRow(
    _i1.Session session,
    AppleAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppleAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AppleAccount>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AppleAccountTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AppleAccount>(
      where: where(AppleAccount.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppleAccountTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AppleAccount>(
      where: where?.call(AppleAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AppleAccountAttachRowRepository {
  const AppleAccountAttachRowRepository._();

  /// Creates a relation between the given [AppleAccount] and [AuthUser]
  /// by setting the [AppleAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    AppleAccount appleAccount,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (appleAccount.id == null) {
      throw ArgumentError.notNull('appleAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $appleAccount = appleAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<AppleAccount>(
      $appleAccount,
      columns: [AppleAccount.t.authUserId],
      transaction: transaction,
    );
  }
}
