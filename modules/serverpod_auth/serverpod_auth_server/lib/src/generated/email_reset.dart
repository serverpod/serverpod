/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class EmailReset extends _i1.TableRow {
  EmailReset({
    int? id,
    required this.userId,
    required this.verificationCode,
    required this.expiration,
  }) : super(id);

  factory EmailReset.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailReset(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      verificationCode: serializationManager
          .deserialize<String>(jsonSerialization['verificationCode']),
      expiration: serializationManager
          .deserialize<DateTime>(jsonSerialization['expiration']),
    );
  }

  static final t = EmailResetTable();

  int userId;

  String verificationCode;

  DateTime expiration;

  @override
  String get tableName => 'serverpod_email_reset';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration,
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
      case 'userId':
        userId = value;
        return;
      case 'verificationCode':
        verificationCode = value;
        return;
      case 'expiration':
        expiration = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<EmailReset>> find(
    _i1.Session session, {
    EmailResetExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailReset>(
      where: where != null ? where(EmailReset.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailReset?> findSingleRow(
    _i1.Session session, {
    EmailResetExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<EmailReset>(
      where: where != null ? where(EmailReset.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailReset?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<EmailReset>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required EmailResetExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailReset>(
      where: where(EmailReset.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    EmailReset row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    EmailReset row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    EmailReset row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    EmailResetExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailReset>(
      where: where != null ? where(EmailReset.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef EmailResetExpressionBuilder = _i1.Expression Function(EmailResetTable);

class EmailResetTable extends _i1.Table {
  EmailResetTable() : super(tableName: 'serverpod_email_reset');

  final id = _i1.ColumnInt('id');

  final userId = _i1.ColumnInt('userId');

  final verificationCode = _i1.ColumnString('verificationCode');

  final expiration = _i1.ColumnDateTime('expiration');

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        verificationCode,
        expiration,
      ];
}

@Deprecated('Use EmailResetTable.t instead.')
EmailResetTable tEmailReset = EmailResetTable();
