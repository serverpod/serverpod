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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _ilwf0zl1;

abstract class SharedModelSubclass extends _ilwf0zl1.SharedModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SharedModelSubclass._({
    super.id,
    required super.name,
    super.data,
    super.createdAt,
    required this.sharedModelSubclassField,
    required this.sharedEnumField,
    this.serverOnlyField,
  });

  factory SharedModelSubclass({
    _is.UuidValue? id,
    required String name,
    int? data,
    DateTime? createdAt,
    required String sharedModelSubclassField,
    required _ilwf0zl1.SharedEnum sharedEnumField,
    String? serverOnlyField,
  }) = _SharedModelSubclassImpl;

  factory SharedModelSubclass.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedModelSubclass(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      data: jsonSerialization['data'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      sharedModelSubclassField:
          jsonSerialization['sharedModelSubclassField'] as String,
      sharedEnumField: _ilwf0zl1.SharedEnum.fromJson(
        (jsonSerialization['sharedEnumField'] as String),
      ),
      serverOnlyField: jsonSerialization['serverOnlyField'] as String?,
    );
  }

  String sharedModelSubclassField;

  _ilwf0zl1.SharedEnum sharedEnumField;

  String? serverOnlyField;

  /// Returns a shallow copy of this [SharedModelSubclass]
  /// with some or all fields replaced by the given arguments.
  @override
  @_is.useResult
  SharedModelSubclass copyWith({
    _is.UuidValue? id,
    String? name,
    Object? data,
    DateTime? createdAt,
    String? sharedModelSubclassField,
    _ilwf0zl1.SharedEnum? sharedEnumField,
    String? serverOnlyField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedModelSubclass',
      'id': id.toJson(),
      'name': name,
      if (data != null) 'data': data,
      'createdAt': createdAt.toJson(),
      'sharedModelSubclassField': sharedModelSubclassField,
      'sharedEnumField': sharedEnumField.toJson(),
      if (serverOnlyField != null) 'serverOnlyField': serverOnlyField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SharedModelSubclass',
      'id': id.toJson(),
      'name': name,
      if (data != null) 'data': data,
      'createdAt': createdAt.toJson(),
      'sharedModelSubclassField': sharedModelSubclassField,
      'sharedEnumField': sharedEnumField.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedModelSubclassImpl extends SharedModelSubclass {
  _SharedModelSubclassImpl({
    _is.UuidValue? id,
    required String name,
    int? data,
    DateTime? createdAt,
    required String sharedModelSubclassField,
    required _ilwf0zl1.SharedEnum sharedEnumField,
    String? serverOnlyField,
  }) : super._(
         id: id,
         name: name,
         data: data,
         createdAt: createdAt,
         sharedModelSubclassField: sharedModelSubclassField,
         sharedEnumField: sharedEnumField,
         serverOnlyField: serverOnlyField,
       );

  /// Returns a shallow copy of this [SharedModelSubclass]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SharedModelSubclass copyWith({
    _is.UuidValue? id,
    String? name,
    Object? data = _Undefined,
    DateTime? createdAt,
    String? sharedModelSubclassField,
    _ilwf0zl1.SharedEnum? sharedEnumField,
    Object? serverOnlyField = _Undefined,
  }) {
    return SharedModelSubclass(
      id: id ?? this.id,
      name: name ?? this.name,
      data: data is int? ? data : this.data,
      createdAt: createdAt ?? this.createdAt,
      sharedModelSubclassField:
          sharedModelSubclassField ?? this.sharedModelSubclassField,
      sharedEnumField: sharedEnumField ?? this.sharedEnumField,
      serverOnlyField: serverOnlyField is String?
          ? serverOnlyField
          : this.serverOnlyField,
    );
  }
}
