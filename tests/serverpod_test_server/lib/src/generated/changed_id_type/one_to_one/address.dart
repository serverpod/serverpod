/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../changed_id_type/one_to_one/citizen.dart' as _i2;

abstract class AddressUuid
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  AddressUuid._({
    _i1.UuidValue? id,
    required this.street,
    this.inhabitantId,
    this.inhabitant,
  }) : id = id ?? _i1.Uuid().v4obj();

  factory AddressUuid({
    _i1.UuidValue? id,
    required String street,
    int? inhabitantId,
    _i2.CitizenInt? inhabitant,
  }) = _AddressUuidImpl;

  factory AddressUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return AddressUuid(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      street: jsonSerialization['street'] as String,
      inhabitantId: jsonSerialization['inhabitantId'] as int?,
      inhabitant: jsonSerialization['inhabitant'] == null
          ? null
          : _i2.CitizenInt.fromJson(
              (jsonSerialization['inhabitant'] as Map<String, dynamic>)),
    );
  }

  static final t = AddressUuidTable();

  static const db = AddressUuidRepository._();

  @override
  _i1.UuidValue id;

  String street;

  int? inhabitantId;

  _i2.CitizenInt? inhabitant;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  /// Returns a shallow copy of this [AddressUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AddressUuid copyWith({
    _i1.UuidValue? id,
    String? street,
    int? inhabitantId,
    _i2.CitizenInt? inhabitant,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      'street': street,
      if (inhabitantId != null) 'inhabitantId': inhabitantId,
      if (inhabitant != null) 'inhabitant': inhabitant?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'id': id.toJson(),
      'street': street,
      if (inhabitantId != null) 'inhabitantId': inhabitantId,
      if (inhabitant != null) 'inhabitant': inhabitant?.toJsonForProtocol(),
    };
  }

  static AddressUuidInclude include({_i2.CitizenIntInclude? inhabitant}) {
    return AddressUuidInclude._(inhabitant: inhabitant);
  }

  static AddressUuidIncludeList includeList({
    _i1.WhereExpressionBuilder<AddressUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AddressUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AddressUuidTable>? orderByList,
    AddressUuidInclude? include,
  }) {
    return AddressUuidIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AddressUuid.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AddressUuid.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AddressUuidImpl extends AddressUuid {
  _AddressUuidImpl({
    _i1.UuidValue? id,
    required String street,
    int? inhabitantId,
    _i2.CitizenInt? inhabitant,
  }) : super._(
          id: id,
          street: street,
          inhabitantId: inhabitantId,
          inhabitant: inhabitant,
        );

  /// Returns a shallow copy of this [AddressUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AddressUuid copyWith({
    _i1.UuidValue? id,
    String? street,
    Object? inhabitantId = _Undefined,
    Object? inhabitant = _Undefined,
  }) {
    return AddressUuid(
      id: id ?? this.id,
      street: street ?? this.street,
      inhabitantId: inhabitantId is int? ? inhabitantId : this.inhabitantId,
      inhabitant: inhabitant is _i2.CitizenInt?
          ? inhabitant
          : this.inhabitant?.copyWith(),
    );
  }
}

class AddressUuidTable extends _i1.Table<_i1.UuidValue> {
  AddressUuidTable({super.tableRelation}) : super(tableName: 'address_uuid') {
    street = _i1.ColumnString(
      'street',
      this,
    );
    inhabitantId = _i1.ColumnInt(
      'inhabitantId',
      this,
    );
  }

  late final _i1.ColumnString street;

  late final _i1.ColumnInt inhabitantId;

  _i2.CitizenIntTable? _inhabitant;

  _i2.CitizenIntTable get inhabitant {
    if (_inhabitant != null) return _inhabitant!;
    _inhabitant = _i1.createRelationTable(
      relationFieldName: 'inhabitant',
      field: AddressUuid.t.inhabitantId,
      foreignField: _i2.CitizenInt.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CitizenIntTable(tableRelation: foreignTableRelation),
    );
    return _inhabitant!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        street,
        inhabitantId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'inhabitant') {
      return inhabitant;
    }
    return null;
  }
}

class AddressUuidInclude extends _i1.IncludeObject {
  AddressUuidInclude._({_i2.CitizenIntInclude? inhabitant}) {
    _inhabitant = inhabitant;
  }

  _i2.CitizenIntInclude? _inhabitant;

  @override
  Map<String, _i1.Include?> get includes => {'inhabitant': _inhabitant};

  @override
  _i1.Table<_i1.UuidValue> get table => AddressUuid.t;
}

