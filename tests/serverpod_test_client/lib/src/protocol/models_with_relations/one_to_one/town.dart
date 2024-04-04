/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Town extends _i1.SerializableEntity {
  Town._({
    this.id,
    required this.name,
    this.mayorId,
    this.mayor,
  });

  factory Town({
    int? id,
    required String name,
    int? mayorId,
    _i2.Citizen? mayor,
  }) = _TownImpl;

  factory Town.fromJson(Map<String, dynamic> jsonSerialization) {
    return Town(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      mayorId: jsonSerialization['mayorId'] as int?,
      mayor: jsonSerialization.containsKey('mayor')
          ? _i2.Citizen.fromJson(
              jsonSerialization['mayor'] as Map<String, dynamic>)
          : null,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int? mayorId;

  _i2.Citizen? mayor;

  Town copyWith({
    int? id,
    String? name,
    int? mayorId,
    _i2.Citizen? mayor,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (mayorId != null) 'mayorId': mayorId,
      if (mayor != null) 'mayor': mayor?.toJson(),
    };
  }
}

class _Undefined {}

class _TownImpl extends Town {
  _TownImpl({
    int? id,
    required String name,
    int? mayorId,
    _i2.Citizen? mayor,
  }) : super._(
          id: id,
          name: name,
          mayorId: mayorId,
          mayor: mayor,
        );

  @override
  Town copyWith({
    Object? id = _Undefined,
    String? name,
    Object? mayorId = _Undefined,
    Object? mayor = _Undefined,
  }) {
    return Town(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      mayorId: mayorId is int? ? mayorId : this.mayorId,
      mayor: mayor is _i2.Citizen? ? mayor : this.mayor?.copyWith(),
    );
  }
}
