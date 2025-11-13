import 'package:serverpod/serverpod.dart';
import 'package:serverpod_new_auth_test_server/src/web/widgets/built_with_serverpod_page.dart';

class RootRoute extends WidgetRoute {
  @override
  Future<TemplateWidget> build(
    final Session session,
    final Request request,
  ) async {
    return BuiltWithServerpodPageWidget();
  }
}
