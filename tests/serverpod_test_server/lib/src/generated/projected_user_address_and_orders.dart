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
import 'projected_order_description.dart' as _i2;
import 'projected_address_street.dart' as _i3;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i4;
import 'projected_user.dart';

abstract class ProjectedUserAddressAndOrders
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProjectedUserAddressAndOrders._({
    this.id,
    required this.name,
    this.orders,
    this.address,
  });

  factory ProjectedUserAddressAndOrders({
    int? id,
    required String name,
    List<_i2.ProjectedOrderDescription>? orders,
    _i3.ProjectedAddressStreet? address,
  }) = _ProjectedUserAddressAndOrdersImpl;

  factory ProjectedUserAddressAndOrders.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedUserAddressAndOrders(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      orders: jsonSerialization['orders'] == null
          ? null
          : _i4.Protocol().deserialize<List<_i2.ProjectedOrderDescription>>(
              jsonSerialization['orders'],
            ),
      address: jsonSerialization['address'] == null
          ? null
          : _i3.ProjectedAddressStreet.fromJson(jsonSerialization['address']),
    );
  }

  static const db = ProjectedUserAddressAndOrdersRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.ProjectedOrderDescription>? orders;

  _i3.ProjectedAddressStreet? address;

  /// Returns a shallow copy of this [ProjectedUserAddressAndOrders]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedUserAddressAndOrders copyWith({
    int? id,
    String? name,
    List<_i2.ProjectedOrderDescription>? orders,
    _i3.ProjectedAddressStreet? address,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUserAddressAndOrders',
      if (id != null) 'id': id,
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJson()),
      if (address != null) 'address': address?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUserAddressAndOrders',
      if (id != null) 'id': id,
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(
          valueToJson: (v) =>
              // ignore: unnecessary_type_check
              v is _i1.ProtocolSerialization
              ? (v as _i1.ProtocolSerialization).toJsonForProtocol()
              :
                // ignore: dead_code
                v.toJson(),
        ),
      if (address != null)
        'address':
            // ignore: unnecessary_type_check
            address is _i1.ProtocolSerialization
            ? (address as _i1.ProtocolSerialization).toJsonForProtocol()
            :
              // ignore: dead_code
              address?.toJson(),
    };
  }

  static ProjectedUserInclude include() {
    return ProjectedUserInclude.internal_(
      selectedColumns: [
        ProjectedUser.t.id,
        ProjectedUser.t.name,
      ],
      orders: _i2.ProjectedOrderDescription.includeList(),
      address: _i3.ProjectedAddressStreet.include(),
    );
  }

  static ProjectedUserIncludeList includeList({
    _i1.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedUserTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedUserTable>? orderByList,
  }) {
    return ProjectedUser.includeList(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      include: ProjectedUserAddressAndOrders.include(),
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserAddressAndOrdersImpl extends ProjectedUserAddressAndOrders {
  _ProjectedUserAddressAndOrdersImpl({
    int? id,
    required String name,
    List<_i2.ProjectedOrderDescription>? orders,
    _i3.ProjectedAddressStreet? address,
  }) : super._(
         id: id,
         name: name,
         orders: orders,
         address: address,
       );

  /// Returns a shallow copy of this [ProjectedUserAddressAndOrders]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedUserAddressAndOrders copyWith({
    Object? id = _Undefined,
    String? name,
    Object? orders = _Undefined,
    Object? address = _Undefined,
  }) {
    return ProjectedUserAddressAndOrders(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      orders: orders is List<_i2.ProjectedOrderDescription>?
          ? orders
          : this.orders?.map((e0) => e0.copyWith()).toList(),
      address: address is _i3.ProjectedAddressStreet?
          ? address
          : this.address?.copyWith(),
    );
  }
}

class ProjectedUserAddressAndOrdersRepository {
  const ProjectedUserAddressAndOrdersRepository._();

  Map<String, dynamic> _stripClassName(Map<String, dynamic> map) {
    var result = <String, dynamic>{};
    for (var entry in map.entries) {
      if (entry.key == '__className__') continue;
      if (entry.value is Map<String, dynamic>) {
        result[entry.key] = _stripClassName(
          entry.value as Map<String, dynamic>,
        );
      } else if (entry.value is List) {
        result[entry.key] = (entry.value as List)
            .map((e) => e is Map<String, dynamic> ? _stripClassName(e) : e)
            .toList();
      } else {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }

  /// Returns a list of [ProjectedUser]s matching the given query parameters.
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
  Future<List<ProjectedUserAddressAndOrders>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedUserTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedUserAddressAndOrdersTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    // ignore: invalid_use_of_internal_member
    return await session.db
        .findAsJson<ProjectedUser>(
          where: where?.call(ProjectedUser.t),
          orderBy: orderBy?.call(ProjectedUser.t),
          orderByList: orderByList?.call(ProjectedUser.t),
          limit: limit,
          offset: offset,
          transaction: transaction,
          include: ProjectedUserAddressAndOrders.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (rows) => rows
              .map((e) => ProjectedUserAddressAndOrders.fromJson(e))
              .toList(),
        );
  }

  /// Returns the first matching [ProjectedUser] matching the given query parameters.
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
  Future<ProjectedUserAddressAndOrders?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProjectedUserTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedUserAddressAndOrdersTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    // ignore: invalid_use_of_internal_member
    return await session.db
        .findFirstRowAsJson<ProjectedUser>(
          where: where?.call(ProjectedUser.t),
          orderBy: orderBy?.call(ProjectedUser.t),
          orderByList: orderByList?.call(ProjectedUser.t),
          offset: offset,
          transaction: transaction,
          include: ProjectedUserAddressAndOrders.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (e) => e == null ? null : ProjectedUserAddressAndOrders.fromJson(e),
        );
  }

  /// Finds a single [ProjectedUser] by its [id] or null if no such row exists.
  Future<ProjectedUserAddressAndOrders?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    // ignore: invalid_use_of_internal_member
    return await session.db
        .findByIdAsJson<ProjectedUser>(
          id,
          transaction: transaction,
          include: ProjectedUserAddressAndOrders.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (e) => e == null ? null : ProjectedUserAddressAndOrders.fromJson(e),
        );
  }
}
