/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'inheritance/sealed_parent.dart' as _i2;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i3;

abstract class ObjectWithSealedClass
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithSealedClass._({
    this.id,
    required this.sealedField,
    this.nullableSealedField,
    required this.sealedList,
  });

  factory ObjectWithSealedClass({
    int? id,
    required _i2.SealedParent sealedField,
    _i2.SealedParent? nullableSealedField,
    required List<_i2.SealedParent> sealedList,
  }) = _ObjectWithSealedClassImpl;

  factory ObjectWithSealedClass.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithSealedClass(
      id: jsonSerialization['id'] as int?,
      sealedField: _i3.Protocol().deserialize<_i2.SealedParent>(
        jsonSerialization['sealedField'],
      ),
      nullableSealedField: jsonSerialization['nullableSealedField'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.SealedParent>(
              jsonSerialization['nullableSealedField'],
            ),
      sealedList: _i3.Protocol().deserialize<List<_i2.SealedParent>>(
        jsonSerialization['sealedList'],
      ),
    );
  }

  static final t = ObjectWithSealedClassTable();

  static const db = ObjectWithSealedClassRepository._();

  @override
  int? id;

  _i2.SealedParent sealedField;

  _i2.SealedParent? nullableSealedField;

  List<_i2.SealedParent> sealedList;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithSealedClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithSealedClass copyWith({
    int? id,
    _i2.SealedParent? sealedField,
    _i2.SealedParent? nullableSealedField,
    List<_i2.SealedParent>? sealedList,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithSealedClass',
      if (id != null) 'id': id,
      'sealedField': sealedField.toJson(),
      if (nullableSealedField != null)
        'nullableSealedField': nullableSealedField?.toJson(),
      'sealedList': sealedList.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithSealedClass',
      if (id != null) 'id': id,
      'sealedField': sealedField.toJsonForProtocol(),
      if (nullableSealedField != null)
        'nullableSealedField': nullableSealedField?.toJsonForProtocol(),
      'sealedList': sealedList.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  static ObjectWithSealedClassInclude include() {
    return ObjectWithSealedClassInclude._();
  }

  static ObjectWithSealedClassIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithSealedClassTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithSealedClassTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithSealedClassTable>? orderByList,
    ObjectWithSealedClassInclude? include,
  }) {
    return ObjectWithSealedClassIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithSealedClass.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithSealedClass.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithSealedClassImpl extends ObjectWithSealedClass {
  _ObjectWithSealedClassImpl({
    int? id,
    required _i2.SealedParent sealedField,
    _i2.SealedParent? nullableSealedField,
    required List<_i2.SealedParent> sealedList,
  }) : super._(
         id: id,
         sealedField: sealedField,
         nullableSealedField: nullableSealedField,
         sealedList: sealedList,
       );

  /// Returns a shallow copy of this [ObjectWithSealedClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithSealedClass copyWith({
    Object? id = _Undefined,
    _i2.SealedParent? sealedField,
    Object? nullableSealedField = _Undefined,
    List<_i2.SealedParent>? sealedList,
  }) {
    return ObjectWithSealedClass(
      id: id is int? ? id : this.id,
      sealedField: sealedField ?? this.sealedField.copyWith(),
      nullableSealedField: nullableSealedField is _i2.SealedParent?
          ? nullableSealedField
          : this.nullableSealedField?.copyWith(),
      sealedList:
          sealedList ?? this.sealedList.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class ObjectWithSealedClassUpdateTable
    extends _i1.UpdateTable<ObjectWithSealedClassTable> {
  ObjectWithSealedClassUpdateTable(super.table);

  _i1.ColumnValue<_i2.SealedParent, _i2.SealedParent> sealedField(
    _i2.SealedParent value,
  ) => _i1.ColumnValue(
    table.sealedField,
    value,
  );

  _i1.ColumnValue<_i2.SealedParent, _i2.SealedParent> nullableSealedField(
    _i2.SealedParent? value,
  ) => _i1.ColumnValue(
    table.nullableSealedField,
    value,
  );

  _i1.ColumnValue<List<_i2.SealedParent>, List<_i2.SealedParent>> sealedList(
    List<_i2.SealedParent> value,
  ) => _i1.ColumnValue(
    table.sealedList,
    value,
  );
}

class ObjectWithSealedClassTable extends _i1.Table<int?> {
  ObjectWithSealedClassTable({super.tableRelation})
    : super(tableName: 'object_with_sealed_class') {
    updateTable = ObjectWithSealedClassUpdateTable(this);
    sealedField = _i1.ColumnSerializable<_i2.SealedParent>(
      'sealedField',
      this,
    );
    nullableSealedField = _i1.ColumnSerializable<_i2.SealedParent>(
      'nullableSealedField',
      this,
    );
    sealedList = _i1.ColumnSerializable<List<_i2.SealedParent>>(
      'sealedList',
      this,
    );
  }

  late final ObjectWithSealedClassUpdateTable updateTable;

  late final _i1.ColumnSerializable<_i2.SealedParent> sealedField;

  late final _i1.ColumnSerializable<_i2.SealedParent> nullableSealedField;

  late final _i1.ColumnSerializable<List<_i2.SealedParent>> sealedList;

  @override
  List<_i1.Column> get columns => [
    id,
    sealedField,
    nullableSealedField,
    sealedList,
  ];
}

class ObjectWithSealedClassInclude extends _i1.IncludeObject {
  ObjectWithSealedClassInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithSealedClass.t;
}

class ObjectWithSealedClassIncludeList extends _i1.IncludeList {
  ObjectWithSealedClassIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithSealedClassTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithSealedClass.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithSealedClass.t;
}

class ObjectWithSealedClassRepository {
  const ObjectWithSealedClassRepository._();

  /// Returns a list of [ObjectWithSealedClass]s matching the given query parameters.
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
  Future<List<ObjectWithSealedClass>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithSealedClassTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithSealedClassTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithSealedClassTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithSealedClass>(
      where: where?.call(ObjectWithSealedClass.t),
      orderBy: orderBy?.call(ObjectWithSealedClass.t),
      orderByList: orderByList?.call(ObjectWithSealedClass.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ObjectWithSealedClass] matching the given query parameters.
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
  Future<ObjectWithSealedClass?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithSealedClassTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithSealedClassTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithSealedClassTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ObjectWithSealedClass>(
      where: where?.call(ObjectWithSealedClass.t),
      orderBy: orderBy?.call(ObjectWithSealedClass.t),
      orderByList: orderByList?.call(ObjectWithSealedClass.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ObjectWithSealedClass] by its [id] or null if no such row exists.
  Future<ObjectWithSealedClass?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ObjectWithSealedClass>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ObjectWithSealedClass]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithSealedClass]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ObjectWithSealedClass>> insert(
    _i1.Session session,
    List<ObjectWithSealedClass> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ObjectWithSealedClass>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ObjectWithSealedClass] and returns the inserted row.
  ///
  /// The returned [ObjectWithSealedClass] will have its `id` field set.
  Future<ObjectWithSealedClass> insertRow(
    _i1.Session session,
    ObjectWithSealedClass row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithSealedClass>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithSealedClass]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ObjectWithSealedClass>> update(
    _i1.Session session,
    List<ObjectWithSealedClass> rows, {
    _i1.ColumnSelections<ObjectWithSealedClassTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ObjectWithSealedClass>(
      rows,
      columns: columns?.call(ObjectWithSealedClass.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithSealedClass]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithSealedClass> updateRow(
    _i1.Session session,
    ObjectWithSealedClass row, {
    _i1.ColumnSelections<ObjectWithSealedClassTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithSealedClass>(
      row,
      columns: columns?.call(ObjectWithSealedClass.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithSealedClass] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithSealedClass?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ObjectWithSealedClassUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithSealedClass>(
      id,
      columnValues: columnValues(ObjectWithSealedClass.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithSealedClass]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ObjectWithSealedClass>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ObjectWithSealedClassUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ObjectWithSealedClassTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithSealedClassTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithSealedClassTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ObjectWithSealedClass>(
      columnValues: columnValues(ObjectWithSealedClass.t.updateTable),
      where: where(ObjectWithSealedClass.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithSealedClass.t),
      orderByList: orderByList?.call(ObjectWithSealedClass.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ObjectWithSealedClass]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ObjectWithSealedClass>> delete(
    _i1.Session session,
    List<ObjectWithSealedClass> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithSealedClass>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ObjectWithSealedClass].
  Future<ObjectWithSealedClass> deleteRow(
    _i1.Session session,
    ObjectWithSealedClass row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithSealedClass>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ObjectWithSealedClass>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithSealedClassTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ObjectWithSealedClass>(
      where: where(ObjectWithSealedClass.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithSealedClassTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithSealedClass>(
      where: where?.call(ObjectWithSealedClass.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
