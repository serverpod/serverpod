part of '../router.dart';

/// Extends [Response] to allow it to be used multiple times in the
/// actual content being served.
class _RouteNotFoundResponse extends Response {
  static const _message = 'Route not found';
  static final _messageBytes = utf8.encode(_message);

  _RouteNotFoundResponse() : super.notFound(body: Body.fromData(_messageBytes));

  @override
  Stream<List<int>> read() => Stream<List<int>>.value(_messageBytes);

  @override
  Response copyWith({
    Headers? headers,
    Map<String, Object?>? context,
    Body? body,
  }) {
    return super.copyWith(
      headers: headers,
      context: context,
      body: body ?? Body.fromData(_messageBytes),
    );
  }
}
