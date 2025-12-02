import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/open_struct.dart';

void main() {
  group('OpenStruct', () {
    test('constructor with all parameters', () {
      final open = OpenStruct(
        day: 1,
        hour: 9,
        minute: 30,
      );

      expect(open.day, 1);
      expect(open.hour, 9);
      expect(open.minute, 30);
    });

    test('constructor with default values', () {
      final open = OpenStruct();
      expect(open.day, 0);
      expect(open.hour, 0);
      expect(open.minute, 0);
    });

    test('day setter and hasDay', () {
      final open = OpenStruct();
      expect(open.hasDay(), false);

      open.day = 5;
      expect(open.day, 5);
      expect(open.hasDay(), true);
    });

    test('hour setter and hasHour', () {
      final open = OpenStruct();
      expect(open.hasHour(), false);

      open.hour = 14;
      expect(open.hour, 14);
      expect(open.hasHour(), true);
    });

    test('minute setter and hasMinute', () {
      final open = OpenStruct();
      expect(open.hasMinute(), false);

      open.minute = 45;
      expect(open.minute, 45);
      expect(open.hasMinute(), true);
    });

    test('incrementDay', () {
      final open = OpenStruct(day: 2);
      open.incrementDay(3);
      expect(open.day, 5);
    });

    test('incrementHour', () {
      final open = OpenStruct(hour: 10);
      open.incrementHour(2);
      expect(open.hour, 12);
    });

    test('incrementMinute', () {
      final open = OpenStruct(minute: 15);
      open.incrementMinute(30);
      expect(open.minute, 45);
    });

    test('fromMap creates struct', () {
      final map = {
        'day': 3,
        'hour': 8,
        'minute': 0,
      };

      final open = OpenStruct.fromMap(map);
      expect(open.day, 3);
      expect(open.hour, 8);
      expect(open.minute, 0);
    });

    test('maybeFromMap with valid map', () {
      final map = {'day': 6, 'hour': 18, 'minute': 30};
      final open = OpenStruct.maybeFromMap(map);
      
      expect(open, isNotNull);
      expect(open!.day, 6);
      expect(open.hour, 18);
      expect(open.minute, 30);
    });

    test('maybeFromMap with non-map returns null', () {
      expect(OpenStruct.maybeFromMap(null), null);
      expect(OpenStruct.maybeFromMap('string'), null);
      expect(OpenStruct.maybeFromMap(123), null);
    });

    test('toMap returns correct map', () {
      final open = OpenStruct(day: 4, hour: 12, minute: 15);
      final map = open.toMap();

      expect(map['day'], 4);
      expect(map['hour'], 12);
      expect(map['minute'], 15);
    });

    test('toSerializableMap', () {
      final open = OpenStruct(day: 2, hour: 10, minute: 30);
      final map = open.toSerializableMap();

      expect(map.containsKey('day'), true);
      expect(map.containsKey('hour'), true);
      expect(map.containsKey('minute'), true);
    });

    test('fromSerializableMap reconstructs struct', () {
      final original = OpenStruct(day: 7, hour: 23, minute: 59);
      final serialized = original.toSerializableMap();
      final reconstructed = OpenStruct.fromSerializableMap(serialized);

      expect(reconstructed.day, original.day);
      expect(reconstructed.hour, original.hour);
      expect(reconstructed.minute, original.minute);
    });

    test('toString produces valid output', () {
      final open = OpenStruct(day: 1, hour: 9, minute: 0);
      final str = open.toString();
      expect(str, contains('OpenStruct'));
    });

    test('equality operator', () {
      final open1 = OpenStruct(day: 3, hour: 14, minute: 30);
      final open2 = OpenStruct(day: 3, hour: 14, minute: 30);
      final open3 = OpenStruct(day: 4, hour: 14, minute: 30);

      expect(open1 == open2, true);
      expect(open1 == open3, false);
    });

    test('hashCode consistency', () {
      final open1 = OpenStruct(day: 5, hour: 17, minute: 45);
      final open2 = OpenStruct(day: 5, hour: 17, minute: 45);

      expect(open1.hashCode, open2.hashCode);
    });
  });
}
