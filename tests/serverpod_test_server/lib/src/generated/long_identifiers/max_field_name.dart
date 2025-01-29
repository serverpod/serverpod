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

abstract class MaxFieldName implements _i1.TableRow, _i1.ProtocolSerialization {
  MaxFieldName._({
    this.id,
    required this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  });

  factory MaxFieldName({
    int? id,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  }) = _MaxFieldNameImpl;

  factory MaxFieldName.fromJson(Map<String, dynamic> jsonSerialization) {
    return MaxFieldName(
      id: jsonSerialization['id'] as int?,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo:
          jsonSerialization[
                  'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo']
              as String,
    );
  }

  static final t = MaxFieldNameTable();

  static const db = MaxFieldNameRepository._();

  @override
  int? id;

  String thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [MaxFieldName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MaxFieldName copyWith({
    int? id,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
    };
  }

  static MaxFieldNameInclude include() {
    return MaxFieldNameInclude._();
  }

  static MaxFieldNameIncludeList includeList({
    _i1.WhereExpressionBuilder<MaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MaxFieldNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MaxFieldNameTable>? orderByList,
    MaxFieldNameInclude? include,
  }) {
    return MaxFieldNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MaxFieldName.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MaxFieldName.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MaxFieldNameImpl extends MaxFieldName {
  _MaxFieldNameImpl({
    int? id,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  }) : super._(
          id: id,
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo:
              thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
        );

  /// Returns a shallow copy of this [MaxFieldName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MaxFieldName copyWith({
    Object? id = _Undefined,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  }) {
    return MaxFieldName(
      id: id is int? ? id : this.id,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo:
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo ??
              this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
    );
  }
}

class MaxFieldNameTable extends _i1.Table {
  MaxFieldNameTable({super.tableRelation})
      : super(tableName: 'max_field_name') {
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo =
        _i1.ColumnString(
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo',
      this,
    );
  }

  late final _i1.ColumnString
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo;

  @override
  List<_i1.Column> get columns => [
        id,
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
      ];
}

class MaxFieldNameInclude extends _i1.IncludeObject {
  MaxFieldNameInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => MaxFieldName.t;
}

class MaxFieldNameIncludeList extends _i1.IncludeList {
  MaxFieldNameIncludeList._({
    _i1.WhereExpressionBuilder<MaxFieldNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MaxFieldName.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => MaxFieldName.t;
}

class MaxFieldNameRepository {
  const MaxFieldNameRepository._();

  /// Returns a list of [MaxFieldName]s matching the given query parameters.
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
  Future<List<MaxFieldName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MaxFieldNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MaxFieldNameTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MaxFieldName>(
      where: where?.call(MaxFieldName.t),
      orderBy: orderBy?.call(MaxFieldName.t),
      orderByList: orderByList?.call(MaxFieldName.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [MaxFieldName] matching the given query parameters.
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
  Future<MaxFieldName?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MaxFieldNameTable>? where,
    int? offset,
    _i1.OrderByBuilder<MaxFieldNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MaxFieldNameTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MaxFieldName>(
      where: where?.call(MaxFieldName.t),
      orderBy: orderBy?.call(MaxFieldName.t),
      orderByList: orderByList?.call(MaxFieldName.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [MaxFieldName] by its [id] or null if no such row exists.
  Future<MaxFieldName?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MaxFieldName>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [MaxFieldName]s in the list and returns the inserted rows.
  ///
  /// The returned [MaxFieldName]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MaxFieldName>> insert(
    _i1.Session session,
    List<MaxFieldName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MaxFieldName>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MaxFieldName] and returns the inserted row.
  ///
  /// The returned [MaxFieldName] will have its `id` field set.
  Future<MaxFieldName> insertRow(
    _i1.Session session,
    MaxFieldName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MaxFieldName>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MaxFieldName]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MaxFieldName>> update(
    _i1.Session session,
    List<MaxFieldName> rows, {
    _i1.ColumnSelections<MaxFieldNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MaxFieldName>(
      rows,
      columns: columns?.call(MaxFieldName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MaxFieldName]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MaxFieldName> updateRow(
    _i1.Session session,
    MaxFieldName row, {
    _i1.ColumnSelections<MaxFieldNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MaxFieldName>(
      row,
      columns: columns?.call(MaxFieldName.t),
      transaction: transaction,
    );
  }

  /// Deletes all [MaxFieldName]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MaxFieldName>> delete(
    _i1.Session session,
    List<MaxFieldName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MaxFieldName>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MaxFieldName].
  Future<MaxFieldName> deleteRow(
    _i1.Session session,
    MaxFieldName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MaxFieldName>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MaxFieldName>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MaxFieldNameTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MaxFieldName>(
      where: where(MaxFieldName.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MaxFieldNameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MaxFieldName>(
      where: where?.call(MaxFieldName.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
