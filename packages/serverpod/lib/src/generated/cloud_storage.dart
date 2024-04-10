/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:typed_data' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// An entry in the database for an uploaded file.
abstract class CloudStorageEntry extends _i1.TableRow {
  CloudStorageEntry._({
    int? id,
    required this.storageId,
    required this.path,
    required this.addedTime,
    this.expiration,
    required this.byteData,
    required this.verified,
  }) : super(id);

  factory CloudStorageEntry({
    int? id,
    required String storageId,
    required String path,
    required DateTime addedTime,
    DateTime? expiration,
    required _i2.ByteData byteData,
    required bool verified,
  }) = _CloudStorageEntryImpl;

  factory CloudStorageEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return CloudStorageEntry(
      id: jsonSerialization['id'] as int?,
      storageId: jsonSerialization['storageId'] as String,
      path: jsonSerialization['path'] as String,
      addedTime: _i1.DateTimeExt.fromJson(jsonSerialization['addedTime']),
      expiration: jsonSerialization['expiration'] == null
          ? null
          : _i1.DateTimeExt.fromJson(jsonSerialization['expiration']),
      byteData: _i1.ByteDataExt.fromJson(jsonSerialization['byteData']),
      verified: jsonSerialization['verified'] as bool,
    );
  }

  static final t = CloudStorageEntryTable();

  static const db = CloudStorageEntryRepository._();

  /// The storageId, typically `public` or `private`.
  String storageId;

  /// The path where the file is stored.
  String path;

  /// The time when the file was added.
  DateTime addedTime;

  /// The time at which the file expires and can be deleted.
  DateTime? expiration;

  /// The actual data of the uploaded file.
  _i2.ByteData byteData;

  /// True if the file has been verified as uploaded.
  bool verified;

  @override
  _i1.Table get table => t;

  CloudStorageEntry copyWith({
    int? id,
    String? storageId,
    String? path,
    DateTime? addedTime,
    DateTime? expiration,
    _i2.ByteData? byteData,
    bool? verified,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'addedTime': addedTime.toJson(),
      if (expiration != null) 'expiration': expiration?.toJson(),
      'byteData': byteData.toJson(),
      'verified': verified,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'addedTime': addedTime.toJson(),
      if (expiration != null) 'expiration': expiration?.toJson(),
      'byteData': byteData.toJson(),
      'verified': verified,
    };
  }

  static CloudStorageEntryInclude include() {
    return CloudStorageEntryInclude._();
  }

  static CloudStorageEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<CloudStorageEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CloudStorageEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CloudStorageEntryTable>? orderByList,
    CloudStorageEntryInclude? include,
  }) {
    return CloudStorageEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CloudStorageEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CloudStorageEntry.t),
      include: include,
    );
  }
}

class _Undefined {}

class _CloudStorageEntryImpl extends CloudStorageEntry {
  _CloudStorageEntryImpl({
    int? id,
    required String storageId,
    required String path,
    required DateTime addedTime,
    DateTime? expiration,
    required _i2.ByteData byteData,
    required bool verified,
  }) : super._(
          id: id,
          storageId: storageId,
          path: path,
          addedTime: addedTime,
          expiration: expiration,
          byteData: byteData,
          verified: verified,
        );

  @override
  CloudStorageEntry copyWith({
    Object? id = _Undefined,
    String? storageId,
    String? path,
    DateTime? addedTime,
    Object? expiration = _Undefined,
    _i2.ByteData? byteData,
    bool? verified,
  }) {
    return CloudStorageEntry(
      id: id is int? ? id : this.id,
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      addedTime: addedTime ?? this.addedTime,
      expiration: expiration is DateTime? ? expiration : this.expiration,
      byteData: byteData ?? this.byteData.clone(),
      verified: verified ?? this.verified,
    );
  }
}

class CloudStorageEntryTable extends _i1.Table {
  CloudStorageEntryTable({super.tableRelation})
      : super(tableName: 'serverpod_cloud_storage') {
    storageId = _i1.ColumnString(
      'storageId',
      this,
    );
    path = _i1.ColumnString(
      'path',
      this,
    );
    addedTime = _i1.ColumnDateTime(
      'addedTime',
      this,
    );
    expiration = _i1.ColumnDateTime(
      'expiration',
      this,
    );
    byteData = _i1.ColumnByteData(
      'byteData',
      this,
    );
    verified = _i1.ColumnBool(
      'verified',
      this,
    );
  }

  /// The storageId, typically `public` or `private`.
  late final _i1.ColumnString storageId;

  /// The path where the file is stored.
  late final _i1.ColumnString path;

  /// The time when the file was added.
  late final _i1.ColumnDateTime addedTime;

  /// The time at which the file expires and can be deleted.
  late final _i1.ColumnDateTime expiration;

  /// The actual data of the uploaded file.
  late final _i1.ColumnByteData byteData;

  /// True if the file has been verified as uploaded.
  late final _i1.ColumnBool verified;

  @override
  List<_i1.Column> get columns => [
        id,
        storageId,
        path,
        addedTime,
        expiration,
        byteData,
        verified,
      ];
}

class CloudStorageEntryInclude extends _i1.IncludeObject {
  CloudStorageEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => CloudStorageEntry.t;
}

class CloudStorageEntryIncludeList extends _i1.IncludeList {
  CloudStorageEntryIncludeList._({
    _i1.WhereExpressionBuilder<CloudStorageEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CloudStorageEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => CloudStorageEntry.t;
}

class CloudStorageEntryRepository {
  const CloudStorageEntryRepository._();

  Future<List<CloudStorageEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CloudStorageEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CloudStorageEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CloudStorageEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CloudStorageEntry>(
      where: where?.call(CloudStorageEntry.t),
      orderBy: orderBy?.call(CloudStorageEntry.t),
      orderByList: orderByList?.call(CloudStorageEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<CloudStorageEntry?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CloudStorageEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<CloudStorageEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CloudStorageEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CloudStorageEntry>(
      where: where?.call(CloudStorageEntry.t),
      orderBy: orderBy?.call(CloudStorageEntry.t),
      orderByList: orderByList?.call(CloudStorageEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<CloudStorageEntry?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CloudStorageEntry>(
      id,
      transaction: transaction,
    );
  }

  Future<List<CloudStorageEntry>> insert(
    _i1.Session session,
    List<CloudStorageEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CloudStorageEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<CloudStorageEntry> insertRow(
    _i1.Session session,
    CloudStorageEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CloudStorageEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<CloudStorageEntry>> update(
    _i1.Session session,
    List<CloudStorageEntry> rows, {
    _i1.ColumnSelections<CloudStorageEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CloudStorageEntry>(
      rows,
      columns: columns?.call(CloudStorageEntry.t),
      transaction: transaction,
    );
  }

  Future<CloudStorageEntry> updateRow(
    _i1.Session session,
    CloudStorageEntry row, {
    _i1.ColumnSelections<CloudStorageEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CloudStorageEntry>(
      row,
      columns: columns?.call(CloudStorageEntry.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<CloudStorageEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CloudStorageEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    CloudStorageEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CloudStorageEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CloudStorageEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CloudStorageEntry>(
      where: where(CloudStorageEntry.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CloudStorageEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CloudStorageEntry>(
      where: where?.call(CloudStorageEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
