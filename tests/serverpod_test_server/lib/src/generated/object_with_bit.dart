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

abstract class ObjectWithBit
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithBit._({
    this.id,
    required this.bit,
    this.bitNullable,
    required this.bitIndexedHnsw,
    required this.bitIndexedHnswWithParams,
    required this.bitIndexedIvfflat,
    required this.bitIndexedIvfflatWithParams,
  });

  factory ObjectWithBit({
    int? id,
    required _i1.Bit bit,
    _i1.Bit? bitNullable,
    required _i1.Bit bitIndexedHnsw,
    required _i1.Bit bitIndexedHnswWithParams,
    required _i1.Bit bitIndexedIvfflat,
    required _i1.Bit bitIndexedIvfflatWithParams,
  }) = _ObjectWithBitImpl;

  factory ObjectWithBit.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithBit(
      id: jsonSerialization['id'] as int?,
      bit: _i1.BitJsonExtension.fromJson(jsonSerialization['bit']),
      bitNullable: jsonSerialization['bitNullable'] == null
          ? null
          : _i1.BitJsonExtension.fromJson(jsonSerialization['bitNullable']),
      bitIndexedHnsw:
          _i1.BitJsonExtension.fromJson(jsonSerialization['bitIndexedHnsw']),
      bitIndexedHnswWithParams: _i1.BitJsonExtension.fromJson(
          jsonSerialization['bitIndexedHnswWithParams']),
      bitIndexedIvfflat:
          _i1.BitJsonExtension.fromJson(jsonSerialization['bitIndexedIvfflat']),
      bitIndexedIvfflatWithParams: _i1.BitJsonExtension.fromJson(
          jsonSerialization['bitIndexedIvfflatWithParams']),
    );
  }

  static final t = ObjectWithBitTable();

  static const db = ObjectWithBitRepository._();

  @override
  int? id;

  _i1.Bit bit;

  _i1.Bit? bitNullable;

  _i1.Bit bitIndexedHnsw;

  _i1.Bit bitIndexedHnswWithParams;

  _i1.Bit bitIndexedIvfflat;

  _i1.Bit bitIndexedIvfflatWithParams;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithBit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithBit copyWith({
    int? id,
    _i1.Bit? bit,
    _i1.Bit? bitNullable,
    _i1.Bit? bitIndexedHnsw,
    _i1.Bit? bitIndexedHnswWithParams,
    _i1.Bit? bitIndexedIvfflat,
    _i1.Bit? bitIndexedIvfflatWithParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'bit': bit.toJson(),
      if (bitNullable != null) 'bitNullable': bitNullable?.toJson(),
      'bitIndexedHnsw': bitIndexedHnsw.toJson(),
      'bitIndexedHnswWithParams': bitIndexedHnswWithParams.toJson(),
      'bitIndexedIvfflat': bitIndexedIvfflat.toJson(),
      'bitIndexedIvfflatWithParams': bitIndexedIvfflatWithParams.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'bit': bit.toJson(),
      if (bitNullable != null) 'bitNullable': bitNullable?.toJson(),
      'bitIndexedHnsw': bitIndexedHnsw.toJson(),
      'bitIndexedHnswWithParams': bitIndexedHnswWithParams.toJson(),
      'bitIndexedIvfflat': bitIndexedIvfflat.toJson(),
      'bitIndexedIvfflatWithParams': bitIndexedIvfflatWithParams.toJson(),
    };
  }

  static ObjectWithBitInclude include() {
    return ObjectWithBitInclude._();
  }

  static ObjectWithBitIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithBitTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithBitTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithBitTable>? orderByList,
    ObjectWithBitInclude? include,
  }) {
    return ObjectWithBitIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithBit.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithBit.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithBitImpl extends ObjectWithBit {
  _ObjectWithBitImpl({
    int? id,
    required _i1.Bit bit,
    _i1.Bit? bitNullable,
    required _i1.Bit bitIndexedHnsw,
    required _i1.Bit bitIndexedHnswWithParams,
    required _i1.Bit bitIndexedIvfflat,
    required _i1.Bit bitIndexedIvfflatWithParams,
  }) : super._(
          id: id,
          bit: bit,
          bitNullable: bitNullable,
          bitIndexedHnsw: bitIndexedHnsw,
          bitIndexedHnswWithParams: bitIndexedHnswWithParams,
          bitIndexedIvfflat: bitIndexedIvfflat,
          bitIndexedIvfflatWithParams: bitIndexedIvfflatWithParams,
        );

  /// Returns a shallow copy of this [ObjectWithBit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithBit copyWith({
    Object? id = _Undefined,
    _i1.Bit? bit,
    Object? bitNullable = _Undefined,
    _i1.Bit? bitIndexedHnsw,
    _i1.Bit? bitIndexedHnswWithParams,
    _i1.Bit? bitIndexedIvfflat,
    _i1.Bit? bitIndexedIvfflatWithParams,
  }) {
    return ObjectWithBit(
      id: id is int? ? id : this.id,
      bit: bit ?? this.bit.clone(),
      bitNullable:
          bitNullable is _i1.Bit? ? bitNullable : this.bitNullable?.clone(),
      bitIndexedHnsw: bitIndexedHnsw ?? this.bitIndexedHnsw.clone(),
      bitIndexedHnswWithParams:
          bitIndexedHnswWithParams ?? this.bitIndexedHnswWithParams.clone(),
      bitIndexedIvfflat: bitIndexedIvfflat ?? this.bitIndexedIvfflat.clone(),
      bitIndexedIvfflatWithParams: bitIndexedIvfflatWithParams ??
          this.bitIndexedIvfflatWithParams.clone(),
    );
  }
}

