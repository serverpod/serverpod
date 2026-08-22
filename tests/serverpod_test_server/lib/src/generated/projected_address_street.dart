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
import 'projected_address.dart';

abstract class ProjectedAddressStreet
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProjectedAddressStreet._({
    this.id,
    required this.street,
  });

  factory ProjectedAddressStreet({
    int? id,
    required String street,
  }) = _ProjectedAddressStreetImpl;

  factory ProjectedAddressStreet.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedAddressStreet(
      id: jsonSerialization['id'] as int?,
      street: jsonSerialization['street'] as String,
    );
  }

  static const db = ProjectedAddressStreetRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String street;

  /// Returns a shallow copy of this [ProjectedAddressStreet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedAddressStreet copyWith({
    int? id,
    String? street,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedAddressStreet',
      if (id != null) 'id': id,
      'street': street,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedAddressStreet',
      if (id != null) 'id': id,
      'street': street,
    };
  }

  static ProjectedAddressInclude include() {
    return ProjectedAddressInclude.internal_(
      selectedColumns: [
        ProjectedAddress.t.id,
        ProjectedAddress.t.street,
      ],
    );
  }

  static ProjectedAddressIncludeList includeList({
    _i1.WhereExpressionBuilder<ProjectedAddressTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedAddressTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedAddressTable>? orderByList,
  }) {
    return ProjectedAddress.includeList(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      include: ProjectedAddressStreet.include(),
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedAddressStreetImpl extends ProjectedAddressStreet {
  _ProjectedAddressStreetImpl({
    int? id,
    required String street,
  }) : super._(
         id: id,
         street: street,
       );

  /// Returns a shallow copy of this [ProjectedAddressStreet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedAddressStreet copyWith({
    Object? id = _Undefined,
    String? street,
  }) {
    return ProjectedAddressStreet(
      id: id is int? ? id : this.id,
      street: street ?? this.street,
    );
  }
}

class ProjectedAddressStreetRepository {
  const ProjectedAddressStreetRepository._();

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
  Future<List<ProjectedAddressStreet>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedAddressTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedAddressTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedAddressStreetTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    // ignore: invalid_use_of_internal_member
    return await session.db
        .findAsJson<ProjectedAddress>(
          where: where?.call(ProjectedAddress.t),
          orderBy: orderBy?.call(ProjectedAddress.t),
          orderByList: orderByList?.call(ProjectedAddress.t),
          limit: limit,
          offset: offset,
          transaction: transaction,
          include: ProjectedAddressStreet.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (rows) =>
              rows.map((e) => ProjectedAddressStreet.fromJson(e)).toList(),
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
  Future<ProjectedAddressStreet?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedAddressTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProjectedAddressTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedAddressStreetTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    // ignore: invalid_use_of_internal_member
    return await session.db
        .findFirstRowAsJson<ProjectedAddress>(
          where: where?.call(ProjectedAddress.t),
          orderBy: orderBy?.call(ProjectedAddress.t),
          orderByList: orderByList?.call(ProjectedAddress.t),
          offset: offset,
          transaction: transaction,
          include: ProjectedAddressStreet.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedAddressStreet.fromJson(e));
  }

  /// Finds a single [ProjectedAddress] by its [id] or null if no such row exists.
  Future<ProjectedAddressStreet?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    // ignore: invalid_use_of_internal_member
    return await session.db
        .findByIdAsJson<ProjectedAddress>(
          id,
          transaction: transaction,
          include: ProjectedAddressStreet.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedAddressStreet.fromJson(e));
  }
}
