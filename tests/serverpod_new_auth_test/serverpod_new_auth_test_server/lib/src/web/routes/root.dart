import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_new_auth_test_server/src/web/widgets/built_with_serverpod_page.dart';

class RouteRoot extends WidgetRoute {
  @override
  Future<Widget> build(final Session session, final HttpRequest request) async {
    return BuiltWithServerpodPage();
  }
}
