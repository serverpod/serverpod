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
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

class SharedModel implements _i1.SerializableModel {
  SharedModel({
    _i1.UuidValue? id,
    required this.name,
    this.data,
    DateTime? createdAt,
  }) : id = id ?? const _i1.Uuid().v4obj(),
       createdAt = createdAt ?? DateTime.now();

  factory SharedModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedModel(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      data: jsonSerialization['data'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  _i1.UuidValue id;

  String name;

  int? data;

  DateTime createdAt;

  /// Returns a shallow copy of this [SharedModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SharedModel copyWith({
    _i1.UuidValue? id,
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
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}
