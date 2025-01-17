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
import '../../changed_id_type/many_to_many/enrollment.dart' as _i2;

abstract class StudentUuid implements _i1.SerializableModel {
  StudentUuid._({
    this.id,
    required this.name,
    this.enrollments,
  });

  factory StudentUuid({
    int? id,
    required String name,
    List<_i2.EnrollmentInt>? enrollments,
  }) = _StudentUuidImpl;

  factory StudentUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentUuid(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      enrollments: (jsonSerialization['enrollments'] as List?)
          ?.map((e) => _i2.EnrollmentInt.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.EnrollmentInt>? enrollments;

  StudentUuid copyWith({
    int? id,
    String? name,
    List<_i2.EnrollmentInt>? enrollments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentUuidImpl extends StudentUuid {
  _StudentUuidImpl({
    int? id,
    required String name,
    List<_i2.EnrollmentInt>? enrollments,
  }) : super._(
          id: id,
          name: name,
          enrollments: enrollments,
        );

  @override
  StudentUuid copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return StudentUuid(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_i2.EnrollmentInt>?
          ? enrollments
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
