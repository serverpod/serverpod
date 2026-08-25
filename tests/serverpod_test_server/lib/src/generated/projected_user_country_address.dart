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
import 'package:serverpod/serverpod.dart' as _is;
import 'projected_address_country.dart' as _ikpl2lpd;
import 'projected_user.dart';

abstract class ProjectedUserCountryAddress
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ProjectedUserCountryAddress._({
    this.id,
    required this.name,
    this.address,
  });

  factory ProjectedUserCountryAddress({
    _is.UuidValue? id,
    required String name,
    _ikpl2lpd.ProjectedAddressCountry? address,
  }) = _ProjectedUserCountryAddressImpl;

  factory ProjectedUserCountryAddress.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedUserCountryAddress(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] == null
          ? null
          : _ikpl2lpd.ProjectedAddressCountry.fromJson(
              jsonSerialization['address'],
            ),
    );
  }

  static const db = ProjectedUserCountryAddressRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _is.UuidValue? id;

  String name;

  _ikpl2lpd.ProjectedAddressCountry? address;

  /// Returns a shallow copy of this [ProjectedUserCountryAddress]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedUserCountryAddress copyWith({
    _is.UuidValue? id,
    String? name,
    _ikpl2lpd.ProjectedAddressCountry? address,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUserCountryAddress',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (address != null) 'address': address?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUserCountryAddress',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (address != null)
        'address':
            // ignore: unnecessary_type_check
            address is _is.ProtocolSerialization
            ? (address as _is.ProtocolSerialization).toJsonForProtocol()
            :
              // ignore: dead_code
              address?.toJson(),
    };
  }

  static ProjectedUserInclude include() {
    return ProjectedUser.include(
      select: (t) => [
        ProjectedUser.t.id,
        ProjectedUser.t.name,
      ],
      address: _ikpl2lpd.ProjectedAddressCountry.include(),
    );
  }

  static ProjectedUserIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
  }) {
    return ProjectedUser.includeList(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      include: ProjectedUserCountryAddress.include(),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserCountryAddressImpl extends ProjectedUserCountryAddress {
  _ProjectedUserCountryAddressImpl({
    _is.UuidValue? id,
    required String name,
    _ikpl2lpd.ProjectedAddressCountry? address,
  }) : super._(
         id: id,
         name: name,
         address: address,
       );

  /// Returns a shallow copy of this [ProjectedUserCountryAddress]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectedUserCountryAddress copyWith({
    Object? id = _Undefined,
    String? name,
    Object? address = _Undefined,
  }) {
    return ProjectedUserCountryAddress(
      id: id is _is.UuidValue? ? id : this.id,
      name: name ?? this.name,
      address: address is _ikpl2lpd.ProjectedAddressCountry?
          ? address
          : this.address?.copyWith(),
    );
  }
}

class ProjectedUserCountryAddressRepository {
  const ProjectedUserCountryAddressRepository._();

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
  Future<List<ProjectedUserCountryAddress>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findAsJson<ProjectedUser>(
          where: where?.call(ProjectedUser.t),
          orderBy: orderBy?.call(ProjectedUser.t),
          orderByList: orderByList?.call(ProjectedUser.t),
          limit: limit,
          offset: offset,
          transaction: transaction,
          include: ProjectedUserCountryAddress.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (rows) =>
              rows.map((e) => ProjectedUserCountryAddress.fromJson(e)).toList(),
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
  Future<ProjectedUserCountryAddress?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findFirstRowAsJson<ProjectedUser>(
          where: where?.call(ProjectedUser.t),
          orderBy: orderBy?.call(ProjectedUser.t),
          orderByList: orderByList?.call(ProjectedUser.t),
          offset: offset,
          transaction: transaction,
          include: ProjectedUserCountryAddress.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (e) => e == null ? null : ProjectedUserCountryAddress.fromJson(e),
        );
  }

  /// Finds a single [ProjectedUser] by its [id] or null if no such row exists.
  Future<ProjectedUserCountryAddress?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findByIdAsJson<ProjectedUser>(
          id,
          transaction: transaction,
          include: ProjectedUserCountryAddress.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (e) => e == null ? null : ProjectedUserCountryAddress.fromJson(e),
        );
  }
}
