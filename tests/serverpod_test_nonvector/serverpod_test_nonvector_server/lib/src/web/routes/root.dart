import 'dart:io';

import 'package:serverpod_test_nonvector_server/src/web/widgets/built_with_serverpod_page.dart';
import 'package:serverpod/serverpod.dart';

class RouteRoot extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, HttpRequest request) async {
    return BuiltWithServerpodPage();
  }
}
