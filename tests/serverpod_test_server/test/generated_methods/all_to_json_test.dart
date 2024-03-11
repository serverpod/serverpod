import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a class with only nullable fields without any of them defined when calling toJson then an empty map is returned.',
      () {
    var types = Types();

    var jsonMap = types.allToJson();

    expect(jsonMap, {});
  });

  test(
      'Given a class with only nullable fields with an int defined when calling toJson then the key and value is set.',
      () {
    var types = Types(anInt: 1);

    var jsonMap = types.allToJson();

    expect(jsonMap, {'anInt': 1});
  });

  test(
      'Given a class with only nullable fields with a double defined when calling toJson then the key and value is set.',
      () {
    var types = Types(aDouble: 1.0);

    var jsonMap = types.allToJson();

    expect(jsonMap, {'aDouble': 1.0});
  });

  test(
      'Given a class with only nullable fields with a bool defined when calling toJson then the key and value is set.',
      () {
    var types = Types(aBool: true);

    var jsonMap = types.allToJson();

    expect(jsonMap, {'aBool': true});
  });

  test(
      'Given a class with only nullable fields with a String defined when calling toJson then the key and value is set.',
      () {
    var types = Types(aString: 'Hello world!');

    var jsonMap = types.allToJson();

    expect(jsonMap, {'aString': 'Hello world!'});
  });

  test(
      'Given a class with only nullable fields with an enum serialized by index defined when calling toJson then the key and value is set.',
      () {
    var types = Types(anEnum: TestEnum.one);

    var jsonMap = types.allToJson();

    expect(jsonMap, {'anEnum': 0});
  });

  test(
      'Given a class with only nullable fields with an enum serialized by name defined when calling toJson then the key and value is set.',
      () {
    var types = Types(aStringifiedEnum: TestEnumStringified.one);

    var jsonMap = types.allToJson();

    expect(jsonMap, {'aStringifiedEnum': 'one'});
  });

  test(
      'Given a class with only nullable fields with a Uuid defined when calling toJson then the key and value is set.',
      () {
    var types = Types(aUuid: UuidValue.nil);

    var jsonMap = types.allToJson();

    expect(jsonMap, {'aUuid': '00000000-0000-0000-0000-000000000000'});
  });

  test(
      'Given a class with only nullable fields with a Duration defined when calling toJson then the key and value is set.',
      () {
    var types = Types(aDuration: Duration(seconds: 1));

    var jsonMap = types.allToJson();

    expect(jsonMap, {'aDuration': 1000});
  });

  test(
      'Given a class with only nullable fields with a DateTime defined when calling toJson then the key and value is set.',
      () {
    var types = Types(aDateTime: DateTime.parse('2024-01-01T00:00:00.000Z'));

    var jsonMap = types.allToJson();

    expect(jsonMap, {'aDateTime': '2024-01-01T00:00:00.000Z'});
  });

  test(
      'Given a class with only nullable fields with a ByteData defined when calling toJson then the key and value is set.',
      () {
    var intList = Uint8List(8);
    for (var i = 0; i < intList.length; i++) {
      intList[i] = i;
    }

    var types = Types(aByteData: ByteData.view(intList.buffer));

    var jsonMap = types.allToJson();

    expect(jsonMap, {'aByteData': 'decode(\'AAECAwQFBgc=\', \'base64\')'});
  });

  test(
      'Given a class with a relation to an object when calling toJson the entire nested structure is converted.',
      () {
    var next = Post(content: 'next');
    var post = Post(content: 'post', next: next);

    var jsonMap = post.allToJson();

    expect(jsonMap, {
      'content': 'post',
      'next': {'content': 'next'}
    });
  });

  test(
      'Given a class with a nested object when calling toJson the entire nested structure is converted.',
      () {
    var simpleData = SimpleData(num: 123);
    var object = SimpleDataObject(object: simpleData);

    var jsonMap = object.allToJson();

    expect(jsonMap, {
      'object': {'num': 123}
    });
  });

  ///----

  test(
      'Given a class with a List with a nested object when calling toJson the entire nested structure is converted.',
      () {
    var type = Types(anInt: 123);
    var object = TypesList(anObject: [type]);

    var jsonMap = object.allToJson();

    expect(jsonMap, {
      'anObject': [
        {'anInt': 123}
      ]
    });
  });

  test(
      'Given a class with a List with a nested DateTime when calling toJson the entire nested structure is converted.',
      () {
    var object = TypesList(
      aDateTime: [DateTime.parse('2024-01-01T00:00:00.000Z')],
    );

    var jsonMap = object.allToJson();

    expect(jsonMap, {
      'aDateTime': ['2024-01-01T00:00:00.000Z']
    });
  });

  test(
      'Given a class with a List with a nested ByteData when calling toJson the entire nested structure is converted.',
      () {
    var intList = Uint8List(8);
    for (var i = 0; i < intList.length; i++) {
      intList[i] = i;
    }

    var object = TypesList(
      aByteData: [ByteData.view(intList.buffer)],
    );

    var jsonMap = object.allToJson();

    expect(jsonMap, {
      'aByteData': ['decode(\'AAECAwQFBgc=\', \'base64\')']
    });
  });

  test(
      'Given a class with a List with a nested Duration when calling toJson the entire nested structure is converted.',
      () {
    var object = TypesList(
      aDuration: [Duration(seconds: 1)],
    );

    var jsonMap = object.allToJson();

    expect(jsonMap, {
      'aDuration': [1000]
    });
  });

  test(
      'Given a class with a List with a nested Uuid when calling toJson the entire nested structure is converted.',
      () {
    var object = TypesList(
      aUuid: [UuidValue.nil],
    );

    var jsonMap = object.allToJson();

    expect(jsonMap, {
      'aUuid': ['00000000-0000-0000-0000-000000000000']
    });
  });

  test(
      'Given a class with a List with a nested enum serialized by index when calling toJson the entire nested structure is converted.',
      () {
    var object = TypesList(
      anEnum: [TestEnum.one],
    );

    var jsonMap = object.allToJson();

    expect(jsonMap, {
      'anEnum': [0]
    });
  });

  test(
      'Given a class with a List with a nested enum serialized by name when calling toJson the entire nested structure is converted.',
      () {
    var object = TypesList(
      aStringifiedEnum: [TestEnumStringified.one],
    );

    var jsonMap = object.allToJson();

    expect(jsonMap, {
      'aStringifiedEnum': ['one']
    });
  });

  test(
      'Given a class with a List with a nested Map serialized by name when calling toJson the entire nested structure is converted.',
      () {
    var type = Types(anInt: 123);
    var object = TypesList(aMap: [
      {'key': type}
    ]);

    var jsonMap = object.allToJson();

    expect(jsonMap, {
      'aMap': [
        {
          'key': {'anInt': 123}
        }
      ]
    });
  });

  test(
      'Given a class with a List with a nested List serialized by name when calling toJson the entire nested structure is converted.',
      () {
    var type = Types(anInt: 123);
    var object = TypesList(aList: [
      [type]
    ]);

    var jsonMap = object.allToJson();

    expect(jsonMap, {
      'aList': [
        [
          {'anInt': 123}
        ]
      ]
    });
  });

  group('Map value -', () {
    test(
        'Given a class with a Map with a nested object when calling toJson the entire nested structure is converted.',
        () {
      var type = Types(anInt: 123);
      var object = TypesMap(anObjectValue: {'key': type});

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'anObjectValue': {
          'key': {'anInt': 123}
        }
      });
    });

    test(
        'Given a class with a Map with a nested DateTime when calling toJson the entire nested structure is converted.',
        () {
      var object = TypesMap(
        aDateTimeValue: {'key': DateTime.parse('2024-01-01T00:00:00.000Z')},
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'aDateTimeValue': {'key': '2024-01-01T00:00:00.000Z'}
      });
    });

    test(
        'Given a class with a Map with a nested ByteData when calling toJson the entire nested structure is converted.',
        () {
      var intList = Uint8List(8);
      for (var i = 0; i < intList.length; i++) {
        intList[i] = i;
      }

      var object = TypesMap(
        aByteDataValue: {'key': ByteData.view(intList.buffer)},
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'aByteDataValue': {'key': 'decode(\'AAECAwQFBgc=\', \'base64\')'}
      });
    });

    test(
        'Given a class with a Map with a nested Duration when calling toJson the entire nested structure is converted.',
        () {
      var object = TypesMap(
        aDurationValue: {'key': Duration(seconds: 1)},
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'aDurationValue': {'key': 1000}
      });
    });

    test(
        'Given a class with a Map with a nested Uuid when calling toJson the entire nested structure is converted.',
        () {
      var object = TypesMap(
        aUuidValue: {'key': UuidValue.nil},
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'aUuidValue': {'key': '00000000-0000-0000-0000-000000000000'}
      });
    });

    test(
        'Given a class with a Map with a nested enum serialized by index when calling toJson the entire nested structure is converted.',
        () {
      var object = TypesMap(
        anEnumValue: {'key': TestEnum.one},
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'anEnumValue': {'key': 0}
      });
    });

    test(
        'Given a class with a Map with a nested enum serialized by name when calling toJson the entire nested structure is converted.',
        () {
      var object = TypesMap(
        aStringifiedEnumValue: {'key': TestEnumStringified.one},
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'aStringifiedEnumValue': {'key': 'one'}
      });
    });

    test(
        'Given a class with a Map with a nested Map serialized by name when calling toJson the entire nested structure is converted.',
        () {
      var type = Types(anInt: 1);
      var object = TypesMap(
        aMapValue: {
          'key': {'key': type}
        },
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'aMapValue': {
          'key': {
            'key': {'anInt': 1}
          }
        }
      });
    });

    test(
        'Given a class with a Map with a nested List serialized by name when calling toJson the entire nested structure is converted.',
        () {
      var type = Types(anInt: 1);
      var object = TypesMap(
        aListValue: {
          'key': [type]
        },
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'aListValue': {
          'key': [
            {'anInt': 1}
          ]
        }
      });
    });
  });

  group('Map key -', () {
    test(
        'Given a class with a Map with a nested object when calling toJson the entire nested structure is converted.',
        () {
      var type = Types(anInt: 123);
      var object = TypesMap(anObjectKey: {type: 'value'});

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'anObjectKey': [
          {
            'k': {'anInt': 123},
            'v': 'value'
          }
        ]
      });
    });

    test(
        'Given a class with a Map with a nested DateTime when calling toJson the entire nested structure is converted.',
        () {
      var object = TypesMap(
        aDateTimeKey: {DateTime.parse('2024-01-01T00:00:00.000Z'): 'value'},
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'aDateTimeKey': [
          {'k': '2024-01-01T00:00:00.000Z', 'v': 'value'}
        ]
      });
    });

    test(
        'Given a class with a Map with a nested ByteData when calling toJson the entire nested structure is converted.',
        () {
      var intList = Uint8List(8);
      for (var i = 0; i < intList.length; i++) {
        intList[i] = i;
      }

      var object = TypesMap(
        aByteDataKey: {ByteData.view(intList.buffer): 'value'},
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'aByteDataKey': [
          {'k': 'decode(\'AAECAwQFBgc=\', \'base64\')', 'v': 'value'}
        ]
      });
    });

    test(
        'Given a class with a Map with a nested Duration when calling toJson the entire nested structure is converted.',
        () {
      var object = TypesMap(
        aDurationKey: {Duration(seconds: 1): 'value'},
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'aDurationKey': [
          {'k': 1000, 'v': 'value'}
        ]
      });
    });

    test(
        'Given a class with a Map with a nested Uuid when calling toJson the entire nested structure is converted.',
        () {
      var object = TypesMap(
        aUuidKey: {UuidValue.nil: 'value'},
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'aUuidKey': [
          {'k': '00000000-0000-0000-0000-000000000000', 'v': 'value'}
        ]
      });
    });

    test(
        'Given a class with a Map with a nested enum serialized by index when calling toJson the entire nested structure is converted.',
        () {
      var object = TypesMap(
        anEnumKey: {TestEnum.one: 'value'},
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'anEnumKey': [
          {'k': 0, 'v': 'value'}
        ]
      });
    });

    test(
        'Given a class with a Map with a nested enum serialized by name when calling toJson the entire nested structure is converted.',
        () {
      var object = TypesMap(
        aStringifiedEnumKey: {TestEnumStringified.one: 'value'},
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'aStringifiedEnumKey': [
          {'k': 'one', 'v': 'value'}
        ]
      });
    });

    test(
        'Given a class with a Map with a nested Map serialized by name when calling toJson the entire nested structure is converted.',
        () {
      var type = Types(anInt: 1);
      var object = TypesMap(
        aMapKey: {
          {type: 'value'}: 'value'
        },
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'aMapKey': [
          {
            'k': [
              {
                'k': {'anInt': 1},
                'v': 'value'
              }
            ],
            'v': 'value'
          }
        ]
      });
    });

    test(
        'Given a class with a Map with a nested List serialized by name when calling toJson the entire nested structure is converted.',
        () {
      var type = Types(anInt: 1);
      var object = TypesMap(
        aListKey: {
          [type]: 'value'
        },
      );

      var jsonMap = object.allToJson();

      expect(jsonMap, {
        'aListKey': [
          {
            'k': [
              {'anInt': 1}
            ],
            'v': 'value'
          }
        ]
      });
    });
  });

  test('Given an object with a server only field then field is serialized.',
      () {
    var object = ScopeServerOnlyField(
      nested: ScopeServerOnlyField(
        allScope: Types(anInt: 1),
        serverOnlyScope: Types(anInt: 2),
      ),
    );

    var jsonMap = object.allToJson();

    expect(jsonMap, {
      'nested': {
        'allScope': {'anInt': 1},
        'serverOnlyScope': {'anInt': 2},
      },
    });
  });
}
