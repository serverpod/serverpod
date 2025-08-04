import 'package:serverpod/serverpod.dart';

class TextWidget extends TemplateWidget {
  TextWidget({
    required String text,
  }) : super(name: 'text') {
    values = {
      'text': text,
    };
  }
}
