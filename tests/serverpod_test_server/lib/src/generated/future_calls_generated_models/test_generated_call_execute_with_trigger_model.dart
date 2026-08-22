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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_server/src/generated/my_trigger_type.dart'
    as _icum80ls;

abstract class TestGeneratedCallExecuteWithTriggerModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TestGeneratedCallExecuteWithTriggerModel._({
    required this.entityId,
    required this.triggerType,
  });

  factory TestGeneratedCallExecuteWithTriggerModel({
    required String entityId,
    required _icum80ls.MyTriggerType triggerType,
  }) = _TestGeneratedCallExecuteWithTriggerModelImpl;

  factory TestGeneratedCallExecuteWithTriggerModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TestGeneratedCallExecuteWithTriggerModel(
      entityId: jsonSerialization['entityId'] as String,
      triggerType: _icum80ls.MyTriggerType.fromJson(
        (jsonSerialization['triggerType'] as String),
      ),
    );
  }

  String entityId;

  _icum80ls.MyTriggerType triggerType;

  /// Returns a shallow copy of this [TestGeneratedCallExecuteWithTriggerModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TestGeneratedCallExecuteWithTriggerModel copyWith({
    String? entityId,
    _icum80ls.MyTriggerType? triggerType,
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
    return _is.SerializationManager.encode(this);
  }
}

class _TestGeneratedCallExecuteWithTriggerModelImpl
    extends TestGeneratedCallExecuteWithTriggerModel {
  _TestGeneratedCallExecuteWithTriggerModelImpl({
    required String entityId,
    required _icum80ls.MyTriggerType triggerType,
  }) : super._(
         entityId: entityId,
         triggerType: triggerType,
       );

  /// Returns a shallow copy of this [TestGeneratedCallExecuteWithTriggerModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TestGeneratedCallExecuteWithTriggerModel copyWith({
    String? entityId,
    _icum80ls.MyTriggerType? triggerType,
  }) {
    return TestGeneratedCallExecuteWithTriggerModel(
      entityId: entityId ?? this.entityId,
      triggerType: triggerType ?? this.triggerType,
    );
  }
}
