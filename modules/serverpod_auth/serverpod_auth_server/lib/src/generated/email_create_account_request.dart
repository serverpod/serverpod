/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class EmailCreateAccountRequest extends _i1.TableRow {
  EmailCreateAccountRequest({
    int? id,
    required this.userName,
    required this.email,
    required this.hash,
    required this.verificationCode,
  }) : super(id);

  factory EmailCreateAccountRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailCreateAccountRequest(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      userName: serializationManager
          .deserializeJson<String>(jsonSerialization['userName']),
      email: serializationManager
          .deserializeJson<String>(jsonSerialization['email']),
      hash: serializationManager
          .deserializeJson<String>(jsonSerialization['hash']),
      verificationCode: serializationManager
          .deserializeJson<String>(jsonSerialization['verificationCode']),
    );
  }

  static final t = EmailCreateAccountRequestTable();

  String userName;

  String email;

  String hash;

  String verificationCode;

  @override
  String get className => 'serverpod_auth_server.EmailCreateAccountRequest';
  @override
  String get tableName => 'serverpod_email_create_request';
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

  static Future<List<EmailCreateAccountRequest>> find(
    _i1.Session session, {
    EmailCreateAccountRequestExpressionBuilder? where,
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

  static Future<EmailCreateAccountRequest?> findSingleRow(
    _i1.Session session, {
    EmailCreateAccountRequestExpressionBuilder? where,
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

  static Future<EmailCreateAccountRequest?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<EmailCreateAccountRequest>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required EmailCreateAccountRequestExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailCreateAccountRequest>(
      where: where(EmailCreateAccountRequest.t),
      transaction: transaction,
    );
  }

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

  static Future<int> count(
    _i1.Session session, {
    EmailCreateAccountRequestExpressionBuilder? where,
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
}

typedef EmailCreateAccountRequestExpressionBuilder = _i1.Expression Function(
    EmailCreateAccountRequestTable);

class EmailCreateAccountRequestTable extends _i1.Table {
  EmailCreateAccountRequestTable()
      : super(tableName: 'serverpod_email_create_request');

  final id = _i1.ColumnInt('id');

  final userName = _i1.ColumnString('userName');

  final email = _i1.ColumnString('email');

  final hash = _i1.ColumnString('hash');

  final verificationCode = _i1.ColumnString('verificationCode');

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
