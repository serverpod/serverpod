import 'package:serverpod/serverpod.dart';

/// Shares its name with future calls in the host and another module.
class TestGeneratedCall extends FutureCall {
  static final receivedNames = <String>[];

  Future<void> hello(Session session, String name) async {
    receivedNames.add(name);
  }
}
