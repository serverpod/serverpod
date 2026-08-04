import 'package:serverpod/serverpod.dart';

class SignInRequiredEndpoint extends Endpoint {
  Future<bool> testMethod(Session session) async {
    return true;
  }

  @override
  bool get requireLogin => true;
}

class AdminScopeRequiredEndpoint extends Endpoint {
  @override
  Set<Scope> get requiredScopes => {Scope.admin};

  Future<bool> testMethod(Session session) async {
    return true;
  }
}
