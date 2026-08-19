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
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;

class SharedModel
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
  SharedModel({
    _iss.UuidValue? id,
    required this.name,
    this.data,
    DateTime? createdAt,
  }) : id = id ?? const _iss.Uuid().v4obj(),
       createdAt = createdAt ?? DateTime.now();

  factory SharedModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedModel(
      id: jsonSerialization['id'] == null
          ? null
          : _iss.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      data: jsonSerialization['data'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _iss.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  _iss.UuidValue id;

  String name;

  int? data;

  DateTime createdAt;

  /// Returns a shallow copy of this [SharedModel]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  SharedModel copyWith({
    _iss.UuidValue? id,
    String? name,
    Object? data = _Undefined,
    DateTime? createdAt,
  }) {
    return SharedModel(
      id: id ?? this.id,
      name: name ?? this.name,
      data: data is int? ? data : this.data,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedModel',
      'id': id.toJson(),
      'name': name,
      if (data != null) 'data': data,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SharedModel',
      'id': id.toJson(),
      'name': name,
      if (data != null) 'data': data,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
  }
}

class _Undefined {}
