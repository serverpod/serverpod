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

/// A request for creating an phone number signin. Created during the sign up process
/// to keep track of the user's details and verification code.
abstract class PhoneCreateAccountRequest
    implements _i1.TableRow, _i1.ProtocolSerialization {
  PhoneCreateAccountRequest._({
    this.id,
    required this.userName,
    required this.phoneNumber,
    required this.hash,
    required this.verificationCode,
  });

  factory PhoneCreateAccountRequest({
    int? id,
    required String userName,
    required String phoneNumber,
    required String hash,
    required String verificationCode,
  }) = _PhoneCreateAccountRequestImpl;

  factory PhoneCreateAccountRequest.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return PhoneCreateAccountRequest(
      id: jsonSerialization['id'] as int?,
      userName: jsonSerialization['userName'] as String,
      phoneNumber: jsonSerialization['phoneNumber'] as String,
      hash: jsonSerialization['hash'] as String,
      verificationCode: jsonSerialization['verificationCode'] as String,
    );
  }

  static final t = PhoneCreateAccountRequestTable();

  static const db = PhoneCreateAccountRequestRepository._();

  @override
  int? id;

  /// The name of the user.
  String userName;

  /// The phone number of the user.
  String phoneNumber;

  /// Hash of the user's requested password.
  String hash;

  /// The verification code sent to the user.
  String verificationCode;

  @override
  _i1.Table get table => t;

  PhoneCreateAccountRequest copyWith({
    int? id,
    String? userName,
    String? phoneNumber,
    String? hash,
    String? verificationCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'hash': hash,
      'verificationCode': verificationCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'hash': hash,
      'verificationCode': verificationCode,
    };
  }

  static PhoneCreateAccountRequestInclude include() {
    return PhoneCreateAccountRequestInclude._();
  }

  static PhoneCreateAccountRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<PhoneCreateAccountRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PhoneCreateAccountRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PhoneCreateAccountRequestTable>? orderByList,
    PhoneCreateAccountRequestInclude? include,
  }) {
    return PhoneCreateAccountRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PhoneCreateAccountRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PhoneCreateAccountRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PhoneCreateAccountRequestImpl extends PhoneCreateAccountRequest {
  _PhoneCreateAccountRequestImpl({
    int? id,
    required String userName,
    required String phoneNumber,
    required String hash,
    required String verificationCode,
  }) : super._(
          id: id,
          userName: userName,
          phoneNumber: phoneNumber,
          hash: hash,
          verificationCode: verificationCode,
        );

  @override
  PhoneCreateAccountRequest copyWith({
    Object? id = _Undefined,
    String? userName,
    String? phoneNumber,
    String? hash,
    String? verificationCode,
  }) {
    return PhoneCreateAccountRequest(
      id: id is int? ? id : this.id,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      hash: hash ?? this.hash,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }
}

class PhoneCreateAccountRequestTable extends _i1.Table {
  PhoneCreateAccountRequestTable({super.tableRelation})
      : super(tableName: 'serverpod_phone_create_request') {
    userName = _i1.ColumnString(
      'userName',
      this,
    );
    phoneNumber = _i1.ColumnString(
      'phoneNumber',
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

  /// The phone number of the user.
  late final _i1.ColumnString phoneNumber;

  /// Hash of the user's requested password.
  late final _i1.ColumnString hash;

  /// The verification code sent to the user.
  late final _i1.ColumnString verificationCode;

  @override
  List<_i1.Column> get columns => [
        id,
        userName,
        phoneNumber,
        hash,
        verificationCode,
      ];
}

class PhoneCreateAccountRequestInclude extends _i1.IncludeObject {
  PhoneCreateAccountRequestInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => PhoneCreateAccountRequest.t;
}

class PhoneCreateAccountRequestIncludeList extends _i1.IncludeList {
  PhoneCreateAccountRequestIncludeList._({
    _i1.WhereExpressionBuilder<PhoneCreateAccountRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PhoneCreateAccountRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => PhoneCreateAccountRequest.t;
}

class PhoneCreateAccountRequestRepository {
  const PhoneCreateAccountRequestRepository._();

  Future<List<PhoneCreateAccountRequest>> find(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<PhoneCreateAccountRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PhoneCreateAccountRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PhoneCreateAccountRequestTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.find<PhoneCreateAccountRequest>(
      where: where?.call(PhoneCreateAccountRequest.t),
      orderBy: orderBy?.call(PhoneCreateAccountRequest.t),
      orderByList: orderByList?.call(PhoneCreateAccountRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<PhoneCreateAccountRequest?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<PhoneCreateAccountRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<PhoneCreateAccountRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PhoneCreateAccountRequestTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findFirstRow<PhoneCreateAccountRequest>(
      where: where?.call(PhoneCreateAccountRequest.t),
      orderBy: orderBy?.call(PhoneCreateAccountRequest.t),
      orderByList: orderByList?.call(PhoneCreateAccountRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<PhoneCreateAccountRequest?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findById<PhoneCreateAccountRequest>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<PhoneCreateAccountRequest>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<PhoneCreateAccountRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<PhoneCreateAccountRequest>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<PhoneCreateAccountRequest> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    PhoneCreateAccountRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<PhoneCreateAccountRequest>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<PhoneCreateAccountRequest>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<PhoneCreateAccountRequest> rows, {
    _i1.ColumnSelections<PhoneCreateAccountRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<PhoneCreateAccountRequest>(
      rows,
      columns: columns?.call(PhoneCreateAccountRequest.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<PhoneCreateAccountRequest> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    PhoneCreateAccountRequest row, {
    _i1.ColumnSelections<PhoneCreateAccountRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<PhoneCreateAccountRequest>(
      row,
      columns: columns?.call(PhoneCreateAccountRequest.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<PhoneCreateAccountRequest>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<PhoneCreateAccountRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<PhoneCreateAccountRequest>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<PhoneCreateAccountRequest> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    PhoneCreateAccountRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<PhoneCreateAccountRequest>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<PhoneCreateAccountRequest>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<PhoneCreateAccountRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<PhoneCreateAccountRequest>(
      where: where(PhoneCreateAccountRequest.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<PhoneCreateAccountRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<PhoneCreateAccountRequest>(
      where: where?.call(PhoneCreateAccountRequest.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}
