/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i2;
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart'
    as _i3;

abstract class MigratedUser
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MigratedUser._({
    this.id,
    required this.oldUserId,
    this.oldUser,
    required this.newAuthUserId,
    this.newAuthUser,
  });

  factory MigratedUser({
    int? id,
    required int oldUserId,
    _i2.UserInfo? oldUser,
    required _i1.UuidValue newAuthUserId,
    _i3.AuthUser? newAuthUser,
  }) = _MigratedUserImpl;

  factory MigratedUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return MigratedUser(
      id: jsonSerialization['id'] as int?,
      oldUserId: jsonSerialization['oldUserId'] as int,
      oldUser: jsonSerialization['oldUser'] == null
          ? null
          : _i2.UserInfo.fromJson(
              (jsonSerialization['oldUser'] as Map<String, dynamic>)),
      newAuthUserId: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['newAuthUserId']),
      newAuthUser: jsonSerialization['newAuthUser'] == null
          ? null
          : _i3.AuthUser.fromJson(
              (jsonSerialization['newAuthUser'] as Map<String, dynamic>)),
    );
  }

  static final t = MigratedUserTable();

  static const db = MigratedUserRepository._();

  @override
  int? id;

  int oldUserId;

  /// The [UserInfo] object which was migrated to the new user.
  _i2.UserInfo? oldUser;

  _i1.UuidValue newAuthUserId;

  /// The [AuthUser] the old user was migrated to.
  _i3.AuthUser? newAuthUser;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MigratedUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MigratedUser copyWith({
    int? id,
    int? oldUserId,
    _i2.UserInfo? oldUser,
    _i1.UuidValue? newAuthUserId,
    _i3.AuthUser? newAuthUser,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'oldUserId': oldUserId,
      if (oldUser != null) 'oldUser': oldUser?.toJson(),
      'newAuthUserId': newAuthUserId.toJson(),
      if (newAuthUser != null) 'newAuthUser': newAuthUser?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id};
  }

  static MigratedUserInclude include({
    _i2.UserInfoInclude? oldUser,
    _i3.AuthUserInclude? newAuthUser,
  }) {
    return MigratedUserInclude._(
      oldUser: oldUser,
      newAuthUser: newAuthUser,
    );
  }

  static MigratedUserIncludeList includeList({
    _i1.WhereExpressionBuilder<MigratedUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MigratedUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MigratedUserTable>? orderByList,
    MigratedUserInclude? include,
  }) {
    return MigratedUserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MigratedUser.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MigratedUser.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MigratedUserImpl extends MigratedUser {
  _MigratedUserImpl({
    int? id,
    required int oldUserId,
    _i2.UserInfo? oldUser,
    required _i1.UuidValue newAuthUserId,
    _i3.AuthUser? newAuthUser,
  }) : super._(
          id: id,
          oldUserId: oldUserId,
          oldUser: oldUser,
          newAuthUserId: newAuthUserId,
          newAuthUser: newAuthUser,
        );

  /// Returns a shallow copy of this [MigratedUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MigratedUser copyWith({
    Object? id = _Undefined,
    int? oldUserId,
    Object? oldUser = _Undefined,
    _i1.UuidValue? newAuthUserId,
    Object? newAuthUser = _Undefined,
  }) {
    return MigratedUser(
      id: id is int? ? id : this.id,
      oldUserId: oldUserId ?? this.oldUserId,
      oldUser: oldUser is _i2.UserInfo? ? oldUser : this.oldUser?.copyWith(),
      newAuthUserId: newAuthUserId ?? this.newAuthUserId,
      newAuthUser: newAuthUser is _i3.AuthUser?
          ? newAuthUser
          : this.newAuthUser?.copyWith(),
    );
  }
}

class MigratedUserTable extends _i1.Table<int?> {
  MigratedUserTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_migration_migrated_user') {
    oldUserId = _i1.ColumnInt(
      'oldUserId',
      this,
    );
    newAuthUserId = _i1.ColumnUuid(
      'newAuthUserId',
      this,
    );
  }

  late final _i1.ColumnInt oldUserId;

  /// The [UserInfo] object which was migrated to the new user.
  _i2.UserInfoTable? _oldUser;

  late final _i1.ColumnUuid newAuthUserId;

  /// The [AuthUser] the old user was migrated to.
  _i3.AuthUserTable? _newAuthUser;

  _i2.UserInfoTable get oldUser {
    if (_oldUser != null) return _oldUser!;
    _oldUser = _i1.createRelationTable(
      relationFieldName: 'oldUser',
      field: MigratedUser.t.oldUserId,
      foreignField: _i2.UserInfo.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserInfoTable(tableRelation: foreignTableRelation),
    );
    return _oldUser!;
  }

  _i3.AuthUserTable get newAuthUser {
    if (_newAuthUser != null) return _newAuthUser!;
    _newAuthUser = _i1.createRelationTable(
      relationFieldName: 'newAuthUser',
      field: MigratedUser.t.newAuthUserId,
      foreignField: _i3.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _newAuthUser!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        oldUserId,
        newAuthUserId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'oldUser') {
      return oldUser;
    }
    if (relationField == 'newAuthUser') {
      return newAuthUser;
    }
    return null;
  }
}

