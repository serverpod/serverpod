import 'dart:io';

import 'package:projectname_server/src/web/components/built_with_serverpod_page.dart';
import 'package:serverpod/serverpod.dart';

class RootRoute extends ComponentRoute {
  @override
  Future<Component> build(Session session, HttpRequest request) async {
    return BuiltWithServerpodPageComponent();
  }
}
