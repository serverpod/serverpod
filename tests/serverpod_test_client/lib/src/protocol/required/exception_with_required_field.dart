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

abstract class ExceptionWithRequiredField
    implements _i1.SerializableException, _i1.SerializableModel {
  ExceptionWithRequiredField._({
    required this.name,
    required this.email,
    this.phone,
  });

  factory ExceptionWithRequiredField({
    required String name,
    required String? email,
    String? phone,
  }) = _ExceptionWithRequiredFieldImpl;

  factory ExceptionWithRequiredField.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ExceptionWithRequiredField(
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
    );
  }

  String name;

  String? email;

  String? phone;

  /// Returns a shallow copy of this [ExceptionWithRequiredField]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ExceptionWithRequiredField copyWith({
    String? name,
    String? email,
    String? phone,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
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

class _ExceptionWithRequiredFieldImpl extends ExceptionWithRequiredField {
  _ExceptionWithRequiredFieldImpl({
    required String name,
    required String? email,
    String? phone,
  }) : super._(name: name, email: email, phone: phone);

  /// Returns a shallow copy of this [ExceptionWithRequiredField]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ExceptionWithRequiredField copyWith({
    String? name,
    Object? email = _Undefined,
    Object? phone = _Undefined,
  }) {
    return ExceptionWithRequiredField(
      name: name ?? this.name,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
    );
  }
}
