/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../changed_id_type/many_to_many/student.dart' as _i2;
import '../../changed_id_type/many_to_many/course.dart' as _i3;

abstract class EnrollmentInt implements _i1.SerializableModel {
  EnrollmentInt._({
    this.id,
    required this.studentId,
    this.student,
    required this.courseId,
    this.course,
  });

  factory EnrollmentInt({
    int? id,
    required int studentId,
    _i2.StudentUuid? student,
    required int courseId,
    _i3.CourseUuid? course,
  }) = _EnrollmentIntImpl;

  factory EnrollmentInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnrollmentInt(
      id: jsonSerialization['id'] as int?,
      studentId: jsonSerialization['studentId'] as int,
      student: jsonSerialization['student'] == null
          ? null
          : _i2.StudentUuid.fromJson(
              (jsonSerialization['student'] as Map<String, dynamic>)),
      courseId: jsonSerialization['courseId'] as int,
      course: jsonSerialization['course'] == null
          ? null
          : _i3.CourseUuid.fromJson(
              (jsonSerialization['course'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int studentId;

  _i2.StudentUuid? student;

  int courseId;

  _i3.CourseUuid? course;

  EnrollmentInt copyWith({
    int? id,
    int? studentId,
    _i2.StudentUuid? student,
    int? courseId,
    _i3.CourseUuid? course,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'studentId': studentId,
      if (student != null) 'student': student?.toJson(),
      'courseId': courseId,
      if (course != null) 'course': course?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnrollmentIntImpl extends EnrollmentInt {
  _EnrollmentIntImpl({
    int? id,
    required int studentId,
    _i2.StudentUuid? student,
    required int courseId,
    _i3.CourseUuid? course,
  }) : super._(
          id: id,
          studentId: studentId,
          student: student,
          courseId: courseId,
          course: course,
        );

  @override
  EnrollmentInt copyWith({
    Object? id = _Undefined,
    int? studentId,
    Object? student = _Undefined,
    int? courseId,
    Object? course = _Undefined,
  }) {
    return EnrollmentInt(
      id: id is int? ? id : this.id,
      studentId: studentId ?? this.studentId,
      student: student is _i2.StudentUuid? ? student : this.student?.copyWith(),
      courseId: courseId ?? this.courseId,
      course: course is _i3.CourseUuid? ? course : this.course?.copyWith(),
    );
  }
}
