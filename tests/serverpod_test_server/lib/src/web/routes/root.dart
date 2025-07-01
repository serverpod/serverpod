import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../widgets/simple_page.dart';
import '../widgets/text.dart';

class RouteRoot extends ComponentRoute {
  @override
  Future<Component> build(Session session, HttpRequest request) async {
    return SimplePageComponent(
      title: 'My Root Page',
      body: TextComponent(text: 'Hello world'),
    );
  }
}
