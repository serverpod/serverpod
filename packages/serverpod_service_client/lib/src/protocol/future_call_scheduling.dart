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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;
part 'cron_future_call_scheduling.dart';
part 'interval_future_call_scheduling.dart';

/// Generic interface that specifies how recurring calls should be scheduled.
sealed class FutureCallScheduling
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FutureCallScheduling();

  /// Returns a shallow copy of this [FutureCallScheduling]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FutureCallScheduling copyWith();
}

class _Undefined {}
