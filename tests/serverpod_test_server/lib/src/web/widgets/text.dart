import 'package:serverpod/serverpod.dart';

class TextWidget extends Widget {
  TextWidget({
    required String text,
  }) : super(name: 'text') {
    values = {
      'text': text,
    };
  }
}
