import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  var protocol = Protocol();

  group('Given a JSON string', () {
    test(
      'when decoding a non-null integer then output is the original integer',
      () {
        int number = 1;
        var decoded = protocol.decodeWithType('{"className":"int","data":1}');
        expect(decoded, number);
      },
    );

    test(
      'when decoding a non-null nullable integer then output is the original integer',
      () {
        int? number = 1;
        var decoded = protocol.decodeWithType('{"className":"int","data":1}');
        expect(decoded, number);
      },
    );

    test(
      'when decoding a null nullable integer then output is the original null value',
      () {
        int? number = null;
        var decoded =
            protocol.decodeWithType('{"className":"null","data":null}');
        expect(decoded, number);
      },
    );

    test(
      'when decoding a non-null SimpleData object then output is the original SimpleData object',
      () {
        SimpleData simpleData = SimpleData.fromJson({'num': 1});
        var decoded = protocol
            .decodeWithType('{"className":"SimpleData","data":{"num":1}}');
        expect(decoded, isA<SimpleData>());
        expect(simpleData.isEqual(decoded), true);
      },
    );

    test(
      'when decoding a non-null nullable SimpleData object then output is the original SimpleData object',
      () {
        SimpleData? simpleData = SimpleData.fromJson({'num': 1});
        var decoded = protocol
            .decodeWithType('{"className":"SimpleData","data":{"num":1}}');
        expect(decoded, isA<SimpleData>());
        expect(simpleData.isEqual(decoded), true);
      },
    );

    test(
      'when decoding a null nullable SimpleData object then output is the original null value',
      () {
        SimpleData? simpleData = null;
        var decoded =
            protocol.decodeWithType('{"className":"null","data":null}');
        expect(decoded, isNull);
        expect(decoded, simpleData);
        expect(decoded is SimpleData?, true);
      },
    );
  });
}

extension _SimpleDataExtension on SimpleData {
  bool isEqual(Object? other) {
    if (identical(this, other)) return true;
    return other is SimpleData && other.num == this.num;
  }
}
