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
import '../../long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i2;

abstract class LongImplicitIdFieldCollection
    implements _i1.TableRow, _i1.ProtocolSerialization {
  LongImplicitIdFieldCollection._({
    this.id,
    required this.name,
    this.thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
  });

  factory LongImplicitIdFieldCollection({
    int? id,
    required String name,
    List<_i2.LongImplicitIdField>?
        thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
  }) = _LongImplicitIdFieldCollectionImpl;

  factory LongImplicitIdFieldCollection.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return LongImplicitIdFieldCollection(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa:
          (jsonSerialization[
                      'thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa']
                  as List?)
              ?.map((e) =>
                  _i2.LongImplicitIdField.fromJson((e as Map<String, dynamic>)))
              .toList(),
    );
  }

  static final t = LongImplicitIdFieldCollectionTable();

  static const db = LongImplicitIdFieldCollectionRepository._();

  @override
  int? id;

  String name;

  List<_i2.LongImplicitIdField>?
      thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [LongImplicitIdFieldCollection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LongImplicitIdFieldCollection copyWith({
    int? id,
    String? name,
    List<_i2.LongImplicitIdField>?
        thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa != null)
        'thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa':
            thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa
                ?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa != null)
        'thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa':
            thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa
                ?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static LongImplicitIdFieldCollectionInclude include(
      {_i2.LongImplicitIdFieldIncludeList?
          thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa}) {
    return LongImplicitIdFieldCollectionInclude._(
        thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa:
            thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa);
  }

  static LongImplicitIdFieldCollectionIncludeList includeList({
    _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LongImplicitIdFieldCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LongImplicitIdFieldCollectionTable>? orderByList,
    LongImplicitIdFieldCollectionInclude? include,
  }) {
    return LongImplicitIdFieldCollectionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LongImplicitIdFieldCollection.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LongImplicitIdFieldCollection.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LongImplicitIdFieldCollectionImpl extends LongImplicitIdFieldCollection {
  _LongImplicitIdFieldCollectionImpl({
    int? id,
    required String name,
    List<_i2.LongImplicitIdField>?
        thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
  }) : super._(
          id: id,
          name: name,
          thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa:
              thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
        );

  /// Returns a shallow copy of this [LongImplicitIdFieldCollection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LongImplicitIdFieldCollection copyWith({
    Object? id = _Undefined,
    String? name,
    Object? thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa =
        _Undefined,
  }) {
    return LongImplicitIdFieldCollection(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa:
          thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa
                  is List<_i2.LongImplicitIdField>?
              ? thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa
              : this
                  .thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa
                  ?.map((e0) => e0.copyWith())
                  .toList(),
    );
  }
}

class LongImplicitIdFieldCollectionTable extends _i1.Table {
  LongImplicitIdFieldCollectionTable({super.tableRelation})
      : super(tableName: 'long_implicit_id_field_collection') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.LongImplicitIdFieldTable?
      ___thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa;

  _i1.ManyRelation<_i2.LongImplicitIdFieldTable>?
      _thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa;

  _i2.LongImplicitIdFieldTable
      get __thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa {
    if (___thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa !=
        null)
      return ___thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa!;
    ___thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa =
        _i1.createRelationTable(
      relationFieldName:
          '__thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa',
      field: LongImplicitIdFieldCollection.t.id,
      foreignField: _i2.LongImplicitIdField.t
          .$_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.LongImplicitIdFieldTable(tableRelation: foreignTableRelation),
    );
    return ___thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa!;
  }

  _i1.ManyRelation<_i2.LongImplicitIdFieldTable>
      get thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa {
    if (_thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa != null)
      return _thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa!;
    var relationTable = _i1.createRelationTable(
      relationFieldName:
          'thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa',
      field: LongImplicitIdFieldCollection.t.id,
      foreignField: _i2.LongImplicitIdField.t
          .$_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.LongImplicitIdFieldTable(tableRelation: foreignTableRelation),
    );
    _thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa =
        _i1.ManyRelation<_i2.LongImplicitIdFieldTable>(
      tableWithRelations: relationTable,
      table: _i2.LongImplicitIdFieldTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField ==
        'thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa') {
      return __thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa;
    }
    return null;
  }
}

class LongImplicitIdFieldCollectionInclude extends _i1.IncludeObject {
  LongImplicitIdFieldCollectionInclude._(
      {_i2.LongImplicitIdFieldIncludeList?
          thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa}) {
    _thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa =
        thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa;
  }

  _i2.LongImplicitIdFieldIncludeList?
      _thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa;

