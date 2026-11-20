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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import '../protocol.dart' as _iv35mfmj;
import 'sealed_list_item.dart' as _iwm5xm7b;
part 'sealed_list_child.dart';

sealed class SealedListParent
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SealedListParent({required this.items});

  List<_iwm5xm7b.SealedListItem> items;

  /// Returns a shallow copy of this [SealedListParent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SealedListParent copyWith({List<_iwm5xm7b.SealedListItem>? items});
}
