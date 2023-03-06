library list_bucket_result_contents;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'list_bucket_result_contents.g.dart';

abstract class Contents implements Built<Contents, ContentsBuilder> {
  Contents._();

  factory Contents([Function(ContentsBuilder b)? updates]) = _$Contents;

  @BuiltValueField(wireName: 'Key')
  String? get key;

  @BuiltValueField(wireName: 'LastModified')
  String? get lastModified;

  @BuiltValueField(wireName: 'ETag')
  String? get eTag;

  @BuiltValueField(wireName: 'Size')
  String? get size;

  @BuiltValueField(wireName: 'StorageClass')
  String? get storageClass;

  String toJson() {
    return json.encode(serializers.serializeWith(Contents.serializer, this));
  }

  static Contents fromJson(String jsonString) {
    return serializers.deserializeWith(
        Contents.serializer, json.decode(jsonString))!;
  }

  static Serializer<Contents> get serializer => _$contentsSerializer;
}
