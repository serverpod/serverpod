import 'package:postgres/postgres.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Encoder for PostgreSQL vector types from pgvector extension.
EncodedValue? pgvectorEncoder(TypedValue input, CodecContext context) {
  final value = input.value;

  switch (value) {
    case Vector():
      return EncodedValue.binary(value.toBinary());
    case HalfVector():
      return EncodedValue.binary(value.toBinary());
    case SparseVector():
      return EncodedValue.binary(value.toBinary());
    case Bit():
      return EncodedValue.binary(value.toBinary());
  }

  return null;
}
