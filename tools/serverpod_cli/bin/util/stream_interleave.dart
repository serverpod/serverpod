import 'dart:async';
import 'dart:io';

class StreamInterleave<T> {
  late StreamController<T> _controller;
  final Map<Stream<T>, StreamSubscription<T>> _subscriptions =
      <Stream<T>, StreamSubscription<T>>{};

  StreamInterleave() {
    _controller = StreamController<T>();
  }

  void addStream(Stream<T> stream) {
    _subscriptions[stream] = stream.listen(
      (T event) {
        _controller.add(event);
      },
      onDone: () {},
      onError: (Object e) {},
    );
  }

  void removeStream(Stream<T> stream) {
    StreamSubscription<T>? sub = _subscriptions[stream];
    sub?.cancel();
    _subscriptions.remove(stream);
  }

  Stream<T> get stream => _controller.stream;

  static StreamInterleave<List<int>> createStdout() {
    StreamInterleave<List<int>> interleave = StreamInterleave<List<int>>();
    stdout.addStream(interleave.stream);
    return interleave;
  }

  static StreamInterleave<List<int>> createStderr() {
    StreamInterleave<List<int>> interleave = StreamInterleave<List<int>>();
    stderr.addStream(interleave.stream);
    return interleave;
  }
}
