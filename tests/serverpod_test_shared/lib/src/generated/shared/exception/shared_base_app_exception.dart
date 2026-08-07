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

class SharedBaseAppException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  SharedBaseAppException({required this.message});

  factory SharedBaseAppException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SharedBaseAppException(
      message: jsonSerialization['message'] as String,
    );
  }

  String message;

  /// Returns a shallow copy of this [SharedBaseAppException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SharedBaseAppException copyWith({String? message}) {
    return SharedBaseAppException(message: message ?? this.message);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedBaseAppException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SharedBaseAppException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'SharedBaseAppException(message: $message)';
  }
}
