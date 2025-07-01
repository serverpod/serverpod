import 'package:serverpod/serverpod.dart';

class TextWidget extends WebWidget {
  TextWidget({
    required String text,
  }) : super(name: 'text') {
    values = {
      'text': text,
    };
  }
}
