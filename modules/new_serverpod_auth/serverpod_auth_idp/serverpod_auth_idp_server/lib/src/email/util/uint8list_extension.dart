import 'dart:typed_data';

import 'package:meta/meta.dart';

@internal
extension Uint8ListAsByteDataExtension on Uint8List {
  ByteData get asByteData {
    return ByteData.sublistView(this);
  }
}
