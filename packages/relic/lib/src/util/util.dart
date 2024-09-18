import 'dart:async';

/// Run [callback] and capture any errors that would otherwise be top-leveled.
///
/// If `this` is called in a non-root error zone, it will just run [callback]
/// and return the result. Otherwise, it will capture any errors using
/// [runZoned] and pass them to [onError].
void catchTopLevelErrors(void Function() callback,
    void Function(dynamic error, StackTrace) onError) {
  if (Zone.current.inSameErrorZone(Zone.root)) {
    return runZonedGuarded(callback, onError);
  } else {
    return callback();
  }
}

/// Returns a [Map] with the values from [original] and the values from
/// [updates].
///
/// For keys that are the same between [original] and [updates], the value in
/// [updates] is used.
///
/// If [updates] is `null` or empty, [original] is returned unchanged.
Map<K, V> updateMap<K, V>(Map<K, V> original, Map<K, V?>? updates) {
  if (updates == null || updates.isEmpty) return original;

  final value = Map.of(original);
  for (var entry in updates.entries) {
    final val = entry.value;
    if (val == null) {
      value.remove(entry.key);
    } else {
      value[entry.key] = val;
    }
  }

  return value;
}

/// Multiple header values are joined with commas.
/// See https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-p1-messaging-21#page-22
String? joinHeaderValues(List<String>? values) {
  if (values == null) return null;
  if (values.isEmpty) return '';
  if (values.length == 1) return values.single;
  return values.join(',');
}