  @override
  Map<String, _i1.Include?> get includes => {
        'thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa':
            _thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa
      };

  @override
  _i1.Table get table => LongImplicitIdFieldCollection.t;
}

class LongImplicitIdFieldCollectionIncludeList extends _i1.IncludeList {
  LongImplicitIdFieldCollectionIncludeList._({
    _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LongImplicitIdFieldCollection.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => LongImplicitIdFieldCollection.t;
}

class LongImplicitIdFieldCollectionRepository {
  const LongImplicitIdFieldCollectionRepository._();

  final attach = const LongImplicitIdFieldCollectionAttachRepository._();

  final attachRow = const LongImplicitIdFieldCollectionAttachRowRepository._();

  final detach = const LongImplicitIdFieldCollectionDetachRepository._();

  final detachRow = const LongImplicitIdFieldCollectionDetachRowRepository._();

  /// Returns a list of [LongImplicitIdFieldCollection]s matching the given query parameters.
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
  Future<List<LongImplicitIdFieldCollection>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LongImplicitIdFieldCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LongImplicitIdFieldCollectionTable>? orderByList,
    _i1.Transaction? transaction,
    LongImplicitIdFieldCollectionInclude? include,
  }) async {
    return session.db.find<LongImplicitIdFieldCollection>(
      where: where?.call(LongImplicitIdFieldCollection.t),
      orderBy: orderBy?.call(LongImplicitIdFieldCollection.t),
      orderByList: orderByList?.call(LongImplicitIdFieldCollection.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [LongImplicitIdFieldCollection] matching the given query parameters.
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
  Future<LongImplicitIdFieldCollection?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>? where,
    int? offset,
    _i1.OrderByBuilder<LongImplicitIdFieldCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LongImplicitIdFieldCollectionTable>? orderByList,
    _i1.Transaction? transaction,
    LongImplicitIdFieldCollectionInclude? include,
  }) async {
    return session.db.findFirstRow<LongImplicitIdFieldCollection>(
      where: where?.call(LongImplicitIdFieldCollection.t),
      orderBy: orderBy?.call(LongImplicitIdFieldCollection.t),
      orderByList: orderByList?.call(LongImplicitIdFieldCollection.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [LongImplicitIdFieldCollection] by its [id] or null if no such row exists.
  Future<LongImplicitIdFieldCollection?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    LongImplicitIdFieldCollectionInclude? include,
  }) async {
    return session.db.findById<LongImplicitIdFieldCollection>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [LongImplicitIdFieldCollection]s in the list and returns the inserted rows.
  ///
  /// The returned [LongImplicitIdFieldCollection]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<LongImplicitIdFieldCollection>> insert(
    _i1.Session session,
    List<LongImplicitIdFieldCollection> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<LongImplicitIdFieldCollection>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [LongImplicitIdFieldCollection] and returns the inserted row.
  ///
  /// The returned [LongImplicitIdFieldCollection] will have its `id` field set.
  Future<LongImplicitIdFieldCollection> insertRow(
    _i1.Session session,
    LongImplicitIdFieldCollection row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LongImplicitIdFieldCollection>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LongImplicitIdFieldCollection]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LongImplicitIdFieldCollection>> update(
    _i1.Session session,
    List<LongImplicitIdFieldCollection> rows, {
    _i1.ColumnSelections<LongImplicitIdFieldCollectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LongImplicitIdFieldCollection>(
      rows,
      columns: columns?.call(LongImplicitIdFieldCollection.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LongImplicitIdFieldCollection]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LongImplicitIdFieldCollection> updateRow(
    _i1.Session session,
    LongImplicitIdFieldCollection row, {
    _i1.ColumnSelections<LongImplicitIdFieldCollectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LongImplicitIdFieldCollection>(
      row,
      columns: columns?.call(LongImplicitIdFieldCollection.t),
      transaction: transaction,
    );
  }

  /// Deletes all [LongImplicitIdFieldCollection]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LongImplicitIdFieldCollection>> delete(
    _i1.Session session,
    List<LongImplicitIdFieldCollection> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LongImplicitIdFieldCollection>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LongImplicitIdFieldCollection].
  Future<LongImplicitIdFieldCollection> deleteRow(
    _i1.Session session,
    LongImplicitIdFieldCollection row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LongImplicitIdFieldCollection>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LongImplicitIdFieldCollection>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LongImplicitIdFieldCollection>(
      where: where(LongImplicitIdFieldCollection.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LongImplicitIdFieldCollectionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LongImplicitIdFieldCollection>(
      where: where?.call(LongImplicitIdFieldCollection.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class LongImplicitIdFieldCollectionAttachRepository {
  const LongImplicitIdFieldCollectionAttachRepository._();

  /// Creates a relation between this [LongImplicitIdFieldCollection] and the given [LongImplicitIdField]s
  /// by setting each [LongImplicitIdField]'s foreign key `_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id` to refer to this [LongImplicitIdFieldCollection].
  Future<void> thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa(
    _i1.Session session,
    LongImplicitIdFieldCollection longImplicitIdFieldCollection,
    List<_i2.LongImplicitIdField> longImplicitIdField, {
    _i1.Transaction? transaction,
  }) async {
    if (longImplicitIdField.any((e) => e.id == null)) {
      throw ArgumentError.notNull('longImplicitIdField.id');
    }
    if (longImplicitIdFieldCollection.id == null) {
      throw ArgumentError.notNull('longImplicitIdFieldCollection.id');
    }

    var $longImplicitIdField = longImplicitIdField
        .map((e) => _i2.LongImplicitIdFieldImplicit(
              e,
              $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id:
                  longImplicitIdFieldCollection.id,
            ))
        .toList();
    await session.db.update<_i2.LongImplicitIdField>(
      $longImplicitIdField,
      columns: [
        _i2.LongImplicitIdField.t
            .$_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id
      ],
      transaction: transaction,
    );
  }
}

class LongImplicitIdFieldCollectionAttachRowRepository {
  const LongImplicitIdFieldCollectionAttachRowRepository._();

  /// Creates a relation between this [LongImplicitIdFieldCollection] and the given [LongImplicitIdField]
  /// by setting the [LongImplicitIdField]'s foreign key `_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id` to refer to this [LongImplicitIdFieldCollection].
  Future<void> thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa(
    _i1.Session session,
    LongImplicitIdFieldCollection longImplicitIdFieldCollection,
    _i2.LongImplicitIdField longImplicitIdField, {
    _i1.Transaction? transaction,
  }) async {
    if (longImplicitIdField.id == null) {
      throw ArgumentError.notNull('longImplicitIdField.id');
    }
    if (longImplicitIdFieldCollection.id == null) {
      throw ArgumentError.notNull('longImplicitIdFieldCollection.id');
    }

    var $longImplicitIdField = _i2.LongImplicitIdFieldImplicit(
      longImplicitIdField,
      $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id:
          longImplicitIdFieldCollection.id,
    );
    await session.db.updateRow<_i2.LongImplicitIdField>(
      $longImplicitIdField,
      columns: [
        _i2.LongImplicitIdField.t
            .$_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id
      ],
      transaction: transaction,
    );
  }
}

class LongImplicitIdFieldCollectionDetachRepository {
  const LongImplicitIdFieldCollectionDetachRepository._();

  /// Detaches the relation between this [LongImplicitIdFieldCollection] and the given [LongImplicitIdField]
  /// by setting the [LongImplicitIdField]'s foreign key `_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa(
    _i1.Session session,
    List<_i2.LongImplicitIdField> longImplicitIdField, {
    _i1.Transaction? transaction,
  }) async {
    if (longImplicitIdField.any((e) => e.id == null)) {
      throw ArgumentError.notNull('longImplicitIdField.id');
    }

    var $longImplicitIdField = longImplicitIdField
        .map((e) => _i2.LongImplicitIdFieldImplicit(
              e,
              $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id:
                  null,
            ))
        .toList();
    await session.db.update<_i2.LongImplicitIdField>(
      $longImplicitIdField,
      columns: [
        _i2.LongImplicitIdField.t
            .$_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id
      ],
      transaction: transaction,
    );
  }
}

class LongImplicitIdFieldCollectionDetachRowRepository {
  const LongImplicitIdFieldCollectionDetachRowRepository._();

  /// Detaches the relation between this [LongImplicitIdFieldCollection] and the given [LongImplicitIdField]
  /// by setting the [LongImplicitIdField]'s foreign key `_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa(
    _i1.Session session,
    _i2.LongImplicitIdField longImplicitIdField, {
    _i1.Transaction? transaction,
  }) async {
    if (longImplicitIdField.id == null) {
      throw ArgumentError.notNull('longImplicitIdField.id');
    }

    var $longImplicitIdField = _i2.LongImplicitIdFieldImplicit(
      longImplicitIdField,
      $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id: null,
    );
    await session.db.updateRow<_i2.LongImplicitIdField>(
      $longImplicitIdField,
      columns: [
        _i2.LongImplicitIdField.t
            .$_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id
      ],
      transaction: transaction,
    );
  }
}
