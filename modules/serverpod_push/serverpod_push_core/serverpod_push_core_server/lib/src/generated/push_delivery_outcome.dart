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

/// Outcome of a single provider send for one target.
enum PushDeliveryOutcome implements _is.SerializableModel {
  accepted,
  retryable,
  rateLimited,
  invalidToken,
  permanentFailure,

  /// Returned when a request's `expiresAt` has already passed at send time.
  /// Terminal, but must not be reported as `permanentFailure`.
  expired;

  static PushDeliveryOutcome fromJson(String name) {
    switch (name) {
      case 'accepted':
        return PushDeliveryOutcome.accepted;
      case 'retryable':
        return PushDeliveryOutcome.retryable;
      case 'rateLimited':
        return PushDeliveryOutcome.rateLimited;
      case 'invalidToken':
        return PushDeliveryOutcome.invalidToken;
      case 'permanentFailure':
        return PushDeliveryOutcome.permanentFailure;
      case 'expired':
        return PushDeliveryOutcome.expired;
      default:
        return PushDeliveryOutcome.retryable;
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
