/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Database bindings for SMSAuth
abstract class SmsAuth extends _i1.TableRow {
  SmsAuth._({
    int? id,
    required this.userId,
    required this.phoneNumber,
  }) : super(id);

  factory SmsAuth({
    int? id,
    required int userId,
    required String phoneNumber,
  }) = _SmsAuthImpl;

  factory SmsAuth.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SmsAuth(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      phoneNumber: serializationManager
          .deserialize<String>(jsonSerialization['phoneNumber']),
    );
  }

  static final t = SmsAuthTable();

  /// The id of the user, corresponds to the id field in the [UserInfo].
  int userId;

  /// The phone number of the user.
  String phoneNumber;

  @override
  _i1.Table get table => t;
  SmsAuth copyWith({
    int? id,
    int? userId,
    String? phoneNumber,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'phoneNumber': phoneNumber,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'userId': userId,
      'phoneNumber': phoneNumber,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'userId': userId,
      'phoneNumber': phoneNumber,
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
      case 'phoneNumber':
        phoneNumber = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<SmsAuth>> find(
    _i1.Session session, {
    SmsAuthExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SmsAuth>(
      where: where != null ? where(SmsAuth.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SmsAuth?> findSingleRow(
    _i1.Session session, {
    SmsAuthExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<SmsAuth>(
      where: where != null ? where(SmsAuth.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SmsAuth?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<SmsAuth>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required SmsAuthExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SmsAuth>(
      where: where(SmsAuth.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    SmsAuth row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    SmsAuth row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    SmsAuth row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    SmsAuthExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SmsAuth>(
      where: where != null ? where(SmsAuth.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static SmsAuthInclude include() {
    return SmsAuthInclude._();
  }
}

class _Undefined {}

class _SmsAuthImpl extends SmsAuth {
  _SmsAuthImpl({
    int? id,
    required int userId,
    required String phoneNumber,
  }) : super._(
          id: id,
          userId: userId,
          phoneNumber: phoneNumber,
        );

  @override
  SmsAuth copyWith({
    Object? id = _Undefined,
    int? userId,
    String? phoneNumber,
  }) {
    return SmsAuth(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

typedef SmsAuthExpressionBuilder = _i1.Expression Function(SmsAuthTable);

class SmsAuthTable extends _i1.Table {
  SmsAuthTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'serverpod_sms_auth') {
    userId = _i1.ColumnInt(
      'userId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    phoneNumber = _i1.ColumnString(
      'phoneNumber',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// The id of the user, corresponds to the id field in the [UserInfo].
  late final _i1.ColumnInt userId;

  /// The phone number of the user.
  late final _i1.ColumnString phoneNumber;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        phoneNumber,
      ];
}

@Deprecated('Use SmsAuthTable.t instead.')
SmsAuthTable tSmsAuth = SmsAuthTable();

class SmsAuthInclude extends _i1.Include {
  SmsAuthInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => SmsAuth.t;
}
