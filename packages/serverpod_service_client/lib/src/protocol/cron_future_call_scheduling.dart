/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of 'future_call_scheduling.dart';

abstract class CronFutureCallScheduling extends _i1.FutureCallScheduling
    implements _i2.SerializableModel {
  CronFutureCallScheduling._({required this.cron});

  factory CronFutureCallScheduling({required String cron}) =
      _CronFutureCallSchedulingImpl;

  factory CronFutureCallScheduling.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CronFutureCallScheduling(cron: jsonSerialization['cron'] as String);
  }

  /// Cron expression for recurring calls
  String cron;

  /// Returns a shallow copy of this [CronFutureCallScheduling]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  CronFutureCallScheduling copyWith({String? cron});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.CronFutureCallScheduling',
      'cron': cron,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _CronFutureCallSchedulingImpl extends CronFutureCallScheduling {
  _CronFutureCallSchedulingImpl({required String cron}) : super._(cron: cron);

  /// Returns a shallow copy of this [CronFutureCallScheduling]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  CronFutureCallScheduling copyWith({String? cron}) {
    return CronFutureCallScheduling(cron: cron ?? this.cron);
  }
}
