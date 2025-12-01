import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palate/flutter_flow/nav/serialization_util.dart';
import 'package:ff_commons/flutter_flow/lat_lng.dart';
import 'package:ff_commons/flutter_flow/place.dart';
import 'package:palate/backend/schema/structs/restaurant_struct.dart';

void main() {
  group('Serialization Helpers', () {
    group('dateTimeRangeToString', () {
      test('serializes DateTimeRange correctly', () {
        final start = DateTime(2024, 1, 15, 10, 30);
        final end = DateTime(2024, 1, 20, 15, 45);
        final range = DateTimeRange(start: start, end: end);
        
        final result = dateTimeRangeToString(range);
        
        expect(result, contains('|'));
        final parts = result.split('|');
        expect(parts.length, equals(2));
        expect(int.parse(parts[0]), equals(start.millisecondsSinceEpoch));
        expect(int.parse(parts[1]), equals(end.millisecondsSinceEpoch));
      });

      test('handles same start and end date', () {
        final date = DateTime(2024, 6, 1);
        final range = DateTimeRange(start: date, end: date);
        
        final result = dateTimeRangeToString(range);
        
        final parts = result.split('|');
        expect(parts[0], equals(parts[1]));
      });
    });

    group('serializeParam', () {
      test('returns null for null parameter', () {
        expect(serializeParam(null, ParamType.String), isNull);
        expect(serializeParam(null, ParamType.int), isNull);
      });

      test('serializes int', () {
        expect(serializeParam(42, ParamType.int), equals('42'));
        expect(serializeParam(0, ParamType.int), equals('0'));
        expect(serializeParam(-100, ParamType.int), equals('-100'));
      });

      test('serializes double', () {
        expect(serializeParam(3.14, ParamType.double), equals('3.14'));
        expect(serializeParam(0.0, ParamType.double), equals('0.0'));
        expect(serializeParam(-2.5, ParamType.double), equals('-2.5'));
      });

      test('serializes String', () {
        expect(serializeParam('hello', ParamType.String), equals('hello'));
        expect(serializeParam('', ParamType.String), equals(''));
        expect(serializeParam('test with spaces', ParamType.String), equals('test with spaces'));
      });

      test('serializes bool', () {
        expect(serializeParam(true, ParamType.bool), equals('true'));
        expect(serializeParam(false, ParamType.bool), equals('false'));
      });

      test('serializes DateTime', () {
        final date = DateTime(2024, 1, 15, 10, 30);
        final result = serializeParam(date, ParamType.DateTime);
        
        expect(result, equals(date.millisecondsSinceEpoch.toString()));
      });

      test('serializes DateTimeRange', () {
        final range = DateTimeRange(
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 1, 31),
        );
        
        final result = serializeParam(range, ParamType.DateTimeRange);
        
        expect(result, isNotNull);
        expect(result, contains('|'));
      });

      test('serializes LatLng', () {
        final latLng = LatLng(40.7128, -74.0060);
        
        final result = serializeParam(latLng, ParamType.LatLng);
        
        expect(result, isNotNull);
        expect(result, equals('40.7128,-74.006'));
      });

      test('serializes Color', () {
        const color = Colors.red;
        
        final result = serializeParam(color, ParamType.Color);
        
        expect(result, isNotNull);
        expect(result, isA<String>());
      });

      test('serializes JSON', () {
        final jsonData = {'name': 'John', 'age': 30};
        
        final result = serializeParam(jsonData, ParamType.JSON);
        
        expect(result, equals('{"name":"John","age":30}'));
      });

      test('serializes DataStruct', () {
        final restaurant = RestaurantStruct(
          name: 'Test Restaurant',
          rating: 4.5,
        );
        
        final result = serializeParam(restaurant, ParamType.DataStruct);
        
        expect(result, isNotNull);
        expect(result, contains('Test Restaurant'));
      });

      test('serializes list of ints', () {
        final result = serializeParam([1, 2, 3], ParamType.int, isList: true);
        
        expect(result, isNotNull);
        final decoded = json.decode(result!);
        expect(decoded, equals(['1', '2', '3']));
      });

      test('serializes list of strings', () {
        final result = serializeParam(['a', 'b', 'c'], ParamType.String, isList: true);
        
        expect(result, isNotNull);
        final decoded = json.decode(result!);
        expect(decoded, equals(['a', 'b', 'c']));
      });

      test('serializes list of bools', () {
        final result = serializeParam([true, false, true], ParamType.bool, isList: true);
        
        expect(result, isNotNull);
        final decoded = json.decode(result!);
        expect(decoded, equals(['true', 'false', 'true']));
      });

      test('handles empty list', () {
        final result = serializeParam([], ParamType.String, isList: true);
        
        expect(result, equals('[]'));
      });

      test('returns null on serialization error', () {
        // Try to serialize invalid data
        final result = serializeParam('not a number', ParamType.int);
        
        // Should still return the toString() value
        expect(result, isNotNull);
      });
    });
  });

  group('Deserialization Helpers', () {
    group('dateTimeRangeFromString', () {
      test('deserializes valid DateTimeRange string', () {
        final start = DateTime(2024, 3, 1);
        final end = DateTime(2024, 3, 15);
        final str = '${start.millisecondsSinceEpoch}|${end.millisecondsSinceEpoch}';
        
        final result = dateTimeRangeFromString(str);
        
        expect(result, isNotNull);
        expect(result!.start, equals(start));
        expect(result.end, equals(end));
      });

      test('returns null for invalid format', () {
        expect(dateTimeRangeFromString('invalid'), isNull);
        expect(dateTimeRangeFromString('123'), isNull);
        expect(dateTimeRangeFromString('123|456|789'), isNull);
        expect(dateTimeRangeFromString(''), isNull);
      });
    });

    group('latLngFromString', () {
      test('deserializes valid LatLng string', () {
        final result = latLngFromString('40.7128,-74.0060');
        
        expect(result, isNotNull);
        expect(result!.latitude, closeTo(40.7128, 0.0001));
        expect(result.longitude, closeTo(-74.0060, 0.0001));
      });

      test('handles whitespace', () {
        final result = latLngFromString(' 51.5074 , -0.1278 ');
        
        expect(result, isNotNull);
        expect(result!.latitude, closeTo(51.5074, 0.0001));
        expect(result.longitude, closeTo(-0.1278, 0.0001));
      });

      test('returns null for invalid format', () {
        expect(latLngFromString(null), isNull);
        expect(latLngFromString(''), isNull);
        expect(latLngFromString('invalid'), isNull);
        expect(latLngFromString('40.7128'), isNull);
        expect(latLngFromString('40.7128,-74.0060,extra'), isNull);
      });
    });

    group('placeFromString', () {
      test('deserializes complete place data', () {
        final placeData = {
          'latLng': '40.7589,-73.9851',
          'name': 'Times Square',
          'address': '123 Main St',
          'city': 'New York',
          'state': 'NY',
          'country': 'USA',
          'zipCode': '10036',
        };
        final placeStr = json.encode(placeData);
        
        final result = placeFromString(placeStr);
        
        expect(result.name, equals('Times Square'));
        expect(result.address, equals('123 Main St'));
        expect(result.city, equals('New York'));
        expect(result.state, equals('NY'));
        expect(result.country, equals('USA'));
        expect(result.zipCode, equals('10036'));
        expect(result.latLng.latitude, closeTo(40.7589, 0.0001));
      });

      test('handles missing optional fields', () {
        final placeData = {
          'name': 'Place Name',
        };
        final placeStr = json.encode(placeData);
        
        final result = placeFromString(placeStr);
        
        expect(result.name, equals('Place Name'));
        expect(result.address, equals(''));
        expect(result.city, equals(''));
        expect(result.latLng.latitude, equals(0.0));
      });
    });

    group('deserializeParam', () {
      test('returns null for null parameter', () {
        expect(deserializeParam(null, ParamType.String, false), isNull);
        expect(deserializeParam(null, ParamType.int, false), isNull);
      });

      test('deserializes int', () {
        expect(deserializeParam('42', ParamType.int, false), equals(42));
        expect(deserializeParam('0', ParamType.int, false), equals(0));
        expect(deserializeParam('-100', ParamType.int, false), equals(-100));
      });

      test('returns null for invalid int', () {
        expect(deserializeParam('not a number', ParamType.int, false), isNull);
        expect(deserializeParam('3.14', ParamType.int, false), isNull);
      });

      test('deserializes double', () {
        expect(deserializeParam('3.14', ParamType.double, false), equals(3.14));
        expect(deserializeParam('0.0', ParamType.double, false), equals(0.0));
        expect(deserializeParam('-2.5', ParamType.double, false), equals(-2.5));
      });

      test('returns null for invalid double', () {
        expect(deserializeParam('not a number', ParamType.double, false), isNull);
      });

      test('deserializes String', () {
        expect(deserializeParam('hello', ParamType.String, false), equals('hello'));
        expect(deserializeParam('', ParamType.String, false), equals(''));
      });

      test('deserializes bool', () {
        expect(deserializeParam('true', ParamType.bool, false), equals(true));
        expect(deserializeParam('false', ParamType.bool, false), equals(false));
        expect(deserializeParam('anything else', ParamType.bool, false), equals(false));
      });

      test('deserializes DateTime', () {
        final date = DateTime(2024, 6, 15, 12, 30);
        final millis = date.millisecondsSinceEpoch.toString();
        
        final result = deserializeParam(millis, ParamType.DateTime, false);
        
        expect(result, isA<DateTime>());
        expect((result as DateTime).millisecondsSinceEpoch, equals(date.millisecondsSinceEpoch));
      });

      test('returns null for invalid DateTime', () {
        expect(deserializeParam('not a number', ParamType.DateTime, false), isNull);
      });

      test('deserializes DateTimeRange', () {
        final start = DateTime(2024, 1, 1);
        final end = DateTime(2024, 1, 31);
        final str = '${start.millisecondsSinceEpoch}|${end.millisecondsSinceEpoch}';
        
        final result = deserializeParam(str, ParamType.DateTimeRange, false);
        
        expect(result, isA<DateTimeRange>());
        expect((result as DateTimeRange).start, equals(start));
        expect(result.end, equals(end));
      });

      test('deserializes LatLng', () {
        final result = deserializeParam('34.0522,-118.2437', ParamType.LatLng, false);
        
        expect(result, isA<LatLng>());
        expect((result as LatLng).latitude, closeTo(34.0522, 0.0001));
        expect(result.longitude, closeTo(-118.2437, 0.0001));
      });

      test('deserializes Color', () {
        final result = deserializeParam('#FF0000', ParamType.Color, false);
        
        expect(result, isA<Color>());
      });

      test('deserializes JSON', () {
        final jsonStr = '{"name":"John","age":30}';
        
        final result = deserializeParam(jsonStr, ParamType.JSON, false);
        
        expect(result, isA<Map>());
        expect((result as Map)['name'], equals('John'));
        expect(result['age'], equals(30));
      });

      test('deserializes DataStruct', () {
        final structData = {
          'name': 'Test Restaurant',
          'rating': 4.5,
        };
        final jsonStr = json.encode(structData);
        
        final result = deserializeParam<RestaurantStruct>(
          jsonStr,
          ParamType.DataStruct,
          false,
          structBuilder: RestaurantStruct.fromMap,
        );
        
        expect(result, isA<RestaurantStruct>());
        expect((result as RestaurantStruct).name, equals('Test Restaurant'));
      });

      test('deserializes list of ints', () {
        final listStr = '["42","100","-5"]';
        
        final result = deserializeParam(listStr, ParamType.int, true);
        
        expect(result, isA<List>());
        expect((result as List).length, equals(3));
        expect(result[0], equals(42));
        expect(result[1], equals(100));
        expect(result[2], equals(-5));
      });

      test('deserializes list of strings', () {
        final listStr = '["hello","world","test"]';
        
        final result = deserializeParam(listStr, ParamType.String, true);
        
        expect(result, isA<List>());
        expect((result as List), equals(['hello', 'world', 'test']));
      });

      test('returns null for empty list', () {
        final result = deserializeParam('[]', ParamType.String, true);
        
        expect(result, isNull);
      });

      test('returns null for invalid list JSON', () {
        final result = deserializeParam('not json', ParamType.String, true);
        
        expect(result, isNull);
      });

      test('filters out non-string elements in list', () {
        final listStr = '["valid",123,null,"another"]';
        
        final result = deserializeParam(listStr, ParamType.String, true);
        
        expect(result, isA<List>());
        expect((result as List).length, equals(2));
        expect(result, equals(['valid', 'another']));
      });

      test('returns null on deserialization error', () {
        final result = deserializeParam('invalid json', ParamType.JSON, false);
        
        expect(result, isNull);
      });
    });
  });
}
