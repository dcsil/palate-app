import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/boolean_map_struct.dart';

void main() {
  group('BooleanMapStruct', () {
    test('constructor with parameters', () {
      final map = BooleanMapStruct(key: 'test', value: true);
      expect(map.key, 'test');
      expect(map.value, true);
    });

    test('default values', () {
      final map = BooleanMapStruct();
      expect(map.key, '');
      expect(map.value, false);
    });

    test('setters and hasers', () {
      final map = BooleanMapStruct();
      expect(map.hasKey(), false);
      expect(map.hasValue(), false);

      map.key = 'enabled';
      map.value = true;
      expect(map.hasKey(), true);
      expect(map.hasValue(), true);
      expect(map.key, 'enabled');
      expect(map.value, true);
    });

    test('fromMap', () {
      final data = {'key': 'feature', 'value': true};
      final map = BooleanMapStruct.fromMap(data);
      expect(map.key, 'feature');
      expect(map.value, true);
    });

    test('maybeFromMap with valid map', () {
      final map = BooleanMapStruct.maybeFromMap({'key': 'k', 'value': false});
      expect(map, isNotNull);
      expect(map!.key, 'k');
      expect(map.value, false);
    });

    test('maybeFromMap with invalid data', () {
      expect(BooleanMapStruct.maybeFromMap(null), null);
      expect(BooleanMapStruct.maybeFromMap('string'), null);
    });

    test('toMap', () {
      final map = BooleanMapStruct(key: 'test', value: true);
      final data = map.toMap();
      expect(data['key'], 'test');
      expect(data['value'], true);
    });

    test('serialization roundtrip', () {
      final original = BooleanMapStruct(key: 'flag', value: true);
      final serialized = original.toSerializableMap();
      final reconstructed = BooleanMapStruct.fromSerializableMap(serialized);
      expect(reconstructed.key, original.key);
      expect(reconstructed.value, original.value);
    });

    test('equality', () {
      final map1 = BooleanMapStruct(key: 'same', value: true);
      final map2 = BooleanMapStruct(key: 'same', value: true);
      final map3 = BooleanMapStruct(key: 'different', value: false);
      expect(map1 == map2, true);
      expect(map1 == map3, false);
    });

    test('toString', () {
      final map = BooleanMapStruct(key: 'test', value: true);
      expect(map.toString(), contains('BooleanMapStruct'));
    });
  });
}
