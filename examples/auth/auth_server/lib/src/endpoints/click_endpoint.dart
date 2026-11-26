import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// Endpoint for recording and counting [Click]s for the authenticated user.
class ClickEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Records a new [Click] for the signed-in user and returns it.
  Future<Click> create(Session session) async {
    final authUserId = session.authenticated!.authUserId;
    return Click.db.insertRow(
      session,
      Click(authUserId: authUserId),
    );
  }

  /// Returns the total number of [Click]s recorded for the signed-in user.
  Future<int> getCount(Session session) async {
    final authUserId = session.authenticated!.authUserId;
    return Click.db.count(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
  }
}
