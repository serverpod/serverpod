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
import 'projected_order.dart';

abstract class ProjectedOrderDescription
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ProjectedOrderDescription._({
    this.id,
    required this.description,
    this.summary,
  });

  factory ProjectedOrderDescription({
    _is.UuidValue? id,
    required String description,
    String? summary,
  }) = _ProjectedOrderDescriptionImpl;

  factory ProjectedOrderDescription.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedOrderDescription(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      description: jsonSerialization['description'] as String,
      summary: jsonSerialization['summary'] as String?,
    );
  }

  static const db = ProjectedOrderDescriptionRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _is.UuidValue? id;

  String description;

  String? summary;

  /// Returns a shallow copy of this [ProjectedOrderDescription]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedOrderDescription copyWith({
    _is.UuidValue? id,
    String? description,
    String? summary,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedOrderDescription',
      if (id != null) 'id': id?.toJson(),
      'description': description,
      if (summary != null) 'summary': summary,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedOrderDescription',
      if (id != null) 'id': id?.toJson(),
      'description': description,
      if (summary != null) 'summary': summary,
    };
  }

  static ProjectedOrderInclude include() {
    return ProjectedOrder.include(
      select: (t) => [
        ProjectedOrder.t.id,
        ProjectedOrder.t.description,
        ProjectedOrder.t.summary,
      ],
    );
  }

  static ProjectedOrderIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedOrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _is.OrderByListBuilder<ProjectedOrderTable>? orderByList,
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
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedOrderDescriptionImpl extends ProjectedOrderDescription {
  _ProjectedOrderDescriptionImpl({
    _is.UuidValue? id,
    required String description,
    String? summary,
  }) : super._(
         id: id,
         description: description,
         summary: summary,
       );

  /// Returns a shallow copy of this [ProjectedOrderDescription]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectedOrderDescription copyWith({
    Object? id = _Undefined,
    String? description,
    Object? summary = _Undefined,
  }) {
    return ProjectedOrderDescription(
      id: id is _is.UuidValue? ? id : this.id,
      description: description ?? this.description,
      summary: summary is String? ? summary : this.summary,
    );
  }
}

class ProjectedOrderDescriptionRepository {
  const ProjectedOrderDescriptionRepository._();

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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedOrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _is.OrderByListBuilder<ProjectedOrderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedOrderTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _is.OrderByListBuilder<ProjectedOrderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
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
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
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
