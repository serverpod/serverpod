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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'projected_course_name.dart' as _icve44wq;

abstract class ProjectedEnrollmentCourse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedEnrollmentCourse._({
    this.id,
    this.course,
  });

  factory ProjectedEnrollmentCourse({
    int? id,
    _icve44wq.ProjectedCourseName? course,
  }) = _ProjectedEnrollmentCourseImpl;

  factory ProjectedEnrollmentCourse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedEnrollmentCourse(
      id: jsonSerialization['id'] as int?,
      course: jsonSerialization['course'] == null
          ? null
          : _icve44wq.ProjectedCourseName.fromJson(jsonSerialization['course']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _icve44wq.ProjectedCourseName? course;

  /// Returns a shallow copy of this [ProjectedEnrollmentCourse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedEnrollmentCourse copyWith({
    int? id,
    _icve44wq.ProjectedCourseName? course,
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
            course is _isc.ProtocolSerialization
            ? (course as _isc.ProtocolSerialization).toJsonForProtocol()
            :
              // ignore: dead_code
              course?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedEnrollmentCourseImpl extends ProjectedEnrollmentCourse {
  _ProjectedEnrollmentCourseImpl({
    int? id,
    _icve44wq.ProjectedCourseName? course,
  }) : super._(
         id: id,
         course: course,
       );

  /// Returns a shallow copy of this [ProjectedEnrollmentCourse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedEnrollmentCourse copyWith({
    Object? id = _Undefined,
    Object? course = _Undefined,
  }) {
    return ProjectedEnrollmentCourse(
      id: id is int? ? id : this.id,
      course: course is _icve44wq.ProjectedCourseName?
          ? course
          : this.course?.copyWith(),
    );
  }
}
