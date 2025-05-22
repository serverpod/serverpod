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
import '../protocol.dart' as _i2;

abstract class ClassWithInterface
    implements _i1.SerializableModel, _i2.ExampleInterface {
  ClassWithInterface._({
    required this.interfaceField,
    required this.classField,
  });

  factory ClassWithInterface({
    required String interfaceField,
    required String classField,
  }) = _ClassWithInterfaceImpl;

  factory ClassWithInterface.fromJson(Map<String, dynamic> jsonSerialization) {
    return ClassWithInterface(
      interfaceField: jsonSerialization['interfaceField'] as String,
      classField: jsonSerialization['classField'] as String,
    );
  }

  @override
  String interfaceField;

  String classField;

  /// Returns a shallow copy of this [ClassWithInterface]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ClassWithInterface copyWith({
    String? interfaceField,
    String? classField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'interfaceField': interfaceField,
      'classField': classField,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ClassWithInterfaceImpl extends ClassWithInterface {
  _ClassWithInterfaceImpl({
    required String interfaceField,
    required String classField,
  }) : super._(
          interfaceField: interfaceField,
          classField: classField,
        );

  /// Returns a shallow copy of this [ClassWithInterface]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ClassWithInterface copyWith({
    String? interfaceField,
    String? classField,
  }) {
    return ClassWithInterface(
      interfaceField: interfaceField ?? this.interfaceField,
      classField: classField ?? this.classField,
    );
  }
}
