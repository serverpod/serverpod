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

abstract class ModelWithRequiredField implements _i1.SerializableModel {
  ModelWithRequiredField._({
    this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  factory ModelWithRequiredField({
    int? id,
    required String name,
    required String? email,
    String? phone,
  }) = _ModelWithRequiredFieldImpl;

  factory ModelWithRequiredField.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ModelWithRequiredField(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? email;

  String? phone;

  /// Returns a shallow copy of this [ModelWithRequiredField]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ModelWithRequiredField copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ModelWithRequiredFieldImpl extends ModelWithRequiredField {
  _ModelWithRequiredFieldImpl({
    int? id,
    required String name,
    required String? email,
    String? phone,
  }) : super._(id: id, name: name, email: email, phone: phone);

  /// Returns a shallow copy of this [ModelWithRequiredField]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ModelWithRequiredField copyWith({
    Object? id = _Undefined,
    String? name,
    Object? email = _Undefined,
    Object? phone = _Undefined,
  }) {
    return ModelWithRequiredField(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
    );
  }
}
