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

/// Database bindings for an email reset.
abstract class EmailReset implements _i1.TableRow, _i1.ProtocolSerialization {
  EmailReset._({
    this.id,
    required this.userId,
    required this.verificationCode,
    required this.expiration,
  });

  factory EmailReset({
    int? id,
    required int userId,
    required String verificationCode,
    required DateTime expiration,
  }) = _EmailResetImpl;

  factory EmailReset.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailReset(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      verificationCode: jsonSerialization['verificationCode'] as String,
      expiration:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiration']),
    );
  }

  static final t = EmailResetTable();

  static const db = EmailResetRepository._();

  @override
  int? id;

  /// The id of the user that is resetting his/her password.
  int userId;

  /// The verification code for the password reset.
  String verificationCode;

  /// The expiration time for the password reset.
  DateTime expiration;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [EmailReset]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailReset copyWith({
    int? id,
    int? userId,
    String? verificationCode,
    DateTime? expiration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration.toJson(),
    };
  }

  static EmailResetInclude include() {
    return EmailResetInclude._();
  }

  static EmailResetIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailResetTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailResetTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailResetTable>? orderByList,
    EmailResetInclude? include,
  }) {
    return EmailResetIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailReset.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailReset.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailResetImpl extends EmailReset {
  _EmailResetImpl({
    int? id,
    required int userId,
    required String verificationCode,
    required DateTime expiration,
  }) : super._(
          id: id,
          userId: userId,
          verificationCode: verificationCode,
          expiration: expiration,
        );

  /// Returns a shallow copy of this [EmailReset]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailReset copyWith({
    Object? id = _Undefined,
    int? userId,
    String? verificationCode,
    DateTime? expiration,
  }) {
    return EmailReset(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      verificationCode: verificationCode ?? this.verificationCode,
      expiration: expiration ?? this.expiration,
    );
  }
}

class EmailResetTable extends _i1.Table {
  EmailResetTable({super.tableRelation})
      : super(tableName: 'serverpod_email_reset') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    verificationCode = _i1.ColumnString(
      'verificationCode',
      this,
    );
    expiration = _i1.ColumnDateTime(
      'expiration',
      this,
    );
  }

  /// The id of the user that is resetting his/her password.
  late final _i1.ColumnInt userId;

  /// The verification code for the password reset.
  late final _i1.ColumnString verificationCode;

  /// The expiration time for the password reset.
  late final _i1.ColumnDateTime expiration;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        verificationCode,
        expiration,
      ];
}

class EmailResetInclude extends _i1.IncludeObject {
  EmailResetInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => EmailReset.t;
}

class EmailResetIncludeList extends _i1.IncludeList {
  EmailResetIncludeList._({
    _i1.WhereExpressionBuilder<EmailResetTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailReset.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => EmailReset.t;
}

class EmailResetRepository {
  const EmailResetRepository._();

  /// Returns a list of [EmailReset]s matching the given query parameters.
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
  Future<List<EmailReset>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailResetTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailResetTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailResetTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailReset>(
      where: where?.call(EmailReset.t),
      orderBy: orderBy?.call(EmailReset.t),
      orderByList: orderByList?.call(EmailReset.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [EmailReset] matching the given query parameters.
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
  Future<EmailReset?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailResetTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailResetTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailResetTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmailReset>(
      where: where?.call(EmailReset.t),
      orderBy: orderBy?.call(EmailReset.t),
      orderByList: orderByList?.call(EmailReset.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmailReset] by its [id] or null if no such row exists.
  Future<EmailReset?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmailReset>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [EmailReset]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailReset]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailReset>> insert(
    _i1.Session session,
    List<EmailReset> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailReset>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailReset] and returns the inserted row.
  ///
  /// The returned [EmailReset] will have its `id` field set.
  Future<EmailReset> insertRow(
    _i1.Session session,
    EmailReset row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailReset>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailReset]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailReset>> update(
    _i1.Session session,
    List<EmailReset> rows, {
    _i1.ColumnSelections<EmailResetTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailReset>(
      rows,
      columns: columns?.call(EmailReset.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailReset]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailReset> updateRow(
    _i1.Session session,
    EmailReset row, {
    _i1.ColumnSelections<EmailResetTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailReset>(
      row,
      columns: columns?.call(EmailReset.t),
      transaction: transaction,
    );
  }

  /// Deletes all [EmailReset]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailReset>> delete(
    _i1.Session session,
    List<EmailReset> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailReset>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailReset].
  Future<EmailReset> deleteRow(
    _i1.Session session,
    EmailReset row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailReset>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailReset>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailResetTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailReset>(
      where: where(EmailReset.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailResetTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailReset>(
      where: where?.call(EmailReset.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
