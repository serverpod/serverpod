import 'package:chat_server/src/web/components/default_page_component.dart';
import 'package:serverpod/serverpod.dart';

class RootRoute extends ComponentRoute {
  @override
  Future<Component> build(Session session, Request request) async {
    return DefaultPageComponent();
  }
}
