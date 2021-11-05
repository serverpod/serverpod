import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'list_bucket_result.dart';
import 'serializers.dart';

part 'list_bucket_result_parker.g.dart';

abstract class ListBucketResultParker
    implements Built<ListBucketResultParker, ListBucketResultParkerBuilder> {
  ListBucketResultParker._();

  @BuiltValueField(wireName: "ListBucketResult")
  ListBucketResult? get result;

  factory ListBucketResultParker([updates(ListBucketResultParkerBuilder b)?]) =
      _$ListBucketResultParker;

  String toJson() {
    return json
        .encode(serializers.serializeWith(ListBucketResult.serializer, this));
  }

  static ListBucketResultParker fromJson(String jsonString) {
    return serializers.deserializeWith(
        ListBucketResultParker.serializer, json.decode(jsonString))!;
  }

  static ListBucketResultParker fromJsonMap(Map<String, dynamic> jsonMap) {
    return serializers.deserializeWith(
        ListBucketResultParker.serializer, jsonMap)!;
  }

  static Serializer<ListBucketResultParker> get serializer =>
      _$listBucketResultParkerSerializer;
}