class ObjectWithBitTable extends _i1.Table<int?> {
  ObjectWithBitTable({super.tableRelation})
      : super(tableName: 'object_with_bit') {
    bit = _i1.ColumnBit(
      'bit',
      this,
      dimension: 512,
    );
    bitNullable = _i1.ColumnBit(
      'bitNullable',
      this,
      dimension: 512,
    );
    bitIndexedHnsw = _i1.ColumnBit(
      'bitIndexedHnsw',
      this,
      dimension: 512,
    );
    bitIndexedHnswWithParams = _i1.ColumnBit(
      'bitIndexedHnswWithParams',
      this,
      dimension: 512,
    );
    bitIndexedIvfflat = _i1.ColumnBit(
      'bitIndexedIvfflat',
      this,
      dimension: 512,
    );
    bitIndexedIvfflatWithParams = _i1.ColumnBit(
      'bitIndexedIvfflatWithParams',
      this,
      dimension: 512,
    );
  }

  late final _i1.ColumnBit bit;

  late final _i1.ColumnBit bitNullable;

  late final _i1.ColumnBit bitIndexedHnsw;

  late final _i1.ColumnBit bitIndexedHnswWithParams;

  late final _i1.ColumnBit bitIndexedIvfflat;

  late final _i1.ColumnBit bitIndexedIvfflatWithParams;

  @override
  List<_i1.Column> get columns => [
        id,
        bit,
        bitNullable,
        bitIndexedHnsw,
        bitIndexedHnswWithParams,
        bitIndexedIvfflat,
        bitIndexedIvfflatWithParams,
      ];
}

class ObjectWithBitInclude extends _i1.IncludeObject {
  ObjectWithBitInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithBit.t;
}

class ObjectWithBitIncludeList extends _i1.IncludeList {
  ObjectWithBitIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithBitTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithBit.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithBit.t;
}

class ObjectWithBitRepository {
  const ObjectWithBitRepository._();

  /// Returns a list of [ObjectWithBit]s matching the given query parameters.
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
  Future<List<ObjectWithBit>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithBitTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithBitTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithBitTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithBit>(
      where: where?.call(ObjectWithBit.t),
      orderBy: orderBy?.call(ObjectWithBit.t),
      orderByList: orderByList?.call(ObjectWithBit.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ObjectWithBit] matching the given query parameters.
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
  Future<ObjectWithBit?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithBitTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithBitTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithBitTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithBit>(
      where: where?.call(ObjectWithBit.t),
      orderBy: orderBy?.call(ObjectWithBit.t),
      orderByList: orderByList?.call(ObjectWithBit.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ObjectWithBit] by its [id] or null if no such row exists.
  Future<ObjectWithBit?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithBit>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ObjectWithBit]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithBit]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectWithBit>> insert(
    _i1.Session session,
    List<ObjectWithBit> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithBit>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectWithBit] and returns the inserted row.
  ///
  /// The returned [ObjectWithBit] will have its `id` field set.
  Future<ObjectWithBit> insertRow(
    _i1.Session session,
    ObjectWithBit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithBit>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithBit]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithBit>> update(
    _i1.Session session,
    List<ObjectWithBit> rows, {
    _i1.ColumnSelections<ObjectWithBitTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithBit>(
      rows,
      columns: columns?.call(ObjectWithBit.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithBit]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithBit> updateRow(
    _i1.Session session,
    ObjectWithBit row, {
    _i1.ColumnSelections<ObjectWithBitTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithBit>(
      row,
      columns: columns?.call(ObjectWithBit.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithBit]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithBit>> delete(
    _i1.Session session,
    List<ObjectWithBit> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithBit>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithBit].
  Future<ObjectWithBit> deleteRow(
    _i1.Session session,
    ObjectWithBit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithBit>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithBit>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithBitTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithBit>(
      where: where(ObjectWithBit.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithBitTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithBit>(
      where: where?.call(ObjectWithBit.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
