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
abstract class EmailAuth implements _i1.TableRow, _i1.ProtocolSerialization {
  EmailAuth._({
    this.id,
    required this.userId,
    required this.email,
    required this.hash,
  });

  factory EmailAuth({
    int? id,
    required int userId,
    required String email,
    required String hash,
  }) = _EmailAuthImpl;

  factory EmailAuth.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailAuth(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      email: jsonSerialization['email'] as String,
      hash: jsonSerialization['hash'] as String,
    );
  }

  static final t = EmailAuthTable();

  static const db = EmailAuthRepository._();

  @override
  int? id;

  /// The id of the user, corresponds to the id field in [UserInfo].
  int userId;

  /// The email of the user.
  String email;

  /// The hashed password of the user.
  String hash;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [EmailAuth]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAuth copyWith({
    int? id,
    int? userId,
    String? email,
    String? hash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'email': email,
      'hash': hash,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'email': email,
      'hash': hash,
    };
  }

  static EmailAuthInclude include() {
    return EmailAuthInclude._();
  }

  static EmailAuthIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailAuthTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAuthTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAuthTable>? orderByList,
    EmailAuthInclude? include,
  }) {
    return EmailAuthIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAuth.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailAuth.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAuthImpl extends EmailAuth {
  _EmailAuthImpl({
    int? id,
    required int userId,
    required String email,
    required String hash,
  }) : super._(
          id: id,
          userId: userId,
          email: email,
          hash: hash,
        );

  /// Returns a shallow copy of this [EmailAuth]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAuth copyWith({
    Object? id = _Undefined,
    int? userId,
    String? email,
    String? hash,
  }) {
    return EmailAuth(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      hash: hash ?? this.hash,
    );
  }
}

class EmailAuthTable extends _i1.Table {
  EmailAuthTable({super.tableRelation})
      : super(tableName: 'serverpod_email_auth') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    hash = _i1.ColumnString(
      'hash',
      this,
    );
  }

  /// The id of the user, corresponds to the id field in [UserInfo].
  late final _i1.ColumnInt userId;

  /// The email of the user.
  late final _i1.ColumnString email;

  /// The hashed password of the user.
  late final _i1.ColumnString hash;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        email,
        hash,
      ];
}

class EmailAuthInclude extends _i1.IncludeObject {
  EmailAuthInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => EmailAuth.t;
}

class EmailAuthIncludeList extends _i1.IncludeList {
  EmailAuthIncludeList._({
    _i1.WhereExpressionBuilder<EmailAuthTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailAuth.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => EmailAuth.t;
}

class EmailAuthRepository {
  const EmailAuthRepository._();

  /// Returns a list of [EmailAuth]s matching the given query parameters.
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
  Future<List<EmailAuth>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAuthTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAuthTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAuthTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailAuth>(
      where: where?.call(EmailAuth.t),
      orderBy: orderBy?.call(EmailAuth.t),
      orderByList: orderByList?.call(EmailAuth.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [EmailAuth] matching the given query parameters.
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
  Future<EmailAuth?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAuthTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailAuthTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAuthTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmailAuth>(
      where: where?.call(EmailAuth.t),
      orderBy: orderBy?.call(EmailAuth.t),
      orderByList: orderByList?.call(EmailAuth.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmailAuth] by its [id] or null if no such row exists.
  Future<EmailAuth?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmailAuth>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [EmailAuth]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAuth]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailAuth>> insert(
    _i1.Session session,
    List<EmailAuth> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailAuth>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailAuth] and returns the inserted row.
  ///
  /// The returned [EmailAuth] will have its `id` field set.
  Future<EmailAuth> insertRow(
    _i1.Session session,
    EmailAuth row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAuth>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailAuth]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailAuth>> update(
    _i1.Session session,
    List<EmailAuth> rows, {
    _i1.ColumnSelections<EmailAuthTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailAuth>(
      rows,
      columns: columns?.call(EmailAuth.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAuth]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAuth> updateRow(
    _i1.Session session,
    EmailAuth row, {
    _i1.ColumnSelections<EmailAuthTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAuth>(
      row,
      columns: columns?.call(EmailAuth.t),
      transaction: transaction,
    );
  }

  /// Deletes all [EmailAuth]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailAuth>> delete(
    _i1.Session session,
    List<EmailAuth> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailAuth>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailAuth].
  Future<EmailAuth> deleteRow(
    _i1.Session session,
    EmailAuth row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAuth>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailAuth>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailAuthTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailAuth>(
      where: where(EmailAuth.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAuthTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailAuth>(
      where: where?.call(EmailAuth.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
