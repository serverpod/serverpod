import 'dart:io';

import 'package:chat_server/src/web/widgets/default_page_widget.dart';
import 'package:serverpod/serverpod.dart';

class RouteRoot extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, HttpRequest request) async {
    return DefaultPageWidget();
  }
}
