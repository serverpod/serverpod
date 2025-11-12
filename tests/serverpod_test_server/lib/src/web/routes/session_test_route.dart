import 'dart:async';
import 'dart:convert';
import 'package:serverpod/serverpod.dart';

class SessionTestRoute extends Route {
  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    var auth = session.authenticated;
    var body = jsonEncode({
      'isAuthenticated': auth != null,
      'userId': auth?.userIdentifier,
      'scopes': auth?.scopes.map((s) => s.name).toList() ?? [],
      'authId': auth?.authId,
    });
    return Response.ok(
      body: Body.fromString(body),
      headers: Headers.build((mh) {
        mh['Content-Type'] = ['application/json'];
      }),
    );
  }
}
