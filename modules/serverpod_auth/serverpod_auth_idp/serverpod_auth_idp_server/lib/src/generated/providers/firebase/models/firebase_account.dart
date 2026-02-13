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

/// A fully configured Firebase account to be used for logins.
abstract class FirebaseAccount
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  FirebaseAccount._({
    this.id,
    required this.authUserId,
    this.authUser,
    DateTime? created,
    this.email,
    this.phone,
    required this.userIdentifier,
  }) : created = created ?? DateTime.now();

  factory FirebaseAccount({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? created,
    String? email,
    String? phone,
    required String userIdentifier,
  }) = _FirebaseAccountImpl;

  factory FirebaseAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return FirebaseAccount(
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
      created: jsonSerialization['created'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      userIdentifier: jsonSerialization['userIdentifier'] as String,
    );
  }

  static final t = FirebaseAccountTable();

  static const db = FirebaseAccountRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUser? authUser;

  /// The time when this authentication was created.
  DateTime created;

  /// The verified email of the user, as received from Firebase.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups.
  ///
  /// Stored in lower-case.
  String? email;

  /// The phone number of the user, as received from Firebase.
  ///
  /// Only populated when using phone authentication.
  String? phone;

  /// The user identifier given by Firebase for this account.
  String userIdentifier;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [FirebaseAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FirebaseAccount copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    DateTime? created,
    String? email,
    String? phone,
    String? userIdentifier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.FirebaseAccount',
      if (id != null) 'id': id?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'created': created.toJson(),
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      'userIdentifier': userIdentifier,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static FirebaseAccountInclude include({_i2.AuthUserInclude? authUser}) {
    return FirebaseAccountInclude._(authUser: authUser);
  }

  static FirebaseAccountIncludeList includeList({
    _i1.WhereExpressionBuilder<FirebaseAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FirebaseAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FirebaseAccountTable>? orderByList,
    FirebaseAccountInclude? include,
  }) {
    return FirebaseAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FirebaseAccount.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FirebaseAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FirebaseAccountImpl extends FirebaseAccount {
  _FirebaseAccountImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    DateTime? created,
    String? email,
    String? phone,
    required String userIdentifier,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         created: created,
         email: email,
         phone: phone,
         userIdentifier: userIdentifier,
       );

  /// Returns a shallow copy of this [FirebaseAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FirebaseAccount copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? created,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    String? userIdentifier,
  }) {
    return FirebaseAccount(
      id: id is _i1.UuidValue? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      created: created ?? this.created,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      userIdentifier: userIdentifier ?? this.userIdentifier,
    );
  }
}

class FirebaseAccountUpdateTable extends _i1.UpdateTable<FirebaseAccountTable> {
  FirebaseAccountUpdateTable(super.table);

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

  _i1.ColumnValue<String, String> email(String? value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> phone(String? value) => _i1.ColumnValue(
    table.phone,
    value,
  );

  _i1.ColumnValue<String, String> userIdentifier(String value) =>
      _i1.ColumnValue(
        table.userIdentifier,
        value,
      );
}

class FirebaseAccountTable extends _i1.Table<_i1.UuidValue?> {
  FirebaseAccountTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_firebase_account') {
    updateTable = FirebaseAccountUpdateTable(this);
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
    phone = _i1.ColumnString(
      'phone',
      this,
    );
    userIdentifier = _i1.ColumnString(
      'userIdentifier',
      this,
    );
  }

  late final FirebaseAccountUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUserTable? _authUser;

  /// The time when this authentication was created.
  late final _i1.ColumnDateTime created;

  /// The verified email of the user, as received from Firebase.
  ///
  /// Logins all work through the [userIdentifier], but the email is retained
  /// for consolidation look-ups.
  ///
  /// Stored in lower-case.
  late final _i1.ColumnString email;

  /// The phone number of the user, as received from Firebase.
  ///
  /// Only populated when using phone authentication.
  late final _i1.ColumnString phone;

