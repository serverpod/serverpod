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
import 'projected_order.dart';

abstract class ProjectedOrderDescription
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProjectedOrderDescription._({
    this.id,
    required this.description,
  });

  factory ProjectedOrderDescription({
    int? id,
    required String description,
  }) = _ProjectedOrderDescriptionImpl;

  factory ProjectedOrderDescription.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedOrderDescription(
      id: jsonSerialization['id'] as int?,
      description: jsonSerialization['description'] as String,
    );
  }

  static const db = ProjectedOrderDescriptionRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String description;

  /// Returns a shallow copy of this [ProjectedOrderDescription]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedOrderDescription copyWith({
    int? id,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedOrderDescription',
      if (id != null) 'id': id,
      'description': description,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedOrderDescription',
      if (id != null) 'id': id,
      'description': description,
    };
  }

  static ProjectedOrderInclude include() {
    return ProjectedOrderInclude.internal_(
      selectedColumns: [
        ProjectedOrder.t.id,
        ProjectedOrder.t.description,
      ],
    );
  }

  static ProjectedOrderIncludeList includeList({
    _i1.WhereExpressionBuilder<ProjectedOrderTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedOrderTable>? orderByList,
  }) {
    return ProjectedOrder.includeList(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      include: ProjectedOrderDescription.include(),
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedOrderDescriptionImpl extends ProjectedOrderDescription {
  _ProjectedOrderDescriptionImpl({
    int? id,
    required String description,
  }) : super._(
         id: id,
         description: description,
       );

  /// Returns a shallow copy of this [ProjectedOrderDescription]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedOrderDescription copyWith({
    Object? id = _Undefined,
    String? description,
  }) {
    return ProjectedOrderDescription(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
    );
  }
}

class ProjectedOrderDescriptionRepository {
  const ProjectedOrderDescriptionRepository._();

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

  /// Returns a list of [ProjectedOrder]s matching the given query parameters.
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
  Future<List<ProjectedOrderDescription>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedOrderTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedOrderDescriptionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    // ignore: invalid_use_of_internal_member
    return await session.db
        .findAsJson<ProjectedOrder>(
          where: where?.call(ProjectedOrder.t),
          orderBy: orderBy?.call(ProjectedOrder.t),
          orderByList: orderByList?.call(ProjectedOrder.t),
          limit: limit,
          offset: offset,
          transaction: transaction,
          include: ProjectedOrderDescription.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (rows) =>
              rows.map((e) => ProjectedOrderDescription.fromJson(e)).toList(),
        );
  }

  /// Returns the first matching [ProjectedOrder] matching the given query parameters.
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
  Future<ProjectedOrderDescription?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedOrderTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedOrderDescriptionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    // ignore: invalid_use_of_internal_member
    return await session.db
        .findFirstRowAsJson<ProjectedOrder>(
          where: where?.call(ProjectedOrder.t),
          orderBy: orderBy?.call(ProjectedOrder.t),
          orderByList: orderByList?.call(ProjectedOrder.t),
          offset: offset,
          transaction: transaction,
          include: ProjectedOrderDescription.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedOrderDescription.fromJson(e));
  }

  /// Finds a single [ProjectedOrder] by its [id] or null if no such row exists.
  Future<ProjectedOrderDescription?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    // ignore: invalid_use_of_internal_member
    return await session.db
        .findByIdAsJson<ProjectedOrder>(
          id,
          transaction: transaction,
          include: ProjectedOrderDescription.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedOrderDescription.fromJson(e));
  }
}
