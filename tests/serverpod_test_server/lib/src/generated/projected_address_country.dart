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
import 'projected_address.dart';

abstract class ProjectedAddressCountry
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ProjectedAddressCountry._({
    this.id,
    required this.country,
  });

  factory ProjectedAddressCountry({
    int? id,
    required String country,
  }) = _ProjectedAddressCountryImpl;

  factory ProjectedAddressCountry.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedAddressCountry(
      id: jsonSerialization['id'] as int?,
      country: jsonSerialization['country'] as String,
    );
  }

  static const db = ProjectedAddressCountryRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String country;

  /// Returns a shallow copy of this [ProjectedAddressCountry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedAddressCountry copyWith({
    int? id,
    String? country,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedAddressCountry',
      if (id != null) 'id': id,
      'country': country,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedAddressCountry',
      if (id != null) 'id': id,
      'country': country,
    };
  }

  static ProjectedAddressInclude include() {
    return ProjectedAddress.include(
      select: (t) => [
        ProjectedAddress.t.id,
        ProjectedAddress.t.country,
      ],
    );
  }

  static ProjectedAddressIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedAddressTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedAddressTable>? orderBy,
    _is.OrderByListBuilder<ProjectedAddressTable>? orderByList,
  }) {
    return ProjectedAddress.includeList(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      include: ProjectedAddressCountry.include(),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedAddressCountryImpl extends ProjectedAddressCountry {
  _ProjectedAddressCountryImpl({
    int? id,
    required String country,
  }) : super._(
         id: id,
         country: country,
       );

  /// Returns a shallow copy of this [ProjectedAddressCountry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectedAddressCountry copyWith({
    Object? id = _Undefined,
    String? country,
  }) {
    return ProjectedAddressCountry(
      id: id is int? ? id : this.id,
      country: country ?? this.country,
    );
  }
}

class ProjectedAddressCountryRepository {
  const ProjectedAddressCountryRepository._();

  /// Returns a list of [ProjectedAddress]s matching the given query parameters.
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
  Future<List<ProjectedAddressCountry>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedAddressTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedAddressTable>? orderBy,
    _is.OrderByListBuilder<ProjectedAddressTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findAsJson<ProjectedAddress>(
          where: where?.call(ProjectedAddress.t),
          orderBy: orderBy?.call(ProjectedAddress.t),
          orderByList: orderByList?.call(ProjectedAddress.t),
          limit: limit,
          offset: offset,
          transaction: transaction,
          include: ProjectedAddressCountry.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (rows) =>
              rows.map((e) => ProjectedAddressCountry.fromJson(e)).toList(),
        );
  }

  /// Returns the first matching [ProjectedAddress] matching the given query parameters.
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
  Future<ProjectedAddressCountry?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedAddressTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedAddressTable>? orderBy,
    _is.OrderByListBuilder<ProjectedAddressTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findFirstRowAsJson<ProjectedAddress>(
          where: where?.call(ProjectedAddress.t),
          orderBy: orderBy?.call(ProjectedAddress.t),
          orderByList: orderByList?.call(ProjectedAddress.t),
          offset: offset,
          transaction: transaction,
          include: ProjectedAddressCountry.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedAddressCountry.fromJson(e));
  }

  /// Finds a single [ProjectedAddress] by its [id] or null if no such row exists.
  Future<ProjectedAddressCountry?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findByIdAsJson<ProjectedAddress>(
          id,
          transaction: transaction,
          include: ProjectedAddressCountry.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedAddressCountry.fromJson(e));
  }
}
