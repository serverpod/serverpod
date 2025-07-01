import 'package:serverpod/serverpod.dart';

class BuiltWithServerpodPage extends Component {
  BuiltWithServerpodPage() : super(name: 'built_with_serverpod') {
    values = {
      'served': DateTime.now(),
      'runmode': Serverpod.instance.runMode,
    };
  }
}
