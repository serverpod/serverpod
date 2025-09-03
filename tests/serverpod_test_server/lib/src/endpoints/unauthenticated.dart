import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as m;

class UnauthenticatedEndpoint extends m.UnauthenticatedEndpoint {}

class PartiallyUnauthenticatedEndpoint
    extends m.PartiallyUnauthenticatedEndpoint {}

class UnauthenticatedRequireLoginEndpoint extends m.UnauthenticatedEndpoint {
  @override
  bool get requireLogin => true;
}

class RequireLoginEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @unauthenticated
  Future<bool> unauthenticatedMethod(Session session) async {
    return session.isUserSignedIn;
  }

  @unauthenticated
  Stream<bool> unauthenticatedStream(Session session) async* {
    yield await session.isUserSignedIn;
  }
}
