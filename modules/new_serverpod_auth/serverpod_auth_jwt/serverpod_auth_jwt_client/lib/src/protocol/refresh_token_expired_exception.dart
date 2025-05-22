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

abstract class RefreshTokenExpiredException
    implements _i1.SerializableException, _i1.SerializableModel {
  RefreshTokenExpiredException._();

  factory RefreshTokenExpiredException() = _RefreshTokenExpiredExceptionImpl;

  factory RefreshTokenExpiredException.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return RefreshTokenExpiredException();
  }

  /// Returns a shallow copy of this [RefreshTokenExpiredException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RefreshTokenExpiredException copyWith();
  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RefreshTokenExpiredExceptionImpl extends RefreshTokenExpiredException {
  _RefreshTokenExpiredExceptionImpl() : super._();

  /// Returns a shallow copy of this [RefreshTokenExpiredException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RefreshTokenExpiredException copyWith() {
    return RefreshTokenExpiredException();
  }
}
