import 'package:serverpod/serverpod.dart';

class SimplePageWidget extends Widget {
  SimplePageWidget({
    required String title,
    required Widget body,
  }) : super(name: 'simple_page') {
    values = {
      'title': title,
      'body': body,
    };
  }
}
