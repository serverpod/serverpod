/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart'
    as _i99s0abf;

/// A fully configured "Sign in with Apple"-based account to be used for logins.
abstract class AppleAccount
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
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
  }) : lastRefreshedAt = lastRefreshedAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now();

  factory AppleAccount({
    _is.UuidValue? id,
    required String userIdentifier,
    required String refreshToken,
    required bool refreshTokenRequestedWithBundleIdentifier,
    DateTime? lastRefreshedAt,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
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
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      refreshToken: jsonSerialization['refreshToken'] as String,
      refreshTokenRequestedWithBundleIdentifier: _is.BoolJsonExtension.fromJson(
        jsonSerialization['refreshTokenRequestedWithBundleIdentifier'],
      ),
      lastRefreshedAt: jsonSerialization['lastRefreshedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastRefreshedAt'],
            ),
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i99s0abf.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      email: jsonSerialization['email'] as String?,
      isEmailVerified: jsonSerialization['isEmailVerified'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['isEmailVerified'],
            ),
      isPrivateEmail: jsonSerialization['isPrivateEmail'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isPrivateEmail']),
      firstName: jsonSerialization['firstName'] as String?,
      lastName: jsonSerialization['lastName'] as String?,
    );
  }

  static final t = AppleAccountTable();

  static const db = AppleAccountRepository._();

  @override
  _is.UuidValue? id;

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

  _is.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUser? authUser;

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
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AppleAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AppleAccount copyWith({
    _is.UuidValue? id,
    String? userIdentifier,
    String? refreshToken,
    bool? refreshTokenRequestedWithBundleIdentifier,
    DateTime? lastRefreshedAt,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
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
      '__className__': 'serverpod_auth_idp.AppleAccount',
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

  static AppleAccountInclude include({
    _iacs.AuthUserInclude? authUser,
    _is.SelectColumnsBuilder<AppleAccountTable>? select,
  }) {
    return AppleAccountInclude._(
      authUser: authUser,
      selectedColumns: select?.call(AppleAccount.t),
    );
  }

  static AppleAccountIncludeList includeList({
    _is.WhereExpressionBuilder<AppleAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppleAccountTable>? orderBy,
    _is.OrderByListBuilder<AppleAccountTable>? orderByList,
    AppleAccountInclude? include,
    _is.SelectColumnsBuilder<AppleAccountTable>? select,
  }) {
    return AppleAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppleAccount.t),
      orderByList: orderByList?.call(AppleAccount.t),
      include: include,
      selectedColumns: select?.call(AppleAccount.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppleAccountImpl extends AppleAccount {
  _AppleAccountImpl({
    _is.UuidValue? id,
    required String userIdentifier,
    required String refreshToken,
    required bool refreshTokenRequestedWithBundleIdentifier,
    DateTime? lastRefreshedAt,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
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
  @_is.useResult
  @override
  AppleAccount copyWith({
    Object? id = _Undefined,
    String? userIdentifier,
    String? refreshToken,
    bool? refreshTokenRequestedWithBundleIdentifier,
    DateTime? lastRefreshedAt,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? createdAt,
    Object? email = _Undefined,
    Object? isEmailVerified = _Undefined,
    Object? isPrivateEmail = _Undefined,
    Object? firstName = _Undefined,
    Object? lastName = _Undefined,
  }) {
    return AppleAccount(
      id: id is _is.UuidValue? ? id : this.id,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      refreshToken: refreshToken ?? this.refreshToken,
      refreshTokenRequestedWithBundleIdentifier:
          refreshTokenRequestedWithBundleIdentifier ??
          this.refreshTokenRequestedWithBundleIdentifier,
      lastRefreshedAt: lastRefreshedAt ?? this.lastRefreshedAt,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      email: email is String? ? email : this.email,
      isEmailVerified: isEmailVerified is bool?
          ? isEmailVerified
          : this.isEmailVerified,
      isPrivateEmail: isPrivateEmail is bool?
          ? isPrivateEmail
          : this.isPrivateEmail,
      firstName: firstName is String? ? firstName : this.firstName,
      lastName: lastName is String? ? lastName : this.lastName,
    );
  }
}

class AppleAccountUpdateTable extends _is.UpdateTable<AppleAccountTable> {
  AppleAccountUpdateTable(super.table);

  _is.ColumnValue<String, String> userIdentifier(String value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );

  _is.ColumnValue<String, String> refreshToken(String value) => _is.ColumnValue(
    table.refreshToken,
    value,
  );

  _is.ColumnValue<bool, bool> refreshTokenRequestedWithBundleIdentifier(
    bool value,
  ) => _is.ColumnValue(
    table.refreshTokenRequestedWithBundleIdentifier,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> lastRefreshedAt(DateTime value) =>
      _is.ColumnValue(
        table.lastRefreshedAt,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<String, String> email(String? value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<bool, bool> isEmailVerified(bool? value) => _is.ColumnValue(
    table.isEmailVerified,
    value,
  );

  _is.ColumnValue<bool, bool> isPrivateEmail(bool? value) => _is.ColumnValue(
    table.isPrivateEmail,
    value,
  );

  _is.ColumnValue<String, String> firstName(String? value) => _is.ColumnValue(
    table.firstName,
    value,
  );

  _is.ColumnValue<String, String> lastName(String? value) => _is.ColumnValue(
    table.lastName,
    value,
  );
}

class AppleAccountTable extends _is.Table<_is.UuidValue?> {
  AppleAccountTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_apple_account') {
    updateTable = AppleAccountUpdateTable(this);
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
    refreshToken = _is.ColumnString(
      'refreshToken',
      this,
    );
    refreshTokenRequestedWithBundleIdentifier = _is.ColumnBool(
      'refreshTokenRequestedWithBundleIdentifier',
      this,
    );
    lastRefreshedAt = _is.ColumnDateTime(
      'lastRefreshedAt',
      this,
      hasDefault: true,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    isEmailVerified = _is.ColumnBool(
      'isEmailVerified',
      this,
    );
    isPrivateEmail = _is.ColumnBool(
      'isPrivateEmail',
      this,
    );
    firstName = _is.ColumnString(
      'firstName',
      this,
    );
    lastName = _is.ColumnString(
      'lastName',
      this,
    );
  }

  late final AppleAccountUpdateTable updateTable;

  /// The Apple-provided user identifier
  late final _is.ColumnString userIdentifier;

  /// Refresh token for this user, to sync the account details with Apple.
  ///
  /// Only the first one is stored per user.
  late final _is.ColumnString refreshToken;

  /// Whether the refresh token was created on an Apple OS.
  ///
  /// The source of the initial registration needs to be retained throughout
  /// the lifecycle of the account.
  late final _is.ColumnBool refreshTokenRequestedWithBundleIdentifier;

  /// Time when the account data was last received from Apple's servers.
  late final _is.ColumnDateTime lastRefreshedAt;

  late final _is.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _iacs.AuthUserTable? _authUser;

  /// The time when this authentication was created.
  late final _is.ColumnDateTime createdAt;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  ///
  /// Presence depends on whether this was requested with the initial sign-up.
  late final _is.ColumnString email;

  /// Whether the email has been verified by Apple.
  late final _is.ColumnBool isEmailVerified;

  /// Whether this email address is a private "relay" email address.
  late final _is.ColumnBool isPrivateEmail;

  /// The first name given during the initial registration.
  ///
  /// Will only be set if it was requested on sign-up.
  /// The user is free to put in whatever they want here, and this is not
  /// verified by or known to Apple.
  late final _is.ColumnString firstName;

  /// The last name given during the initial registration.
  ///
  /// Will only be set if it was requested on sign-up.
  /// The user is free to put in whatever they want here, and this is not
  /// verified by or known to Apple.
  late final _is.ColumnString lastName;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: AppleAccount.t.authUserId,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_is.Column> get columns => [
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
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class AppleAccountInclude extends _is.IncludeObject {
  AppleAccountInclude._({
    _iacs.AuthUserInclude? authUser,
    this.selectedColumns,
  }) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<_is.UuidValue?> get table => AppleAccount.t;
}

class AppleAccountIncludeList extends _is.IncludeList {
  AppleAccountIncludeList._({
    _is.WhereExpressionBuilder<AppleAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(AppleAccount.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => AppleAccount.t;
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppleAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppleAccountTable>? orderBy,
    _is.OrderByListBuilder<AppleAccountTable>? orderByList,
    _is.Transaction? transaction,
    AppleAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AppleAccount>(
      where: where?.call(AppleAccount.t),
      orderBy: orderBy?.call(AppleAccount.t),
      orderByList: orderByList?.call(AppleAccount.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppleAccountTable>? where,
    int? offset,
    _is.OrderByBuilder<AppleAccountTable>? orderBy,
    _is.OrderByListBuilder<AppleAccountTable>? orderByList,
    _is.Transaction? transaction,
    AppleAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AppleAccount>(
      where: where?.call(AppleAccount.t),
      orderBy: orderBy?.call(AppleAccount.t),
      orderByList: orderByList?.call(AppleAccount.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AppleAccount] by its [id] or null if no such row exists.
  Future<AppleAccount?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    AppleAccountInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AppleAccount>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var persons = await Persons.db.findAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.lastName],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppleAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppleAccountTable>? orderBy,
    _is.OrderByListBuilder<AppleAccountTable>? orderByList,
    _is.Transaction? transaction,
    AppleAccountInclude? include,
    _is.SelectColumnsBuilder<AppleAccountTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<AppleAccount>(
      where: where?.call(AppleAccount.t),
      orderBy: orderBy?.call(AppleAccount.t),
      orderByList: orderByList?.call(AppleAccount.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(AppleAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var youngestPerson = await Persons.db.findFirstRowAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.age],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppleAccountTable>? where,
    int? offset,
    _is.OrderByBuilder<AppleAccountTable>? orderBy,
    _is.OrderByListBuilder<AppleAccountTable>? orderByList,
    _is.Transaction? transaction,
    AppleAccountInclude? include,
    _is.SelectColumnsBuilder<AppleAccountTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<AppleAccount>(
      where: where?.call(AppleAccount.t),
      orderBy: orderBy?.call(AppleAccount.t),
      orderByList: orderByList?.call(AppleAccount.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(AppleAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    AppleAccountInclude? include,
    _is.SelectColumnsBuilder<AppleAccountTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<AppleAccount>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(AppleAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AppleAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [AppleAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppleAccount>> insert(
    _is.DatabaseSession session,
    List<AppleAccount> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AppleAccount>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AppleAccount] and returns the inserted row.
  ///
  /// The returned [AppleAccount] will have its `id` field set.
  Future<AppleAccount> insertRow(
    _is.DatabaseSession session,
    AppleAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppleAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AppleAccount]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [AppleAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppleAccount>> upsert(
    _is.DatabaseSession session,
    List<AppleAccount> rows, {
    required _is.ColumnSelections<AppleAccountTable> conflictColumns,
    _is.ColumnSelections<AppleAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<AppleAccountTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AppleAccount>(
      rows,
      conflictColumns: conflictColumns(AppleAccount.t),
      updateColumns: updateColumns?.call(AppleAccount.t),
      updateWhere: updateWhere?.call(AppleAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AppleAccount] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [AppleAccount] will have its `id` field set.
  Future<AppleAccount?> upsertRow(
    _is.DatabaseSession session,
    AppleAccount row, {
    required _is.ColumnSelections<AppleAccountTable> conflictColumns,
    _is.ColumnSelections<AppleAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<AppleAccountTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AppleAccount>(
      row,
      conflictColumns: conflictColumns(AppleAccount.t),
      updateColumns: updateColumns?.call(AppleAccount.t),
      updateWhere: updateWhere?.call(AppleAccount.t),
      transaction: transaction,
    );
  }

  /// Updates all [AppleAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppleAccount>> update(
    _is.DatabaseSession session,
    List<AppleAccount> rows, {
    _is.ColumnSelections<AppleAccountTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AppleAccount>(
      rows,
      columns: columns?.call(AppleAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AppleAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppleAccount> updateRow(
    _is.DatabaseSession session,
    AppleAccount row, {
    _is.ColumnSelections<AppleAccountTable>? columns,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<AppleAccountUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AppleAccount>(
      id,
      columnValues: columnValues(AppleAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppleAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppleAccount>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AppleAccountUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AppleAccountTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppleAccountTable>? orderBy,
    _is.OrderByListBuilder<AppleAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AppleAccount>(
      columnValues: columnValues(AppleAccount.t.updateTable),
      where: where(AppleAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppleAccount.t),
      orderByList: orderByList?.call(AppleAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AppleAccount]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppleAccount>> delete(
    _is.DatabaseSession session,
    List<AppleAccount> rows, {
    _is.OrderByBuilder<AppleAccountTable>? orderBy,
    _is.OrderByListBuilder<AppleAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AppleAccount>(
      rows,
      orderBy: orderBy?.call(AppleAccount.t),
      orderByList: orderByList?.call(AppleAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AppleAccount].
  Future<AppleAccount> deleteRow(
    _is.DatabaseSession session,
    AppleAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppleAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppleAccount>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AppleAccountTable> where,
    _is.OrderByBuilder<AppleAccountTable>? orderBy,
    _is.OrderByListBuilder<AppleAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AppleAccount>(
      where: where(AppleAccount.t),
      orderBy: orderBy?.call(AppleAccount.t),
      orderByList: orderByList?.call(AppleAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppleAccountTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AppleAccount>(
      where: where?.call(AppleAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AppleAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AppleAccountTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AppleAccount>(
      where: where(AppleAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class AppleAccountAttachRowRepository {
  const AppleAccountAttachRowRepository._();

  /// Creates a relation between the given [AppleAccount] and [AuthUser]
  /// by setting the [AppleAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    AppleAccount appleAccount,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
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
