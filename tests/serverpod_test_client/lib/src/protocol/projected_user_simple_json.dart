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
import 'projected_json_field_simple.dart' as _i37n7uc1;

abstract class ProjectedUserSimpleJson
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedUserSimpleJson._({
    this.id,
    required this.name,
    this.jsonField,
  });

  factory ProjectedUserSimpleJson({
    int? id,
    required String name,
    _i37n7uc1.ProjectedJsonFieldSimple? jsonField,
  }) = _ProjectedUserSimpleJsonImpl;

  factory ProjectedUserSimpleJson.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedUserSimpleJson(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      jsonField: jsonSerialization['jsonField'] == null
          ? null
          : _i37n7uc1.ProjectedJsonFieldSimple.fromJson(
              jsonSerialization['jsonField'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  _i37n7uc1.ProjectedJsonFieldSimple? jsonField;

  /// Returns a shallow copy of this [ProjectedUserSimpleJson]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedUserSimpleJson copyWith({
    int? id,
    String? name,
    _i37n7uc1.ProjectedJsonFieldSimple? jsonField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUserSimpleJson',
      if (id != null) 'id': id,
      'name': name,
      if (jsonField != null) 'jsonField': jsonField?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUserSimpleJson',
      if (id != null) 'id': id,
      'name': name,
      if (jsonField != null)
        'jsonField':
            // ignore: unnecessary_type_check
            jsonField is _isc.ProtocolSerialization
            ? (jsonField as _isc.ProtocolSerialization).toJsonForProtocol()
            :
              // ignore: dead_code
              jsonField?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserSimpleJsonImpl extends ProjectedUserSimpleJson {
  _ProjectedUserSimpleJsonImpl({
    int? id,
    required String name,
    _i37n7uc1.ProjectedJsonFieldSimple? jsonField,
  }) : super._(
         id: id,
         name: name,
         jsonField: jsonField,
       );

  /// Returns a shallow copy of this [ProjectedUserSimpleJson]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedUserSimpleJson copyWith({
    Object? id = _Undefined,
    String? name,
    Object? jsonField = _Undefined,
  }) {
    return ProjectedUserSimpleJson(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      jsonField: jsonField is _i37n7uc1.ProjectedJsonFieldSimple?
          ? jsonField
          : this.jsonField?.copyWith(),
    );
  }
}
