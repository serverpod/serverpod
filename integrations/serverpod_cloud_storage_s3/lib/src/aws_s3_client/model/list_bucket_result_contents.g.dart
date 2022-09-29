// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

part of list_bucket_result_contents;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Contents> _$contentsSerializer = _$ContentsSerializer();

class _$ContentsSerializer implements StructuredSerializer<Contents> {
  @override
  final Iterable<Type> types = const [Contents, _$Contents];
  @override
  final String wireName = 'Contents';

  @override
  Iterable<Object?> serialize(Serializers serializers, Contents object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.key;
    if (value != null) {
      result
        ..add('Key')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.lastModified;
    if (value != null) {
      result
        ..add('LastModified')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.eTag;
    if (value != null) {
      result
        ..add('ETag')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.size;
    if (value != null) {
      result
        ..add('Size')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.storageClass;
    if (value != null) {
      result
        ..add('StorageClass')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Contents deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ContentsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'Key':
          result.key = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'LastModified':
          result.lastModified = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'ETag':
          result.eTag = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'Size':
          result.size = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'StorageClass':
          result.storageClass = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Contents extends Contents {
  @override
  final String? key;
  @override
  final String? lastModified;
  @override
  final String? eTag;
  @override
  final String? size;
  @override
  final String? storageClass;

  factory _$Contents([void Function(ContentsBuilder)? updates]) =>
      (ContentsBuilder()..update(updates)).build();

  _$Contents._(
      {this.key, this.lastModified, this.eTag, this.size, this.storageClass})
      : super._();

  @override
  Contents rebuild(void Function(ContentsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContentsBuilder toBuilder() => ContentsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Contents &&
        key == other.key &&
        lastModified == other.lastModified &&
        eTag == other.eTag &&
        size == other.size &&
        storageClass == other.storageClass;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, key.hashCode), lastModified.hashCode),
                eTag.hashCode),
            size.hashCode),
        storageClass.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Contents')
          ..add('key', key)
          ..add('lastModified', lastModified)
          ..add('eTag', eTag)
          ..add('size', size)
          ..add('storageClass', storageClass))
        .toString();
  }
}

class ContentsBuilder implements Builder<Contents, ContentsBuilder> {
  _$Contents? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _lastModified;
  String? get lastModified => _$this._lastModified;
  set lastModified(String? lastModified) => _$this._lastModified = lastModified;

  String? _eTag;
  String? get eTag => _$this._eTag;
  set eTag(String? eTag) => _$this._eTag = eTag;

  String? _size;
  String? get size => _$this._size;
  set size(String? size) => _$this._size = size;

  String? _storageClass;
  String? get storageClass => _$this._storageClass;
  set storageClass(String? storageClass) => _$this._storageClass = storageClass;

  ContentsBuilder();

  ContentsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _lastModified = $v.lastModified;
      _eTag = $v.eTag;
      _size = $v.size;
      _storageClass = $v.storageClass;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Contents other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Contents;
  }

  @override
  void update(void Function(ContentsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Contents build() {
    final _$result = _$v ??
        _$Contents._(
            key: key,
            lastModified: lastModified,
            eTag: eTag,
            size: size,
            storageClass: storageClass);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
