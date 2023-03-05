import 'dart:async';

import 'package:serverpod/serverpod.dart';

class SubDirTestEndpoint extends Endpoint {
  Future<String> testMethod(Session session) async {
    return 'subDir';
  }
}