  /// The user identifier given by Firebase for this account.
  late final _i1.ColumnString userIdentifier;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: FirebaseAccount.t.authUserId,
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
    phone,
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

class FirebaseAccountInclude extends _i1.IncludeObject {
  FirebaseAccountInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<_i1.UuidValue?> get table => FirebaseAccount.t;
}

class FirebaseAccountIncludeList extends _i1.IncludeList {
  FirebaseAccountIncludeList._({
    _i1.WhereExpressionBuilder<FirebaseAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FirebaseAccount.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => FirebaseAccount.t;
}

class FirebaseAccountRepository {
  const FirebaseAccountRepository._();

  final attachRow = const FirebaseAccountAttachRowRepository._();

  /// Returns a list of [FirebaseAccount]s matching the given query parameters.
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
  Future<List<FirebaseAccount>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FirebaseAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FirebaseAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FirebaseAccountTable>? orderByList,
    _i1.Transaction? transaction,
    FirebaseAccountInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FirebaseAccount>(
      where: where?.call(FirebaseAccount.t),
      orderBy: orderBy?.call(FirebaseAccount.t),
      orderByList: orderByList?.call(FirebaseAccount.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FirebaseAccount] matching the given query parameters.
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
  Future<FirebaseAccount?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FirebaseAccountTable>? where,
    int? offset,
    _i1.OrderByBuilder<FirebaseAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FirebaseAccountTable>? orderByList,
    _i1.Transaction? transaction,
    FirebaseAccountInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FirebaseAccount>(
      where: where?.call(FirebaseAccount.t),
      orderBy: orderBy?.call(FirebaseAccount.t),
      orderByList: orderByList?.call(FirebaseAccount.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FirebaseAccount] by its [id] or null if no such row exists.
  Future<FirebaseAccount?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    FirebaseAccountInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FirebaseAccount>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FirebaseAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [FirebaseAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<FirebaseAccount>> insert(
    _i1.Session session,
    List<FirebaseAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<FirebaseAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [FirebaseAccount] and returns the inserted row.
  ///
  /// The returned [FirebaseAccount] will have its `id` field set.
  Future<FirebaseAccount> insertRow(
    _i1.Session session,
    FirebaseAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FirebaseAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FirebaseAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FirebaseAccount>> update(
    _i1.Session session,
    List<FirebaseAccount> rows, {
    _i1.ColumnSelections<FirebaseAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FirebaseAccount>(
      rows,
      columns: columns?.call(FirebaseAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FirebaseAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FirebaseAccount> updateRow(
    _i1.Session session,
    FirebaseAccount row, {
    _i1.ColumnSelections<FirebaseAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FirebaseAccount>(
      row,
      columns: columns?.call(FirebaseAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FirebaseAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FirebaseAccount?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<FirebaseAccountUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FirebaseAccount>(
      id,
      columnValues: columnValues(FirebaseAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FirebaseAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FirebaseAccount>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<FirebaseAccountUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<FirebaseAccountTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FirebaseAccountTable>? orderBy,
    _i1.OrderByListBuilder<FirebaseAccountTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FirebaseAccount>(
      columnValues: columnValues(FirebaseAccount.t.updateTable),
      where: where(FirebaseAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FirebaseAccount.t),
      orderByList: orderByList?.call(FirebaseAccount.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FirebaseAccount]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FirebaseAccount>> delete(
    _i1.Session session,
    List<FirebaseAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FirebaseAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FirebaseAccount].
  Future<FirebaseAccount> deleteRow(
    _i1.Session session,
    FirebaseAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FirebaseAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FirebaseAccount>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FirebaseAccountTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FirebaseAccount>(
      where: where(FirebaseAccount.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FirebaseAccountTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FirebaseAccount>(
      where: where?.call(FirebaseAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FirebaseAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FirebaseAccountTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FirebaseAccount>(
      where: where(FirebaseAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class FirebaseAccountAttachRowRepository {
  const FirebaseAccountAttachRowRepository._();

  /// Creates a relation between the given [FirebaseAccount] and [AuthUser]
  /// by setting the [FirebaseAccount]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    FirebaseAccount firebaseAccount,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (firebaseAccount.id == null) {
      throw ArgumentError.notNull('firebaseAccount.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $firebaseAccount = firebaseAccount.copyWith(authUserId: authUser.id);
    await session.db.updateRow<FirebaseAccount>(
      $firebaseAccount,
      columns: [FirebaseAccount.t.authUserId],
      transaction: transaction,
    );
  }
}
