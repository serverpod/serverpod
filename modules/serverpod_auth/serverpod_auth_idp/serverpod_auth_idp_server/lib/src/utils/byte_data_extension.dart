import 'dart:typed_data';

import 'package:meta/meta.dart';

@internal
extension ByteDataAsUint8List on ByteData {
  Uint8List get asUint8List {
    return Uint8List.sublistView(this);
  }
}
