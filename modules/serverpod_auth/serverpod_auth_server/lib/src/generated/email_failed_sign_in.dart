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

/// Database table for tracking failed email sign-ins. Saves IP-address, time,
/// and email to be prevent brute force attacks.
abstract class EmailFailedSignIn
    implements _i1.TableRow, _i1.ProtocolSerialization {
  EmailFailedSignIn._({
    this.id,
    required this.email,
    required this.time,
    required this.ipAddress,
  });

  factory EmailFailedSignIn({
    int? id,
    required String email,
    required DateTime time,
    required String ipAddress,
  }) = _EmailFailedSignInImpl;

  factory EmailFailedSignIn.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailFailedSignIn(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      time: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['time']),
      ipAddress: jsonSerialization['ipAddress'] as String,
    );
  }

  static final t = EmailFailedSignInTable();

  static const db = EmailFailedSignInRepository._();

  @override
  int? id;

  /// Email attempting to sign in with.
  String email;

  /// The time of the sign in attempt.
  DateTime time;

  /// The IP address of the sign in attempt.
  String ipAddress;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [EmailFailedSignIn]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailFailedSignIn copyWith({
    int? id,
    String? email,
    DateTime? time,
    String? ipAddress,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'time': time.toJson(),
      'ipAddress': ipAddress,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'time': time.toJson(),
      'ipAddress': ipAddress,
    };
  }

  static EmailFailedSignInInclude include() {
    return EmailFailedSignInInclude._();
  }

  static EmailFailedSignInIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailFailedSignInTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailFailedSignInTable>? orderByList,
    EmailFailedSignInInclude? include,
  }) {
    return EmailFailedSignInIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailFailedSignIn.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailFailedSignIn.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailFailedSignInImpl extends EmailFailedSignIn {
  _EmailFailedSignInImpl({
    int? id,
    required String email,
    required DateTime time,
    required String ipAddress,
  }) : super._(
          id: id,
          email: email,
          time: time,
          ipAddress: ipAddress,
        );

  /// Returns a shallow copy of this [EmailFailedSignIn]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailFailedSignIn copyWith({
    Object? id = _Undefined,
    String? email,
    DateTime? time,
    String? ipAddress,
  }) {
    return EmailFailedSignIn(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      time: time ?? this.time,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}

class EmailFailedSignInTable extends _i1.Table {
  EmailFailedSignInTable({super.tableRelation})
      : super(tableName: 'serverpod_email_failed_sign_in') {
    email = _i1.ColumnString(
      'email',
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

  /// Email attempting to sign in with.
  late final _i1.ColumnString email;

  /// The time of the sign in attempt.
  late final _i1.ColumnDateTime time;

  /// The IP address of the sign in attempt.
  late final _i1.ColumnString ipAddress;

  @override
  List<_i1.Column> get columns => [
        id,
        email,
        time,
        ipAddress,
      ];
}

class EmailFailedSignInInclude extends _i1.IncludeObject {
  EmailFailedSignInInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => EmailFailedSignIn.t;
}

class EmailFailedSignInIncludeList extends _i1.IncludeList {
  EmailFailedSignInIncludeList._({
    _i1.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailFailedSignIn.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => EmailFailedSignIn.t;
}

class EmailFailedSignInRepository {
  const EmailFailedSignInRepository._();

  /// Returns a list of [EmailFailedSignIn]s matching the given query parameters.
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
  Future<List<EmailFailedSignIn>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailFailedSignInTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailFailedSignInTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailFailedSignIn>(
      where: where?.call(EmailFailedSignIn.t),
      orderBy: orderBy?.call(EmailFailedSignIn.t),
      orderByList: orderByList?.call(EmailFailedSignIn.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [EmailFailedSignIn] matching the given query parameters.
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
  Future<EmailFailedSignIn?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailFailedSignInTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailFailedSignInTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmailFailedSignIn>(
      where: where?.call(EmailFailedSignIn.t),
      orderBy: orderBy?.call(EmailFailedSignIn.t),
      orderByList: orderByList?.call(EmailFailedSignIn.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmailFailedSignIn] by its [id] or null if no such row exists.
  Future<EmailFailedSignIn?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmailFailedSignIn>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [EmailFailedSignIn]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailFailedSignIn]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailFailedSignIn>> insert(
    _i1.Session session,
    List<EmailFailedSignIn> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailFailedSignIn>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailFailedSignIn] and returns the inserted row.
  ///
  /// The returned [EmailFailedSignIn] will have its `id` field set.
  Future<EmailFailedSignIn> insertRow(
    _i1.Session session,
    EmailFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailFailedSignIn>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailFailedSignIn]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailFailedSignIn>> update(
    _i1.Session session,
    List<EmailFailedSignIn> rows, {
    _i1.ColumnSelections<EmailFailedSignInTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailFailedSignIn>(
      rows,
      columns: columns?.call(EmailFailedSignIn.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailFailedSignIn]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailFailedSignIn> updateRow(
    _i1.Session session,
    EmailFailedSignIn row, {
    _i1.ColumnSelections<EmailFailedSignInTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailFailedSignIn>(
      row,
      columns: columns?.call(EmailFailedSignIn.t),
      transaction: transaction,
    );
  }

  /// Deletes all [EmailFailedSignIn]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailFailedSignIn>> delete(
    _i1.Session session,
    List<EmailFailedSignIn> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailFailedSignIn>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailFailedSignIn].
  Future<EmailFailedSignIn> deleteRow(
    _i1.Session session,
    EmailFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailFailedSignIn>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailFailedSignIn>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailFailedSignInTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailFailedSignIn>(
      where: where(EmailFailedSignIn.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailFailedSignIn>(
      where: where?.call(EmailFailedSignIn.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
