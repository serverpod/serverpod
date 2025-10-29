import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/src/providers/apple/business/apple_idp_utils.dart';

/// {@macro apple_idp.revokedNotificationRoute}
class AppleRevokedNotificationRoute extends Route {
  final AppleIDPUtils _utils;

  /// Creates a new route to handle Apple IDP revoked notifications.
  AppleRevokedNotificationRoute({required final AppleIDPUtils utils})
      : _utils = utils,
        super(methods: {Method.post});

  @override
  FutureOr<HandledContext> handleCall(
    final Session _,
    final RequestContext context,
  ) {
    return _utils.revokedNotificationHandler()(context);
  }
}
