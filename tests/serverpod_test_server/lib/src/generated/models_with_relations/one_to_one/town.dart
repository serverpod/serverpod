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
import '../../models_with_relations/one_to_one/citizen.dart' as _i2;

abstract class Town implements _i1.TableRow, _i1.ProtocolSerialization {
  Town._({
    this.id,
    required this.name,
    this.mayorId,
    this.mayor,
  });

  factory Town({
    int? id,
    required String name,
    int? mayorId,
    _i2.Citizen? mayor,
  }) = _TownImpl;

  factory Town.fromJson(Map<String, dynamic> jsonSerialization) {
    return Town(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      mayorId: jsonSerialization['mayorId'] as int?,
      mayor: jsonSerialization['mayor'] == null
          ? null
          : _i2.Citizen.fromJson(
              (jsonSerialization['mayor'] as Map<String, dynamic>)),
    );
  }

  static final t = TownTable();

  static const db = TownRepository._();

  @override
  int? id;

  String name;

  int? mayorId;

  _i2.Citizen? mayor;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [Town]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Town copyWith({
    int? id,
    String? name,
    int? mayorId,
    _i2.Citizen? mayor,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (mayorId != null) 'mayorId': mayorId,
      if (mayor != null) 'mayor': mayor?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (mayorId != null) 'mayorId': mayorId,
      if (mayor != null) 'mayor': mayor?.toJsonForProtocol(),
    };
  }

  static TownInclude include({_i2.CitizenInclude? mayor}) {
    return TownInclude._(mayor: mayor);
  }

  static TownIncludeList includeList({
    _i1.WhereExpressionBuilder<TownTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TownTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TownTable>? orderByList,
    TownInclude? include,
  }) {
    return TownIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Town.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Town.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TownImpl extends Town {
  _TownImpl({
    int? id,
    required String name,
    int? mayorId,
    _i2.Citizen? mayor,
  }) : super._(
          id: id,
          name: name,
          mayorId: mayorId,
          mayor: mayor,
        );

  /// Returns a shallow copy of this [Town]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Town copyWith({
    Object? id = _Undefined,
    String? name,
    Object? mayorId = _Undefined,
    Object? mayor = _Undefined,
  }) {
    return Town(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      mayorId: mayorId is int? ? mayorId : this.mayorId,
      mayor: mayor is _i2.Citizen? ? mayor : this.mayor?.copyWith(),
    );
  }
}

class TownTable extends _i1.Table {
  TownTable({super.tableRelation}) : super(tableName: 'town') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    mayorId = _i1.ColumnInt(
      'mayorId',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt mayorId;

  _i2.CitizenTable? _mayor;

  _i2.CitizenTable get mayor {
    if (_mayor != null) return _mayor!;
    _mayor = _i1.createRelationTable(
      relationFieldName: 'mayor',
      field: Town.t.mayorId,
      foreignField: _i2.Citizen.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CitizenTable(tableRelation: foreignTableRelation),
    );
    return _mayor!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        mayorId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'mayor') {
      return mayor;
    }
    return null;
  }
}

class TownInclude extends _i1.IncludeObject {
  TownInclude._({_i2.CitizenInclude? mayor}) {
    _mayor = mayor;
  }

  _i2.CitizenInclude? _mayor;

  @override
  Map<String, _i1.Include?> get includes => {'mayor': _mayor};

  @override
  _i1.Table get table => Town.t;
}

class TownIncludeList extends _i1.IncludeList {
  TownIncludeList._({
    _i1.WhereExpressionBuilder<TownTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Town.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Town.t;
}

class TownRepository {
  const TownRepository._();

  final attachRow = const TownAttachRowRepository._();

  final detachRow = const TownDetachRowRepository._();

  /// Returns a list of [Town]s matching the given query parameters.
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
  Future<List<Town>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TownTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TownTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TownTable>? orderByList,
    _i1.Transaction? transaction,
    TownInclude? include,
  }) async {
    return session.db.find<Town>(
      where: where?.call(Town.t),
      orderBy: orderBy?.call(Town.t),
      orderByList: orderByList?.call(Town.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Town] matching the given query parameters.
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
  Future<Town?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TownTable>? where,
    int? offset,
    _i1.OrderByBuilder<TownTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TownTable>? orderByList,
    _i1.Transaction? transaction,
    TownInclude? include,
  }) async {
    return session.db.findFirstRow<Town>(
      where: where?.call(Town.t),
      orderBy: orderBy?.call(Town.t),
      orderByList: orderByList?.call(Town.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Town] by its [id] or null if no such row exists.
  Future<Town?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    TownInclude? include,
  }) async {
    return session.db.findById<Town>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Town]s in the list and returns the inserted rows.
  ///
  /// The returned [Town]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Town>> insert(
    _i1.Session session,
    List<Town> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Town>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Town] and returns the inserted row.
  ///
  /// The returned [Town] will have its `id` field set.
  Future<Town> insertRow(
    _i1.Session session,
    Town row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Town>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Town]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Town>> update(
    _i1.Session session,
    List<Town> rows, {
    _i1.ColumnSelections<TownTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Town>(
      rows,
      columns: columns?.call(Town.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Town]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Town> updateRow(
    _i1.Session session,
    Town row, {
    _i1.ColumnSelections<TownTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Town>(
      row,
      columns: columns?.call(Town.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Town]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Town>> delete(
    _i1.Session session,
    List<Town> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Town>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Town].
  Future<Town> deleteRow(
    _i1.Session session,
    Town row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Town>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Town>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TownTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Town>(
      where: where(Town.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TownTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Town>(
      where: where?.call(Town.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class TownAttachRowRepository {
  const TownAttachRowRepository._();

  /// Creates a relation between the given [Town] and [Citizen]
  /// by setting the [Town]'s foreign key `mayorId` to refer to the [Citizen].
  Future<void> mayor(
    _i1.Session session,
    Town town,
    _i2.Citizen mayor, {
    _i1.Transaction? transaction,
  }) async {
    if (town.id == null) {
      throw ArgumentError.notNull('town.id');
    }
    if (mayor.id == null) {
      throw ArgumentError.notNull('mayor.id');
    }

    var $town = town.copyWith(mayorId: mayor.id);
    await session.db.updateRow<Town>(
      $town,
      columns: [Town.t.mayorId],
      transaction: transaction,
    );
  }
}

class TownDetachRowRepository {
  const TownDetachRowRepository._();

  /// Detaches the relation between this [Town] and the [Citizen] set in `mayor`
  /// by setting the [Town]'s foreign key `mayorId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> mayor(
    _i1.Session session,
    Town town, {
    _i1.Transaction? transaction,
  }) async {
    if (town.id == null) {
      throw ArgumentError.notNull('town.id');
    }

    var $town = town.copyWith(mayorId: null);
    await session.db.updateRow<Town>(
      $town,
      columns: [Town.t.mayorId],
      transaction: transaction,
    );
  }
}
