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
import 'unique_data.dart' as _i2;

abstract class RelatedUniqueData
    implements _i1.TableRow, _i1.ProtocolSerialization {
  RelatedUniqueData._({
    this.id,
    required this.uniqueDataId,
    this.uniqueData,
    required this.number,
  });

  factory RelatedUniqueData({
    int? id,
    required int uniqueDataId,
    _i2.UniqueData? uniqueData,
    required int number,
  }) = _RelatedUniqueDataImpl;

  factory RelatedUniqueData.fromJson(Map<String, dynamic> jsonSerialization) {
    return RelatedUniqueData(
      id: jsonSerialization['id'] as int?,
      uniqueDataId: jsonSerialization['uniqueDataId'] as int,
      uniqueData: jsonSerialization['uniqueData'] == null
          ? null
          : _i2.UniqueData.fromJson(
              (jsonSerialization['uniqueData'] as Map<String, dynamic>)),
      number: jsonSerialization['number'] as int,
    );
  }

  static final t = RelatedUniqueDataTable();

  static const db = RelatedUniqueDataRepository._();

  @override
  int? id;

  int uniqueDataId;

  _i2.UniqueData? uniqueData;

  int number;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [RelatedUniqueData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RelatedUniqueData copyWith({
    int? id,
    int? uniqueDataId,
    _i2.UniqueData? uniqueData,
    int? number,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uniqueDataId': uniqueDataId,
      if (uniqueData != null) 'uniqueData': uniqueData?.toJson(),
      'number': number,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'uniqueDataId': uniqueDataId,
      if (uniqueData != null) 'uniqueData': uniqueData?.toJsonForProtocol(),
      'number': number,
    };
  }

  static RelatedUniqueDataInclude include({_i2.UniqueDataInclude? uniqueData}) {
    return RelatedUniqueDataInclude._(uniqueData: uniqueData);
  }

  static RelatedUniqueDataIncludeList includeList({
    _i1.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RelatedUniqueDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RelatedUniqueDataTable>? orderByList,
    RelatedUniqueDataInclude? include,
  }) {
    return RelatedUniqueDataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RelatedUniqueData.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RelatedUniqueData.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RelatedUniqueDataImpl extends RelatedUniqueData {
  _RelatedUniqueDataImpl({
    int? id,
    required int uniqueDataId,
    _i2.UniqueData? uniqueData,
    required int number,
  }) : super._(
          id: id,
          uniqueDataId: uniqueDataId,
          uniqueData: uniqueData,
          number: number,
        );

  /// Returns a shallow copy of this [RelatedUniqueData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RelatedUniqueData copyWith({
    Object? id = _Undefined,
    int? uniqueDataId,
    Object? uniqueData = _Undefined,
    int? number,
  }) {
    return RelatedUniqueData(
      id: id is int? ? id : this.id,
      uniqueDataId: uniqueDataId ?? this.uniqueDataId,
      uniqueData: uniqueData is _i2.UniqueData?
          ? uniqueData
          : this.uniqueData?.copyWith(),
      number: number ?? this.number,
    );
  }
}

class RelatedUniqueDataTable extends _i1.Table {
  RelatedUniqueDataTable({super.tableRelation})
      : super(tableName: 'related_unique_data') {
    uniqueDataId = _i1.ColumnInt(
      'uniqueDataId',
      this,
    );
    number = _i1.ColumnInt(
      'number',
      this,
    );
  }

  late final _i1.ColumnInt uniqueDataId;

  _i2.UniqueDataTable? _uniqueData;

  late final _i1.ColumnInt number;

  _i2.UniqueDataTable get uniqueData {
    if (_uniqueData != null) return _uniqueData!;
    _uniqueData = _i1.createRelationTable(
      relationFieldName: 'uniqueData',
      field: RelatedUniqueData.t.uniqueDataId,
      foreignField: _i2.UniqueData.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UniqueDataTable(tableRelation: foreignTableRelation),
    );
    return _uniqueData!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        uniqueDataId,
        number,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'uniqueData') {
      return uniqueData;
    }
    return null;
  }
}

class RelatedUniqueDataInclude extends _i1.IncludeObject {
  RelatedUniqueDataInclude._({_i2.UniqueDataInclude? uniqueData}) {
    _uniqueData = uniqueData;
  }

  _i2.UniqueDataInclude? _uniqueData;

  @override
  Map<String, _i1.Include?> get includes => {'uniqueData': _uniqueData};

