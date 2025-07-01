import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../components/simple_page.dart';
import '../components/text.dart';

class RootRoute extends ComponentRoute {
  @override
  Future<Component> build(Session session, HttpRequest request) async {
    return SimplePageComponent(
      title: 'My Root Page',
      body: TextComponent(text: 'Hello world'),
    );
  }
}
