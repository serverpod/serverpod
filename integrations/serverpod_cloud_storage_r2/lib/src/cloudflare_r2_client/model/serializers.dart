import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'list_bucket_result.dart';
import 'list_bucket_result_contents.dart';
import 'list_bucket_result_parker.dart';

part 'serializers.g.dart';

@SerializersFor([ListBucketResultParker])
Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
