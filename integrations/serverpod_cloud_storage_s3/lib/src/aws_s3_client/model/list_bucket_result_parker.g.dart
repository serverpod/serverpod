// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

part of 'list_bucket_result_parker.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ListBucketResultParker> _$listBucketResultParkerSerializer =
    _$ListBucketResultParkerSerializer();

class _$ListBucketResultParkerSerializer
    implements StructuredSerializer<ListBucketResultParker> {
  @override
  final Iterable<Type> types = const [
    ListBucketResultParker,
    _$ListBucketResultParker
  ];
  @override
  final String wireName = 'ListBucketResultParker';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ListBucketResultParker object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.result;
    if (value != null) {
      result
        ..add('ListBucketResult')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ListBucketResult)));
    }
    return result;
  }

  @override
  ListBucketResultParker deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ListBucketResultParkerBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'ListBucketResult':
          result.result.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ListBucketResult))!
              as ListBucketResult);
          break;
      }
    }

    return result.build();
  }
}

class _$ListBucketResultParker extends ListBucketResultParker {
  @override
  final ListBucketResult? result;

  factory _$ListBucketResultParker(
          [void Function(ListBucketResultParkerBuilder)? updates]) =>
      (ListBucketResultParkerBuilder()..update(updates)).build();

  _$ListBucketResultParker._({this.result}) : super._();

  @override
  ListBucketResultParker rebuild(
          void Function(ListBucketResultParkerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListBucketResultParkerBuilder toBuilder() =>
      ListBucketResultParkerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListBucketResultParker && result == other.result;
  }

  @override
  int get hashCode {
    return $jf($jc(0, result.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ListBucketResultParker')
          ..add('result', result))
        .toString();
  }
}

class ListBucketResultParkerBuilder
    implements Builder<ListBucketResultParker, ListBucketResultParkerBuilder> {
  _$ListBucketResultParker? _$v;

  ListBucketResultBuilder? _result;
  ListBucketResultBuilder get result =>
      _$this._result ??= ListBucketResultBuilder();
  set result(ListBucketResultBuilder? result) => _$this._result = result;

  ListBucketResultParkerBuilder();

  ListBucketResultParkerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _result = $v.result?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListBucketResultParker other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ListBucketResultParker;
  }

  @override
  void update(void Function(ListBucketResultParkerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ListBucketResultParker build() {
    _$ListBucketResultParker _$result;
    try {
      _$result = _$v ?? _$ListBucketResultParker._(result: _result?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'result';
        _result?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            'ListBucketResultParker', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
