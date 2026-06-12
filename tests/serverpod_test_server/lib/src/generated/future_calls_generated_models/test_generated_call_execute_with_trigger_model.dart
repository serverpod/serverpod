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
import 'package:serverpod_test_server/src/generated/my_trigger_type.dart'
    as _i2;

abstract class TestGeneratedCallExecuteWithTriggerModel
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  TestGeneratedCallExecuteWithTriggerModel._({
    required this.entityId,
    required this.triggerType,
  });

  factory TestGeneratedCallExecuteWithTriggerModel({
    required String entityId,
    required _i2.MyTriggerType triggerType,
  }) = _TestGeneratedCallExecuteWithTriggerModelImpl;

  factory TestGeneratedCallExecuteWithTriggerModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TestGeneratedCallExecuteWithTriggerModel(
      entityId: jsonSerialization['entityId'] as String,
      triggerType: _i2.MyTriggerType.fromJson(
        (jsonSerialization['triggerType'] as String),
      ),
    );
  }

  String entityId;

  _i2.MyTriggerType triggerType;

  /// Returns a shallow copy of this [TestGeneratedCallExecuteWithTriggerModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TestGeneratedCallExecuteWithTriggerModel copyWith({
    String? entityId,
    _i2.MyTriggerType? triggerType,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TestGeneratedCallExecuteWithTriggerModel',
      'entityId': entityId,
      'triggerType': triggerType.toJson(),
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

class _TestGeneratedCallExecuteWithTriggerModelImpl
    extends TestGeneratedCallExecuteWithTriggerModel {
  _TestGeneratedCallExecuteWithTriggerModelImpl({
    required String entityId,
    required _i2.MyTriggerType triggerType,
  }) : super._(
         entityId: entityId,
         triggerType: triggerType,
       );

  /// Returns a shallow copy of this [TestGeneratedCallExecuteWithTriggerModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TestGeneratedCallExecuteWithTriggerModel copyWith({
    String? entityId,
    _i2.MyTriggerType? triggerType,
  }) {
    return TestGeneratedCallExecuteWithTriggerModel(
      entityId: entityId ?? this.entityId,
      triggerType: triggerType ?? this.triggerType,
    );
  }
}
