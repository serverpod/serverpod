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
import 'dart:typed_data' as _i2;

/// An entry in the database for an uploaded file.
abstract class CloudStorageEntry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CloudStorageEntry._({
    this.id,
    required this.storageId,
    required this.path,
    required this.addedTime,
    this.expiration,
    required this.byteData,
    required this.verified,
  });

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
      addedTime:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['addedTime']),
      expiration: jsonSerialization['expiration'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiration']),
      byteData:
          _i1.ByteDataJsonExtension.fromJson(jsonSerialization['byteData']),
      verified: jsonSerialization['verified'] as bool,
    );
  }

  static final t = CloudStorageEntryTable();

  static const db = CloudStorageEntryRepository._();

  @override
  int? id;

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
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CloudStorageEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
  Map<String, dynamic> toJsonForProtocol() {
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

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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

  /// Returns a shallow copy of this [CloudStorageEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

class CloudStorageEntryTable extends _i1.Table<int?> {
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
  _i1.Table<int?> get table => CloudStorageEntry.t;
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
  _i1.Table<int?> get table => CloudStorageEntry.t;
}

class CloudStorageEntryRepository {
  const CloudStorageEntryRepository._();

  /// Returns a list of [CloudStorageEntry]s matching the given query parameters.
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

  /// Returns the first matching [CloudStorageEntry] matching the given query parameters.
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

  /// Finds a single [CloudStorageEntry] by its [id] or null if no such row exists.
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

  /// Inserts all [CloudStorageEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [CloudStorageEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
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

  /// Inserts a single [CloudStorageEntry] and returns the inserted row.
  ///
  /// The returned [CloudStorageEntry] will have its `id` field set.
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

  /// Updates all [CloudStorageEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
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

  /// Updates a single [CloudStorageEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
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

  /// Deletes all [CloudStorageEntry]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CloudStorageEntry>> delete(
    _i1.Session session,
    List<CloudStorageEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CloudStorageEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CloudStorageEntry].
  Future<CloudStorageEntry> deleteRow(
    _i1.Session session,
    CloudStorageEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CloudStorageEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CloudStorageEntry>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CloudStorageEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CloudStorageEntry>(
      where: where(CloudStorageEntry.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
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
