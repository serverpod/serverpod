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
import '../protocol.dart' as _i2;

abstract class ExceptionWithInterface
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i2.ExampleInterface,
        _i1.ProtocolSerialization {
  ExceptionWithInterface._({
    required this.interfaceField,
    required this.exceptionField,
  });

  factory ExceptionWithInterface({
    required String interfaceField,
    required String exceptionField,
  }) = _ExceptionWithInterfaceImpl;

  factory ExceptionWithInterface.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ExceptionWithInterface(
      interfaceField: jsonSerialization['interfaceField'] as String,
      exceptionField: jsonSerialization['exceptionField'] as String,
    );
  }

  @override
  String interfaceField;

  String exceptionField;

  /// Returns a shallow copy of this [ExceptionWithInterface]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ExceptionWithInterface copyWith({
    String? interfaceField,
    String? exceptionField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'interfaceField': interfaceField,
      'exceptionField': exceptionField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'interfaceField': interfaceField,
      'exceptionField': exceptionField,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ExceptionWithInterfaceImpl extends ExceptionWithInterface {
  _ExceptionWithInterfaceImpl({
    required String interfaceField,
    required String exceptionField,
  }) : super._(
          interfaceField: interfaceField,
          exceptionField: exceptionField,
        );

  /// Returns a shallow copy of this [ExceptionWithInterface]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ExceptionWithInterface copyWith({
    String? interfaceField,
    String? exceptionField,
  }) {
    return ExceptionWithInterface(
      interfaceField: interfaceField ?? this.interfaceField,
      exceptionField: exceptionField ?? this.exceptionField,
    );
  }
}