  @override
  _i1.Table get table => RelatedUniqueData.t;
}

class RelatedUniqueDataIncludeList extends _i1.IncludeList {
  RelatedUniqueDataIncludeList._({
    _i1.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RelatedUniqueData.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => RelatedUniqueData.t;
}

class RelatedUniqueDataRepository {
  const RelatedUniqueDataRepository._();

  final attachRow = const RelatedUniqueDataAttachRowRepository._();

  /// Returns a list of [RelatedUniqueData]s matching the given query parameters.
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
  Future<List<RelatedUniqueData>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RelatedUniqueDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RelatedUniqueDataTable>? orderByList,
    _i1.Transaction? transaction,
    RelatedUniqueDataInclude? include,
  }) async {
    return session.db.find<RelatedUniqueData>(
      where: where?.call(RelatedUniqueData.t),
      orderBy: orderBy?.call(RelatedUniqueData.t),
      orderByList: orderByList?.call(RelatedUniqueData.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [RelatedUniqueData] matching the given query parameters.
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
  Future<RelatedUniqueData?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    int? offset,
    _i1.OrderByBuilder<RelatedUniqueDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RelatedUniqueDataTable>? orderByList,
    _i1.Transaction? transaction,
    RelatedUniqueDataInclude? include,
  }) async {
    return session.db.findFirstRow<RelatedUniqueData>(
      where: where?.call(RelatedUniqueData.t),
      orderBy: orderBy?.call(RelatedUniqueData.t),
      orderByList: orderByList?.call(RelatedUniqueData.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [RelatedUniqueData] by its [id] or null if no such row exists.
  Future<RelatedUniqueData?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    RelatedUniqueDataInclude? include,
  }) async {
    return session.db.findById<RelatedUniqueData>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [RelatedUniqueData]s in the list and returns the inserted rows.
  ///
  /// The returned [RelatedUniqueData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<RelatedUniqueData>> insert(
    _i1.Session session,
    List<RelatedUniqueData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<RelatedUniqueData>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [RelatedUniqueData] and returns the inserted row.
  ///
  /// The returned [RelatedUniqueData] will have its `id` field set.
  Future<RelatedUniqueData> insertRow(
    _i1.Session session,
    RelatedUniqueData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RelatedUniqueData>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RelatedUniqueData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RelatedUniqueData>> update(
    _i1.Session session,
    List<RelatedUniqueData> rows, {
    _i1.ColumnSelections<RelatedUniqueDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RelatedUniqueData>(
      rows,
      columns: columns?.call(RelatedUniqueData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RelatedUniqueData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RelatedUniqueData> updateRow(
    _i1.Session session,
    RelatedUniqueData row, {
    _i1.ColumnSelections<RelatedUniqueDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RelatedUniqueData>(
      row,
      columns: columns?.call(RelatedUniqueData.t),
      transaction: transaction,
    );
  }

  /// Deletes all [RelatedUniqueData]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RelatedUniqueData>> delete(
    _i1.Session session,
    List<RelatedUniqueData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RelatedUniqueData>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RelatedUniqueData].
  Future<RelatedUniqueData> deleteRow(
    _i1.Session session,
    RelatedUniqueData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RelatedUniqueData>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RelatedUniqueData>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RelatedUniqueDataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RelatedUniqueData>(
      where: where(RelatedUniqueData.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RelatedUniqueData>(
      where: where?.call(RelatedUniqueData.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class RelatedUniqueDataAttachRowRepository {
  const RelatedUniqueDataAttachRowRepository._();

  /// Creates a relation between the given [RelatedUniqueData] and [UniqueData]
  /// by setting the [RelatedUniqueData]'s foreign key `uniqueDataId` to refer to the [UniqueData].
  Future<void> uniqueData(
    _i1.Session session,
    RelatedUniqueData relatedUniqueData,
    _i2.UniqueData uniqueData, {
    _i1.Transaction? transaction,
  }) async {
    if (relatedUniqueData.id == null) {
      throw ArgumentError.notNull('relatedUniqueData.id');
    }
    if (uniqueData.id == null) {
      throw ArgumentError.notNull('uniqueData.id');
    }

    var $relatedUniqueData =
        relatedUniqueData.copyWith(uniqueDataId: uniqueData.id);
    await session.db.updateRow<RelatedUniqueData>(
      $relatedUniqueData,
      columns: [RelatedUniqueData.t.uniqueDataId],
      transaction: transaction,
    );
  }
}
