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

/// A fully configured SMS account to be used for logins.
abstract class SmsAccount
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  SmsAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    DateTime? createdAt,
    required this.passwordHash,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SmsAccount({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? createdAt,
    required String passwordHash,
  }) = _SmsAccountImpl;

  factory SmsAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return SmsAccount(
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
      passwordHash: jsonSerialization['passwordHash'] as String,
    );
  }

  static final t = SmsAccountTable();

  static const db = SmsAccountRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this account belongs to
  _i2.AuthUser? authUser;

  /// The time when this account was created.
  DateTime createdAt;

  /// The hashed password of the user.
  ///
  /// Stored in PHC format: $argon2id$v=19$m={memory},t={iterations},p={lanes}${base64Salt}$${base64Hash}
  String passwordHash;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [SmsAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SmsAccount copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    DateTime? createdAt,
    String? passwordHash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.SmsAccount',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'createdAt': createdAt.toJson(),
      'passwordHash': passwordHash,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SmsAccountInclude include({_i2.AuthUserInclude? authUser}) {
    return SmsAccountInclude._(authUser: authUser);
  }

  static SmsAccountIncludeList includeList({
    _i1.WhereExpressionBuilder<SmsAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsAccountTable>? orderByList,
    SmsAccountInclude? include,
  }) {
    return SmsAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmsAccount.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SmsAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SmsAccountImpl extends SmsAccount {
  _SmsAccountImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? createdAt,
    required String passwordHash,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         createdAt: createdAt,
         passwordHash: passwordHash,
       );

  /// Returns a shallow copy of this [SmsAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SmsAccount copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? createdAt,
    String? passwordHash,
  }) {
    return SmsAccount(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }
}

class SmsAccountUpdateTable extends _i1.UpdateTable<SmsAccountTable> {
  SmsAccountUpdateTable(super.table);

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

  _i1.ColumnValue<String, String> passwordHash(String value) => _i1.ColumnValue(
    table.passwordHash,
    value,
  );
}

class SmsAccountTable extends _i1.Table<_i1.UuidValue?> {
  SmsAccountTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_sms_account') {
    updateTable = SmsAccountUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    passwordHash = _i1.ColumnString(
      'passwordHash',
      this,
    );
  }

  late final SmsAccountUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this account belongs to
  _i2.AuthUserTable? _authUser;

  /// The time when this account was created.
  late final _i1.ColumnDateTime createdAt;

  /// The hashed password of the user.
  ///
  /// Stored in PHC format: $argon2id$v=19$m={memory},t={iterations},p={lanes}${base64Salt}$${base64Hash}
  late final _i1.ColumnString passwordHash;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: SmsAccount.t.authUserId,
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
    passwordHash,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class SmsAccountInclude extends _i1.IncludeObject {
  SmsAccountInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => SmsAccount.t;
}

class SmsAccountIncludeList extends _i1.IncludeList {
  SmsAccountIncludeList._({
    _i1.WhereExpressionBuilder<SmsAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SmsAccount.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => SmsAccount.t;
}

class SmsAccountRepository {
  const SmsAccountRepository._();

  final attachRow = const SmsAccountAttachRowRepository._();

  /// Returns a list of [SmsAccount]s matching the given query parameters.
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
  Future<List<SmsAccount>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsAccountTable>? orderByList,
    _i1.Transaction? transaction,
    SmsAccountInclude? include,
  }) async {
    return session.db.find<SmsAccount>(
      where: where?.call(SmsAccount.t),
      orderBy: orderBy?.call(SmsAccount.t),
      orderByList: orderByList?.call(SmsAccount.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [SmsAccount] matching the given query parameters.
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
  Future<SmsAccount?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsAccountTable>? where,
    int? offset,
    _i1.OrderByBuilder<SmsAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SmsAccountTable>? orderByList,
    _i1.Transaction? transaction,
    SmsAccountInclude? include,
  }) async {
    return session.db.findFirstRow<SmsAccount>(
      where: where?.call(SmsAccount.t),
      orderBy: orderBy?.call(SmsAccount.t),
      orderByList: orderByList?.call(SmsAccount.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [SmsAccount] by its [id] or null if no such row exists.
  Future<SmsAccount?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    SmsAccountInclude? include,
  }) async {
    return session.db.findById<SmsAccount>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [SmsAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [SmsAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SmsAccount>> insert(
    _i1.Session session,
    List<SmsAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SmsAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SmsAccount] and returns the inserted row.
  ///
  /// The returned [SmsAccount] will have its `id` field set.
  Future<SmsAccount> insertRow(
    _i1.Session session,
    SmsAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SmsAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SmsAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SmsAccount>> update(
    _i1.Session session,
    List<SmsAccount> rows, {
    _i1.ColumnSelections<SmsAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SmsAccount>(
      rows,
      columns: columns?.call(SmsAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SmsAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SmsAccount> updateRow(
    _i1.Session session,
    SmsAccount row, {
    _i1.ColumnSelections<SmsAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SmsAccount>(
      row,
      columns: columns?.call(SmsAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SmsAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SmsAccount?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<SmsAccountUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SmsAccount>(
      id,
      columnValues: columnValues(SmsAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SmsAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SmsAccount>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SmsAccountUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SmsAccountTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SmsAccountTable>? orderBy,
    _i1.OrderByListBuilder<SmsAccountTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SmsAccount>(
      columnValues: columnValues(SmsAccount.t.updateTable),
      where: where(SmsAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmsAccount.t),
      orderByList: orderByList?.call(SmsAccount.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SmsAccount]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SmsAccount>> delete(
    _i1.Session session,
    List<SmsAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SmsAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SmsAccount].
  Future<SmsAccount> deleteRow(
    _i1.Session session,
    SmsAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SmsAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SmsAccount>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SmsAccountTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SmsAccount>(
      where: where(SmsAccount.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SmsAccountTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SmsAccount>(
      where: where?.call(SmsAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class SmsAccountAttachRowRepository {
  const SmsAccountAttachRowRepository._();

  /// Creates a relation between the given [SmsAccount] and [AuthUser]
  /// by setting the [SmsAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    SmsAccount smsAccount,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (smsAccount.id == null) {
      throw ArgumentError.notNull('smsAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $smsAccount = smsAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<SmsAccount>(
      $smsAccount,
      columns: [SmsAccount.t.authUserId],
      transaction: transaction,
    );
  }
}
