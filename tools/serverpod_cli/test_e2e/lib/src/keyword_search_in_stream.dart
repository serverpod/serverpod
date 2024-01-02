import 'dart:async';

/// Searches the [onData] string for the [keywords].
///
/// The class will search for the keywords and set the [_found] flag to true
/// if the keyword is found. If the keyword is not found within the timeout
/// period, the [_found] flag will be set to false.
///
/// The user can call [keywordFound] to wait for the keyword to be
/// found or the timeout to occur.
///
/// The user needs to call [cancel] once search is completed to remove any
/// active timeouts and prevent future onces from being initialized.
class KeywordSearchInStream {
  bool? _found;
  final List<String> keywords;
  final Duration timeout;
  Timer? _timer;
  bool _searching = true;

  KeywordSearchInStream({
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

  void onData(String data) {
    print(data);

    if (!_searching) {
      return;
    }

    if (keywords.contains(data.trim())) {
      _found = true;
    }

    _scheduleTimeout();
  }

  void cancel() {
    _searching = false;
    _timer?.cancel();
  }

  void _scheduleTimeout() {
    _timer?.cancel();
    _timer = Timer(timeout, () {
      _found ??= false;
    });
  }
}
