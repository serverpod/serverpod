import 'package:projectname_server/src/web/widgets/built_with_serverpod_page.dart';
import 'package:serverpod/serverpod.dart';

class RouteRoot extends WidgetRoute {
  @override
  Future<Widget> build(Session session, Request request) async {
    return BuiltWithServerpodPage();
  }
}
