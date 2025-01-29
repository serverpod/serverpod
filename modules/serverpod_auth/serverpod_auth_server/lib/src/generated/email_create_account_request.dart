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

/// A request for creating an email signin. Created during the sign up process
/// to keep track of the user's details and verification code.
abstract class EmailCreateAccountRequest
    implements _i1.TableRow, _i1.ProtocolSerialization {
  EmailCreateAccountRequest._({
    this.id,
    required this.userName,
    required this.email,
    required this.hash,
    required this.verificationCode,
  });

  factory EmailCreateAccountRequest({
    int? id,
    required String userName,
    required String email,
    required String hash,
    required String verificationCode,
  }) = _EmailCreateAccountRequestImpl;

  factory EmailCreateAccountRequest.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailCreateAccountRequest(
      id: jsonSerialization['id'] as int?,
      userName: jsonSerialization['userName'] as String,
      email: jsonSerialization['email'] as String,
      hash: jsonSerialization['hash'] as String,
      verificationCode: jsonSerialization['verificationCode'] as String,
    );
  }

  static final t = EmailCreateAccountRequestTable();

  static const db = EmailCreateAccountRequestRepository._();

  @override
  int? id;

  /// The name of the user.
  String userName;

  /// The email of the user.
  String email;

  /// Hash of the user's requested password.
  String hash;

  /// The verification code sent to the user.
  String verificationCode;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [EmailCreateAccountRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailCreateAccountRequest copyWith({
    int? id,
    String? userName,
    String? email,
    String? hash,
    String? verificationCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userName': userName,
      'email': email,
      'hash': hash,
      'verificationCode': verificationCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userName': userName,
      'email': email,
      'hash': hash,
      'verificationCode': verificationCode,
    };
  }

  static EmailCreateAccountRequestInclude include() {
    return EmailCreateAccountRequestInclude._();
  }

  static EmailCreateAccountRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailCreateAccountRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailCreateAccountRequestTable>? orderByList,
    EmailCreateAccountRequestInclude? include,
  }) {
    return EmailCreateAccountRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailCreateAccountRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailCreateAccountRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailCreateAccountRequestImpl extends EmailCreateAccountRequest {
  _EmailCreateAccountRequestImpl({
    int? id,
    required String userName,
    required String email,
    required String hash,
    required String verificationCode,
  }) : super._(
          id: id,
          userName: userName,
          email: email,
          hash: hash,
          verificationCode: verificationCode,
        );

  /// Returns a shallow copy of this [EmailCreateAccountRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailCreateAccountRequest copyWith({
    Object? id = _Undefined,
    String? userName,
    String? email,
    String? hash,
    String? verificationCode,
  }) {
    return EmailCreateAccountRequest(
      id: id is int? ? id : this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      hash: hash ?? this.hash,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }
}

class EmailCreateAccountRequestTable extends _i1.Table {
  EmailCreateAccountRequestTable({super.tableRelation})
      : super(tableName: 'serverpod_email_create_request') {
    userName = _i1.ColumnString(
      'userName',
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
    verificationCode = _i1.ColumnString(
      'verificationCode',
      this,
    );
  }

  /// The name of the user.
  late final _i1.ColumnString userName;

  /// The email of the user.
  late final _i1.ColumnString email;

  /// Hash of the user's requested password.
  late final _i1.ColumnString hash;

  /// The verification code sent to the user.
  late final _i1.ColumnString verificationCode;

  @override
  List<_i1.Column> get columns => [
        id,
        userName,
        email,
        hash,
        verificationCode,
      ];
}

class EmailCreateAccountRequestInclude extends _i1.IncludeObject {
  EmailCreateAccountRequestInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => EmailCreateAccountRequest.t;
}

class EmailCreateAccountRequestIncludeList extends _i1.IncludeList {
  EmailCreateAccountRequestIncludeList._({
    _i1.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailCreateAccountRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => EmailCreateAccountRequest.t;
}

class EmailCreateAccountRequestRepository {
  const EmailCreateAccountRequestRepository._();

  /// Returns a list of [EmailCreateAccountRequest]s matching the given query parameters.
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
  Future<List<EmailCreateAccountRequest>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailCreateAccountRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailCreateAccountRequestTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailCreateAccountRequest>(
      where: where?.call(EmailCreateAccountRequest.t),
      orderBy: orderBy?.call(EmailCreateAccountRequest.t),
      orderByList: orderByList?.call(EmailCreateAccountRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [EmailCreateAccountRequest] matching the given query parameters.
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
  Future<EmailCreateAccountRequest?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailCreateAccountRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailCreateAccountRequestTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmailCreateAccountRequest>(
      where: where?.call(EmailCreateAccountRequest.t),
      orderBy: orderBy?.call(EmailCreateAccountRequest.t),
      orderByList: orderByList?.call(EmailCreateAccountRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmailCreateAccountRequest] by its [id] or null if no such row exists.
  Future<EmailCreateAccountRequest?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmailCreateAccountRequest>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [EmailCreateAccountRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailCreateAccountRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailCreateAccountRequest>> insert(
    _i1.Session session,
    List<EmailCreateAccountRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailCreateAccountRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailCreateAccountRequest] and returns the inserted row.
  ///
  /// The returned [EmailCreateAccountRequest] will have its `id` field set.
  Future<EmailCreateAccountRequest> insertRow(
    _i1.Session session,
    EmailCreateAccountRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailCreateAccountRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailCreateAccountRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailCreateAccountRequest>> update(
    _i1.Session session,
    List<EmailCreateAccountRequest> rows, {
    _i1.ColumnSelections<EmailCreateAccountRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailCreateAccountRequest>(
      rows,
      columns: columns?.call(EmailCreateAccountRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailCreateAccountRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailCreateAccountRequest> updateRow(
    _i1.Session session,
    EmailCreateAccountRequest row, {
    _i1.ColumnSelections<EmailCreateAccountRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailCreateAccountRequest>(
      row,
      columns: columns?.call(EmailCreateAccountRequest.t),
      transaction: transaction,
    );
  }

  /// Deletes all [EmailCreateAccountRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailCreateAccountRequest>> delete(
    _i1.Session session,
    List<EmailCreateAccountRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailCreateAccountRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailCreateAccountRequest].
  Future<EmailCreateAccountRequest> deleteRow(
    _i1.Session session,
    EmailCreateAccountRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailCreateAccountRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailCreateAccountRequest>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailCreateAccountRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailCreateAccountRequest>(
      where: where(EmailCreateAccountRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailCreateAccountRequest>(
      where: where?.call(EmailCreateAccountRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
