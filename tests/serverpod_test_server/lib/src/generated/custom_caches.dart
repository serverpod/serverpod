/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../caches/my_custom_cache.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;

final _myCustomCacheExpando = Expando<_i1.MyCustomCache>();

extension CustomCaches on _i2.Caches {
  _i1.MyCustomCache get myCustomCache {
    var cache = _myCustomCacheExpando[this];
    if (cache == null) {
      cache = _i1.MyCustomCache(serializationManager);
      _myCustomCacheExpando[this] = cache;
    }
    return cache;
  }
}
