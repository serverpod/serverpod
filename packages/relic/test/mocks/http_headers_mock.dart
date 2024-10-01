import 'dart:io';

class HttpHeadersMock implements HttpHeaders {
  final Map<String, List<String>> _headers = {};

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    var lowerName = name.toLowerCase();
    if (!_headers.containsKey(lowerName)) {
      _headers[lowerName] = [];
    }

    if (value.toString().isNotEmpty) {
      _headers[lowerName]!.add(
        value.toString(),
      );
    }
  }

  @override
  void forEach(void Function(String name, List<String> values) action) {
    _headers.forEach((name, values) {
      action(name, values);
    });
  }

  @override
  String? value(String name) {
    var values = _headers[name] ?? [];
    if (values.length <= 1) return values.firstOrNull;
    return null;
  }

  @override
  List<String>? operator [](String name) => _headers[name.toLowerCase()];

  // Unimplemented methods will throw an exception if called during tests.
  @override
  noSuchMethod(Invocation invocation) {
    return _headers[invocation.memberName.toString()];
  }
}
