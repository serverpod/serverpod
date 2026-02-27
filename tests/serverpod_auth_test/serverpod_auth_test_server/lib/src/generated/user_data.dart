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
import 'package:serverpod_auth_test_server/src/generated/protocol.dart' as _i3;

abstract class UserData
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserData._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.displayName,
    this.bio,
  });

  factory UserData({
    int? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String displayName,
    String? bio,
  }) = _UserDataImpl;

  factory UserData.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserData(
      id: jsonSerialization['id'] as int?,
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.AuthUser>(
              jsonSerialization['authUser'],
            ),
      displayName: jsonSerialization['displayName'] as String,
      bio: jsonSerialization['bio'] as String?,
    );
  }

  static final t = UserDataTable();

  static const db = UserDataRepository._();

  @override
  int? id;

  _i1.UuidValue authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUser? authUser;

  /// User's display name
  String displayName;

  /// User's bio
  String? bio;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserData copyWith({
    int? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUser? authUser,
    String? displayName,
    String? bio,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserData',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'displayName': displayName,
      if (bio != null) 'bio': bio,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserData',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJsonForProtocol(),
      'displayName': displayName,
      if (bio != null) 'bio': bio,
    };
  }

  static UserDataInclude include({_i2.AuthUserInclude? authUser}) {
    return UserDataInclude._(authUser: authUser);
  }

  static UserDataIncludeList includeList({
    _i1.WhereExpressionBuilder<UserDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserDataTable>? orderByList,
    UserDataInclude? include,
  }) {
    return UserDataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserData.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserData.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserDataImpl extends UserData {
  _UserDataImpl({
    int? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUser? authUser,
    required String displayName,
    String? bio,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         displayName: displayName,
         bio: bio,
       );

  /// Returns a shallow copy of this [UserData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserData copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? displayName,
    Object? bio = _Undefined,
  }) {
    return UserData(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i2.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      displayName: displayName ?? this.displayName,
      bio: bio is String? ? bio : this.bio,
    );
  }
}

class UserDataUpdateTable extends _i1.UpdateTable<UserDataTable> {
  UserDataUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authUserId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<String, String> displayName(String value) => _i1.ColumnValue(
    table.displayName,
    value,
  );

  _i1.ColumnValue<String, String> bio(String? value) => _i1.ColumnValue(
    table.bio,
    value,
  );
}

class UserDataTable extends _i1.Table<int?> {
  UserDataTable({super.tableRelation}) : super(tableName: 'user_data') {
    updateTable = UserDataUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    displayName = _i1.ColumnString(
      'displayName',
      this,
    );
    bio = _i1.ColumnString(
      'bio',
      this,
    );
  }

  late final UserDataUpdateTable updateTable;

  late final _i1.ColumnUuid authUserId;

  /// The [AuthUser] this profile belongs to
  _i2.AuthUserTable? _authUser;

  /// User's display name
  late final _i1.ColumnString displayName;

  /// User's bio
  late final _i1.ColumnString bio;

  _i2.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: UserData.t.authUserId,
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
    displayName,
    bio,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class UserDataInclude extends _i1.IncludeObject {
  UserDataInclude._({_i2.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<int?> get table => UserData.t;
}

class UserDataIncludeList extends _i1.IncludeList {
  UserDataIncludeList._({
    _i1.WhereExpressionBuilder<UserDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserData.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserData.t;
}

class UserDataRepository {
  const UserDataRepository._();

  final attachRow = const UserDataAttachRowRepository._();

  /// Returns a list of [UserData]s matching the given query parameters.
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
  Future<List<UserData>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserDataTable>? orderByList,
    _i1.Transaction? transaction,
    UserDataInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserData>(
      where: where?.call(UserData.t),
      orderBy: orderBy?.call(UserData.t),
      orderByList: orderByList?.call(UserData.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserData] matching the given query parameters.
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
  Future<UserData?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserDataTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserDataTable>? orderByList,
    _i1.Transaction? transaction,
    UserDataInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserData>(
      where: where?.call(UserData.t),
      orderBy: orderBy?.call(UserData.t),
      orderByList: orderByList?.call(UserData.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserData] by its [id] or null if no such row exists.
  Future<UserData?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    UserDataInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserData>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserData]s in the list and returns the inserted rows.
  ///
  /// The returned [UserData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<UserData>> insert(
    _i1.Session session,
    List<UserData> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<UserData>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [UserData] and returns the inserted row.
  ///
  /// The returned [UserData] will have its `id` field set.
  Future<UserData> insertRow(
    _i1.Session session,
    UserData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserData>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserData>> update(
    _i1.Session session,
    List<UserData> rows, {
    _i1.ColumnSelections<UserDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserData>(
      rows,
      columns: columns?.call(UserData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserData> updateRow(
    _i1.Session session,
    UserData row, {
    _i1.ColumnSelections<UserDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserData>(
      row,
      columns: columns?.call(UserData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserData] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserData?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserDataUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserData>(
      id,
      columnValues: columnValues(UserData.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserData]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserData>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserDataUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserDataTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserDataTable>? orderBy,
    _i1.OrderByListBuilder<UserDataTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserData>(
      columnValues: columnValues(UserData.t.updateTable),
      where: where(UserData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserData.t),
      orderByList: orderByList?.call(UserData.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserData]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserData>> delete(
    _i1.Session session,
    List<UserData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserData>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserData].
  Future<UserData> deleteRow(
    _i1.Session session,
    UserData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserData>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserData>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserDataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserData>(
      where: where(UserData.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserDataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserData>(
      where: where?.call(UserData.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserData] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserDataTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserData>(
      where: where(UserData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class UserDataAttachRowRepository {
  const UserDataAttachRowRepository._();

  /// Creates a relation between the given [UserData] and [AuthUser]
  /// by setting the [UserData]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    UserData userData,
    _i2.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (userData.id == null) {
      throw ArgumentError.notNull('userData.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $userData = userData.copyWith(authUserId: authUser.id);
    await session.db.updateRow<UserData>(
      $userData,
      columns: [UserData.t.authUserId],
      transaction: transaction,
    );
  }
}
