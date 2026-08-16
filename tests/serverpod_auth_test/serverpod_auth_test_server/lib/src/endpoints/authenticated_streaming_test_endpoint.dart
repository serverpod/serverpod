import 'package:serverpod/serverpod.dart';

class AuthenticatedStreamingTestEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Stream<int> openAuthenticatedStream(final Session session) async* {
    int counter = 0;
    while (true) {
      yield ++counter;
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }
}