class MigratedUserInclude extends _i1.IncludeObject {
  MigratedUserInclude._({
    _i2.UserInfoInclude? oldUser,
    _i3.AuthUserInclude? newAuthUser,
  }) {
    _oldUser = oldUser;
    _newAuthUser = newAuthUser;
  }

  _i2.UserInfoInclude? _oldUser;

  _i3.AuthUserInclude? _newAuthUser;

  @override
  Map<String, _i1.Include?> get includes => {
        'oldUser': _oldUser,
        'newAuthUser': _newAuthUser,
      };

  @override
  _i1.Table<int?> get table => MigratedUser.t;
}

class MigratedUserIncludeList extends _i1.IncludeList {
  MigratedUserIncludeList._({
    _i1.WhereExpressionBuilder<MigratedUserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MigratedUser.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MigratedUser.t;
}

class MigratedUserRepository {
  const MigratedUserRepository._();

  final attachRow = const MigratedUserAttachRowRepository._();

  /// Returns a list of [MigratedUser]s matching the given query parameters.
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
  Future<List<MigratedUser>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MigratedUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MigratedUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MigratedUserTable>? orderByList,
    _i1.Transaction? transaction,
    MigratedUserInclude? include,
  }) async {
    return session.db.find<MigratedUser>(
      where: where?.call(MigratedUser.t),
      orderBy: orderBy?.call(MigratedUser.t),
      orderByList: orderByList?.call(MigratedUser.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [MigratedUser] matching the given query parameters.
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
  Future<MigratedUser?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MigratedUserTable>? where,
    int? offset,
    _i1.OrderByBuilder<MigratedUserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MigratedUserTable>? orderByList,
    _i1.Transaction? transaction,
    MigratedUserInclude? include,
  }) async {
    return session.db.findFirstRow<MigratedUser>(
      where: where?.call(MigratedUser.t),
      orderBy: orderBy?.call(MigratedUser.t),
      orderByList: orderByList?.call(MigratedUser.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [MigratedUser] by its [id] or null if no such row exists.
  Future<MigratedUser?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    MigratedUserInclude? include,
  }) async {
    return session.db.findById<MigratedUser>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [MigratedUser]s in the list and returns the inserted rows.
  ///
  /// The returned [MigratedUser]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MigratedUser>> insert(
    _i1.Session session,
    List<MigratedUser> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MigratedUser>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MigratedUser] and returns the inserted row.
  ///
  /// The returned [MigratedUser] will have its `id` field set.
  Future<MigratedUser> insertRow(
    _i1.Session session,
    MigratedUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MigratedUser>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MigratedUser]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MigratedUser>> update(
    _i1.Session session,
    List<MigratedUser> rows, {
    _i1.ColumnSelections<MigratedUserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MigratedUser>(
      rows,
      columns: columns?.call(MigratedUser.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MigratedUser]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MigratedUser> updateRow(
    _i1.Session session,
    MigratedUser row, {
    _i1.ColumnSelections<MigratedUserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MigratedUser>(
      row,
      columns: columns?.call(MigratedUser.t),
      transaction: transaction,
    );
  }

  /// Deletes all [MigratedUser]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MigratedUser>> delete(
    _i1.Session session,
    List<MigratedUser> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MigratedUser>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MigratedUser].
  Future<MigratedUser> deleteRow(
    _i1.Session session,
    MigratedUser row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MigratedUser>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MigratedUser>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MigratedUserTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MigratedUser>(
      where: where(MigratedUser.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MigratedUserTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MigratedUser>(
      where: where?.call(MigratedUser.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class MigratedUserAttachRowRepository {
  const MigratedUserAttachRowRepository._();

  /// Creates a relation between the given [MigratedUser] and [UserInfo]
  /// by setting the [MigratedUser]'s foreign key `oldUserId` to refer to the [UserInfo].
  Future<void> oldUser(
    _i1.Session session,
    MigratedUser migratedUser,
    _i2.UserInfo oldUser, {
    _i1.Transaction? transaction,
  }) async {
    if (migratedUser.id == null) {
      throw ArgumentError.notNull('migratedUser.id');
    }
    if (oldUser.id == null) {
      throw ArgumentError.notNull('oldUser.id');
    }

    var $migratedUser = migratedUser.copyWith(oldUserId: oldUser.id);
    await session.db.updateRow<MigratedUser>(
      $migratedUser,
      columns: [MigratedUser.t.oldUserId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [MigratedUser] and [AuthUser]
  /// by setting the [MigratedUser]'s foreign key `newAuthUserId` to refer to the [AuthUser].
  Future<void> newAuthUser(
    _i1.Session session,
    MigratedUser migratedUser,
    _i3.AuthUser newAuthUser, {
    _i1.Transaction? transaction,
  }) async {
    if (migratedUser.id == null) {
      throw ArgumentError.notNull('migratedUser.id');
    }
    if (newAuthUser.id == null) {
      throw ArgumentError.notNull('newAuthUser.id');
    }

    var $migratedUser = migratedUser.copyWith(newAuthUserId: newAuthUser.id);
    await session.db.updateRow<MigratedUser>(
      $migratedUser,
      columns: [MigratedUser.t.newAuthUserId],
      transaction: transaction,
    );
  }
}
