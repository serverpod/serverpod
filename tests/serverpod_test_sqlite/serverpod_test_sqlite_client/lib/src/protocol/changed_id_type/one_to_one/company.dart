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
import '../../changed_id_type/one_to_one/town.dart' as _i3qwzvq1;

abstract class CompanyUuid
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CompanyUuid._({
    this.id,
    required this.name,
    required this.townId,
    this.town,
  });

  factory CompanyUuid({
    _isc.UuidValue? id,
    required String name,
    required int townId,
    _i3qwzvq1.TownInt? town,
  }) = _CompanyUuidImpl;

  factory CompanyUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return CompanyUuid(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      townId: jsonSerialization['townId'] as int,
      town: jsonSerialization['town'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_i3qwzvq1.TownInt>(
              jsonSerialization['town'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String name;

  int townId;

  _i3qwzvq1.TownInt? town;

  /// Returns a shallow copy of this [CompanyUuid]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CompanyUuid copyWith({
    _isc.UuidValue? id,
    String? name,
    int? townId,
    _i3qwzvq1.TownInt? town,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CompanyUuid',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'townId': townId,
      if (town != null) 'town': town?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CompanyUuid',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'townId': townId,
      if (town != null) 'town': town?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CompanyUuidImpl extends CompanyUuid {
  _CompanyUuidImpl({
    _isc.UuidValue? id,
    required String name,
    required int townId,
    _i3qwzvq1.TownInt? town,
  }) : super._(
         id: id,
         name: name,
         townId: townId,
         town: town,
       );

  /// Returns a shallow copy of this [CompanyUuid]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CompanyUuid copyWith({
    Object? id = _Undefined,
    String? name,
    int? townId,
    Object? town = _Undefined,
  }) {
    return CompanyUuid(
      id: id is _isc.UuidValue? ? id : this.id,
      name: name ?? this.name,
      townId: townId ?? this.townId,
      town: town is _i3qwzvq1.TownInt? ? town : this.town?.copyWith(),
    );
  }
}
