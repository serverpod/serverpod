/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class RefreshTokenNotFoundException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  RefreshTokenNotFoundException._();

  factory RefreshTokenNotFoundException() = _RefreshTokenNotFoundExceptionImpl;

  factory RefreshTokenNotFoundException.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return RefreshTokenNotFoundException();
  }

  /// Returns a shallow copy of this [RefreshTokenNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RefreshTokenNotFoundException copyWith();
  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RefreshTokenNotFoundExceptionImpl extends RefreshTokenNotFoundException {
  _RefreshTokenNotFoundExceptionImpl() : super._();

  /// Returns a shallow copy of this [RefreshTokenNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RefreshTokenNotFoundException copyWith() {
    return RefreshTokenNotFoundException();
  }
}
