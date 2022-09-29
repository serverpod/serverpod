// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

part of list_bucket_result;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ListBucketResult> _$listBucketResultSerializer =
    _$ListBucketResultSerializer();

class _$ListBucketResultSerializer
    implements StructuredSerializer<ListBucketResult> {
  @override
  final Iterable<Type> types = const [ListBucketResult, _$ListBucketResult];
  @override
  final String wireName = 'ListBucketResult';

  @override
  Iterable<Object?> serialize(Serializers serializers, ListBucketResult object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'Name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'MaxKeys',
      serializers.serialize(object.maxKeys,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.prefix;
    if (value != null) {
      result
        ..add('Prefix')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.keyCount;
    if (value != null) {
      result
        ..add('KeyCount')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.isTruncated;
    if (value != null) {
      result
        ..add('IsTruncated')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.contents;
    if (value != null) {
      result
        ..add('Contents')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltList, [FullType(Contents)])));
    }
    return result;
  }

  @override
  ListBucketResult deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ListBucketResultBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'Name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'Prefix':
          result.prefix = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'MaxKeys':
          result.maxKeys = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'KeyCount':
          result.keyCount = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'IsTruncated':
          result.isTruncated = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'Contents':
          result.contents.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, [FullType(Contents)]))!
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$ListBucketResult extends ListBucketResult {
  @override
  final String name;
  @override
  final String? prefix;
  @override
  final String maxKeys;
  @override
  final String? keyCount;
  @override
  final String? isTruncated;
  @override
  final BuiltList<Contents>? contents;

  factory _$ListBucketResult(
          [void Function(ListBucketResultBuilder)? updates]) =>
      (ListBucketResultBuilder()..update(updates)).build();

  _$ListBucketResult._(
      {required this.name,
      this.prefix,
      required this.maxKeys,
      this.keyCount,
      this.isTruncated,
      this.contents})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, 'ListBucketResult', 'name');
    BuiltValueNullFieldError.checkNotNull(
        maxKeys, 'ListBucketResult', 'maxKeys');
  }

  @override
  ListBucketResult rebuild(void Function(ListBucketResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListBucketResultBuilder toBuilder() =>
      ListBucketResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListBucketResult &&
        name == other.name &&
        prefix == other.prefix &&
        maxKeys == other.maxKeys &&
        keyCount == other.keyCount &&
        isTruncated == other.isTruncated &&
        contents == other.contents;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, name.hashCode), prefix.hashCode),
                    maxKeys.hashCode),
                keyCount.hashCode),
            isTruncated.hashCode),
        contents.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ListBucketResult')
          ..add('name', name)
          ..add('prefix', prefix)
          ..add('maxKeys', maxKeys)
          ..add('keyCount', keyCount)
          ..add('isTruncated', isTruncated)
          ..add('contents', contents))
        .toString();
  }
}

class ListBucketResultBuilder
    implements Builder<ListBucketResult, ListBucketResultBuilder> {
  _$ListBucketResult? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _prefix;
  String? get prefix => _$this._prefix;
  set prefix(String? prefix) => _$this._prefix = prefix;

  String? _maxKeys;
  String? get maxKeys => _$this._maxKeys;
  set maxKeys(String? maxKeys) => _$this._maxKeys = maxKeys;

  String? _keyCount;
  String? get keyCount => _$this._keyCount;
  set keyCount(String? keyCount) => _$this._keyCount = keyCount;

  String? _isTruncated;
  String? get isTruncated => _$this._isTruncated;
  set isTruncated(String? isTruncated) => _$this._isTruncated = isTruncated;

  ListBuilder<Contents>? _contents;
  ListBuilder<Contents> get contents =>
      _$this._contents ??= ListBuilder<Contents>();
  set contents(ListBuilder<Contents>? contents) => _$this._contents = contents;

  ListBucketResultBuilder();

  ListBucketResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _prefix = $v.prefix;
      _maxKeys = $v.maxKeys;
      _keyCount = $v.keyCount;
      _isTruncated = $v.isTruncated;
      _contents = $v.contents?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListBucketResult other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ListBucketResult;
  }

  @override
  void update(void Function(ListBucketResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ListBucketResult build() {
    _$ListBucketResult _$result;
    try {
      _$result = _$v ??
          _$ListBucketResult._(
              name: BuiltValueNullFieldError.checkNotNull(
                  name, 'ListBucketResult', 'name'),
              prefix: prefix,
              maxKeys: BuiltValueNullFieldError.checkNotNull(
                  maxKeys, 'ListBucketResult', 'maxKeys'),
              keyCount: keyCount,
              isTruncated: isTruncated,
              contents: _contents?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'contents';
        _contents?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            'ListBucketResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
