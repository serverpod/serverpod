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
import 'test_enum.dart' as _i2;

abstract class ObjectWithEnum
    implements _i1.TableRow, _i1.ProtocolSerialization {
  ObjectWithEnum._({
    this.id,
    required this.testEnum,
    this.nullableEnum,
    required this.enumList,
    required this.nullableEnumList,
    required this.enumListList,
  });

  factory ObjectWithEnum({
    int? id,
    required _i2.TestEnum testEnum,
    _i2.TestEnum? nullableEnum,
    required List<_i2.TestEnum> enumList,
    required List<_i2.TestEnum?> nullableEnumList,
    required List<List<_i2.TestEnum>> enumListList,
  }) = _ObjectWithEnumImpl;

  factory ObjectWithEnum.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithEnum(
      id: jsonSerialization['id'] as int?,
      testEnum: _i2.TestEnum.fromJson((jsonSerialization['testEnum'] as int)),
      nullableEnum: jsonSerialization['nullableEnum'] == null
          ? null
          : _i2.TestEnum.fromJson((jsonSerialization['nullableEnum'] as int)),
      enumList: (jsonSerialization['enumList'] as List)
          .map((e) => _i2.TestEnum.fromJson((e as int)))
          .toList(),
      nullableEnumList: (jsonSerialization['nullableEnumList'] as List)
          .map((e) => e == null ? null : _i2.TestEnum.fromJson((e as int)))
          .toList(),
      enumListList: (jsonSerialization['enumListList'] as List)
          .map((e) => (e as List)
              .map((e) => _i2.TestEnum.fromJson((e as int)))
              .toList())
          .toList(),
    );
  }

  static final t = ObjectWithEnumTable();

  static const db = ObjectWithEnumRepository._();

  @override
  int? id;

  _i2.TestEnum testEnum;

  _i2.TestEnum? nullableEnum;

  List<_i2.TestEnum> enumList;

  List<_i2.TestEnum?> nullableEnumList;

  List<List<_i2.TestEnum>> enumListList;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [ObjectWithEnum]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithEnum copyWith({
    int? id,
    _i2.TestEnum? testEnum,
    _i2.TestEnum? nullableEnum,
    List<_i2.TestEnum>? enumList,
    List<_i2.TestEnum?>? nullableEnumList,
    List<List<_i2.TestEnum>>? enumListList,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'testEnum': testEnum.toJson(),
      if (nullableEnum != null) 'nullableEnum': nullableEnum?.toJson(),
      'enumList': enumList.toJson(valueToJson: (v) => v.toJson()),
      'nullableEnumList':
          nullableEnumList.toJson(valueToJson: (v) => v?.toJson()),
      'enumListList': enumListList.toJson(
          valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson())),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'testEnum': testEnum.toJson(),
      if (nullableEnum != null) 'nullableEnum': nullableEnum?.toJson(),
      'enumList': enumList.toJson(valueToJson: (v) => v.toJson()),
      'nullableEnumList':
          nullableEnumList.toJson(valueToJson: (v) => v?.toJson()),
      'enumListList': enumListList.toJson(
          valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson())),
    };
  }

  static ObjectWithEnumInclude include() {
    return ObjectWithEnumInclude._();
  }

  static ObjectWithEnumIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithEnumTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithEnumTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithEnumTable>? orderByList,
    ObjectWithEnumInclude? include,
  }) {
    return ObjectWithEnumIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithEnum.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithEnum.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithEnumImpl extends ObjectWithEnum {
  _ObjectWithEnumImpl({
    int? id,
    required _i2.TestEnum testEnum,
    _i2.TestEnum? nullableEnum,
    required List<_i2.TestEnum> enumList,
    required List<_i2.TestEnum?> nullableEnumList,
    required List<List<_i2.TestEnum>> enumListList,
  }) : super._(
          id: id,
          testEnum: testEnum,
          nullableEnum: nullableEnum,
          enumList: enumList,
          nullableEnumList: nullableEnumList,
          enumListList: enumListList,
        );

  /// Returns a shallow copy of this [ObjectWithEnum]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithEnum copyWith({
    Object? id = _Undefined,
    _i2.TestEnum? testEnum,
    Object? nullableEnum = _Undefined,
    List<_i2.TestEnum>? enumList,
    List<_i2.TestEnum?>? nullableEnumList,
    List<List<_i2.TestEnum>>? enumListList,
  }) {
    return ObjectWithEnum(
      id: id is int? ? id : this.id,
      testEnum: testEnum ?? this.testEnum,
      nullableEnum:
          nullableEnum is _i2.TestEnum? ? nullableEnum : this.nullableEnum,
      enumList: enumList ?? this.enumList.map((e0) => e0).toList(),
      nullableEnumList:
          nullableEnumList ?? this.nullableEnumList.map((e0) => e0).toList(),
      enumListList: enumListList ??
          this.enumListList.map((e0) => e0.map((e1) => e1).toList()).toList(),
    );
  }
}

