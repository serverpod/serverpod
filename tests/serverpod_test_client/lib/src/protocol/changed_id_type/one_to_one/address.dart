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
import '../../changed_id_type/one_to_one/citizen.dart' as _i2;

abstract class AddressUuid implements _i1.SerializableModel {
  AddressUuid._({
    _i1.UuidValue? id,
    required this.street,
    this.inhabitantId,
    this.inhabitant,
  }) : id = id ?? _i1.Uuid().v4obj();

  factory AddressUuid({
    _i1.UuidValue? id,
    required String street,
    int? inhabitantId,
    _i2.CitizenInt? inhabitant,
  }) = _AddressUuidImpl;

  factory AddressUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return AddressUuid(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      street: jsonSerialization['street'] as String,
      inhabitantId: jsonSerialization['inhabitantId'] as int?,
      inhabitant: jsonSerialization['inhabitant'] == null
          ? null
          : _i2.CitizenInt.fromJson(
              (jsonSerialization['inhabitant'] as Map<String, dynamic>)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue id;

  String street;

  int? inhabitantId;

  _i2.CitizenInt? inhabitant;

  /// Returns a shallow copy of this [AddressUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AddressUuid copyWith({
    _i1.UuidValue? id,
    String? street,
    int? inhabitantId,
    _i2.CitizenInt? inhabitant,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id.toJson(),
      'street': street,
      if (inhabitantId != null) 'inhabitantId': inhabitantId,
      if (inhabitant != null) 'inhabitant': inhabitant?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AddressUuidImpl extends AddressUuid {
  _AddressUuidImpl({
    _i1.UuidValue? id,
    required String street,
    int? inhabitantId,
    _i2.CitizenInt? inhabitant,
  }) : super._(
          id: id,
          street: street,
          inhabitantId: inhabitantId,
          inhabitant: inhabitant,
        );

  /// Returns a shallow copy of this [AddressUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AddressUuid copyWith({
    _i1.UuidValue? id,
    String? street,
    Object? inhabitantId = _Undefined,
    Object? inhabitant = _Undefined,
  }) {
    return AddressUuid(
      id: id ?? this.id,
      street: street ?? this.street,
      inhabitantId: inhabitantId is int? ? inhabitantId : this.inhabitantId,
      inhabitant: inhabitant is _i2.CitizenInt?
          ? inhabitant
          : this.inhabitant?.copyWith(),
    );
  }
}
