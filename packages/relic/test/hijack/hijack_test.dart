import 'dart:async';

import 'package:relic/relic.dart';
import 'package:relic/src/method/request_method.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

import '../util/test_util.dart';

void main() {
  const requestData = [1, 2, 3];
  const responseData = [4, 5, 6];

  test(
    'Given a non-hijackable request when hijack is called then it throws a StateError',
    () {
      var request = Request(RequestMethod.get, localhostUri);
      expect(() => request.hijack((_) {}), throwsStateError);
    },
  );

  test(
    'Given a hijackable request when hijack is called then it throws a HijackException and calls onHijack',
    () {
      var request = Request(RequestMethod.get, localhostUri,
          onHijack: expectAsync1((callback) {
        var streamController = StreamController<List<int>>();
        streamController.add(requestData);
        streamController.close();

        var sinkController = StreamController<List<int>>();
        expect(sinkController.stream.first, completion(equals(responseData)));

        callback(StreamChannel(streamController.stream, sinkController));
      }));

      expect(
        () => request.hijack(expectAsync1((channel) {
          expect(channel.stream.first, completion(equals(requestData)));
          channel.sink.add(responseData);
          channel.sink.close();
        })),
        throwsHijackException,
      );
    },
  );

  test(
    'Given a hijackable request when hijack is called twice then it throws a StateError',
    () {
      var request = Request(RequestMethod.get, localhostUri,
          onHijack: expectAsync1((_) {}, count: 1));
      expect(() => request.hijack((_) {}), throwsHijackException);
      expect(() => request.hijack((_) {}), throwsStateError);
    },
  );

  test(
    'Given a hijackable request when hijack is not called then onHijack is not triggered',
    () {
      Request(
        RequestMethod.get,
        localhostUri,
        onHijack: expectAsync1((_) {}, count: 0),
      );
    },
  );

  test(
    'Given a hijackable request when hijack is called with empty data then it handles gracefully',
    () {
      var request = Request(RequestMethod.get, localhostUri,
          onHijack: expectAsync1((callback) {
        var streamController = StreamController<List<int>>();
        streamController.close();

        var sinkController = StreamController<List<int>>();
        callback(StreamChannel(streamController.stream, sinkController));
      }));

      expect(
        () => request.hijack(
          expectAsync1((channel) {
            expect(channel.stream.isEmpty, completion(isTrue));
            channel.sink.close();
          }),
        ),
        throwsHijackException,
      );
    },
  );
}