class AddressUuidIncludeList extends _i1.IncludeList {
  AddressUuidIncludeList._({
    _i1.WhereExpressionBuilder<AddressUuidTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AddressUuid.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => AddressUuid.t;
}

class AddressUuidRepository {
  const AddressUuidRepository._();

  final attachRow = const AddressUuidAttachRowRepository._();

  final detachRow = const AddressUuidDetachRowRepository._();

  /// Returns a list of [AddressUuid]s matching the given query parameters.
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
  Future<List<AddressUuid>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AddressUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AddressUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AddressUuidTable>? orderByList,
    _i1.Transaction? transaction,
    AddressUuidInclude? include,
  }) async {
    return session.db.find<AddressUuid>(
      where: where?.call(AddressUuid.t),
      orderBy: orderBy?.call(AddressUuid.t),
      orderByList: orderByList?.call(AddressUuid.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [AddressUuid] matching the given query parameters.
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
  Future<AddressUuid?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AddressUuidTable>? where,
    int? offset,
    _i1.OrderByBuilder<AddressUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AddressUuidTable>? orderByList,
    _i1.Transaction? transaction,
    AddressUuidInclude? include,
  }) async {
    return session.db.findFirstRow<AddressUuid>(
      where: where?.call(AddressUuid.t),
      orderBy: orderBy?.call(AddressUuid.t),
      orderByList: orderByList?.call(AddressUuid.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [AddressUuid] by its [id] or null if no such row exists.
  Future<AddressUuid?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    AddressUuidInclude? include,
  }) async {
    return session.db.findById<AddressUuid>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [AddressUuid]s in the list and returns the inserted rows.
  ///
  /// The returned [AddressUuid]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AddressUuid>> insert(
    _i1.Session session,
    List<AddressUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AddressUuid>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AddressUuid] and returns the inserted row.
  ///
  /// The returned [AddressUuid] will have its `id` field set.
  Future<AddressUuid> insertRow(
    _i1.Session session,
    AddressUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AddressUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AddressUuid]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AddressUuid>> update(
    _i1.Session session,
    List<AddressUuid> rows, {
    _i1.ColumnSelections<AddressUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AddressUuid>(
      rows,
      columns: columns?.call(AddressUuid.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AddressUuid]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AddressUuid> updateRow(
    _i1.Session session,
    AddressUuid row, {
    _i1.ColumnSelections<AddressUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AddressUuid>(
      row,
      columns: columns?.call(AddressUuid.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AddressUuid]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AddressUuid>> delete(
    _i1.Session session,
    List<AddressUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AddressUuid>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AddressUuid].
  Future<AddressUuid> deleteRow(
    _i1.Session session,
    AddressUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AddressUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AddressUuid>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AddressUuidTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AddressUuid>(
      where: where(AddressUuid.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AddressUuidTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AddressUuid>(
      where: where?.call(AddressUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AddressUuidAttachRowRepository {
  const AddressUuidAttachRowRepository._();

  /// Creates a relation between the given [AddressUuid] and [CitizenInt]
  /// by setting the [AddressUuid]'s foreign key `inhabitantId` to refer to the [CitizenInt].
  Future<void> inhabitant(
    _i1.Session session,
    AddressUuid addressUuid,
    _i2.CitizenInt inhabitant, {
    _i1.Transaction? transaction,
  }) async {
    if (addressUuid.id == null) {
      throw ArgumentError.notNull('addressUuid.id');
    }
    if (inhabitant.id == null) {
      throw ArgumentError.notNull('inhabitant.id');
    }

    var $addressUuid = addressUuid.copyWith(inhabitantId: inhabitant.id);
    await session.db.updateRow<AddressUuid>(
      $addressUuid,
      columns: [AddressUuid.t.inhabitantId],
      transaction: transaction,
    );
  }
}

class AddressUuidDetachRowRepository {
  const AddressUuidDetachRowRepository._();

  /// Detaches the relation between this [AddressUuid] and the [CitizenInt] set in `inhabitant`
  /// by setting the [AddressUuid]'s foreign key `inhabitantId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> inhabitant(
    _i1.Session session,
    AddressUuid addressuuid, {
    _i1.Transaction? transaction,
  }) async {
    if (addressuuid.id == null) {
      throw ArgumentError.notNull('addressuuid.id');
    }

    var $addressuuid = addressuuid.copyWith(inhabitantId: null);
    await session.db.updateRow<AddressUuid>(
      $addressuuid,
      columns: [AddressUuid.t.inhabitantId],
      transaction: transaction,
    );
  }
}
