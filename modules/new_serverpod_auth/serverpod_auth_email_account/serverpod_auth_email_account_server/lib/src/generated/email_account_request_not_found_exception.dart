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

abstract class EmailAccountRequestNotFoundException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  EmailAccountRequestNotFoundException._();

  factory EmailAccountRequestNotFoundException() =
      _EmailAccountRequestNotFoundExceptionImpl;

  factory EmailAccountRequestNotFoundException.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailAccountRequestNotFoundException();
  }

  /// Returns a shallow copy of this [EmailAccountRequestNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountRequestNotFoundException copyWith();
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

class _EmailAccountRequestNotFoundExceptionImpl
    extends EmailAccountRequestNotFoundException {
  _EmailAccountRequestNotFoundExceptionImpl() : super._();

  /// Returns a shallow copy of this [EmailAccountRequestNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountRequestNotFoundException copyWith() {
    return EmailAccountRequestNotFoundException();
  }
}
