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

abstract class ProjectedUserJsonField
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedUserJsonField._({
    this.id,
    required this.name,
    this.jsonFieldText,
  });

  factory ProjectedUserJsonField({
    _isc.UuidValue? id,
    required String name,
    String? jsonFieldText,
  }) = _ProjectedUserJsonFieldImpl;

  factory ProjectedUserJsonField.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedUserJsonField(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      jsonFieldText:
          (jsonSerialization['jsonFieldText'] ??
                  (jsonSerialization['jsonField'] as Map?)?['text'])
              as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String name;

  String? jsonFieldText;

  /// Returns a shallow copy of this [ProjectedUserJsonField]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedUserJsonField copyWith({
    _isc.UuidValue? id,
    String? name,
    String? jsonFieldText,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUserJsonField',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (jsonFieldText != null) 'jsonFieldText': jsonFieldText,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUserJsonField',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (jsonFieldText != null) 'jsonFieldText': jsonFieldText,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserJsonFieldImpl extends ProjectedUserJsonField {
  _ProjectedUserJsonFieldImpl({
    _isc.UuidValue? id,
    required String name,
    String? jsonFieldText,
  }) : super._(
         id: id,
         name: name,
         jsonFieldText: jsonFieldText,
       );

  /// Returns a shallow copy of this [ProjectedUserJsonField]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedUserJsonField copyWith({
    Object? id = _Undefined,
    String? name,
    Object? jsonFieldText = _Undefined,
  }) {
    return ProjectedUserJsonField(
      id: id is _isc.UuidValue? ? id : this.id,
      name: name ?? this.name,
      jsonFieldText: jsonFieldText is String?
          ? jsonFieldText
          : this.jsonFieldText,
    );
  }
}
