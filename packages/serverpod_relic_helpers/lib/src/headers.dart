// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:http_parser/http_parser.dart';

import 'util.dart';

final _emptyHeaders = Headers._empty();

/// Unmodifiable, key-insensitive header map.
class Headers extends UnmodifiableMapView<String, List<String>> {
  late final Map<String, String> singleValues = UnmodifiableMapView(
    CaseInsensitiveMap.from(
      map((key, value) => MapEntry(key, joinHeaderValues(value)!)),
    ),
  );

  factory Headers.from(Map<String, List<String>>? values) {
    if (values == null || values.isEmpty) {
      return _emptyHeaders;
    } else if (values is Headers) {
      return values;
    } else {
      return Headers._(values.entries);
    }
  }

  factory Headers.fromEntries(
    Iterable<MapEntry<String, List<String>>>? entries,
  ) {
    if (entries == null || (entries is List && entries.isEmpty)) {
      return _emptyHeaders;
    } else {
      return Headers._(entries);
    }
  }

  Headers._(Iterable<MapEntry<String, List<String>>> entries)
      : super(
          CaseInsensitiveMap.fromEntries(
            entries
                .where((e) => e.value.isNotEmpty)
                .map((e) => MapEntry(e.key, List.unmodifiable(e.value))),
          ),
        );

  Headers._empty() : super(const {});

  factory Headers.empty() => _emptyHeaders;
}
