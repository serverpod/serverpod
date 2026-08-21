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
import 'projected_course.dart';

abstract class ProjectedCourseName
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProjectedCourseName._({
    this.id,
    required this.name,
  });

  factory ProjectedCourseName({
    int? id,
    required String name,
  }) = _ProjectedCourseNameImpl;

  factory ProjectedCourseName.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedCourseName(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
    );
  }

  static const db = ProjectedCourseNameRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  /// Returns a shallow copy of this [ProjectedCourseName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedCourseName copyWith({
    int? id,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedCourseName',
      if (id != null) 'id': id,
      'name': name,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedCourseName',
      if (id != null) 'id': id,
      'name': name,
    };
  }

  static ProjectedCourseInclude include() {
    return ProjectedCourseInclude.internal_(
      selectedColumns: [
        ProjectedCourse.t.id,
        ProjectedCourse.t.name,
      ],
    );
  }

  static ProjectedCourseIncludeList includeList({
    _i1.WhereExpressionBuilder<ProjectedCourseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedCourseTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectedCourseTable>? orderByList,
  }) {
    return ProjectedCourse.includeList(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      orderByList: orderByList,
      include: ProjectedCourseName.include(),
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedCourseNameImpl extends ProjectedCourseName {
  _ProjectedCourseNameImpl({
    int? id,
    required String name,
  }) : super._(
         id: id,
         name: name,
       );

  /// Returns a shallow copy of this [ProjectedCourseName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedCourseName copyWith({
    Object? id = _Undefined,
    String? name,
  }) {
    return ProjectedCourseName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
    );
  }
}

class ProjectedCourseNameRepository {
  const ProjectedCourseNameRepository._();

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

  /// Returns a list of [ProjectedCourse]s matching the given query parameters.
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
  Future<List<ProjectedCourseName>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedCourseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedCourseTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectedCourseTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    // ignore: invalid_use_of_internal_member
    return await session.db
        .findAsJson<ProjectedCourse>(
          where: where?.call(ProjectedCourse.t),
          orderBy: orderBy?.call(ProjectedCourse.t),
          orderByList: orderByList?.call(ProjectedCourse.t),
          orderDescending: // ignore: deprecated_member_use
              orderDescending,
          limit: limit,
          offset: offset,
          transaction: transaction,
          include: ProjectedCourseName.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (rows) => rows.map((e) => ProjectedCourseName.fromJson(e)).toList(),
        );
  }

  /// Returns the first matching [ProjectedCourse] matching the given query parameters.
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
  Future<ProjectedCourseName?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedCourseTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProjectedCourseTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectedCourseTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    // ignore: invalid_use_of_internal_member
    return await session.db
        .findFirstRowAsJson<ProjectedCourse>(
          where: where?.call(ProjectedCourse.t),
          orderBy: orderBy?.call(ProjectedCourse.t),
          orderByList: orderByList?.call(ProjectedCourse.t),
          orderDescending: // ignore: deprecated_member_use
              orderDescending,
          offset: offset,
          transaction: transaction,
          include: ProjectedCourseName.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedCourseName.fromJson(e));
  }

  /// Finds a single [ProjectedCourse] by its [id] or null if no such row exists.
  Future<ProjectedCourseName?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    // ignore: invalid_use_of_internal_member
    return await session.db
        .findByIdAsJson<ProjectedCourse>(
          id,
          transaction: transaction,
          include: ProjectedCourseName.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedCourseName.fromJson(e));
  }
}
