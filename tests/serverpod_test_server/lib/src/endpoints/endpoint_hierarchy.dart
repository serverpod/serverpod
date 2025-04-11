import 'package:serverpod/serverpod.dart';

// #region Endpoint hierarchy based on plain classes

class LoggedInEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;
}

class MyLoggedInEndpoint extends LoggedInEndpoint {
  Future<String> echo(Session session, String value) async {
    return value;
  }
}

class AdminEndpoint extends LoggedInEndpoint {
  @override
  Set<Scope> get requiredScopes => {Scope.admin};
}

class MyAdminEndpoint extends AdminEndpoint {
  Future<String> echo(Session session, String value) async {
    return value;
  }
}

// #endregion
