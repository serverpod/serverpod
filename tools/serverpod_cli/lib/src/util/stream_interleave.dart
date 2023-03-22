import 'dart:async';
import 'dart:io';

class StreamInterleave<T> {
  late StreamController<T> _controller;
  final _subscriptions = <Stream, StreamSubscription>{};

  StreamInterleave() {
    _controller = StreamController<T>();
  }

  void addStream(Stream<T> stream) {
    _subscriptions[stream] = stream.listen(
      (event) {
        _controller.add(event);
      },
      onDone: () {},
      onError: (e) {},
    );
  }

  void removeStream(Stream stream) {
    var sub = _subscriptions[stream];
    sub?.cancel();
    _subscriptions.remove(stream);
  }

  Stream<T> get stream => _controller.stream;

  static StreamInterleave<List<int>> createStdout() {
    var interleave = StreamInterleave<List<int>>();
    stdout.addStream(interleave.stream);
    return interleave;
  }

  static StreamInterleave<List<int>> createStderr() {
    var interleave = StreamInterleave<List<int>>();
    stderr.addStream(interleave.stream);
    return interleave;
  }
}
