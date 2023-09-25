/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

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

  static EmailCreateAccountRequestInclude include() {
    return EmailCreateAccountRequestInclude._();
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

typedef EmailCreateAccountRequestExpressionBuilder = _i1.Expression Function(
    EmailCreateAccountRequestTable);
typedef EmailCreateAccountRequestWithoutManyRelationsExpressionBuilder
    = _i1.Expression Function(
        EmailCreateAccountRequestWithoutManyRelationsTable);

class EmailCreateAccountRequestTable
    extends EmailCreateAccountRequestWithoutManyRelationsTable {
  EmailCreateAccountRequestTable({
    super.queryPrefix,
    super.tableRelations,
  });
}

class EmailCreateAccountRequestWithoutManyRelationsTable extends _i1.Table {
  EmailCreateAccountRequestWithoutManyRelationsTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'serverpod_email_create_request') {
    userName = _i1.ColumnString(
      'userName',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    email = _i1.ColumnString(
      'email',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    hash = _i1.ColumnString(
      'hash',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    verificationCode = _i1.ColumnString(
      'verificationCode',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
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

class EmailCreateAccountRequestInclude extends _i1.Include {
  EmailCreateAccountRequestInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => EmailCreateAccountRequest.t;
}
