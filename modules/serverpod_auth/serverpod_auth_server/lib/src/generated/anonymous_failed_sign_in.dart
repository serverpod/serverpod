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

/// Database table for tracking failed anonymous sign-ins. Saves IP-address,
/// time, and email to be prevent brute force attacks.
abstract class AnonymousFailedSignIn
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AnonymousFailedSignIn._({
    this.id,
    required this.userId,
    required this.time,
    required this.ipAddress,
  });

  factory AnonymousFailedSignIn({
    int? id,
    required int userId,
    required DateTime time,
    required String ipAddress,
  }) = _AnonymousFailedSignInImpl;

  factory AnonymousFailedSignIn.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return AnonymousFailedSignIn(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      time: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['time']),
      ipAddress: jsonSerialization['ipAddress'] as String,
    );
  }

  static final t = AnonymousFailedSignInTable();

  static const db = AnonymousFailedSignInRepository._();

  @override
  int? id;

  /// UserId attempting to sign in with.
  int userId;

  /// The time of the sign in attempt.
  DateTime time;

  /// The IP address of the sign in attempt.
  String ipAddress;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AnonymousFailedSignIn]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AnonymousFailedSignIn copyWith({
    int? id,
    int? userId,
    DateTime? time,
    String? ipAddress,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'time': time.toJson(),
      'ipAddress': ipAddress,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'time': time.toJson(),
      'ipAddress': ipAddress,
    };
  }

  static AnonymousFailedSignInInclude include() {
    return AnonymousFailedSignInInclude._();
  }

  static AnonymousFailedSignInIncludeList includeList({
    _i1.WhereExpressionBuilder<AnonymousFailedSignInTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnonymousFailedSignInTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnonymousFailedSignInTable>? orderByList,
    AnonymousFailedSignInInclude? include,
  }) {
    return AnonymousFailedSignInIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AnonymousFailedSignIn.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AnonymousFailedSignIn.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnonymousFailedSignInImpl extends AnonymousFailedSignIn {
  _AnonymousFailedSignInImpl({
    int? id,
    required int userId,
    required DateTime time,
    required String ipAddress,
  }) : super._(
          id: id,
          userId: userId,
          time: time,
          ipAddress: ipAddress,
        );

  /// Returns a shallow copy of this [AnonymousFailedSignIn]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AnonymousFailedSignIn copyWith({
    Object? id = _Undefined,
    int? userId,
    DateTime? time,
    String? ipAddress,
  }) {
    return AnonymousFailedSignIn(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      time: time ?? this.time,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}

class AnonymousFailedSignInTable extends _i1.Table<int?> {
  AnonymousFailedSignInTable({super.tableRelation})
      : super(tableName: 'serverpod_anonymous_failed_sign_in') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    time = _i1.ColumnDateTime(
      'time',
      this,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
  }

  /// UserId attempting to sign in with.
  late final _i1.ColumnInt userId;

  /// The time of the sign in attempt.
  late final _i1.ColumnDateTime time;

  /// The IP address of the sign in attempt.
  late final _i1.ColumnString ipAddress;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        time,
        ipAddress,
      ];
}

class AnonymousFailedSignInInclude extends _i1.IncludeObject {
  AnonymousFailedSignInInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AnonymousFailedSignIn.t;
}

class AnonymousFailedSignInIncludeList extends _i1.IncludeList {
  AnonymousFailedSignInIncludeList._({
    _i1.WhereExpressionBuilder<AnonymousFailedSignInTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AnonymousFailedSignIn.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AnonymousFailedSignIn.t;
}

class AnonymousFailedSignInRepository {
  const AnonymousFailedSignInRepository._();

  /// Returns a list of [AnonymousFailedSignIn]s matching the given query parameters.
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
  Future<List<AnonymousFailedSignIn>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnonymousFailedSignInTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnonymousFailedSignInTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnonymousFailedSignInTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AnonymousFailedSignIn>(
      where: where?.call(AnonymousFailedSignIn.t),
      orderBy: orderBy?.call(AnonymousFailedSignIn.t),
      orderByList: orderByList?.call(AnonymousFailedSignIn.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AnonymousFailedSignIn] matching the given query parameters.
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
  Future<AnonymousFailedSignIn?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnonymousFailedSignInTable>? where,
    int? offset,
    _i1.OrderByBuilder<AnonymousFailedSignInTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnonymousFailedSignInTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AnonymousFailedSignIn>(
      where: where?.call(AnonymousFailedSignIn.t),
      orderBy: orderBy?.call(AnonymousFailedSignIn.t),
      orderByList: orderByList?.call(AnonymousFailedSignIn.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AnonymousFailedSignIn] by its [id] or null if no such row exists.
  Future<AnonymousFailedSignIn?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AnonymousFailedSignIn>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AnonymousFailedSignIn]s in the list and returns the inserted rows.
  ///
  /// The returned [AnonymousFailedSignIn]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AnonymousFailedSignIn>> insert(
    _i1.Session session,
    List<AnonymousFailedSignIn> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AnonymousFailedSignIn>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AnonymousFailedSignIn] and returns the inserted row.
  ///
  /// The returned [AnonymousFailedSignIn] will have its `id` field set.
  Future<AnonymousFailedSignIn> insertRow(
    _i1.Session session,
    AnonymousFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AnonymousFailedSignIn>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AnonymousFailedSignIn]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AnonymousFailedSignIn>> update(
    _i1.Session session,
    List<AnonymousFailedSignIn> rows, {
    _i1.ColumnSelections<AnonymousFailedSignInTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AnonymousFailedSignIn>(
      rows,
      columns: columns?.call(AnonymousFailedSignIn.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AnonymousFailedSignIn]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AnonymousFailedSignIn> updateRow(
    _i1.Session session,
    AnonymousFailedSignIn row, {
    _i1.ColumnSelections<AnonymousFailedSignInTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AnonymousFailedSignIn>(
      row,
      columns: columns?.call(AnonymousFailedSignIn.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AnonymousFailedSignIn]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AnonymousFailedSignIn>> delete(
    _i1.Session session,
    List<AnonymousFailedSignIn> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AnonymousFailedSignIn>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AnonymousFailedSignIn].
  Future<AnonymousFailedSignIn> deleteRow(
    _i1.Session session,
    AnonymousFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AnonymousFailedSignIn>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AnonymousFailedSignIn>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AnonymousFailedSignInTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AnonymousFailedSignIn>(
      where: where(AnonymousFailedSignIn.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnonymousFailedSignInTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AnonymousFailedSignIn>(
      where: where?.call(AnonymousFailedSignIn.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
