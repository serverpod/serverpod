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
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import 'projected_enrollment_course.dart' as _ika7thts;

abstract class ProjectedStudentCourses
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedStudentCourses._({
    this.id,
    required this.name,
    this.enrollments,
  });

  factory ProjectedStudentCourses({
    int? id,
    required String name,
    List<_ika7thts.ProjectedEnrollmentCourse>? enrollments,
  }) = _ProjectedStudentCoursesImpl;

  factory ProjectedStudentCourses.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedStudentCourses(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      enrollments: jsonSerialization['enrollments'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<List<_ika7thts.ProjectedEnrollmentCourse>>(
                  jsonSerialization['enrollments'],
                ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_ika7thts.ProjectedEnrollmentCourse>? enrollments;

  /// Returns a shallow copy of this [ProjectedStudentCourses]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedStudentCourses copyWith({
    int? id,
    String? name,
    List<_ika7thts.ProjectedEnrollmentCourse>? enrollments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedStudentCourses',
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedStudentCourses',
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(
          valueToJson: (v) =>
              // ignore: unnecessary_type_check
              v is _isc.ProtocolSerialization
              ? (v as _isc.ProtocolSerialization).toJsonForProtocol()
              :
                // ignore: dead_code
                v.toJson(),
        ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedStudentCoursesImpl extends ProjectedStudentCourses {
  _ProjectedStudentCoursesImpl({
    int? id,
    required String name,
    List<_ika7thts.ProjectedEnrollmentCourse>? enrollments,
  }) : super._(
         id: id,
         name: name,
         enrollments: enrollments,
       );

  /// Returns a shallow copy of this [ProjectedStudentCourses]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedStudentCourses copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return ProjectedStudentCourses(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_ika7thts.ProjectedEnrollmentCourse>?
          ? enrollments
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
