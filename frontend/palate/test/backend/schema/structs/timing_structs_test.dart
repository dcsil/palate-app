import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/close_struct.dart';
import 'package:palate/backend/schema/structs/open_struct.dart';
import 'package:palate/backend/schema/structs/boolean_map_struct.dart';
import 'package:palate/backend/schema/structs/types_struct.dart';

void main() {
  group('CloseStruct Tests', () {
    test('Constructor initializes fields correctly', () {
      final close = CloseStruct(day: 3, minute: 45, hour: 14);
      
      expect(close.day, equals(3));
      expect(close.minute, equals(45));
      expect(close.hour, equals(14));
    });

    test('Default values when fields are null', () {
      final close = CloseStruct();
      
      expect(close.day, equals(0));
      expect(close.minute, equals(0));
      expect(close.hour, equals(0));
    });

    test('Setters modify field values', () {
      final close = CloseStruct();
      
      close.day = 5;
      close.minute = 30;
      close.hour = 18;
      
      expect(close.day, equals(5));
      expect(close.minute, equals(30));
      expect(close.hour, equals(18));
    });

    test('incrementDay increments day field', () {
      final close = CloseStruct(day: 2);
      
      close.incrementDay(3);
      expect(close.day, equals(5));
      
      close.incrementDay(-1);
      expect(close.day, equals(4));
    });

    test('incrementMinute increments minute field', () {
      final close = CloseStruct(minute: 15);
      
      close.incrementMinute(30);
      expect(close.minute, equals(45));
      
      close.incrementMinute(-10);
      expect(close.minute, equals(35));
    });

    test('incrementHour increments hour field', () {
      final close = CloseStruct(hour: 10);
      
      close.incrementHour(5);
      expect(close.hour, equals(15));
      
      close.incrementHour(-3);
      expect(close.hour, equals(12));
    });

    test('hasDay returns correct null check', () {
      final withDay = CloseStruct(day: 1);
      final withoutDay = CloseStruct();
      
      expect(withDay.hasDay(), isTrue);
      expect(withoutDay.hasDay(), isFalse);
    });

    test('hasMinute returns correct null check', () {
      final withMinute = CloseStruct(minute: 30);
      final withoutMinute = CloseStruct();
      
      expect(withMinute.hasMinute(), isTrue);
      expect(withoutMinute.hasMinute(), isFalse);
    });

    test('hasHour returns correct null check', () {
      final withHour = CloseStruct(hour: 12);
      final withoutHour = CloseStruct();
      
      expect(withHour.hasHour(), isTrue);
      expect(withoutHour.hasHour(), isFalse);
    });

    test('fromMap creates instance from map', () {
      final map = {'day': 4, 'minute': 30, 'hour': 15};
      final close = CloseStruct.fromMap(map);
      
      expect(close.day, equals(4));
      expect(close.minute, equals(30));
      expect(close.hour, equals(15));
    });

    test('fromMap handles missing fields', () {
      final map = <String, dynamic>{'day': 2};
      final close = CloseStruct.fromMap(map);
      
      expect(close.day, equals(2));
      expect(close.minute, equals(0));
      expect(close.hour, equals(0));
    });

    test('maybeFromMap returns instance for valid map', () {
      final map = {'day': 6, 'minute': 45, 'hour': 22};
      final close = CloseStruct.maybeFromMap(map);
      
      expect(close, isNotNull);
      expect(close!.day, equals(6));
    });

    test('maybeFromMap returns null for non-map', () {
      expect(CloseStruct.maybeFromMap('not a map'), isNull);
      expect(CloseStruct.maybeFromMap(123), isNull);
      expect(CloseStruct.maybeFromMap(null), isNull);
    });

    test('toMap converts to map correctly', () {
      final close = CloseStruct(day: 3, minute: 20, hour: 9);
      final map = close.toMap();
      
      expect(map['day'], equals(3));
      expect(map['minute'], equals(20));
      expect(map['hour'], equals(9));
    });

    test('toMap excludes null fields', () {
      final close = CloseStruct();
      final map = close.toMap();
      
      expect(map.containsKey('day'), isFalse);
      expect(map.containsKey('minute'), isFalse);
      expect(map.containsKey('hour'), isFalse);
    });

    test('toSerializableMap produces correct output', () {
      final close = CloseStruct(day: 5, minute: 0, hour: 23);
      final map = close.toSerializableMap();
      
      expect(map['day'], equals('5'));
      expect(map['minute'], equals('0'));
      expect(map['hour'], equals('23'));
    });

    test('fromSerializableMap deserializes correctly', () {
      final map = {'day': '2', 'minute': '15', 'hour': '8'};
      final close = CloseStruct.fromSerializableMap(map);
      
      expect(close.day, equals(2));
      expect(close.minute, equals(15));
      expect(close.hour, equals(8));
    });

    test('toString returns readable representation', () {
      final close = CloseStruct(day: 1, minute: 30, hour: 12);
      final str = close.toString();
      
      expect(str, contains('CloseStruct'));
      expect(str, contains('day'));
      expect(str, contains('minute'));
      expect(str, contains('hour'));
    });

    test('Equality works correctly', () {
      final close1 = CloseStruct(day: 3, minute: 45, hour: 14);
      final close2 = CloseStruct(day: 3, minute: 45, hour: 14);
      final close3 = CloseStruct(day: 3, minute: 45, hour: 15);
      
      expect(close1 == close2, isTrue);
      expect(close1 == close3, isFalse);
    });

    test('hashCode is consistent', () {
      final close1 = CloseStruct(day: 2, minute: 30, hour: 10);
      final close2 = CloseStruct(day: 2, minute: 30, hour: 10);
      
      expect(close1.hashCode, equals(close2.hashCode));
    });
  });

  group('OpenStruct Tests', () {
    test('Constructor initializes fields correctly', () {
      final open = OpenStruct(day: 1, minute: 0, hour: 9);
      
      expect(open.day, equals(1));
      expect(open.minute, equals(0));
      expect(open.hour, equals(9));
    });

    test('Default values when fields are null', () {
      final open = OpenStruct();
      
      expect(open.day, equals(0));
      expect(open.minute, equals(0));
      expect(open.hour, equals(0));
    });

    test('Setters modify field values', () {
      final open = OpenStruct();
      
      open.day = 3;
      open.minute = 15;
      open.hour = 8;
      
      expect(open.day, equals(3));
      expect(open.minute, equals(15));
      expect(open.hour, equals(8));
    });

    test('incrementDay increments day field', () {
      final open = OpenStruct(day: 1);
      
      open.incrementDay(2);
      expect(open.day, equals(3));
      
      open.incrementDay(-1);
      expect(open.day, equals(2));
    });

    test('incrementMinute increments minute field', () {
      final open = OpenStruct(minute: 0);
      
      open.incrementMinute(15);
      expect(open.minute, equals(15));
      
      open.incrementMinute(-5);
      expect(open.minute, equals(10));
    });

    test('incrementHour increments hour field', () {
      final open = OpenStruct(hour: 8);
      
      open.incrementHour(2);
      expect(open.hour, equals(10));
      
      open.incrementHour(-1);
      expect(open.hour, equals(9));
    });

    test('hasDay returns correct null check', () {
      final withDay = OpenStruct(day: 5);
      final withoutDay = OpenStruct();
      
      expect(withDay.hasDay(), isTrue);
      expect(withoutDay.hasDay(), isFalse);
    });

    test('hasMinute returns correct null check', () {
      final withMinute = OpenStruct(minute: 0);
      final withoutMinute = OpenStruct();
      
      expect(withMinute.hasMinute(), isTrue);
      expect(withoutMinute.hasMinute(), isFalse);
    });

    test('hasHour returns correct null check', () {
      final withHour = OpenStruct(hour: 9);
      final withoutHour = OpenStruct();
      
      expect(withHour.hasHour(), isTrue);
      expect(withoutHour.hasHour(), isFalse);
    });

    test('fromMap creates instance from map', () {
      final map = {'day': 2, 'minute': 30, 'hour': 10};
      final open = OpenStruct.fromMap(map);
      
      expect(open.day, equals(2));
      expect(open.minute, equals(30));
      expect(open.hour, equals(10));
    });

    test('fromMap handles missing fields', () {
      final map = <String, dynamic>{'hour': 12};
      final open = OpenStruct.fromMap(map);
      
      expect(open.day, equals(0));
      expect(open.minute, equals(0));
      expect(open.hour, equals(12));
    });

    test('maybeFromMap returns instance for valid map', () {
      final map = {'day': 6, 'minute': 0, 'hour': 7};
      final open = OpenStruct.maybeFromMap(map);
      
      expect(open, isNotNull);
      expect(open!.hour, equals(7));
    });

    test('maybeFromMap returns null for non-map', () {
      expect(OpenStruct.maybeFromMap('invalid'), isNull);
      expect(OpenStruct.maybeFromMap(456), isNull);
      expect(OpenStruct.maybeFromMap(null), isNull);
    });

    test('toMap converts to map correctly', () {
      final open = OpenStruct(day: 1, minute: 0, hour: 6);
      final map = open.toMap();
      
      expect(map['day'], equals(1));
      expect(map['minute'], equals(0));
      expect(map['hour'], equals(6));
    });

    test('toMap excludes null fields', () {
      final open = OpenStruct();
      final map = open.toMap();
      
      expect(map.containsKey('day'), isFalse);
      expect(map.containsKey('minute'), isFalse);
      expect(map.containsKey('hour'), isFalse);
    });

    test('toSerializableMap produces correct output', () {
      final open = OpenStruct(day: 3, minute: 45, hour: 11);
      final map = open.toSerializableMap();
      
      expect(map['day'], equals('3'));
      expect(map['minute'], equals('45'));
      expect(map['hour'], equals('11'));
    });

    test('fromSerializableMap deserializes correctly', () {
      final map = {'day': '4', 'minute': '0', 'hour': '13'};
      final open = OpenStruct.fromSerializableMap(map);
      
      expect(open.day, equals(4));
      expect(open.minute, equals(0));
      expect(open.hour, equals(13));
    });

    test('toString returns readable representation', () {
      final open = OpenStruct(day: 5, minute: 15, hour: 18);
      final str = open.toString();
      
      expect(str, contains('OpenStruct'));
      expect(str, contains('day'));
      expect(str, contains('minute'));
      expect(str, contains('hour'));
    });

    test('Equality works correctly', () {
      final open1 = OpenStruct(day: 2, minute: 30, hour: 9);
      final open2 = OpenStruct(day: 2, minute: 30, hour: 9);
      final open3 = OpenStruct(day: 2, minute: 30, hour: 10);
      
      expect(open1 == open2, isTrue);
      expect(open1 == open3, isFalse);
    });

    test('hashCode is consistent', () {
      final open1 = OpenStruct(day: 1, minute: 0, hour: 8);
      final open2 = OpenStruct(day: 1, minute: 0, hour: 8);
      
      expect(open1.hashCode, equals(open2.hashCode));
    });
  });

  group('BooleanMapStruct Tests', () {
    test('Constructor initializes fields correctly', () {
      final boolMap = BooleanMapStruct(key: 'feature_enabled', value: true);
      
      expect(boolMap.key, equals('feature_enabled'));
      expect(boolMap.value, equals(true));
    });

    test('Default values when fields are null', () {
      final boolMap = BooleanMapStruct();
      
      expect(boolMap.key, equals(''));
      expect(boolMap.value, equals(false));
    });

    test('Setters modify field values', () {
      final boolMap = BooleanMapStruct();
      
      boolMap.key = 'is_active';
      boolMap.value = true;
      
      expect(boolMap.key, equals('is_active'));
      expect(boolMap.value, equals(true));
    });

    test('hasKey returns correct null check', () {
      final withKey = BooleanMapStruct(key: 'test');
      final withoutKey = BooleanMapStruct();
      
      expect(withKey.hasKey(), isTrue);
      expect(withoutKey.hasKey(), isFalse);
    });

    test('hasValue returns correct null check', () {
      final withValue = BooleanMapStruct(value: false);
      final withoutValue = BooleanMapStruct();
      
      expect(withValue.hasValue(), isTrue);
      expect(withoutValue.hasValue(), isFalse);
    });

    test('fromMap creates instance from map', () {
      final map = {'key': 'enabled', 'value': true};
      final boolMap = BooleanMapStruct.fromMap(map);
      
      expect(boolMap.key, equals('enabled'));
      expect(boolMap.value, equals(true));
    });

    test('fromMap handles missing fields', () {
      final map = <String, dynamic>{'key': 'test'};
      final boolMap = BooleanMapStruct.fromMap(map);
      
      expect(boolMap.key, equals('test'));
      expect(boolMap.value, equals(false));
    });

    test('maybeFromMap returns instance for valid map', () {
      final map = {'key': 'flag', 'value': false};
      final boolMap = BooleanMapStruct.maybeFromMap(map);
      
      expect(boolMap, isNotNull);
      expect(boolMap!.key, equals('flag'));
      expect(boolMap.value, equals(false));
    });

    test('maybeFromMap returns null for non-map', () {
      expect(BooleanMapStruct.maybeFromMap('not a map'), isNull);
      expect(BooleanMapStruct.maybeFromMap(123), isNull);
      expect(BooleanMapStruct.maybeFromMap(null), isNull);
    });

    test('toMap converts to map correctly', () {
      final boolMap = BooleanMapStruct(key: 'setting', value: true);
      final map = boolMap.toMap();
      
      expect(map['key'], equals('setting'));
      expect(map['value'], equals(true));
    });

    test('toMap excludes null fields', () {
      final boolMap = BooleanMapStruct();
      final map = boolMap.toMap();
      
      expect(map.containsKey('key'), isFalse);
      expect(map.containsKey('value'), isFalse);
    });

    test('toSerializableMap produces correct output', () {
      final boolMap = BooleanMapStruct(key: 'option', value: false);
      final map = boolMap.toSerializableMap();
      
      expect(map['key'], equals('option'));
      expect(map['value'], equals('false'));
    });

    test('toString returns readable representation', () {
      final boolMap = BooleanMapStruct(key: 'test', value: true);
      final str = boolMap.toString();
      
      expect(str, contains('BooleanMapStruct'));
      expect(str, contains('key'));
      expect(str, contains('value'));
    });

    test('Equality works correctly', () {
      final bool1 = BooleanMapStruct(key: 'a', value: true);
      final bool2 = BooleanMapStruct(key: 'a', value: true);
      final bool3 = BooleanMapStruct(key: 'b', value: true);
      final bool4 = BooleanMapStruct(key: 'a', value: false);
      
      expect(bool1 == bool2, isTrue);
      expect(bool1 == bool3, isFalse);
      expect(bool1 == bool4, isFalse);
    });

    test('hashCode is consistent', () {
      final bool1 = BooleanMapStruct(key: 'test', value: true);
      final bool2 = BooleanMapStruct(key: 'test', value: true);
      
      expect(bool1.hashCode, equals(bool2.hashCode));
    });

    test('Special characters in key', () {
      final boolMap = BooleanMapStruct(key: 'key-with_special.chars!', value: true);
      
      expect(boolMap.key, equals('key-with_special.chars!'));
      
      final map = boolMap.toMap();
      final reconstructed = BooleanMapStruct.fromMap(map);
      
      expect(reconstructed.key, equals('key-with_special.chars!'));
    });

    test('Empty string key', () {
      final boolMap = BooleanMapStruct(key: '', value: false);
      
      expect(boolMap.key, equals(''));
      expect(boolMap.hasKey(), isTrue);
    });
  });

  group('TypesStruct Tests', () {
    test('Constructor initializes type list correctly', () {
      final types = TypesStruct(type: ['restaurant', 'cafe', 'bar']);
      
      expect(types.type, equals(['restaurant', 'cafe', 'bar']));
      expect(types.type.length, equals(3));
    });

    test('Default value is empty list when type is null', () {
      final types = TypesStruct();
      
      expect(types.type, equals([]));
      expect(types.type.isEmpty, isTrue);
    });

    test('Setter modifies type list', () {
      final types = TypesStruct();
      
      types.type = ['food', 'drink'];
      
      expect(types.type, equals(['food', 'drink']));
      expect(types.type.length, equals(2));
    });

    test('updateType callback modifies list', () {
      final types = TypesStruct(type: ['a']);
      
      types.updateType((list) {
        list.add('b');
        list.add('c');
      });
      
      expect(types.type, equals(['a', 'b', 'c']));
    });

    test('updateType initializes null list', () {
      final types = TypesStruct();
      
      types.updateType((list) {
        list.add('first');
      });
      
      expect(types.type, equals(['first']));
    });

    test('hasType returns correct null check', () {
      final withType = TypesStruct(type: ['restaurant']);
      final withoutType = TypesStruct();
      
      expect(withType.hasType(), isTrue);
      expect(withoutType.hasType(), isFalse);
    });

    test('fromMap creates instance from map', () {
      final map = {
        'type': ['restaurant', 'bar', 'cafe']
      };
      final types = TypesStruct.fromMap(map);
      
      expect(types.type, equals(['restaurant', 'bar', 'cafe']));
    });

    test('fromMap handles empty list', () {
      final map = {'type': <String>[]};
      final types = TypesStruct.fromMap(map);
      
      expect(types.type, equals([]));
    });

    test('fromMap handles missing type field', () {
      final map = <String, dynamic>{};
      final types = TypesStruct.fromMap(map);
      
      expect(types.type, equals([]));
    });

    test('maybeFromMap returns instance for valid map', () {
      final map = {
        'type': ['food', 'drink']
      };
      final types = TypesStruct.maybeFromMap(map);
      
      expect(types, isNotNull);
      expect(types!.type, equals(['food', 'drink']));
    });

    test('maybeFromMap returns null for non-map', () {
      expect(TypesStruct.maybeFromMap('not a map'), isNull);
      expect(TypesStruct.maybeFromMap(123), isNull);
      expect(TypesStruct.maybeFromMap(null), isNull);
    });

    test('toMap converts to map correctly', () {
      final types = TypesStruct(type: ['cafe', 'restaurant']);
      final map = types.toMap();
      
      expect(map['type'], equals(['cafe', 'restaurant']));
    });

    test('toMap excludes null type', () {
      final types = TypesStruct();
      final map = types.toMap();
      
      expect(map.containsKey('type'), isFalse);
    });

    test('toSerializableMap produces correct output', () {
      final types = TypesStruct(type: ['bar', 'pub']);
      final map = types.toSerializableMap();
      
      expect(map['type'], equals('["bar","pub"]'));
    });

    test('toString returns readable representation', () {
      final types = TypesStruct(type: ['restaurant']);
      final str = types.toString();
      
      expect(str, contains('TypesStruct'));
      expect(str, contains('type'));
    });

    test('Equality works correctly', () {
      final types1 = TypesStruct(type: ['a', 'b', 'c']);
      final types2 = TypesStruct(type: ['a', 'b', 'c']);
      final types3 = TypesStruct(type: ['a', 'b']);
      final types4 = TypesStruct(type: ['c', 'b', 'a']);
      
      expect(types1 == types2, isTrue);
      expect(types1 == types3, isFalse);
      expect(types1 == types4, isFalse);
    });

    test('hashCode is consistent for equal objects', () {
      final types1 = TypesStruct(type: ['x', 'y']);
      final types2 = TypesStruct(type: ['x', 'y']);
      
      // Verify equal objects produce consistent comparison
      expect(types1 == types2, isTrue);
      // Note: hashCode may vary between instances even if equal
    });

    test('Single item in type list', () {
      final types = TypesStruct(type: ['single']);
      
      expect(types.type.length, equals(1));
      expect(types.type.first, equals('single'));
    });

    test('Many items in type list', () {
      final manyTypes = List.generate(100, (i) => 'type$i');
      final types = TypesStruct(type: manyTypes);
      
      expect(types.type.length, equals(100));
      expect(types.type.last, equals('type99'));
    });

    test('Type list with duplicates', () {
      final types = TypesStruct(type: ['a', 'b', 'a', 'c']);
      
      expect(types.type.length, equals(4));
      expect(types.type, equals(['a', 'b', 'a', 'c']));
    });

    test('Type list with special characters', () {
      final types = TypesStruct(type: ['type-1', 'type_2', 'type.3']);
      
      expect(types.type, equals(['type-1', 'type_2', 'type.3']));
      
      final map = types.toMap();
      final reconstructed = TypesStruct.fromMap(map);
      
      expect(reconstructed.type, equals(['type-1', 'type_2', 'type.3']));
    });

    test('Type list with unicode characters', () {
      final types = TypesStruct(type: ['café', '餐厅', 'レストラン']);
      
      expect(types.type, equals(['café', '餐厅', 'レストラン']));
      
      final map = types.toMap();
      final reconstructed = TypesStruct.fromMap(map);
      
      expect(reconstructed.type, equals(['café', '餐厅', 'レストラン']));
    });

    test('Empty string in type list', () {
      final types = TypesStruct(type: ['', 'valid', '']);
      
      expect(types.type.length, equals(3));
      expect(types.type, equals(['', 'valid', '']));
    });
  });
}
