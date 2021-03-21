import 'package:serverpod/serverpod.dart';

int globalInt = 0;

class SimpleEndpoint extends Endpoint {
  
  Future<void> setGlobalInt(Session session, int value, [int secondValue]) async {
    globalInt = value;
  }

  Future<void> addToGlobalInt(Session session) async {
    globalInt += 1;
  }

  Future<int> getGlobalInt(Session session) async {
    return globalInt;
  }

  Future<int> _getGlobalInt(Session session) async {

  }
}