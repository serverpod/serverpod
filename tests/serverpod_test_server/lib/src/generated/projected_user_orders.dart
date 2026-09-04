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
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import 'projected_order_description.dart' as _id3wrdef;
import 'projected_user.dart';

abstract class ProjectedUserOrders
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ProjectedUserOrders._({
    this.id,
    required this.name,
    this.orders,
  });

  factory ProjectedUserOrders({
    _is.UuidValue? id,
    required String name,
    List<_id3wrdef.ProjectedOrderDescription>? orders,
  }) = _ProjectedUserOrdersImpl;

  factory ProjectedUserOrders.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedUserOrders(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      orders: jsonSerialization['orders'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<List<_id3wrdef.ProjectedOrderDescription>>(
                  jsonSerialization['orders'],
                ),
    );
  }

  static const db = ProjectedUserOrdersRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _is.UuidValue? id;

  String name;

  List<_id3wrdef.ProjectedOrderDescription>? orders;

  /// Returns a shallow copy of this [ProjectedUserOrders]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedUserOrders copyWith({
    _is.UuidValue? id,
    String? name,
    List<_id3wrdef.ProjectedOrderDescription>? orders,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUserOrders',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUserOrders',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(
          valueToJson: (v) =>
              // ignore: unnecessary_type_check
              v is _is.ProtocolSerialization
              ? (v as _is.ProtocolSerialization).toJsonForProtocol()
              :
                // ignore: dead_code
                v.toJson(),
        ),
    };
  }

  static ProjectedUserJsonInclude include() {
    return ProjectedUser.includeJson(
      select: (t) => [
        ProjectedUser.t.id,
        ProjectedUser.t.name,
      ],
      orders: _id3wrdef.ProjectedOrderDescription.includeList(),
    );
  }

  static ProjectedUserJsonIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
  }) {
    return ProjectedUser.includeJsonList(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      include: ProjectedUserOrders.include(),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserOrdersImpl extends ProjectedUserOrders {
  _ProjectedUserOrdersImpl({
    _is.UuidValue? id,
    required String name,
    List<_id3wrdef.ProjectedOrderDescription>? orders,
  }) : super._(
         id: id,
         name: name,
         orders: orders,
       );

  /// Returns a shallow copy of this [ProjectedUserOrders]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectedUserOrders copyWith({
    Object? id = _Undefined,
    String? name,
    Object? orders = _Undefined,
  }) {
    return ProjectedUserOrders(
      id: id is _is.UuidValue? ? id : this.id,
      name: name ?? this.name,
      orders: orders is List<_id3wrdef.ProjectedOrderDescription>?
          ? orders
          : this.orders?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class ProjectedUserOrdersRepository {
  const ProjectedUserOrdersRepository._();

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
  Future<List<ProjectedUserOrders>> find(
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
          include: ProjectedUserOrders.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (rows) => rows.map((e) => ProjectedUserOrders.fromJson(e)).toList(),
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
  Future<ProjectedUserOrders?> findFirstRow(
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
          include: ProjectedUserOrders.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedUserOrders.fromJson(e));
  }

  /// Finds a single [ProjectedUser] by its [id] or null if no such row exists.
  Future<ProjectedUserOrders?> findById(
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
          include: ProjectedUserOrders.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedUserOrders.fromJson(e));
  }
}
