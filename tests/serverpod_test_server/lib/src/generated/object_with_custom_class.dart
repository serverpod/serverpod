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
import 'package:serverpod_test_server/src/custom_classes.dart' as _i2;

abstract class ObjectWithCustomClass
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ObjectWithCustomClass._({required this.customClassField});

  factory ObjectWithCustomClass({required _i2.CustomClass3 customClassField}) =
      _ObjectWithCustomClassImpl;

  factory ObjectWithCustomClass.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ObjectWithCustomClass(
        customClassField:
            _i2.CustomClass3.fromJson(jsonSerialization['customClassField']));
  }

  _i2.CustomClass3 customClassField;

  ObjectWithCustomClass copyWith({_i2.CustomClass3? customClassField});
  @override
  Map<String, dynamic> toJson() {
    return {'customClassField': customClassField.toJson()};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {'customClassField': customClassField.toJsonForProtocol()};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ObjectWithCustomClassImpl extends ObjectWithCustomClass {
  _ObjectWithCustomClassImpl({required _i2.CustomClass3 customClassField})
      : super._(customClassField: customClassField);

  @override
  ObjectWithCustomClass copyWith({_i2.CustomClass3? customClassField}) {
    return ObjectWithCustomClass(
        customClassField: customClassField ?? this.customClassField.copyWith());
  }
}
