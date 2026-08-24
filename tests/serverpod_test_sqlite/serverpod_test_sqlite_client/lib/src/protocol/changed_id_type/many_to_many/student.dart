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
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import '../../changed_id_type/many_to_many/enrollment.dart' as _ih6xbg05;

abstract class StudentUuid
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StudentUuid._({
    this.id,
    required this.name,
    this.enrollments,
  });

  factory StudentUuid({
    _isc.UuidValue? id,
    required String name,
    List<_ih6xbg05.EnrollmentInt>? enrollments,
  }) = _StudentUuidImpl;

  factory StudentUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return StudentUuid(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      enrollments: jsonSerialization['enrollments'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<List<_ih6xbg05.EnrollmentInt>>(
              jsonSerialization['enrollments'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String name;

  List<_ih6xbg05.EnrollmentInt>? enrollments;

  /// Returns a shallow copy of this [StudentUuid]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StudentUuid copyWith({
    _isc.UuidValue? id,
    String? name,
    List<_ih6xbg05.EnrollmentInt>? enrollments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StudentUuid',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StudentUuid',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StudentUuidImpl extends StudentUuid {
  _StudentUuidImpl({
    _isc.UuidValue? id,
    required String name,
    List<_ih6xbg05.EnrollmentInt>? enrollments,
  }) : super._(
         id: id,
         name: name,
         enrollments: enrollments,
       );

  /// Returns a shallow copy of this [StudentUuid]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StudentUuid copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return StudentUuid(
      id: id is _isc.UuidValue? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_ih6xbg05.EnrollmentInt>?
          ? enrollments
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
