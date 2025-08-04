import 'package:serverpod/serverpod.dart';

class SimplePageWidget extends TemplateWidget {
  SimplePageWidget({
    required String title,
    required WebWidget body,
  }) : super(name: 'simple_page') {
    values = {
      'title': title,
      'body': body,
    };
  }
}
