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

abstract class Address implements _i1.TableRow, _i1.ProtocolSerialization {
  Address._({
    this.id,
    required this.street,
    this.inhabitantId,
    this.inhabitant,
  });

  factory Address({
    int? id,
    required String street,
    int? inhabitantId,
    _i2.Citizen? inhabitant,
  }) = _AddressImpl;

  factory Address.fromJson(Map<String, dynamic> jsonSerialization) {
    return Address(
      id: jsonSerialization['id'] as int?,
      street: jsonSerialization['street'] as String,
      inhabitantId: jsonSerialization['inhabitantId'] as int?,
      inhabitant: jsonSerialization['inhabitant'] == null
          ? null
          : _i2.Citizen.fromJson(
              (jsonSerialization['inhabitant'] as Map<String, dynamic>)),
    );
  }

  static final t = AddressTable();

  static const db = AddressRepository._();

  @override
  int? id;

  String street;

  int? inhabitantId;

  _i2.Citizen? inhabitant;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [Address]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Address copyWith({
    int? id,
    String? street,
    int? inhabitantId,
    _i2.Citizen? inhabitant,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'street': street,
      if (inhabitantId != null) 'inhabitantId': inhabitantId,
      if (inhabitant != null) 'inhabitant': inhabitant?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'street': street,
      if (inhabitantId != null) 'inhabitantId': inhabitantId,
      if (inhabitant != null) 'inhabitant': inhabitant?.toJsonForProtocol(),
    };
  }

  static AddressInclude include({_i2.CitizenInclude? inhabitant}) {
    return AddressInclude._(inhabitant: inhabitant);
  }

  static AddressIncludeList includeList({
    _i1.WhereExpressionBuilder<AddressTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AddressTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AddressTable>? orderByList,
    AddressInclude? include,
  }) {
    return AddressIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Address.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Address.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AddressImpl extends Address {
  _AddressImpl({
    int? id,
    required String street,
    int? inhabitantId,
    _i2.Citizen? inhabitant,
  }) : super._(
          id: id,
          street: street,
          inhabitantId: inhabitantId,
          inhabitant: inhabitant,
        );

  /// Returns a shallow copy of this [Address]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Address copyWith({
    Object? id = _Undefined,
    String? street,
    Object? inhabitantId = _Undefined,
    Object? inhabitant = _Undefined,
  }) {
    return Address(
      id: id is int? ? id : this.id,
      street: street ?? this.street,
      inhabitantId: inhabitantId is int? ? inhabitantId : this.inhabitantId,
      inhabitant:
          inhabitant is _i2.Citizen? ? inhabitant : this.inhabitant?.copyWith(),
    );
  }
}

class AddressTable extends _i1.Table {
  AddressTable({super.tableRelation}) : super(tableName: 'address') {
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

  _i2.CitizenTable? _inhabitant;

  _i2.CitizenTable get inhabitant {
    if (_inhabitant != null) return _inhabitant!;
    _inhabitant = _i1.createRelationTable(
      relationFieldName: 'inhabitant',
      field: Address.t.inhabitantId,
      foreignField: _i2.Citizen.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CitizenTable(tableRelation: foreignTableRelation),
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

class AddressInclude extends _i1.IncludeObject {
  AddressInclude._({_i2.CitizenInclude? inhabitant}) {
    _inhabitant = inhabitant;
  }

  _i2.CitizenInclude? _inhabitant;

  @override
  Map<String, _i1.Include?> get includes => {'inhabitant': _inhabitant};

  @override
  _i1.Table get table => Address.t;
}

class AddressIncludeList extends _i1.IncludeList {
  AddressIncludeList._({
    _i1.WhereExpressionBuilder<AddressTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Address.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Address.t;
}

class AddressRepository {
  const AddressRepository._();

  final attachRow = const AddressAttachRowRepository._();

  final detachRow = const AddressDetachRowRepository._();

  /// Returns a list of [Address]s matching the given query parameters.
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
  Future<List<Address>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AddressTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AddressTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AddressTable>? orderByList,
    _i1.Transaction? transaction,
    AddressInclude? include,
  }) async {
    return session.db.find<Address>(
      where: where?.call(Address.t),
      orderBy: orderBy?.call(Address.t),
      orderByList: orderByList?.call(Address.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Address] matching the given query parameters.
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
  Future<Address?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AddressTable>? where,
    int? offset,
    _i1.OrderByBuilder<AddressTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AddressTable>? orderByList,
    _i1.Transaction? transaction,
    AddressInclude? include,
  }) async {
    return session.db.findFirstRow<Address>(
      where: where?.call(Address.t),
      orderBy: orderBy?.call(Address.t),
      orderByList: orderByList?.call(Address.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Address] by its [id] or null if no such row exists.
  Future<Address?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    AddressInclude? include,
  }) async {
    return session.db.findById<Address>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Address]s in the list and returns the inserted rows.
  ///
  /// The returned [Address]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Address>> insert(
    _i1.Session session,
    List<Address> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Address>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Address] and returns the inserted row.
  ///
  /// The returned [Address] will have its `id` field set.
  Future<Address> insertRow(
    _i1.Session session,
    Address row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Address>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Address]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Address>> update(
    _i1.Session session,
    List<Address> rows, {
    _i1.ColumnSelections<AddressTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Address>(
      rows,
      columns: columns?.call(Address.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Address]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Address> updateRow(
    _i1.Session session,
    Address row, {
    _i1.ColumnSelections<AddressTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Address>(
      row,
      columns: columns?.call(Address.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Address]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Address>> delete(
    _i1.Session session,
    List<Address> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Address>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Address].
  Future<Address> deleteRow(
    _i1.Session session,
    Address row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Address>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Address>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AddressTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Address>(
      where: where(Address.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AddressTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Address>(
      where: where?.call(Address.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AddressAttachRowRepository {
  const AddressAttachRowRepository._();

  /// Creates a relation between the given [Address] and [Citizen]
  /// by setting the [Address]'s foreign key `inhabitantId` to refer to the [Citizen].
  Future<void> inhabitant(
    _i1.Session session,
    Address address,
    _i2.Citizen inhabitant, {
    _i1.Transaction? transaction,
  }) async {
    if (address.id == null) {
      throw ArgumentError.notNull('address.id');
    }
    if (inhabitant.id == null) {
      throw ArgumentError.notNull('inhabitant.id');
    }

    var $address = address.copyWith(inhabitantId: inhabitant.id);
    await session.db.updateRow<Address>(
      $address,
      columns: [Address.t.inhabitantId],
      transaction: transaction,
    );
  }
}

class AddressDetachRowRepository {
  const AddressDetachRowRepository._();

  /// Detaches the relation between this [Address] and the [Citizen] set in `inhabitant`
  /// by setting the [Address]'s foreign key `inhabitantId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> inhabitant(
    _i1.Session session,
    Address address, {
    _i1.Transaction? transaction,
  }) async {
    if (address.id == null) {
      throw ArgumentError.notNull('address.id');
    }

    var $address = address.copyWith(inhabitantId: null);
    await session.db.updateRow<Address>(
      $address,
      columns: [Address.t.inhabitantId],
      transaction: transaction,
    );
  }
}
