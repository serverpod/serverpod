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

abstract class IntervalFutureCallScheduling extends _i1.FutureCallScheduling
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  IntervalFutureCallScheduling._({
    required this.interval,
    this.start,
  });

  factory IntervalFutureCallScheduling({
    required Duration interval,
    DateTime? start,
  }) = _IntervalFutureCallSchedulingImpl;

  factory IntervalFutureCallScheduling.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return IntervalFutureCallScheduling(
      interval: _i2.DurationJsonExtension.fromJson(
        jsonSerialization['interval'],
      ),
      start: jsonSerialization['start'] == null
          ? null
          : _i2.DateTimeJsonExtension.fromJson(jsonSerialization['start']),
    );
  }

  /// Interval for recurring calls
  Duration interval;

  /// Optional start time for the first execution
  DateTime? start;

  /// Returns a shallow copy of this [IntervalFutureCallScheduling]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  IntervalFutureCallScheduling copyWith({
    Duration? interval,
    DateTime? start,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.IntervalFutureCallScheduling',
      'interval': interval.toJson(),
      if (start != null) 'start': start?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.IntervalFutureCallScheduling',
      'interval': interval.toJson(),
      if (start != null) 'start': start?.toJson(),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _IntervalFutureCallSchedulingImpl extends IntervalFutureCallScheduling {
  _IntervalFutureCallSchedulingImpl({
    required Duration interval,
    DateTime? start,
  }) : super._(
         interval: interval,
         start: start,
       );

  /// Returns a shallow copy of this [IntervalFutureCallScheduling]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  IntervalFutureCallScheduling copyWith({
    Duration? interval,
    Object? start = _Undefined,
  }) {
    return IntervalFutureCallScheduling(
      interval: interval ?? this.interval,
      start: start is DateTime? ? start : this.start,
    );
  }
}
