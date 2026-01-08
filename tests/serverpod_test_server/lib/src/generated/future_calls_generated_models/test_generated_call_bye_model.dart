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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class TestGeneratedCallByeModel
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  TestGeneratedCallByeModel._({
    required this.name,
    required this.code,
  });

  factory TestGeneratedCallByeModel({
    required String name,
    required int code,
  }) = _TestGeneratedCallByeModelImpl;

  factory TestGeneratedCallByeModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TestGeneratedCallByeModel(
      name: jsonSerialization['name'] as String,
      code: jsonSerialization['code'] as int,
    );
  }

  String name;

  int code;

  /// Returns a shallow copy of this [TestGeneratedCallByeModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TestGeneratedCallByeModel copyWith({
    String? name,
    int? code,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TestGeneratedCallByeModel',
      'name': name,
      'code': code,
    };
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

class _TestGeneratedCallByeModelImpl extends TestGeneratedCallByeModel {
  _TestGeneratedCallByeModelImpl({
    required String name,
    required int code,
  }) : super._(
         name: name,
         code: code,
       );

  /// Returns a shallow copy of this [TestGeneratedCallByeModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TestGeneratedCallByeModel copyWith({
    String? name,
    int? code,
  }) {
    return TestGeneratedCallByeModel(
      name: name ?? this.name,
      code: code ?? this.code,
    );
  }
}
