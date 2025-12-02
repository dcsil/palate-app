import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/close_struct.dart';

void main() {
  group('CloseStruct', () {
    test('constructor with all parameters', () {
      final close = CloseStruct(
        day: 1,
        hour: 22,
        minute: 0,
      );

      expect(close.day, 1);
      expect(close.hour, 22);
      expect(close.minute, 0);
    });

    test('constructor with default values', () {
      final close = CloseStruct();
      expect(close.day, 0);
      expect(close.hour, 0);
      expect(close.minute, 0);
    });

    test('day setter and hasDay', () {
      final close = CloseStruct();
      expect(close.hasDay(), false);

      close.day = 6;
      expect(close.day, 6);
      expect(close.hasDay(), true);
    });

    test('hour setter and hasHour', () {
      final close = CloseStruct();
      expect(close.hasHour(), false);

      close.hour = 23;
      expect(close.hour, 23);
      expect(close.hasHour(), true);
    });

    test('minute setter and hasMinute', () {
      final close = CloseStruct();
      expect(close.hasMinute(), false);

      close.minute = 30;
      expect(close.minute, 30);
      expect(close.hasMinute(), true);
    });

    test('incrementDay', () {
      final close = CloseStruct(day: 1);
      close.incrementDay(2);
      expect(close.day, 3);
    });

    test('incrementHour', () {
      final close = CloseStruct(hour: 20);
      close.incrementHour(3);
      expect(close.hour, 23);
    });

    test('incrementMinute', () {
      final close = CloseStruct(minute: 0);
      close.incrementMinute(45);
      expect(close.minute, 45);
    });

    test('fromMap creates struct', () {
      final map = {
        'day': 5,
        'hour': 21,
        'minute': 30,
      };

      final close = CloseStruct.fromMap(map);
      expect(close.day, 5);
      expect(close.hour, 21);
      expect(close.minute, 30);
    });

    test('maybeFromMap with valid map', () {
      final map = {'day': 7, 'hour': 23, 'minute': 59};
      final close = CloseStruct.maybeFromMap(map);
      
      expect(close, isNotNull);
      expect(close!.day, 7);
      expect(close.hour, 23);
      expect(close.minute, 59);
    });

    test('maybeFromMap with non-map returns null', () {
      expect(CloseStruct.maybeFromMap(null), null);
      expect(CloseStruct.maybeFromMap('string'), null);
      expect(CloseStruct.maybeFromMap(123), null);
    });

    test('toMap returns correct map', () {
      final close = CloseStruct(day: 3, hour: 18, minute: 45);
      final map = close.toMap();

      expect(map['day'], 3);
      expect(map['hour'], 18);
      expect(map['minute'], 45);
    });

    test('toSerializableMap', () {
      final close = CloseStruct(day: 4, hour: 22, minute: 0);
      final map = close.toSerializableMap();

      expect(map.containsKey('day'), true);
      expect(map.containsKey('hour'), true);
      expect(map.containsKey('minute'), true);
    });

    test('fromSerializableMap reconstructs struct', () {
      final original = CloseStruct(day: 6, hour: 20, minute: 30);
      final serialized = original.toSerializableMap();
      final reconstructed = CloseStruct.fromSerializableMap(serialized);

      expect(reconstructed.day, original.day);
      expect(reconstructed.hour, original.hour);
      expect(reconstructed.minute, original.minute);
    });

    test('toString produces valid output', () {
      final close = CloseStruct(day: 1, hour: 23, minute: 0);
      final str = close.toString();
      expect(str, contains('CloseStruct'));
    });

    test('equality operator', () {
      final close1 = CloseStruct(day: 2, hour: 22, minute: 30);
      final close2 = CloseStruct(day: 2, hour: 22, minute: 30);
      final close3 = CloseStruct(day: 3, hour: 22, minute: 30);

      expect(close1 == close2, true);
      expect(close1 == close3, false);
    });

    test('hashCode consistency', () {
      final close1 = CloseStruct(day: 4, hour: 21, minute: 15);
      final close2 = CloseStruct(day: 4, hour: 21, minute: 15);

      expect(close1.hashCode, close2.hashCode);
    });
  });
}
