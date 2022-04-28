import 'package:serverpod_relic/serverpod_relic.dart';

class SimplePageWidget extends Widget {
  SimplePageWidget({
    required String title,
    required Widget body,
  }) : super(name: 'simple_page') {
    values = <String, dynamic>{
      'title': title,
      'body': body,
    };
  }
}
