/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

/// Database bindings for a user image.
abstract class UserImage
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UserImage._({
    this.id,
    required this.userId,
    required this.version,
    required this.url,
  });

  factory UserImage({
    int? id,
    required int userId,
    required int version,
    required String url,
  }) = _UserImageImpl;

  factory UserImage.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserImage(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      version: jsonSerialization['version'] as int,
      url: jsonSerialization['url'] as String,
    );
  }

  static final t = UserImageTable();

  static const db = UserImageRepository._();

  @override
  int? id;

  /// The id of the user.
  int userId;

  /// Version of the image. Increased by one for every uploaded image.
  int version;

  /// The URL to the image.
  String url;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserImage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserImage copyWith({
    int? id,
    int? userId,
    int? version,
    String? url,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth.UserImage',
      if (id != null) 'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth.UserImage',
      if (id != null) 'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    };
  }

  static UserImageInclude include() {
    return UserImageInclude._();
  }

  static UserImageIncludeList includeList({
    _is.WhereExpressionBuilder<UserImageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserImageTable>? orderBy,
    _is.OrderByListBuilder<UserImageTable>? orderByList,
    UserImageInclude? include,
  }) {
    return UserImageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserImage.t),
      orderByList: orderByList?.call(UserImage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserImageImpl extends UserImage {
  _UserImageImpl({
    int? id,
    required int userId,
    required int version,
    required String url,
  }) : super._(
         id: id,
         userId: userId,
         version: version,
         url: url,
       );

  /// Returns a shallow copy of this [UserImage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserImage copyWith({
    Object? id = _Undefined,
    int? userId,
    int? version,
    String? url,
  }) {
    return UserImage(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      version: version ?? this.version,
      url: url ?? this.url,
    );
  }
}

class UserImageUpdateTable extends _is.UpdateTable<UserImageTable> {
  UserImageUpdateTable(super.table);

  _is.ColumnValue<int, int> userId(int value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<int, int> version(int value) => _is.ColumnValue(
    table.version,
    value,
  );

  _is.ColumnValue<String, String> url(String value) => _is.ColumnValue(
    table.url,
    value,
  );
}

class UserImageTable extends _is.Table<int?> {
  UserImageTable({super.tableRelation})
    : super(tableName: 'serverpod_user_image') {
    updateTable = UserImageUpdateTable(this);
    userId = _is.ColumnInt(
      'userId',
      this,
    );
    version = _is.ColumnInt(
      'version',
      this,
    );
    url = _is.ColumnString(
      'url',
      this,
    );
  }

  late final UserImageUpdateTable updateTable;

  /// The id of the user.
  late final _is.ColumnInt userId;

  /// Version of the image. Increased by one for every uploaded image.
  late final _is.ColumnInt version;

  /// The URL to the image.
  late final _is.ColumnString url;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    version,
    url,
  ];
}

class UserImageInclude extends _is.IncludeObject {
  UserImageInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UserImage.t;
}

class UserImageIncludeList extends _is.IncludeList {
  UserImageIncludeList._({
    _is.WhereExpressionBuilder<UserImageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserImage.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UserImage.t;
}

class UserImageRepository {
  const UserImageRepository._();

  /// Returns a list of [UserImage]s matching the given query parameters.
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
  Future<List<UserImage>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserImageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserImageTable>? orderBy,
    _is.OrderByListBuilder<UserImageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserImage>(
      where: where?.call(UserImage.t),
      orderBy: orderBy?.call(UserImage.t),
      orderByList: orderByList?.call(UserImage.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserImage] matching the given query parameters.
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
  Future<UserImage?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserImageTable>? where,
    int? offset,
    _is.OrderByBuilder<UserImageTable>? orderBy,
    _is.OrderByListBuilder<UserImageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserImage>(
      where: where?.call(UserImage.t),
      orderBy: orderBy?.call(UserImage.t),
      orderByList: orderByList?.call(UserImage.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserImage] by its [id] or null if no such row exists.
  Future<UserImage?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserImage>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserImage]s in the list and returns the inserted rows.
  ///
  /// The returned [UserImage]s will have their `id` fields set.
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
  Future<List<UserImage>> insert(
    _is.DatabaseSession session,
    List<UserImage> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UserImage>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UserImage] and returns the inserted row.
  ///
  /// The returned [UserImage] will have its `id` field set.
  Future<UserImage> insertRow(
    _is.DatabaseSession session,
    UserImage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserImage>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UserImage]s in the list and returns the resulting rows.
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
  /// The returned [UserImage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserImage>> upsert(
    _is.DatabaseSession session,
    List<UserImage> rows, {
    required _is.ColumnSelections<UserImageTable> conflictColumns,
    _is.ColumnSelections<UserImageTable>? updateColumns,
    _is.WhereExpressionBuilder<UserImageTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UserImage>(
      rows,
      conflictColumns: conflictColumns(UserImage.t),
      updateColumns: updateColumns?.call(UserImage.t),
      updateWhere: updateWhere?.call(UserImage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UserImage] and returns the resulting row.
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
  /// The returned [UserImage] will have its `id` field set.
  Future<UserImage?> upsertRow(
    _is.DatabaseSession session,
    UserImage row, {
    required _is.ColumnSelections<UserImageTable> conflictColumns,
    _is.ColumnSelections<UserImageTable>? updateColumns,
    _is.WhereExpressionBuilder<UserImageTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UserImage>(
      row,
      conflictColumns: conflictColumns(UserImage.t),
      updateColumns: updateColumns?.call(UserImage.t),
      updateWhere: updateWhere?.call(UserImage.t),
      transaction: transaction,
    );
  }

  /// Updates all [UserImage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserImage>> update(
    _is.DatabaseSession session,
    List<UserImage> rows, {
    _is.ColumnSelections<UserImageTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UserImage>(
      rows,
      columns: columns?.call(UserImage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UserImage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserImage> updateRow(
    _is.DatabaseSession session,
    UserImage row, {
    _is.ColumnSelections<UserImageTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserImage>(
      row,
      columns: columns?.call(UserImage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserImage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserImage?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UserImageUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UserImage>(
      id,
      columnValues: columnValues(UserImage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserImage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserImage>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UserImageUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UserImageTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserImageTable>? orderBy,
    _is.OrderByListBuilder<UserImageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UserImage>(
      columnValues: columnValues(UserImage.t.updateTable),
      where: where(UserImage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserImage.t),
      orderByList: orderByList?.call(UserImage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UserImage]s in the list and returns the deleted rows.
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
  Future<List<UserImage>> delete(
    _is.DatabaseSession session,
    List<UserImage> rows, {
    _is.OrderByBuilder<UserImageTable>? orderBy,
    _is.OrderByListBuilder<UserImageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UserImage>(
      rows,
      orderBy: orderBy?.call(UserImage.t),
      orderByList: orderByList?.call(UserImage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UserImage].
  Future<UserImage> deleteRow(
    _is.DatabaseSession session,
    UserImage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserImage>(
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
  Future<List<UserImage>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserImageTable> where,
    _is.OrderByBuilder<UserImageTable>? orderBy,
    _is.OrderByListBuilder<UserImageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UserImage>(
      where: where(UserImage.t),
      orderBy: orderBy?.call(UserImage.t),
      orderByList: orderByList?.call(UserImage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserImageTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UserImage>(
      where: where?.call(UserImage.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserImage] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserImageTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserImage>(
      where: where(UserImage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
