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

/// Database bindings for a Google refresh token.
abstract class GoogleRefreshToken
    implements _i1.TableRow, _i1.ProtocolSerialization {
  GoogleRefreshToken._({
    this.id,
    required this.userId,
    required this.refreshToken,
  });

  factory GoogleRefreshToken({
    int? id,
    required int userId,
    required String refreshToken,
  }) = _GoogleRefreshTokenImpl;

  factory GoogleRefreshToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return GoogleRefreshToken(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      refreshToken: jsonSerialization['refreshToken'] as String,
    );
  }

  static final t = GoogleRefreshTokenTable();

  static const db = GoogleRefreshTokenRepository._();

  @override
  int? id;

  /// The user id associated with the token.
  int userId;

  /// The token itself.
  String refreshToken;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [GoogleRefreshToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GoogleRefreshToken copyWith({
    int? id,
    int? userId,
    String? refreshToken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'refreshToken': refreshToken,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'refreshToken': refreshToken,
    };
  }

  static GoogleRefreshTokenInclude include() {
    return GoogleRefreshTokenInclude._();
  }

  static GoogleRefreshTokenIncludeList includeList({
    _i1.WhereExpressionBuilder<GoogleRefreshTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GoogleRefreshTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GoogleRefreshTokenTable>? orderByList,
    GoogleRefreshTokenInclude? include,
  }) {
    return GoogleRefreshTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GoogleRefreshToken.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(GoogleRefreshToken.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GoogleRefreshTokenImpl extends GoogleRefreshToken {
  _GoogleRefreshTokenImpl({
    int? id,
    required int userId,
    required String refreshToken,
  }) : super._(
          id: id,
          userId: userId,
          refreshToken: refreshToken,
        );

  /// Returns a shallow copy of this [GoogleRefreshToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GoogleRefreshToken copyWith({
    Object? id = _Undefined,
    int? userId,
    String? refreshToken,
  }) {
    return GoogleRefreshToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

class GoogleRefreshTokenTable extends _i1.Table {
  GoogleRefreshTokenTable({super.tableRelation})
      : super(tableName: 'serverpod_google_refresh_token') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    refreshToken = _i1.ColumnString(
      'refreshToken',
      this,
    );
  }

  /// The user id associated with the token.
  late final _i1.ColumnInt userId;

  /// The token itself.
  late final _i1.ColumnString refreshToken;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        refreshToken,
      ];
}

class GoogleRefreshTokenInclude extends _i1.IncludeObject {
  GoogleRefreshTokenInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => GoogleRefreshToken.t;
}

class GoogleRefreshTokenIncludeList extends _i1.IncludeList {
  GoogleRefreshTokenIncludeList._({
    _i1.WhereExpressionBuilder<GoogleRefreshTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(GoogleRefreshToken.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => GoogleRefreshToken.t;
}

class GoogleRefreshTokenRepository {
  const GoogleRefreshTokenRepository._();

  /// Returns a list of [GoogleRefreshToken]s matching the given query parameters.
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
  Future<List<GoogleRefreshToken>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GoogleRefreshTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GoogleRefreshTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GoogleRefreshTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<GoogleRefreshToken>(
      where: where?.call(GoogleRefreshToken.t),
      orderBy: orderBy?.call(GoogleRefreshToken.t),
      orderByList: orderByList?.call(GoogleRefreshToken.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [GoogleRefreshToken] matching the given query parameters.
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
  Future<GoogleRefreshToken?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GoogleRefreshTokenTable>? where,
    int? offset,
    _i1.OrderByBuilder<GoogleRefreshTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GoogleRefreshTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<GoogleRefreshToken>(
      where: where?.call(GoogleRefreshToken.t),
      orderBy: orderBy?.call(GoogleRefreshToken.t),
      orderByList: orderByList?.call(GoogleRefreshToken.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [GoogleRefreshToken] by its [id] or null if no such row exists.
  Future<GoogleRefreshToken?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<GoogleRefreshToken>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [GoogleRefreshToken]s in the list and returns the inserted rows.
  ///
  /// The returned [GoogleRefreshToken]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<GoogleRefreshToken>> insert(
    _i1.Session session,
    List<GoogleRefreshToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<GoogleRefreshToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [GoogleRefreshToken] and returns the inserted row.
  ///
  /// The returned [GoogleRefreshToken] will have its `id` field set.
  Future<GoogleRefreshToken> insertRow(
    _i1.Session session,
    GoogleRefreshToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<GoogleRefreshToken>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [GoogleRefreshToken]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<GoogleRefreshToken>> update(
    _i1.Session session,
    List<GoogleRefreshToken> rows, {
    _i1.ColumnSelections<GoogleRefreshTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<GoogleRefreshToken>(
      rows,
      columns: columns?.call(GoogleRefreshToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GoogleRefreshToken]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<GoogleRefreshToken> updateRow(
    _i1.Session session,
    GoogleRefreshToken row, {
    _i1.ColumnSelections<GoogleRefreshTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<GoogleRefreshToken>(
      row,
      columns: columns?.call(GoogleRefreshToken.t),
      transaction: transaction,
    );
  }

  /// Deletes all [GoogleRefreshToken]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<GoogleRefreshToken>> delete(
    _i1.Session session,
    List<GoogleRefreshToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<GoogleRefreshToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [GoogleRefreshToken].
  Future<GoogleRefreshToken> deleteRow(
    _i1.Session session,
    GoogleRefreshToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<GoogleRefreshToken>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<GoogleRefreshToken>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<GoogleRefreshTokenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<GoogleRefreshToken>(
      where: where(GoogleRefreshToken.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GoogleRefreshTokenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<GoogleRefreshToken>(
      where: where?.call(GoogleRefreshToken.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
