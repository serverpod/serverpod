import 'package:serverpod/serverpod.dart';

import '../widgets/simple_page.dart';
import '../widgets/text.dart';

class RootRoute extends WidgetRoute {
  @override
  Future<TemplateWidget> build(Session session, Request request) async {
    return SimplePageWidget(
      title: 'My Root Page',
      body: TextWidget(text: 'Hello world'),
    );
  }
}
