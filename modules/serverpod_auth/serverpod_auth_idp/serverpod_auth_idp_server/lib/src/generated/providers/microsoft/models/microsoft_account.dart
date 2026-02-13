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

/// A fully configured Microsoft account to be used for logins.
abstract class MicrosoftAccount
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  MicrosoftAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.userIdentifier,
    this.email,
    DateTime? created,
  }) : created = created ?? DateTime.now();

  factory MicrosoftAccount({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String userIdentifier,
    String? email,
    DateTime? created,
  }) = _MicrosoftAccountImpl;

  factory MicrosoftAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return MicrosoftAccount(
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

  static final t = MicrosoftAccountTable();

  static const db = MicrosoftAccountRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUser? authUser;

  /// The user identifier given by Microsoft for this account.
  String userIdentifier;

  /// The verified email of the user, as received from Microsoft.
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

  /// Returns a shallow copy of this [MicrosoftAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MicrosoftAccount copyWith({
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
      '__className__': 'serverpod_auth_idp.MicrosoftAccount',
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

  static MicrosoftAccountInclude include({_i2.AuthUserInclude? authUser}) {
    return MicrosoftAccountInclude._(authUser: authUser);
  }

  static MicrosoftAccountIncludeList includeList({
    _i1.WhereExpressionBuilder<MicrosoftAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MicrosoftAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MicrosoftAccountTable>? orderByList,
    MicrosoftAccountInclude? include,
  }) {
    return MicrosoftAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MicrosoftAccount.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MicrosoftAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MicrosoftAccountImpl extends MicrosoftAccount {
  _MicrosoftAccountImpl({
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

  /// Returns a shallow copy of this [MicrosoftAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MicrosoftAccount copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? userIdentifier,
    Object? email = _Undefined,
    DateTime? created,
  }) {
    return MicrosoftAccount(
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

class MicrosoftAccountUpdateTable
    extends _i1.UpdateTable<MicrosoftAccountTable> {
  MicrosoftAccountUpdateTable(super.table);

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

class MicrosoftAccountTable extends _i1.Table<_i1.UuidValue?> {
  MicrosoftAccountTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_microsoft_account') {
    updateTable = MicrosoftAccountUpdateTable(this);
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

  late final MicrosoftAccountUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUserTable? _authUser;

  /// The user identifier given by Microsoft for this account.
  late final _i1.ColumnString userIdentifier;

  /// The verified email of the user, as received from Microsoft.
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
      field: MicrosoftAccount.t.authUserId,
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

class MicrosoftAccountInclude extends _i1.IncludeObject {
  MicrosoftAccountInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => MicrosoftAccount.t;
}

class MicrosoftAccountIncludeList extends _i1.IncludeList {
  MicrosoftAccountIncludeList._({
    _i1.WhereExpressionBuilder<MicrosoftAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MicrosoftAccount.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => MicrosoftAccount.t;
}

class MicrosoftAccountRepository {
  const MicrosoftAccountRepository._();

  final attachRow = const MicrosoftAccountAttachRowRepository._();

  /// Returns a list of [MicrosoftAccount]s matching the given query parameters.
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
  Future<List<MicrosoftAccount>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MicrosoftAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MicrosoftAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MicrosoftAccountTable>? orderByList,
    _i1.Transaction? transaction,
    MicrosoftAccountInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MicrosoftAccount>(
      where: where?.call(MicrosoftAccount.t),
      orderBy: orderBy?.call(MicrosoftAccount.t),
      orderByList: orderByList?.call(MicrosoftAccount.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MicrosoftAccount] matching the given query parameters.
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
  Future<MicrosoftAccount?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MicrosoftAccountTable>? where,
    int? offset,
    _i1.OrderByBuilder<MicrosoftAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MicrosoftAccountTable>? orderByList,
    _i1.Transaction? transaction,
    MicrosoftAccountInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MicrosoftAccount>(
      where: where?.call(MicrosoftAccount.t),
      orderBy: orderBy?.call(MicrosoftAccount.t),
      orderByList: orderByList?.call(MicrosoftAccount.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MicrosoftAccount] by its [id] or null if no such row exists.
  Future<MicrosoftAccount?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    MicrosoftAccountInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MicrosoftAccount>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MicrosoftAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [MicrosoftAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MicrosoftAccount>> insert(
    _i1.Session session,
    List<MicrosoftAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MicrosoftAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MicrosoftAccount] and returns the inserted row.
  ///
  /// The returned [MicrosoftAccount] will have its `id` field set.
  Future<MicrosoftAccount> insertRow(
    _i1.Session session,
    MicrosoftAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MicrosoftAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MicrosoftAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MicrosoftAccount>> update(
    _i1.Session session,
    List<MicrosoftAccount> rows, {
    _i1.ColumnSelections<MicrosoftAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MicrosoftAccount>(
      rows,
      columns: columns?.call(MicrosoftAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MicrosoftAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MicrosoftAccount> updateRow(
    _i1.Session session,
    MicrosoftAccount row, {
    _i1.ColumnSelections<MicrosoftAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MicrosoftAccount>(
      row,
      columns: columns?.call(MicrosoftAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MicrosoftAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MicrosoftAccount?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<MicrosoftAccountUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<MicrosoftAccount>(
      id,
      columnValues: columnValues(MicrosoftAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MicrosoftAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<MicrosoftAccount>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<MicrosoftAccountUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<MicrosoftAccountTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MicrosoftAccountTable>? orderBy,
    _i1.OrderByListBuilder<MicrosoftAccountTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<MicrosoftAccount>(
      columnValues: columnValues(MicrosoftAccount.t.updateTable),
      where: where(MicrosoftAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MicrosoftAccount.t),
      orderByList: orderByList?.call(MicrosoftAccount.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [MicrosoftAccount]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MicrosoftAccount>> delete(
    _i1.Session session,
    List<MicrosoftAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MicrosoftAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MicrosoftAccount].
  Future<MicrosoftAccount> deleteRow(
    _i1.Session session,
    MicrosoftAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MicrosoftAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MicrosoftAccount>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MicrosoftAccountTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MicrosoftAccount>(
      where: where(MicrosoftAccount.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MicrosoftAccountTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MicrosoftAccount>(
      where: where?.call(MicrosoftAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MicrosoftAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MicrosoftAccountTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MicrosoftAccount>(
      where: where(MicrosoftAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class MicrosoftAccountAttachRowRepository {
  const MicrosoftAccountAttachRowRepository._();

  /// Creates a relation between the given [MicrosoftAccount] and [AuthUser]
  /// by setting the [MicrosoftAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    MicrosoftAccount microsoftAccount,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (microsoftAccount.id == null) {
      throw ArgumentError.notNull('microsoftAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $microsoftAccount = microsoftAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<MicrosoftAccount>(
      $microsoftAccount,
      columns: [MicrosoftAccount.t.authUserId],
      transaction: transaction,
    );
  }
}
