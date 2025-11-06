import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod/protocol.dart' as serverpod;
import 'package:test/test.dart';

void main() {
  var protocol = Protocol();

  test(
    'Given a integer when encoding and decoding with type then output matches input',
    () {
      int number = 1;
      var encoded = protocol.encodeWithType(number);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, number);
    },
  );

  test(
    'Given a non-null nullable integer when encoding and decoding with type then output matches input',
    () {
      int? number = 1;
      var encoded = protocol.encodeWithType(number);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, number);
    },
  );

  test(
    'Given a null nullable integer when encoding and decoding with type then output matches input',
    () {
      int? number = null;
      var encoded = protocol.encodeWithType(number);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, number);
    },
  );

  test(
    'Given a non-null SimpleData object when encoding and decoding with type then output matches input',
    () {
      SimpleData simpleData = SimpleData.fromJson({'num': 1});
      var encoded = protocol.encodeWithType(simpleData);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, isA<SimpleData>());
      expect(simpleData.isEqual(decoded), true);
    },
  );

  test(
    'Given a non-null nullable SimpleData object when encoding and decoding with type then output matches input',
    () {
      SimpleData? simpleData = SimpleData.fromJson({'num': 1});
      var encoded = protocol.encodeWithType(simpleData);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, isA<SimpleData>());
      expect(simpleData.isEqual(decoded), true);
    },
  );

  test(
    'Given a null nullable SimpleData object when encoding and decoding with type then output matches input',
    () {
      SimpleData? simpleData = null;
      var encoded = protocol.encodeWithType(simpleData);
      var decoded = protocol.decodeWithType(encoded);
      expect(decoded, simpleData);
      expect(decoded is SimpleData?, true);
    },
  );

  test(
    'Given a Serverpod defined model when encoding and decoding with type then output matches input',
    () {
      var serverpodDefinedModel = serverpod.ClusterServerInfo(
        serverId: 'Hello World',
      );
      var encoded = protocol.encodeWithType(serverpodDefinedModel);
      var decoded = protocol.decodeWithType(encoded);

      expect(decoded, isA<serverpod.ClusterServerInfo>());
      expect(
        (decoded as serverpod.ClusterServerInfo).serverId,
        serverpodDefinedModel.serverId,
      );
    },
  );
}

extension _SimpleDataExtension on SimpleData {
  bool isEqual(Object? other) {
    if (identical(this, other)) return true;
    return other is SimpleData && other.num == this.num;
  }
}
