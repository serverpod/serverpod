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
import 'projected_address_street.dart' as _i2;
import 'projected_user.dart';

abstract class ProjectedUserStreetAddress
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProjectedUserStreetAddress._({
    this.id,
    required this.name,
    this.address,
  });

  factory ProjectedUserStreetAddress({
    int? id,
    required String name,
    _i2.ProjectedAddressStreet? address,
  }) = _ProjectedUserStreetAddressImpl;

  factory ProjectedUserStreetAddress.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedUserStreetAddress(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] == null
          ? null
          : _i2.ProjectedAddressStreet.fromJson(jsonSerialization['address']),
    );
  }

  static const db = ProjectedUserStreetAddressRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  _i2.ProjectedAddressStreet? address;

  /// Returns a shallow copy of this [ProjectedUserStreetAddress]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedUserStreetAddress copyWith({
    int? id,
    String? name,
    _i2.ProjectedAddressStreet? address,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUserStreetAddress',
      if (id != null) 'id': id,
      'name': name,
      if (address != null) 'address': address?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUserStreetAddress',
      if (id != null) 'id': id,
      'name': name,
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
      address: _i2.ProjectedAddressStreet.include(),
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
      include: ProjectedUserStreetAddress.include(),
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserStreetAddressImpl extends ProjectedUserStreetAddress {
  _ProjectedUserStreetAddressImpl({
    int? id,
    required String name,
    _i2.ProjectedAddressStreet? address,
  }) : super._(
         id: id,
         name: name,
         address: address,
       );

  /// Returns a shallow copy of this [ProjectedUserStreetAddress]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedUserStreetAddress copyWith({
    Object? id = _Undefined,
    String? name,
    Object? address = _Undefined,
  }) {
    return ProjectedUserStreetAddress(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      address: address is _i2.ProjectedAddressStreet?
          ? address
          : this.address?.copyWith(),
    );
  }
}

class ProjectedUserStreetAddressRepository {
  const ProjectedUserStreetAddressRepository._();

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
  Future<List<ProjectedUserStreetAddress>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedUserTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findAsJson<ProjectedUser>(
          where: where?.call(ProjectedUser.t),
          orderBy: orderBy?.call(ProjectedUser.t),
          orderByList: orderByList?.call(ProjectedUser.t),
          limit: limit,
          offset: offset,
          transaction: transaction,
          include: ProjectedUserStreetAddress.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (rows) =>
              rows.map((e) => ProjectedUserStreetAddress.fromJson(e)).toList(),
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
  Future<ProjectedUserStreetAddress?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProjectedUserTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findFirstRowAsJson<ProjectedUser>(
          where: where?.call(ProjectedUser.t),
          orderBy: orderBy?.call(ProjectedUser.t),
          orderByList: orderByList?.call(ProjectedUser.t),
          offset: offset,
          transaction: transaction,
          include: ProjectedUserStreetAddress.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedUserStreetAddress.fromJson(e));
  }

  /// Finds a single [ProjectedUser] by its [id] or null if no such row exists.
  Future<ProjectedUserStreetAddress?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findByIdAsJson<ProjectedUser>(
          id,
          transaction: transaction,
          include: ProjectedUserStreetAddress.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedUserStreetAddress.fromJson(e));
  }
}
