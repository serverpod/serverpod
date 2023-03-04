import 'dart:async';

import 'package:serverpod/serverpod.dart';

class SubSubDirTestEndpoint extends Endpoint {
  Future<String> testMethod(Session session) async {
    return 'subSubDir';
  }
}
