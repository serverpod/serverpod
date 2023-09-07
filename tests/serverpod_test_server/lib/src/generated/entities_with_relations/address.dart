/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

abstract class Address extends _i1.TableRow {
  Address._({
    int? id,
    required this.street,
    required this.inhabitantId,
    this.inhabitant,
  }) : super(id);

  factory Address({
    int? id,
    required String street,
    required int inhabitantId,
    _i2.Citizen? inhabitant,
  }) = _AddressImpl;

  factory Address.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Address(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      street:
          serializationManager.deserialize<String>(jsonSerialization['street']),
      inhabitantId: serializationManager
          .deserialize<int>(jsonSerialization['inhabitantId']),
      inhabitant: serializationManager
          .deserialize<_i2.Citizen?>(jsonSerialization['inhabitant']),
    );
  }

  static final t = AddressTable();

  static final db = AddressRepository._();

  String street;

  int inhabitantId;

  _i2.Citizen? inhabitant;

  @override
  String get tableName => 'address';
  Address copyWith({
    int? id,
    String? street,
    int? inhabitantId,
    _i2.Citizen? inhabitant,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'street': street,
      'inhabitantId': inhabitantId,
      'inhabitant': inhabitant,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'street': street,
      'inhabitantId': inhabitantId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'street': street,
      'inhabitantId': inhabitantId,
      'inhabitant': inhabitant,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'street':
        street = value;
        return;
      case 'inhabitantId':
        inhabitantId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<Address>> find(
    _i1.Session session, {
    AddressExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    AddressInclude? include,
  }) async {
    return session.db.find<Address>(
      where: where != null ? where(Address.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<Address?> findSingleRow(
    _i1.Session session, {
    AddressExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    AddressInclude? include,
  }) async {
    return session.db.findSingleRow<Address>(
      where: where != null ? where(Address.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<Address?> findById(
    _i1.Session session,
    int id, {
    AddressInclude? include,
  }) async {
    return session.db.findById<Address>(
      id,
      include: include,
    );
  }

  static Future<int> delete(
    _i1.Session session, {
    required AddressExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Address>(
      where: where(Address.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    Address row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    Address row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    Address row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    AddressExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Address>(
      where: where != null ? where(Address.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static AddressInclude include({_i2.CitizenInclude? inhabitant}) {
    return AddressInclude._(inhabitant: inhabitant);
  }
}

class _Undefined {}

class _AddressImpl extends Address {
  _AddressImpl({
    int? id,
    required String street,
    required int inhabitantId,
    _i2.Citizen? inhabitant,
  }) : super._(
          id: id,
          street: street,
          inhabitantId: inhabitantId,
          inhabitant: inhabitant,
        );

  @override
  Address copyWith({
    Object? id = _Undefined,
    String? street,
    int? inhabitantId,
    Object? inhabitant = _Undefined,
  }) {
    return Address(
      id: id is int? ? id : this.id,
      street: street ?? this.street,
      inhabitantId: inhabitantId ?? this.inhabitantId,
      inhabitant:
          inhabitant is _i2.Citizen? ? inhabitant : this.inhabitant?.copyWith(),
    );
  }
}

typedef AddressExpressionBuilder = _i1.Expression Function(AddressTable);

class AddressTable extends _i1.Table {
  AddressTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'address') {
    street = _i1.ColumnString(
      'street',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    inhabitantId = _i1.ColumnInt(
      'inhabitantId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  late final _i1.ColumnString street;

  late final _i1.ColumnInt inhabitantId;

  _i2.CitizenTable? _inhabitant;

  _i2.CitizenTable get inhabitant {
    if (_inhabitant != null) return _inhabitant!;
    _inhabitant = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'inhabitant',
      foreignTableName: _i2.Citizen.t.tableName,
      column: inhabitantId,
      foreignColumnName: _i2.Citizen.t.id.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.CitizenTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
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

@Deprecated('Use AddressTable.t instead.')
AddressTable tAddress = AddressTable();

class AddressInclude extends _i1.Include {
  AddressInclude._({_i2.CitizenInclude? inhabitant}) {
    _inhabitant = inhabitant;
  }

  _i2.CitizenInclude? _inhabitant;

  @override
  Map<String, _i1.Include?> get includes => {'inhabitant': _inhabitant};
  @override
  _i1.Table get table => Address.t;
}

class AddressRepository {
  AddressRepository._();
}
