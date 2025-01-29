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
import '../../long_identifiers/multiple_max_field_name.dart' as _i2;

abstract class RelationToMultipleMaxFieldName
    implements _i1.TableRow, _i1.ProtocolSerialization {
  RelationToMultipleMaxFieldName._({
    this.id,
    required this.name,
    this.multipleMaxFieldNames,
  });

  factory RelationToMultipleMaxFieldName({
    int? id,
    required String name,
    List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames,
  }) = _RelationToMultipleMaxFieldNameImpl;

  factory RelationToMultipleMaxFieldName.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return RelationToMultipleMaxFieldName(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      multipleMaxFieldNames: (jsonSerialization['multipleMaxFieldNames']
              as List?)
          ?.map((e) =>
              _i2.MultipleMaxFieldName.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = RelationToMultipleMaxFieldNameTable();

  static const db = RelationToMultipleMaxFieldNameRepository._();

  @override
  int? id;

  String name;

  List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [RelationToMultipleMaxFieldName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RelationToMultipleMaxFieldName copyWith({
    int? id,
    String? name,
    List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (multipleMaxFieldNames != null)
        'multipleMaxFieldNames':
            multipleMaxFieldNames?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (multipleMaxFieldNames != null)
        'multipleMaxFieldNames': multipleMaxFieldNames?.toJson(
            valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static RelationToMultipleMaxFieldNameInclude include(
      {_i2.MultipleMaxFieldNameIncludeList? multipleMaxFieldNames}) {
    return RelationToMultipleMaxFieldNameInclude._(
        multipleMaxFieldNames: multipleMaxFieldNames);
  }

  static RelationToMultipleMaxFieldNameIncludeList includeList({
    _i1.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RelationToMultipleMaxFieldNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RelationToMultipleMaxFieldNameTable>? orderByList,
    RelationToMultipleMaxFieldNameInclude? include,
  }) {
    return RelationToMultipleMaxFieldNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RelationToMultipleMaxFieldName.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RelationToMultipleMaxFieldName.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RelationToMultipleMaxFieldNameImpl
    extends RelationToMultipleMaxFieldName {
  _RelationToMultipleMaxFieldNameImpl({
    int? id,
    required String name,
    List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames,
  }) : super._(
          id: id,
          name: name,
          multipleMaxFieldNames: multipleMaxFieldNames,
        );

  /// Returns a shallow copy of this [RelationToMultipleMaxFieldName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RelationToMultipleMaxFieldName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? multipleMaxFieldNames = _Undefined,
  }) {
    return RelationToMultipleMaxFieldName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      multipleMaxFieldNames:
          multipleMaxFieldNames is List<_i2.MultipleMaxFieldName>?
              ? multipleMaxFieldNames
              : this.multipleMaxFieldNames?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class RelationToMultipleMaxFieldNameTable extends _i1.Table {
  RelationToMultipleMaxFieldNameTable({super.tableRelation})
      : super(tableName: 'relation_to_multiple_max_field_name') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.MultipleMaxFieldNameTable? ___multipleMaxFieldNames;

  _i1.ManyRelation<_i2.MultipleMaxFieldNameTable>? _multipleMaxFieldNames;

  _i2.MultipleMaxFieldNameTable get __multipleMaxFieldNames {
    if (___multipleMaxFieldNames != null) return ___multipleMaxFieldNames!;
    ___multipleMaxFieldNames = _i1.createRelationTable(
      relationFieldName: '__multipleMaxFieldNames',
      field: RelationToMultipleMaxFieldName.t.id,
      foreignField: _i2.MultipleMaxFieldName.t
          .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.MultipleMaxFieldNameTable(tableRelation: foreignTableRelation),
    );
    return ___multipleMaxFieldNames!;
  }

  _i1.ManyRelation<_i2.MultipleMaxFieldNameTable> get multipleMaxFieldNames {
    if (_multipleMaxFieldNames != null) return _multipleMaxFieldNames!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'multipleMaxFieldNames',
      field: RelationToMultipleMaxFieldName.t.id,
      foreignField: _i2.MultipleMaxFieldName.t
          .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.MultipleMaxFieldNameTable(tableRelation: foreignTableRelation),
    );
    _multipleMaxFieldNames = _i1.ManyRelation<_i2.MultipleMaxFieldNameTable>(
      tableWithRelations: relationTable,
      table: _i2.MultipleMaxFieldNameTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _multipleMaxFieldNames!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'multipleMaxFieldNames') {
      return __multipleMaxFieldNames;
    }
    return null;
  }
}

class RelationToMultipleMaxFieldNameInclude extends _i1.IncludeObject {
  RelationToMultipleMaxFieldNameInclude._(
      {_i2.MultipleMaxFieldNameIncludeList? multipleMaxFieldNames}) {
    _multipleMaxFieldNames = multipleMaxFieldNames;
  }

  _i2.MultipleMaxFieldNameIncludeList? _multipleMaxFieldNames;

  @override
  Map<String, _i1.Include?> get includes =>
      {'multipleMaxFieldNames': _multipleMaxFieldNames};

  @override
  _i1.Table get table => RelationToMultipleMaxFieldName.t;
}

class RelationToMultipleMaxFieldNameIncludeList extends _i1.IncludeList {
  RelationToMultipleMaxFieldNameIncludeList._({
    _i1.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RelationToMultipleMaxFieldName.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => RelationToMultipleMaxFieldName.t;
}

class RelationToMultipleMaxFieldNameRepository {
  const RelationToMultipleMaxFieldNameRepository._();

  final attach = const RelationToMultipleMaxFieldNameAttachRepository._();

  final attachRow = const RelationToMultipleMaxFieldNameAttachRowRepository._();

  final detach = const RelationToMultipleMaxFieldNameDetachRepository._();

  final detachRow = const RelationToMultipleMaxFieldNameDetachRowRepository._();

  /// Returns a list of [RelationToMultipleMaxFieldName]s matching the given query parameters.
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
  Future<List<RelationToMultipleMaxFieldName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RelationToMultipleMaxFieldNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RelationToMultipleMaxFieldNameTable>? orderByList,
    _i1.Transaction? transaction,
    RelationToMultipleMaxFieldNameInclude? include,
  }) async {
    return session.db.find<RelationToMultipleMaxFieldName>(
      where: where?.call(RelationToMultipleMaxFieldName.t),
      orderBy: orderBy?.call(RelationToMultipleMaxFieldName.t),
      orderByList: orderByList?.call(RelationToMultipleMaxFieldName.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [RelationToMultipleMaxFieldName] matching the given query parameters.
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
  Future<RelationToMultipleMaxFieldName?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    int? offset,
    _i1.OrderByBuilder<RelationToMultipleMaxFieldNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RelationToMultipleMaxFieldNameTable>? orderByList,
    _i1.Transaction? transaction,
    RelationToMultipleMaxFieldNameInclude? include,
  }) async {
    return session.db.findFirstRow<RelationToMultipleMaxFieldName>(
      where: where?.call(RelationToMultipleMaxFieldName.t),
      orderBy: orderBy?.call(RelationToMultipleMaxFieldName.t),
      orderByList: orderByList?.call(RelationToMultipleMaxFieldName.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [RelationToMultipleMaxFieldName] by its [id] or null if no such row exists.
  Future<RelationToMultipleMaxFieldName?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    RelationToMultipleMaxFieldNameInclude? include,
  }) async {
    return session.db.findById<RelationToMultipleMaxFieldName>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [RelationToMultipleMaxFieldName]s in the list and returns the inserted rows.
  ///
  /// The returned [RelationToMultipleMaxFieldName]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<RelationToMultipleMaxFieldName>> insert(
    _i1.Session session,
    List<RelationToMultipleMaxFieldName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<RelationToMultipleMaxFieldName>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [RelationToMultipleMaxFieldName] and returns the inserted row.
  ///
  /// The returned [RelationToMultipleMaxFieldName] will have its `id` field set.
  Future<RelationToMultipleMaxFieldName> insertRow(
    _i1.Session session,
    RelationToMultipleMaxFieldName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RelationToMultipleMaxFieldName>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RelationToMultipleMaxFieldName]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RelationToMultipleMaxFieldName>> update(
    _i1.Session session,
    List<RelationToMultipleMaxFieldName> rows, {
    _i1.ColumnSelections<RelationToMultipleMaxFieldNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RelationToMultipleMaxFieldName>(
      rows,
      columns: columns?.call(RelationToMultipleMaxFieldName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RelationToMultipleMaxFieldName]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RelationToMultipleMaxFieldName> updateRow(
    _i1.Session session,
    RelationToMultipleMaxFieldName row, {
    _i1.ColumnSelections<RelationToMultipleMaxFieldNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RelationToMultipleMaxFieldName>(
      row,
      columns: columns?.call(RelationToMultipleMaxFieldName.t),
      transaction: transaction,
    );
  }

  /// Deletes all [RelationToMultipleMaxFieldName]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RelationToMultipleMaxFieldName>> delete(
    _i1.Session session,
    List<RelationToMultipleMaxFieldName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RelationToMultipleMaxFieldName>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RelationToMultipleMaxFieldName].
  Future<RelationToMultipleMaxFieldName> deleteRow(
    _i1.Session session,
    RelationToMultipleMaxFieldName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RelationToMultipleMaxFieldName>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RelationToMultipleMaxFieldName>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RelationToMultipleMaxFieldName>(
      where: where(RelationToMultipleMaxFieldName.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RelationToMultipleMaxFieldName>(
      where: where?.call(RelationToMultipleMaxFieldName.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class RelationToMultipleMaxFieldNameAttachRepository {
  const RelationToMultipleMaxFieldNameAttachRepository._();

  /// Creates a relation between this [RelationToMultipleMaxFieldName] and the given [MultipleMaxFieldName]s
  /// by setting each [MultipleMaxFieldName]'s foreign key `_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId` to refer to this [RelationToMultipleMaxFieldName].
  Future<void> multipleMaxFieldNames(
    _i1.Session session,
    RelationToMultipleMaxFieldName relationToMultipleMaxFieldName,
    List<_i2.MultipleMaxFieldName> multipleMaxFieldName, {
    _i1.Transaction? transaction,
  }) async {
    if (multipleMaxFieldName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('multipleMaxFieldName.id');
    }
    if (relationToMultipleMaxFieldName.id == null) {
      throw ArgumentError.notNull('relationToMultipleMaxFieldName.id');
    }

    var $multipleMaxFieldName = multipleMaxFieldName
        .map((e) => _i2.MultipleMaxFieldNameImplicit(
              e,
              $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId:
                  relationToMultipleMaxFieldName.id,
            ))
        .toList();
    await session.db.update<_i2.MultipleMaxFieldName>(
      $multipleMaxFieldName,
      columns: [
        _i2.MultipleMaxFieldName.t
            .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId
      ],
      transaction: transaction,
    );
  }
}

class RelationToMultipleMaxFieldNameAttachRowRepository {
  const RelationToMultipleMaxFieldNameAttachRowRepository._();

  /// Creates a relation between this [RelationToMultipleMaxFieldName] and the given [MultipleMaxFieldName]
  /// by setting the [MultipleMaxFieldName]'s foreign key `_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId` to refer to this [RelationToMultipleMaxFieldName].
  Future<void> multipleMaxFieldNames(
    _i1.Session session,
    RelationToMultipleMaxFieldName relationToMultipleMaxFieldName,
    _i2.MultipleMaxFieldName multipleMaxFieldName, {
    _i1.Transaction? transaction,
  }) async {
    if (multipleMaxFieldName.id == null) {
      throw ArgumentError.notNull('multipleMaxFieldName.id');
    }
    if (relationToMultipleMaxFieldName.id == null) {
      throw ArgumentError.notNull('relationToMultipleMaxFieldName.id');
    }

    var $multipleMaxFieldName = _i2.MultipleMaxFieldNameImplicit(
      multipleMaxFieldName,
      $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId:
          relationToMultipleMaxFieldName.id,
    );
    await session.db.updateRow<_i2.MultipleMaxFieldName>(
      $multipleMaxFieldName,
      columns: [
        _i2.MultipleMaxFieldName.t
            .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId
      ],
      transaction: transaction,
    );
  }
}

class RelationToMultipleMaxFieldNameDetachRepository {
  const RelationToMultipleMaxFieldNameDetachRepository._();

  /// Detaches the relation between this [RelationToMultipleMaxFieldName] and the given [MultipleMaxFieldName]
  /// by setting the [MultipleMaxFieldName]'s foreign key `_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> multipleMaxFieldNames(
    _i1.Session session,
    List<_i2.MultipleMaxFieldName> multipleMaxFieldName, {
    _i1.Transaction? transaction,
  }) async {
    if (multipleMaxFieldName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('multipleMaxFieldName.id');
    }

    var $multipleMaxFieldName = multipleMaxFieldName
        .map((e) => _i2.MultipleMaxFieldNameImplicit(
              e,
              $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId:
                  null,
            ))
        .toList();
    await session.db.update<_i2.MultipleMaxFieldName>(
      $multipleMaxFieldName,
      columns: [
        _i2.MultipleMaxFieldName.t
            .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId
      ],
      transaction: transaction,
    );
  }
}

class RelationToMultipleMaxFieldNameDetachRowRepository {
  const RelationToMultipleMaxFieldNameDetachRowRepository._();

  /// Detaches the relation between this [RelationToMultipleMaxFieldName] and the given [MultipleMaxFieldName]
  /// by setting the [MultipleMaxFieldName]'s foreign key `_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> multipleMaxFieldNames(
    _i1.Session session,
    _i2.MultipleMaxFieldName multipleMaxFieldName, {
    _i1.Transaction? transaction,
  }) async {
    if (multipleMaxFieldName.id == null) {
      throw ArgumentError.notNull('multipleMaxFieldName.id');
    }

    var $multipleMaxFieldName = _i2.MultipleMaxFieldNameImplicit(
      multipleMaxFieldName,
      $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId: null,
    );
    await session.db.updateRow<_i2.MultipleMaxFieldName>(
      $multipleMaxFieldName,
      columns: [
        _i2.MultipleMaxFieldName.t
            .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId
      ],
      transaction: transaction,
    );
  }
}
