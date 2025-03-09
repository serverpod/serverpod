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

abstract class ClassOverridingInterfaceField
    implements
        _i1.SerializableModel,
        _i1.ProtocolSerialization,
        _i2.ExampleInterface {
  ClassOverridingInterfaceField._({
    required this.classField,
    String? interfaceField,
  }) : interfaceField = interfaceField ?? 'This is a default value';

  factory ClassOverridingInterfaceField({
    required String classField,
    String? interfaceField,
  }) = _ClassOverridingInterfaceFieldImpl;

  factory ClassOverridingInterfaceField.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ClassOverridingInterfaceField(
      classField: jsonSerialization['classField'] as String,
      interfaceField: jsonSerialization['interfaceField'] as String,
    );
  }

  String classField;

  @override
  String interfaceField;

  /// Returns a shallow copy of this [ClassOverridingInterfaceField]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ClassOverridingInterfaceField copyWith({
    String? classField,
    String? interfaceField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'classField': classField,
      'interfaceField': interfaceField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'classField': classField,
      'interfaceField': interfaceField,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ClassOverridingInterfaceFieldImpl extends ClassOverridingInterfaceField {
  _ClassOverridingInterfaceFieldImpl({
    required String classField,
    String? interfaceField,
  }) : super._(
          classField: classField,
          interfaceField: interfaceField,
        );

  /// Returns a shallow copy of this [ClassOverridingInterfaceField]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ClassOverridingInterfaceField copyWith({
    String? classField,
    String? interfaceField,
  }) {
    return ClassOverridingInterfaceField(
      classField: classField ?? this.classField,
      interfaceField: interfaceField ?? this.interfaceField,
    );
  }
}
