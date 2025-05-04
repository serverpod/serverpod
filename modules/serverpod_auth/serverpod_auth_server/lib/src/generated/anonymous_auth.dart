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

/// Database bindings for a sign in with email.
abstract class AnonymousAuth
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AnonymousAuth._({
    this.id,
    required this.userId,
    required this.hash,
  });

  factory AnonymousAuth({
    int? id,
    required int userId,
    required String hash,
  }) = _AnonymousAuthImpl;

  factory AnonymousAuth.fromJson(Map<String, dynamic> jsonSerialization) {
    return AnonymousAuth(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      hash: jsonSerialization['hash'] as String,
    );
  }

  static final t = AnonymousAuthTable();

  static const db = AnonymousAuthRepository._();

  @override
  int? id;

  /// The id of the user, corresponds to the id field in [UserInfo].
  int userId;

  /// The hashed password of the user.
  String hash;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AnonymousAuth]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AnonymousAuth copyWith({
    int? id,
    int? userId,
    String? hash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'hash': hash,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'hash': hash,
    };
  }

  static AnonymousAuthInclude include() {
    return AnonymousAuthInclude._();
  }

  static AnonymousAuthIncludeList includeList({
    _i1.WhereExpressionBuilder<AnonymousAuthTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnonymousAuthTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnonymousAuthTable>? orderByList,
    AnonymousAuthInclude? include,
  }) {
    return AnonymousAuthIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AnonymousAuth.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AnonymousAuth.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnonymousAuthImpl extends AnonymousAuth {
  _AnonymousAuthImpl({
    int? id,
    required int userId,
    required String hash,
  }) : super._(
          id: id,
          userId: userId,
          hash: hash,
        );

  /// Returns a shallow copy of this [AnonymousAuth]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AnonymousAuth copyWith({
    Object? id = _Undefined,
    int? userId,
    String? hash,
  }) {
    return AnonymousAuth(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      hash: hash ?? this.hash,
    );
  }
}

class AnonymousAuthTable extends _i1.Table<int?> {
  AnonymousAuthTable({super.tableRelation})
      : super(tableName: 'serverpod_anonymous_auth') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    hash = _i1.ColumnString(
      'hash',
      this,
    );
  }

  /// The id of the user, corresponds to the id field in [UserInfo].
  late final _i1.ColumnInt userId;

  /// The hashed password of the user.
  late final _i1.ColumnString hash;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        hash,
      ];
}

class AnonymousAuthInclude extends _i1.IncludeObject {
  AnonymousAuthInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AnonymousAuth.t;
}

class AnonymousAuthIncludeList extends _i1.IncludeList {
  AnonymousAuthIncludeList._({
    _i1.WhereExpressionBuilder<AnonymousAuthTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AnonymousAuth.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AnonymousAuth.t;
}

class AnonymousAuthRepository {
  const AnonymousAuthRepository._();

  /// Returns a list of [AnonymousAuth]s matching the given query parameters.
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
  Future<List<AnonymousAuth>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnonymousAuthTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnonymousAuthTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnonymousAuthTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AnonymousAuth>(
      where: where?.call(AnonymousAuth.t),
      orderBy: orderBy?.call(AnonymousAuth.t),
      orderByList: orderByList?.call(AnonymousAuth.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AnonymousAuth] matching the given query parameters.
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
  Future<AnonymousAuth?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnonymousAuthTable>? where,
    int? offset,
    _i1.OrderByBuilder<AnonymousAuthTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnonymousAuthTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AnonymousAuth>(
      where: where?.call(AnonymousAuth.t),
      orderBy: orderBy?.call(AnonymousAuth.t),
      orderByList: orderByList?.call(AnonymousAuth.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AnonymousAuth] by its [id] or null if no such row exists.
  Future<AnonymousAuth?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AnonymousAuth>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AnonymousAuth]s in the list and returns the inserted rows.
  ///
  /// The returned [AnonymousAuth]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AnonymousAuth>> insert(
    _i1.Session session,
    List<AnonymousAuth> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AnonymousAuth>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AnonymousAuth] and returns the inserted row.
  ///
  /// The returned [AnonymousAuth] will have its `id` field set.
  Future<AnonymousAuth> insertRow(
    _i1.Session session,
    AnonymousAuth row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AnonymousAuth>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AnonymousAuth]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AnonymousAuth>> update(
    _i1.Session session,
    List<AnonymousAuth> rows, {
    _i1.ColumnSelections<AnonymousAuthTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AnonymousAuth>(
      rows,
      columns: columns?.call(AnonymousAuth.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AnonymousAuth]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AnonymousAuth> updateRow(
    _i1.Session session,
    AnonymousAuth row, {
    _i1.ColumnSelections<AnonymousAuthTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AnonymousAuth>(
      row,
      columns: columns?.call(AnonymousAuth.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AnonymousAuth]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AnonymousAuth>> delete(
    _i1.Session session,
    List<AnonymousAuth> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AnonymousAuth>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AnonymousAuth].
  Future<AnonymousAuth> deleteRow(
    _i1.Session session,
    AnonymousAuth row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AnonymousAuth>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AnonymousAuth>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AnonymousAuthTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AnonymousAuth>(
      where: where(AnonymousAuth.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnonymousAuthTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AnonymousAuth>(
      where: where?.call(AnonymousAuth.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
