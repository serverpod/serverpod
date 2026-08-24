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
import '../../changed_id_type/one_to_one/citizen.dart' as _i7hzilwf;

abstract class AddressUuid
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AddressUuid._({
    _isc.UuidValue? id,
    required this.street,
    this.inhabitantId,
    this.inhabitant,
  }) : id = id ?? const _isc.Uuid().v4obj();

  factory AddressUuid({
    _isc.UuidValue? id,
    required String street,
    int? inhabitantId,
    _i7hzilwf.CitizenInt? inhabitant,
  }) = _AddressUuidImpl;

  factory AddressUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return AddressUuid(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      street: jsonSerialization['street'] as String,
      inhabitantId: jsonSerialization['inhabitantId'] as int?,
      inhabitant: jsonSerialization['inhabitant'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_i7hzilwf.CitizenInt>(
              jsonSerialization['inhabitant'],
            ),
    );
  }

  /// The id of the object.
  _isc.UuidValue id;

  String street;

  int? inhabitantId;

  _i7hzilwf.CitizenInt? inhabitant;

  /// Returns a shallow copy of this [AddressUuid]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AddressUuid copyWith({
    _isc.UuidValue? id,
    String? street,
    int? inhabitantId,
    _i7hzilwf.CitizenInt? inhabitant,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AddressUuid',
      'id': id.toJson(),
      'street': street,
      if (inhabitantId != null) 'inhabitantId': inhabitantId,
      if (inhabitant != null) 'inhabitant': inhabitant?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AddressUuid',
      'id': id.toJson(),
      'street': street,
      if (inhabitantId != null) 'inhabitantId': inhabitantId,
      if (inhabitant != null) 'inhabitant': inhabitant?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AddressUuidImpl extends AddressUuid {
  _AddressUuidImpl({
    _isc.UuidValue? id,
    required String street,
    int? inhabitantId,
    _i7hzilwf.CitizenInt? inhabitant,
  }) : super._(
         id: id,
         street: street,
         inhabitantId: inhabitantId,
         inhabitant: inhabitant,
       );

  /// Returns a shallow copy of this [AddressUuid]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AddressUuid copyWith({
    _isc.UuidValue? id,
    String? street,
    Object? inhabitantId = _Undefined,
    Object? inhabitant = _Undefined,
  }) {
    return AddressUuid(
      id: id ?? this.id,
      street: street ?? this.street,
      inhabitantId: inhabitantId is int? ? inhabitantId : this.inhabitantId,
      inhabitant: inhabitant is _i7hzilwf.CitizenInt?
          ? inhabitant
          : this.inhabitant?.copyWith(),
    );
  }
}
