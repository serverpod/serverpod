import 'package:auth_example_server/src/web/widgets/default_page_widget.dart';
import 'package:serverpod/serverpod.dart';

class RootRoute extends WidgetRoute {
  @override
  Future<TemplateWidget> build(Session session, Request request) async {
    return DefaultPageWidget();
  }
}
