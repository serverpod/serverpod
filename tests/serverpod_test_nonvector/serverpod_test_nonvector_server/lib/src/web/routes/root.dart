import 'package:serverpod_test_nonvector_server/src/web/widgets/built_with_serverpod_page.dart';
import 'package:serverpod/serverpod.dart';

class RootRoute extends ComponentRoute {
  @override
  Future<Component> build(Session session, Request request) async {
    return BuiltWithServerpodPageComponent();
  }
}
