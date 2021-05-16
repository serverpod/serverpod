import 'package:serverpod_relic/serverpod_relic.dart';

class TextWidget extends Widget {
  TextWidget({
    required String text,
  }) : super(name: 'text') {
    values = {
      'text': text,
    };
  }
}