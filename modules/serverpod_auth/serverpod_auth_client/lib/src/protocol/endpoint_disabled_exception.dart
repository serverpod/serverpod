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

abstract class EndpointDisabledException
    implements _i1.SerializableException, _i1.SerializableModel {
  EndpointDisabledException._();

  factory EndpointDisabledException() = _EndpointDisabledExceptionImpl;

  factory EndpointDisabledException.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EndpointDisabledException();
  }

  /// Returns a shallow copy of this [EndpointDisabledException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EndpointDisabledException copyWith();
  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _EndpointDisabledExceptionImpl extends EndpointDisabledException {
  _EndpointDisabledExceptionImpl() : super._();

  /// Returns a shallow copy of this [EndpointDisabledException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EndpointDisabledException copyWith() {
    return EndpointDisabledException();
  }
}
