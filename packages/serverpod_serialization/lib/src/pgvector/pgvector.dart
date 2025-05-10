import 'dart:convert';
import 'vector.dart';

class Pgvector {
  const Pgvector();

  // encode as text
  String encode(List<double> input) {
    return Vector(input).toString();
  }

  // decode from binary
  // TODO find a way to make encode/decode consistent
  List<double> decode(dynamic input) {
    // PostgresBinaryDecoder in the postgres package
    // tries to decode as utf8 for unknown types
    // sometimes it succeeds, other times it fails
    // so need to handle both cases
    if (input is String) {
      input = utf8.encode(input);
    }
    return Vector.fromBinary(input).toList();
  }
}

const Pgvector pgvector = Pgvector();
