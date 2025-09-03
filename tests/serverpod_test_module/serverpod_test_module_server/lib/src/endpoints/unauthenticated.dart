import 'package:serverpod/serverpod.dart';

/// An endpoint class with all methods marked as unauthenticated.
@unauthenticatedClientCall
class UnauthenticatedEndpoint extends Endpoint {
  Future<bool> unauthenticatedMethod(Session session) async {
    return session.isUserSignedIn;
  }

  Stream<bool> unauthenticatedStream(Session session) async* {
    yield await session.isUserSignedIn;
  }
}

/// An endpoint with only one method marked as unauthenticated.
class PartiallyUnauthenticatedEndpoint extends Endpoint {
  @unauthenticatedClientCall
  Future<bool> unauthenticatedMethod(Session session) async {
    return session.isUserSignedIn;
  }

  @unauthenticatedClientCall
  Stream<bool> unauthenticatedStream(Session session) async* {
    yield await session.isUserSignedIn;
  }

  Future<bool> authenticatedMethod(Session session) async {
    return session.isUserSignedIn;
  }

  Stream<bool> authenticatedStream(Session session) async* {
    yield await session.isUserSignedIn;
  }
}
