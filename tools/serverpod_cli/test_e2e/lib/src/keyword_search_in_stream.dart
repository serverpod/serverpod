import 'dart:async';

/// Searches for keywords in a stream of strings.
/// The class expects a stream that is split by lines and utf8 decoded.
///
/// The class will listen to the stream and set the [_found] flag to true
/// if the keyword is found. If the keyword is not found within the timeout
/// period, the [_found] flag will be set to false.
///
/// The user can call [keywordFound] to wait for the keyword to be
/// found or the timeout to occur.
///
/// The user needs to call [startListen] to start listening to the stream.
/// The user needs to call [close] to stop listening to the stream.
class KeywordSearchInStream {
  bool? _found;
  final List<String> keywords;
  final Stream<String> _stream;
  late final StreamSubscription<String> _subscription;
  final Duration timeout;
  Timer? _timer;

  KeywordSearchInStream(
    this._stream, {
    this.timeout = const Duration(seconds: 30),
    required this.keywords,
  });

  Future<bool> get keywordFound async {
    var value = _found;
    _scheduleTimeout();
    while (value == null) {
      await Future.delayed(const Duration(milliseconds: 100));
      value = _found;
    }

    _found = null;

    return value;
  }

  void close() {
    _timer?.cancel();
    _subscription.cancel();
  }

  KeywordSearchInStream startListen() {
    _subscription = _stream.listen(
      (String output) {
        if (keywords.contains(output.trim())) {
          _found = true;
        }

        print(output);
        _scheduleTimeout();
      },
      onError: (err) {
        print('Error in stream: $err');
      },
      cancelOnError: false,
    );

    return this;
  }

  void _scheduleTimeout() {
    _timer?.cancel();
    _timer = Timer(timeout, () {
      _found ??= false;
    });
  }
}
