import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../widgets/simple_page.dart';
import '../widgets/text.dart';

class RouteRoot extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, HttpRequest request) async {
    return SimplePageWidget(
      title: 'My Root Page',
      body: TextWidget(text: 'Hello world'),
    );
  }
}
