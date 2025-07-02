import 'package:serverpod/serverpod.dart';

class BuiltWithServerpodPageComponent extends Component {
  BuiltWithServerpodPageComponent() : super(name: 'built_with_serverpod') {
    values = {
      'served': DateTime.now(),
      'runmode': Serverpod.instance.runMode,
    };
  }
}
