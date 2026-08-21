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
import 'projected_course_name.dart' as _i2;
import 'projected_enrollment.dart';

abstract class ProjectedEnrollmentCourse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProjectedEnrollmentCourse._({
    this.id,
    this.course,
  });

  factory ProjectedEnrollmentCourse({
    int? id,
    _i2.ProjectedCourseName? course,
  }) = _ProjectedEnrollmentCourseImpl;

  factory ProjectedEnrollmentCourse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedEnrollmentCourse(
      id: jsonSerialization['id'] as int?,
      course: jsonSerialization['course'] == null
          ? null
          : _i2.ProjectedCourseName.fromJson(jsonSerialization['course']),
    );
  }

  static const db = ProjectedEnrollmentCourseRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2.ProjectedCourseName? course;

  /// Returns a shallow copy of this [ProjectedEnrollmentCourse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedEnrollmentCourse copyWith({
    int? id,
    _i2.ProjectedCourseName? course,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedEnrollmentCourse',
      if (id != null) 'id': id,
      if (course != null) 'course': course?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedEnrollmentCourse',
      if (id != null) 'id': id,
      if (course != null)
        'course':
            // ignore: unnecessary_type_check
            course is _i1.ProtocolSerialization
            ? (course as _i1.ProtocolSerialization).toJsonForProtocol()
            :
              // ignore: dead_code
              course?.toJson(),
    };
  }

  static ProjectedEnrollmentInclude include() {
    return ProjectedEnrollmentInclude.internal_(
      selectedColumns: [ProjectedEnrollment.t.id],
      course: _i2.ProjectedCourseName.include(),
    );
  }

  static ProjectedEnrollmentIncludeList includeList({
    _i1.WhereExpressionBuilder<ProjectedEnrollmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedEnrollmentTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectedEnrollmentTable>? orderByList,
  }) {
    return ProjectedEnrollment.includeList(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      orderByList: orderByList,
      include: ProjectedEnrollmentCourse.include(),
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedEnrollmentCourseImpl extends ProjectedEnrollmentCourse {
  _ProjectedEnrollmentCourseImpl({
    int? id,
    _i2.ProjectedCourseName? course,
  }) : super._(
         id: id,
         course: course,
       );

  /// Returns a shallow copy of this [ProjectedEnrollmentCourse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedEnrollmentCourse copyWith({
    Object? id = _Undefined,
    Object? course = _Undefined,
  }) {
    return ProjectedEnrollmentCourse(
      id: id is int? ? id : this.id,
      course: course is _i2.ProjectedCourseName?
          ? course
          : this.course?.copyWith(),
    );
  }
}

class ProjectedEnrollmentCourseRepository {
  const ProjectedEnrollmentCourseRepository._();

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

  /// Returns a list of [ProjectedEnrollment]s matching the given query parameters.
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
  Future<List<ProjectedEnrollmentCourse>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedEnrollmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedEnrollmentTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectedEnrollmentTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    // ignore: invalid_use_of_internal_member
    return await session.db
        .findAsJson<ProjectedEnrollment>(
          where: where?.call(ProjectedEnrollment.t),
          orderBy: orderBy?.call(ProjectedEnrollment.t),
          orderByList: orderByList?.call(ProjectedEnrollment.t),
          orderDescending: // ignore: deprecated_member_use
              orderDescending,
          limit: limit,
          offset: offset,
          transaction: transaction,
          include: ProjectedEnrollmentCourse.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (rows) =>
              rows.map((e) => ProjectedEnrollmentCourse.fromJson(e)).toList(),
        );
  }

  /// Returns the first matching [ProjectedEnrollment] matching the given query parameters.
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
  Future<ProjectedEnrollmentCourse?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedEnrollmentTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProjectedEnrollmentTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectedEnrollmentTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    // ignore: invalid_use_of_internal_member
    return await session.db
        .findFirstRowAsJson<ProjectedEnrollment>(
          where: where?.call(ProjectedEnrollment.t),
          orderBy: orderBy?.call(ProjectedEnrollment.t),
          orderByList: orderByList?.call(ProjectedEnrollment.t),
          orderDescending: // ignore: deprecated_member_use
              orderDescending,
          offset: offset,
          transaction: transaction,
          include: ProjectedEnrollmentCourse.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedEnrollmentCourse.fromJson(e));
  }

  /// Finds a single [ProjectedEnrollment] by its [id] or null if no such row exists.
  Future<ProjectedEnrollmentCourse?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    // ignore: invalid_use_of_internal_member
    return await session.db
        .findByIdAsJson<ProjectedEnrollment>(
          id,
          transaction: transaction,
          include: ProjectedEnrollmentCourse.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedEnrollmentCourse.fromJson(e));
  }
}
