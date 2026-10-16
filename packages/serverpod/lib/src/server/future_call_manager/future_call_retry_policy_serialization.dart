import 'dart:async';

import 'package:serverpod_serialization/serverpod_serialization.dart';

/// The zone key under which [runWithRetryPolicySerialization] stores the
/// serialization manager.
final _serializationManagerKey = Object();

/// Runs [body] with [serializationManager] available to retry policies that
/// save and load other retry policies, such as a `ChainedRetryPolicies`.
///
/// A policy's `fromJson` constructor has no access to the project's protocol,
/// which is needed to load policies of classes declared in the project. The
/// future call manager runs every save and load of a retry policy through this
/// function.
T runWithRetryPolicySerialization<T>(
  SerializationManager serializationManager,
  T Function() body,
) {
  return runZoned(
    body,
    zoneValues: {_serializationManagerKey: serializationManager},
  );
}

/// Returns the serialization manager set by [runWithRetryPolicySerialization].
///
/// Throws a [StateError] when called outside of it.
SerializationManager currentRetryPolicySerializationManager() {
  var serializationManager = Zone.current[_serializationManagerKey];
  if (serializationManager is! SerializationManager) {
    throw StateError(
      'Retry policies that contain other retry policies can only be saved and '
      'loaded by the future call manager.',
    );
  }
  return serializationManager;
}
