import 'dart:convert';
import 'package:postgres/postgres.dart';
import 'bit.dart';
import 'halfvec.dart';
import 'sparsevec.dart';
import 'vector.dart';

EncodedValue? pgvectorEncoder(TypedValue input, CodecContext context) {
  final value = input.value;

  if (value is Vector) {
    return EncodedValue.binary(value.toBinary());
  }

  if (value is HalfVector) {
    return EncodedValue.text(utf8.encode(value.toString()));
  }

  if (value is Bit) {
    return EncodedValue.binary(value.toBinary());
  }

  if (value is SparseVector) {
    return EncodedValue.binary(value.toBinary());
  }

  return null;
}
