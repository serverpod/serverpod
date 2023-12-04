/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// A request for creating an email signin. Created during the sign up process
/// to keep track of the user's details and verification code.
abstract class EmailCreateAccountRequest extends _i1.TableRow {
  EmailCreateAccountRequest._({
    int? id,
    required this.userName,
    required this.email,
    required this.hash,
    required this.verificationCode,
  }) : super(id);

  factory EmailCreateAccountRequest({
    int? id,
    required String userName,
    required String email,
    required String hash,
    required String verificationCode,
  }) = _EmailCreateAccountRequestImpl;

  factory EmailCreateAccountRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailCreateAccountRequest(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userName: serializationManager
          .deserialize<String>(jsonSerialization['userName']),
      email:
          serializationManager.deserialize<String>(jsonSerialization['email']),
      hash: serializationManager.deserialize<String>(jsonSerialization['hash']),
      verificationCode: serializationManager
          .deserialize<String>(jsonSerialization['verificationCode']),
    );
  }

  static final t = EmailCreateAccountRequestTable();

  static const db = EmailCreateAccountRequestRepository._();

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
      'id': id,
      'userName': userName,
      'email': email,
      'hash': hash,
      'verificationCode': verificationCode,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'hash': hash,
      'verificationCode': verificationCode,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'hash': hash,
      'verificationCode': verificationCode,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'userName':
        userName = value;
        return;
      case 'email':
        email = value;
        return;
      case 'hash':
        hash = value;
        return;
      case 'verificationCode':
        verificationCode = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<EmailCreateAccountRequest>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailCreateAccountRequest>(
      where: where != null ? where(EmailCreateAccountRequest.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<EmailCreateAccountRequest?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<EmailCreateAccountRequest>(
      where: where != null ? where(EmailCreateAccountRequest.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<EmailCreateAccountRequest?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<EmailCreateAccountRequest>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailCreateAccountRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailCreateAccountRequest>(
      where: where(EmailCreateAccountRequest.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    EmailCreateAccountRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
  static Future<bool> update(
    _i1.Session session,
    EmailCreateAccountRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
  static Future<void> insert(
    _i1.Session session,
    EmailCreateAccountRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailCreateAccountRequest>(
      where: where != null ? where(EmailCreateAccountRequest.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
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

@Deprecated('Use EmailCreateAccountRequestTable.t instead.')
EmailCreateAccountRequestTable tEmailCreateAccountRequest =
    EmailCreateAccountRequestTable();

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
    return session.dbNext.find<EmailCreateAccountRequest>(
      where: where?.call(EmailCreateAccountRequest.t),
      orderBy: orderBy?.call(EmailCreateAccountRequest.t),
      orderByList: orderByList?.call(EmailCreateAccountRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<EmailCreateAccountRequest?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailCreateAccountRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailCreateAccountRequestTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<EmailCreateAccountRequest>(
      where: where?.call(EmailCreateAccountRequest.t),
      orderBy: orderBy?.call(EmailCreateAccountRequest.t),
      orderByList: orderByList?.call(EmailCreateAccountRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<EmailCreateAccountRequest?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<EmailCreateAccountRequest>(
      id,
      transaction: transaction,
    );
  }

  Future<List<EmailCreateAccountRequest>> insert(
    _i1.Session session,
    List<EmailCreateAccountRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<EmailCreateAccountRequest>(
      rows,
      transaction: transaction,
    );
  }

  Future<EmailCreateAccountRequest> insertRow(
    _i1.Session session,
    EmailCreateAccountRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<EmailCreateAccountRequest>(
      row,
      transaction: transaction,
    );
  }

  Future<List<EmailCreateAccountRequest>> update(
    _i1.Session session,
    List<EmailCreateAccountRequest> rows, {
    _i1.ColumnSelections<EmailCreateAccountRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<EmailCreateAccountRequest>(
      rows,
      columns: columns?.call(EmailCreateAccountRequest.t),
      transaction: transaction,
    );
  }

  Future<EmailCreateAccountRequest> updateRow(
    _i1.Session session,
    EmailCreateAccountRequest row, {
    _i1.ColumnSelections<EmailCreateAccountRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<EmailCreateAccountRequest>(
      row,
      columns: columns?.call(EmailCreateAccountRequest.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<EmailCreateAccountRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<EmailCreateAccountRequest>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    EmailCreateAccountRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<EmailCreateAccountRequest>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailCreateAccountRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<EmailCreateAccountRequest>(
      where: where(EmailCreateAccountRequest.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailCreateAccountRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<EmailCreateAccountRequest>(
      where: where?.call(EmailCreateAccountRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
