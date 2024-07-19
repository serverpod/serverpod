import 'dart:async';

class TestCompleterTimeout {
  Map<String, Completer> _completers = {};
  Timer? _timer;

  void start(
    Map<String, Completer> completers, {
    Duration duration = const Duration(seconds: 5),
  }) {
    _completers = completers;
    _timer = Timer(duration, () {
      _completers.forEach((key, value) {
        if (!value.isCompleted) {
          value.completeError('$key failed to complete future before timeout.');
        }
      });
    });
  }

  void cancel() {
    _timer?.cancel();
  }
}
