/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class MigratedUser
    implements _i1.TableRow<int>, _i1.ProtocolSerialization {
  MigratedUser._({
    this.id,
    required this.oldUserId,
    required this.newUserId,
  });

  factory MigratedUser({
    int? id,
    required int oldUserId,
    required _i1.UuidValue newUserId,
  }) = _MigratedUserImpl;

  factory MigratedUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return MigratedUser(
      id: jsonSerialization['id'] as int?,
      oldUserId: jsonSerialization['oldUserId'] as int,
      newUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['newUserId']),
    );
  }

  static final t = MigratedUserTable();

  static const db = MigratedUserRepository._();

  @override
  int? id;

  int oldUserId;

  _i1.UuidValue newUserId;

  @override
  _i1.Table<int> get table => t;

  /// Returns a shallow copy of this [MigratedUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MigratedUser copyWith({
    int? id,
    int? oldUserId,
    _i1.UuidValue? newUserId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'oldUserId': oldUserId,
      'newUserId': newUserId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'oldUserId': oldUserId,
      'newUserId': newUserId.toJson(),
    };
  }

  static MigratedUserInclude include() {
    return MigratedUserInclude._();
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
    required _i1.UuidValue newUserId,
  }) : super._(
          id: id,
          oldUserId: oldUserId,
          newUserId: newUserId,
        );

  /// Returns a shallow copy of this [MigratedUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MigratedUser copyWith({
    Object? id = _Undefined,
    int? oldUserId,
    _i1.UuidValue? newUserId,
  }) {
    return MigratedUser(
      id: id is int? ? id : this.id,
      oldUserId: oldUserId ?? this.oldUserId,
      newUserId: newUserId ?? this.newUserId,
    );
  }
}

class MigratedUserTable extends _i1.Table<int> {
  MigratedUserTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_migration_user') {
    oldUserId = _i1.ColumnInt(
      'oldUserId',
      this,
    );
    newUserId = _i1.ColumnUuid(
      'newUserId',
      this,
    );
  }

  late final _i1.ColumnInt oldUserId;

  late final _i1.ColumnUuid newUserId;

  @override
  List<_i1.Column> get columns => [
        id,
        oldUserId,
        newUserId,
      ];
}

class MigratedUserInclude extends _i1.IncludeObject {
  MigratedUserInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int> get table => MigratedUser.t;
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
  _i1.Table<int> get table => MigratedUser.t;
}

class MigratedUserRepository {
  const MigratedUserRepository._();

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
  }) async {
    return session.db.find<MigratedUser>(
      where: where?.call(MigratedUser.t),
      orderBy: orderBy?.call(MigratedUser.t),
      orderByList: orderByList?.call(MigratedUser.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
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
  }) async {
    return session.db.findFirstRow<MigratedUser>(
      where: where?.call(MigratedUser.t),
      orderBy: orderBy?.call(MigratedUser.t),
      orderByList: orderByList?.call(MigratedUser.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [MigratedUser] by its [id] or null if no such row exists.
  Future<MigratedUser?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MigratedUser>(
      id,
      transaction: transaction,
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
