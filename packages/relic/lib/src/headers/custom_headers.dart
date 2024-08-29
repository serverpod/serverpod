import 'dart:collection';

import 'package:http_parser/http_parser.dart';

final _emptyCustomHeaders = CustomHeaders._empty();

/// Unmodifiable, key-insensitive header map.
class CustomHeaders extends UnmodifiableMapView<String, List<String>> {
  static const _customHeaderPrefix = 'custom-header-';

  Iterable<MapEntry<String, List<String>>> get httpRequestEntries =>
      super.entries.map(
            (entry) => MapEntry<String, List<String>>(
              '$_customHeaderPrefix${entry.key}'.toLowerCase(),
              entry.value,
            ),
          );

  late final Map<String, String> singleValues = UnmodifiableMapView(
    CaseInsensitiveMap.from(
      map(
        (key, value) => MapEntry(
          key.toLowerCase(),
          _joinHeaderValues(value)!,
        ),
      ),
    ),
  );

  factory CustomHeaders(Map<String, String> values) {
    return CustomHeaders._(
      values.entries.map((e) => MapEntry(e.key, [e.value])),
    );
  }

  factory CustomHeaders.from(
    Map<String, List<String>>? values,
  ) {
    if (values == null || values.isEmpty) {
      return _emptyCustomHeaders;
    } else if (values is CustomHeaders) {
      return values;
    } else {
      return CustomHeaders._(values.entries);
    }
  }

  factory CustomHeaders.fromHttpRequestEntries(
    Iterable<MapEntry<String, List<String>>>? entries,
  ) {
    if (entries == null || (entries is List && entries.isEmpty)) {
      return _emptyCustomHeaders;
    } else {
      return CustomHeaders._(
        entries,
        filterWithCustomPrefix: true,
      );
    }
  }

  factory CustomHeaders.fromEntries(
    Iterable<MapEntry<String, List<String>>>? entries,
  ) {
    if (entries == null || (entries is List && entries.isEmpty)) {
      return _emptyCustomHeaders;
    } else {
      return CustomHeaders._(
        entries,
      );
    }
  }

  CustomHeaders._(
    Iterable<MapEntry<String, List<String>>> entries, {
    bool filterWithCustomPrefix = false,
  }) : super(
          CaseInsensitiveMap.from(
            _entriesToMap(
              entries
                  .where(
                    (e) =>
                        e.value.isNotEmpty &&

                        /// Filtering all custom headers
                        (!filterWithCustomPrefix ||
                            e.key.startsWith(_customHeaderPrefix)),
                  )
                  .map(
                    (e) => MapEntry(
                      /// removing the custom prefix
                      e.key.replaceAll(_customHeaderPrefix, '').toLowerCase(),
                      List.unmodifiable(e.value),
                    ),
                  ),
            ),
          ),
        );

  CustomHeaders._empty() : super(const {});

  factory CustomHeaders.empty() => _emptyCustomHeaders;

  static Map<String, List<String>> _entriesToMap(
    Iterable<MapEntry<String, List<String>>> entries,
  ) {
    var map = Map.fromEntries(entries);
    return map;
  }

  static String? _joinHeaderValues(List<String>? values) {
    if (values == null) return null;
    if (values.isEmpty) return '';
    if (values.length == 1) return values.single;
    return values.join(',');
  }
}
