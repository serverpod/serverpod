import 'dart:developer' as developer;

import 'package:serverpod_shared/serverpod_shared.dart'
    show ServerpodAddresses, serverpodAddressesEvent;

/// Posts the pod's public listener addresses as a [serverpodAddressesEvent].
void postServerpodAddresses({
  required String? api,
  required String? insights,
  required String? web,
}) => developer.postEvent(
  serverpodAddressesEvent,
  ServerpodAddresses(api: api, insights: insights, web: web).toJson(),
);
