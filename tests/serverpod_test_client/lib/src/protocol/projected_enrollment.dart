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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'projected_student.dart' as _i2;
import 'projected_course.dart' as _i3;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i4;

abstract class ProjectedEnrollment
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProjectedEnrollment._({
    this.id,
    required this.studentId,
    this.student,
    required this.courseId,
    this.course,
  });

  factory ProjectedEnrollment({
    int? id,
    required int studentId,
    _i2.ProjectedStudent? student,
    required int courseId,
    _i3.ProjectedCourse? course,
  }) = _ProjectedEnrollmentImpl;

  factory ProjectedEnrollment.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedEnrollment(
      id: jsonSerialization['id'] as int?,
      studentId: jsonSerialization['studentId'] as int,
      student: jsonSerialization['student'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.ProjectedStudent>(
              jsonSerialization['student'],
            ),
      courseId: jsonSerialization['courseId'] as int,
      course: jsonSerialization['course'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.ProjectedCourse>(
              jsonSerialization['course'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int studentId;

  _i2.ProjectedStudent? student;

  int courseId;

  _i3.ProjectedCourse? course;

  /// Returns a shallow copy of this [ProjectedEnrollment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedEnrollment copyWith({
    int? id,
    int? studentId,
    _i2.ProjectedStudent? student,
    int? courseId,
    _i3.ProjectedCourse? course,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedEnrollment',
      if (id != null) 'id': id,
      'studentId': studentId,
      if (student != null) 'student': student?.toJson(),
      'courseId': courseId,
      if (course != null) 'course': course?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedEnrollment',
      if (id != null) 'id': id,
      'studentId': studentId,
      if (student != null) 'student': student?.toJsonForProtocol(),
      'courseId': courseId,
      if (course != null) 'course': course?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedEnrollmentImpl extends ProjectedEnrollment {
  _ProjectedEnrollmentImpl({
    int? id,
    required int studentId,
    _i2.ProjectedStudent? student,
    required int courseId,
    _i3.ProjectedCourse? course,
  }) : super._(
         id: id,
         studentId: studentId,
         student: student,
         courseId: courseId,
         course: course,
       );

  /// Returns a shallow copy of this [ProjectedEnrollment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedEnrollment copyWith({
    Object? id = _Undefined,
    int? studentId,
    Object? student = _Undefined,
    int? courseId,
    Object? course = _Undefined,
  }) {
    return ProjectedEnrollment(
      id: id is int? ? id : this.id,
      studentId: studentId ?? this.studentId,
      student: student is _i2.ProjectedStudent?
          ? student
          : this.student?.copyWith(),
      courseId: courseId ?? this.courseId,
      course: course is _i3.ProjectedCourse? ? course : this.course?.copyWith(),
    );
  }
}
