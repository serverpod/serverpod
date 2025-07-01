import 'package:serverpod/serverpod.dart';

class DefaultPageComponent extends Component {
  DefaultPageComponent() : super(name: 'default') {
    values = {
      'served': DateTime.now(),
      'runmode': Serverpod.instance.runMode,
    };
  }
}
