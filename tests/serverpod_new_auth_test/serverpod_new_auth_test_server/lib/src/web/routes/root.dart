import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_new_auth_test_server/src/web/components/built_with_serverpod_page.dart';

class RootRoute extends ComponentRoute {
  @override
  Future<Component> build(
      final Session session, final HttpRequest request) async {
    return BuiltWithServerpodPageComponent();
  }
}
