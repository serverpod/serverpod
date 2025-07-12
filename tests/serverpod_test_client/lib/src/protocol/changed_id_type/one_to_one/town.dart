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
import '../../changed_id_type/one_to_one/citizen.dart' as _i2;

abstract class TownInt implements _i1.SerializableModel {
  TownInt._({
    this.id,
    required this.name,
    this.mayorId,
    this.mayor,
  });

  factory TownInt({
    int? id,
    required String name,
    int? mayorId,
    _i2.CitizenInt? mayor,
  }) = _TownIntImpl;

  factory TownInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return TownInt(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      mayorId: jsonSerialization['mayorId'] as int?,
      mayor: jsonSerialization['mayor'] == null
          ? null
          : _i2.CitizenInt.fromJson(
              (jsonSerialization['mayor'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int? mayorId;

  _i2.CitizenInt? mayor;

  /// Returns a shallow copy of this [TownInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TownInt copyWith({
    int? id,
    String? name,
    int? mayorId,
    _i2.CitizenInt? mayor,
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

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TownIntImpl extends TownInt {
  _TownIntImpl({
    int? id,
    required String name,
    int? mayorId,
    _i2.CitizenInt? mayor,
  }) : super._(
          id: id,
          name: name,
          mayorId: mayorId,
          mayor: mayor,
        );

  /// Returns a shallow copy of this [TownInt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TownInt copyWith({
    Object? id = _Undefined,
    String? name,
    Object? mayorId = _Undefined,
    Object? mayor = _Undefined,
  }) {
    return TownInt(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      mayorId: mayorId is int? ? mayorId : this.mayorId,
      mayor: mayor is _i2.CitizenInt? ? mayor : this.mayor?.copyWith(),
    );
  }
}
