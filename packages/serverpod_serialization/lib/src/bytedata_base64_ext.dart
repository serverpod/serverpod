import 'dart:convert';
import 'dart:typed_data';

/// Extension for encoding [ByteData] in the protocol.
extension Base64Enc on ByteData {
  /// Returns a base64 encoded string with the `base64:` prefix.
  String base64encodedString() {
    return 'base64:' + base64Encode(buffer.asUint8List());
  }
}

/// Extension for decoding [ByteData] in protocol.
extension Base64Dec on String {
  /// Returns [ByteData] from an encoded String.
  ByteData base64DecodedByteData() {
    return ByteData.view(base64Decode(substring(7)).buffer);
  }
}