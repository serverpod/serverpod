import 'dart:developer' as developer;

import 'package:serverpod_shared/serverpod_shared.dart'
    show ServerpodAddresses, serverpodAddressesEvent;

/// Posts the addresses the pod's listeners actually resolved to.
///
/// The event name and payload shape are [serverpodAddressesEvent] and
/// [ServerpodAddresses], which live in `serverpod_shared` because the CLI
/// decodes them.
///
/// In production, where the VM service is disabled, [developer.postEvent] is a
/// no-op.
void postServerpodAddresses({
  required String? api,
  required String? insights,
  required String? web,
}) => developer.postEvent(
  serverpodAddressesEvent,
  ServerpodAddresses(api: api, insights: insights, web: web).toJson(),
);
