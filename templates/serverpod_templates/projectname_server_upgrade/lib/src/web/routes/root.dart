import 'package:projectname_server/src/web/widgets/default_page_widget.dart';
import 'package:serverpod/serverpod.dart';

class RouteRoot extends WidgetRoute {
  @override
  Future<Widget> build(Session session, Request request) async {
    return DefaultPageWidget();
  }
}
