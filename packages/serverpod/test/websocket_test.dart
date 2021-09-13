import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';


void main() {
  var client = Client('http://localhost:8080/');

  setUp(() {
  });

  group('Basic websocket', () {

    test('Connect and send SimpleData', () async {
      await client.connectWebSocket();

      var nums = [42, 1337, 69];

      for (var num in nums) {
        await client.streaming.sendToStream(SimpleData(num: num));
      }

      var n = 0;
      await for (var message in client.streaming.stream) {
        var simpleData = message as SimpleData;
        expect(simpleData.num, nums[n]);

        n += 1;
        if (n == nums.length)
          break;
      }
    });

  });
}
