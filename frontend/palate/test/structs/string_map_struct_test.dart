import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/string_map_struct.dart';

void main() {
  group('StringMapStruct', () {
    test('constructor with parameters', () {
      final map = StringMapStruct(
        key: 'testKey',
        value: 'testValue',
      );

      expect(map.key, 'testKey');
      expect(map.value, 'testValue');
    });

    test('constructor with default values', () {
      final map = StringMapStruct();
      expect(map.key, '');
      expect(map.value, '');
    });

    test('key setter and hasKey', () {
      final map = StringMapStruct();
      expect(map.hasKey(), false);

      map.key = 'myKey';
      expect(map.key, 'myKey');
      expect(map.hasKey(), true);
    });

    test('value setter and hasValue', () {
      final map = StringMapStruct();
      expect(map.hasValue(), false);

      map.value = 'myValue';
      expect(map.value, 'myValue');
      expect(map.hasValue(), true);
    });

    test('fromMap creates struct', () {
      final data = {
        'key': 'fromMapKey',
        'value': 'fromMapValue',
      };

      final map = StringMapStruct.fromMap(data);
      expect(map.key, 'fromMapKey');
      expect(map.value, 'fromMapValue');
    });

    test('maybeFromMap with valid map', () {
      final data = {'key': 'k1', 'value': 'v1'};
      final map = StringMapStruct.maybeFromMap(data);
      
      expect(map, isNotNull);
      expect(map!.key, 'k1');
      expect(map.value, 'v1');
    });

    test('maybeFromMap with non-map returns null', () {
      expect(StringMapStruct.maybeFromMap(null), null);
      expect(StringMapStruct.maybeFromMap('string'), null);
      expect(StringMapStruct.maybeFromMap(123), null);
    });

    test('toMap returns correct map', () {
      final stringMap = StringMapStruct(key: 'k', value: 'v');
      final data = stringMap.toMap();

      expect(data['key'], 'k');
      expect(data['value'], 'v');
    });

    test('toSerializableMap', () {
      final stringMap = StringMapStruct(key: 'serKey', value: 'serValue');
      final data = stringMap.toSerializableMap();

      expect(data.containsKey('key'), true);
      expect(data.containsKey('value'), true);
    });

    test('fromSerializableMap reconstructs struct', () {
      final original = StringMapStruct(key: 'original', value: 'data');
      final serialized = original.toSerializableMap();
      final reconstructed = StringMapStruct.fromSerializableMap(serialized);

      expect(reconstructed.key, original.key);
      expect(reconstructed.value, original.value);
    });

    test('toString produces valid output', () {
      final map = StringMapStruct(key: 'k', value: 'v');
      final str = map.toString();
      expect(str, contains('StringMapStruct'));
    });

    test('equality operator', () {
      final map1 = StringMapStruct(key: 'same', value: 'value');
      final map2 = StringMapStruct(key: 'same', value: 'value');
      final map3 = StringMapStruct(key: 'different', value: 'value');

      expect(map1 == map2, true);
      expect(map1 == map3, false);
    });

    test('hashCode consistency', () {
      final map1 = StringMapStruct(key: 'k', value: 'v');
      final map2 = StringMapStruct(key: 'k', value: 'v');

      expect(map1.hashCode, map2.hashCode);
    });
  });
}
