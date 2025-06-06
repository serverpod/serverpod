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

abstract class EmailAccountRequestNotVerifiedException
    implements _i1.SerializableException, _i1.SerializableModel {
  EmailAccountRequestNotVerifiedException._();

  factory EmailAccountRequestNotVerifiedException() =
      _EmailAccountRequestNotVerifiedExceptionImpl;

  factory EmailAccountRequestNotVerifiedException.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailAccountRequestNotVerifiedException();
  }

  /// Returns a shallow copy of this [EmailAccountRequestNotVerifiedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountRequestNotVerifiedException copyWith();
  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _EmailAccountRequestNotVerifiedExceptionImpl
    extends EmailAccountRequestNotVerifiedException {
  _EmailAccountRequestNotVerifiedExceptionImpl() : super._();

  /// Returns a shallow copy of this [EmailAccountRequestNotVerifiedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountRequestNotVerifiedException copyWith() {
    return EmailAccountRequestNotVerifiedException();
  }
}
