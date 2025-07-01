import 'package:serverpod/serverpod.dart';

class SimplePageComponent extends Component {
  SimplePageComponent({
    required String title,
    required Component body,
  }) : super(name: 'simple_page') {
    values = {
      'title': title,
      'body': body,
    };
  }
}