class ObjectWithEnumTable extends _i1.Table {
  ObjectWithEnumTable({super.tableRelation})
      : super(tableName: 'object_with_enum') {
    testEnum = _i1.ColumnEnum(
      'testEnum',
      this,
      _i1.EnumSerialization.byIndex,
    );
    nullableEnum = _i1.ColumnEnum(
      'nullableEnum',
      this,
      _i1.EnumSerialization.byIndex,
    );
    enumList = _i1.ColumnSerializable(
      'enumList',
      this,
    );
    nullableEnumList = _i1.ColumnSerializable(
      'nullableEnumList',
      this,
    );
    enumListList = _i1.ColumnSerializable(
      'enumListList',
      this,
    );
  }

  late final _i1.ColumnEnum<_i2.TestEnum> testEnum;

  late final _i1.ColumnEnum<_i2.TestEnum> nullableEnum;

  late final _i1.ColumnSerializable enumList;

  late final _i1.ColumnSerializable nullableEnumList;

  late final _i1.ColumnSerializable enumListList;

  @override
  List<_i1.Column> get columns => [
        id,
        testEnum,
        nullableEnum,
        enumList,
        nullableEnumList,
        enumListList,
      ];
}

class ObjectWithEnumInclude extends _i1.IncludeObject {
  ObjectWithEnumInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ObjectWithEnum.t;
}

class ObjectWithEnumIncludeList extends _i1.IncludeList {
  ObjectWithEnumIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithEnumTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithEnum.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ObjectWithEnum.t;
}

class ObjectWithEnumRepository {
  const ObjectWithEnumRepository._();

  /// Returns a list of [ObjectWithEnum]s matching the given query parameters.
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
  Future<List<ObjectWithEnum>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithEnumTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithEnumTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithEnumTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithEnum>(
      where: where?.call(ObjectWithEnum.t),
      orderBy: orderBy?.call(ObjectWithEnum.t),
      orderByList: orderByList?.call(ObjectWithEnum.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ObjectWithEnum] matching the given query parameters.
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
  Future<ObjectWithEnum?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithEnumTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithEnumTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithEnumTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithEnum>(
      where: where?.call(ObjectWithEnum.t),
      orderBy: orderBy?.call(ObjectWithEnum.t),
      orderByList: orderByList?.call(ObjectWithEnum.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ObjectWithEnum] by its [id] or null if no such row exists.
  Future<ObjectWithEnum?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithEnum>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ObjectWithEnum]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithEnum]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectWithEnum>> insert(
    _i1.Session session,
    List<ObjectWithEnum> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithEnum>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectWithEnum] and returns the inserted row.
  ///
  /// The returned [ObjectWithEnum] will have its `id` field set.
  Future<ObjectWithEnum> insertRow(
    _i1.Session session,
    ObjectWithEnum row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithEnum>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithEnum]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithEnum>> update(
    _i1.Session session,
    List<ObjectWithEnum> rows, {
    _i1.ColumnSelections<ObjectWithEnumTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithEnum>(
      rows,
      columns: columns?.call(ObjectWithEnum.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithEnum]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithEnum> updateRow(
    _i1.Session session,
    ObjectWithEnum row, {
    _i1.ColumnSelections<ObjectWithEnumTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithEnum>(
      row,
      columns: columns?.call(ObjectWithEnum.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithEnum]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithEnum>> delete(
    _i1.Session session,
    List<ObjectWithEnum> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithEnum>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithEnum].
  Future<ObjectWithEnum> deleteRow(
    _i1.Session session,
    ObjectWithEnum row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithEnum>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithEnum>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithEnumTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithEnum>(
      where: where(ObjectWithEnum.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithEnumTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithEnum>(
      where: where?.call(ObjectWithEnum.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
