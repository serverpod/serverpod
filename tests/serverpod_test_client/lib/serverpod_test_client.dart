import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_test_client/src/custom_classes.dart';
import 'package:serverpod_test_client/src/protocol/protocol.dart';

export 'src/protocol/protocol.dart';
export 'package:serverpod_client/serverpod_client.dart';

extension CustomProtocol on Protocol {
  void registerCustomConstructors() {
    Protocol.customConstructors[CustomClass2] =
        (data, serializationManager) => CustomClass2(data['text']);
    Protocol.customConstructors[getType<CustomClass2?>()] =
        (data, serializationManager) =>
            data == null ? null : CustomClass2(data['text']);
  }
}
