import 'package:serverpod/serverpod.dart';

class TextComponent extends Component {
  TextComponent({
    required String text,
  }) : super(name: 'text') {
    values = {
      'text': text,
    };
  }
}
