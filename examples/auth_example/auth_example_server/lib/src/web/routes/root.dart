import 'dart:io';

import 'package:auth_example_server/src/web/components/default_page_component.dart';
import 'package:serverpod/serverpod.dart';

class RootRoute extends ComponentRoute {
  @override
  Future<Component> build(Session session, HttpRequest request) async {
    return DefaultPageComponent();
  }
}
