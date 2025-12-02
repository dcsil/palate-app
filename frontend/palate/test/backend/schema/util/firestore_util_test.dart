import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/util/firestore_util.dart';
import 'package:palate/flutter_flow/flutter_flow_util.dart';

void main() {
  group('FirestoreUtilData', () {
    test('should create with default values', () {
      const data = FirestoreUtilData();
      expect(data.fieldValues, isEmpty);
      expect(data.clearUnsetFields, isTrue);
      expect(data.create, isFalse);
      expect(data.delete, isFalse);
    });

    test('should create with custom field values', () {
      const data = FirestoreUtilData(
        fieldValues: {'key': 'value'},
        clearUnsetFields: false,
        create: true,
        delete: true,
      );
      expect(data.fieldValues, equals({'key': 'value'}));
      expect(data.clearUnsetFields, isFalse);
      expect(data.create, isTrue);
      expect(data.delete, isTrue);
    });

    test('should have correct name property', () {
      expect(FirestoreUtilData.name, equals('firestoreUtilData'));
    });
  });

  group('mapFromFirestore', () {
    test('should handle empty map', () {
      final result = mapFromFirestore({});
      expect(result, isEmpty);
    });

    test('should filter out firestoreUtilData field', () {
      final data = {
        'name': 'Test',
        'firestoreUtilData': {'some': 'data'},
      };
      final result = mapFromFirestore(data);
      expect(result.containsKey('firestoreUtilData'), isFalse);
      expect(result.containsKey('name'), isTrue);
    });

    test('should convert Timestamp to DateTime', () {
      final timestamp = Timestamp.fromDate(DateTime(2024, 1, 15));
      final data = {'date': timestamp};
      final result = mapFromFirestore(data);
      expect(result['date'], isA<DateTime>());
      expect((result['date'] as DateTime).year, equals(2024));
    });

    test('should convert list of Timestamps to list of DateTimes', () {
      final timestamps = [
        Timestamp.fromDate(DateTime(2024, 1, 1)),
        Timestamp.fromDate(DateTime(2024, 2, 1)),
      ];
      final data = {'dates': timestamps};
      final result = mapFromFirestore(data);
      expect(result['dates'], isA<List>());
      expect((result['dates'] as List).first, isA<DateTime>());
    });

    test('should convert GeoPoint to LatLng', () {
      final geoPoint = GeoPoint(40.7128, -74.0060); // NYC
      final data = {'location': geoPoint};
      final result = mapFromFirestore(data);
      expect(result['location'], isA<LatLng>());
      final latLng = result['location'] as LatLng;
      expect(latLng.latitude, closeTo(40.7128, 0.0001));
      expect(latLng.longitude, closeTo(-74.0060, 0.0001));
    });

    test('should convert list of GeoPoints to list of LatLng', () {
      final geoPoints = [
        GeoPoint(40.7128, -74.0060),
        GeoPoint(34.0522, -118.2437), // LA
      ];
      final data = {'locations': geoPoints};
      final result = mapFromFirestore(data);
      expect(result['locations'], isA<List>());
      expect((result['locations'] as List).first, isA<LatLng>());
    });

    test('should handle nested maps', () {
      final data = {
        'outer': {
          'inner': 'value',
        },
      };
      final result = mapFromFirestore(data);
      expect(result['outer'], isA<Map>());
      expect((result['outer'] as Map)['inner'], equals('value'));
    });

    test('should handle list of nested maps', () {
      final data = {
        'items': [
          {'name': 'item1'},
          {'name': 'item2'},
        ],
      };
      final result = mapFromFirestore(data);
      expect(result['items'], isA<List>());
      final items = result['items'] as List;
      expect(items[0], isA<Map>());
      expect((items[0] as Map)['name'], equals('item1'));
    });

    test('should handle mixed data types', () {
      final timestamp = Timestamp.fromDate(DateTime(2024, 1, 1));
      final geoPoint = GeoPoint(0, 0);
      final data = {
        'string': 'text',
        'number': 42,
        'date': timestamp,
        'location': geoPoint,
        'nested': {'key': 'value'},
      };
      final result = mapFromFirestore(data);
      expect(result['string'], equals('text'));
      expect(result['number'], equals(42));
      expect(result['date'], isA<DateTime>());
      expect(result['location'], isA<LatLng>());
      expect(result['nested'], isA<Map>());
    });

    test('should handle null values', () {
      final data = {
        'nullable': null,
        'string': 'value',
      };
      final result = mapFromFirestore(data);
      expect(result['nullable'], isNull);
      expect(result['string'], equals('value'));
    });
  });

  group('mapToFirestore', () {
    test('should handle empty map', () {
      final result = mapToFirestore({});
      expect(result, isEmpty);
    });

    test('should filter out firestoreUtilData field', () {
      final data = {
        'name': 'Test',
        'firestoreUtilData': {'some': 'data'},
      };
      final result = mapToFirestore(data);
      expect(result.containsKey('firestoreUtilData'), isFalse);
      expect(result.containsKey('name'), isTrue);
    });

    test('should convert LatLng to GeoPoint', () {
      final latLng = LatLng(40.7128, -74.0060);
      final data = {'location': latLng};
      final result = mapToFirestore(data);
      expect(result['location'], isA<GeoPoint>());
      final geoPoint = result['location'] as GeoPoint;
      expect(geoPoint.latitude, closeTo(40.7128, 0.0001));
      expect(geoPoint.longitude, closeTo(-74.0060, 0.0001));
    });

    test('should convert list of LatLng to list of GeoPoint', () {
      final latLngs = [
        LatLng(40.7128, -74.0060),
        LatLng(34.0522, -118.2437),
      ];
      final data = {'locations': latLngs};
      final result = mapToFirestore(data);
      expect(result['locations'], isA<List>());
      expect((result['locations'] as List).first, isA<GeoPoint>());
    });

    test('should convert Color to CSS string', () {
      final color = Colors.red;
      final data = {'color': color};
      final result = mapToFirestore(data);
      expect(result['color'], isA<String>());
      expect(result['color'], startsWith('#'));
    });

    test('should convert list of Colors to list of CSS strings', () {
      final colors = [Colors.red, Colors.blue, Colors.green];
      final data = {'colors': colors};
      final result = mapToFirestore(data);
      expect(result['colors'], isA<List>());
      expect((result['colors'] as List).first, isA<String>());
    });

    test('should handle nested maps', () {
      final data = {
        'outer': {
          'inner': 'value',
        },
      };
      final result = mapToFirestore(data);
      expect(result['outer'], isA<Map>());
      expect((result['outer'] as Map)['inner'], equals('value'));
    });

    test('should handle list of nested maps', () {
      final data = {
        'items': [
          {'name': 'item1'},
          {'name': 'item2'},
        ],
      };
      final result = mapToFirestore(data);
      expect(result['items'], isA<List>());
      final items = result['items'] as List;
      expect(items[0], isA<Map>());
      expect((items[0] as Map)['name'], equals('item1'));
    });

    test('should handle mixed data types', () {
      final latLng = LatLng(0, 0);
      final color = Colors.blue;
      final data = {
        'string': 'text',
        'number': 42,
        'location': latLng,
        'color': color,
        'nested': {'key': 'value'},
      };
      final result = mapToFirestore(data);
      expect(result['string'], equals('text'));
      expect(result['number'], equals(42));
      expect(result['location'], isA<GeoPoint>());
      expect(result['color'], isA<String>());
      expect(result['nested'], isA<Map>());
    });

    test('should handle null values', () {
      final data = {
        'nullable': null,
        'string': 'value',
      };
      final result = mapToFirestore(data);
      expect(result['nullable'], isNull);
      expect(result['string'], equals('value'));
    });

    test('should handle deeply nested structures', () {
      final data = {
        'level1': {
          'level2': {
            'level3': 'deep value',
          },
        },
      };
      final result = mapToFirestore(data);
      expect(result['level1'], isA<Map>());
      final level1 = result['level1'] as Map;
      expect(level1['level2'], isA<Map>());
      final level2 = level1['level2'] as Map;
      expect(level2['level3'], equals('deep value'));
    });

    test('should handle nested maps with values', () {
      final data = {
        'notEmpty': {'key': 'value'},
      };
      final result = mapToFirestore(data);
      expect(result['notEmpty'], isNotEmpty);
    });

    test('should handle lists with mixed types', () {
      final data = {
        'mixed': [1, 'string', true, null],
      };
      final result = mapToFirestore(data);
      expect(result['mixed'], isA<List>());
      final mixed = result['mixed'] as List;
      expect(mixed.length, equals(4));
      expect(mixed[0], equals(1));
      expect(mixed[1], equals('string'));
      expect(mixed[2], equals(true));
      expect(mixed[3], isNull);
    });

    test('should handle boolean values', () {
      final data = {
        'active': true,
        'deleted': false,
      };
      final result = mapToFirestore(data);
      expect(result['active'], isTrue);
      expect(result['deleted'], isFalse);
    });

    test('should handle empty lists', () {
      final data = {
        'emptyList': [],
        'nonEmptyList': [1, 2, 3],
      };
      final result = mapToFirestore(data);
      expect(result['emptyList'], isEmpty);
      expect(result['nonEmptyList'], hasLength(3));
    });

    test('should preserve string values', () {
      final data = {
        'text': 'Hello World',
        'empty': '',
        'special': 'Test with special chars: !@#\$%',
      };
      final result = mapToFirestore(data);
      expect(result['text'], equals('Hello World'));
      expect(result['empty'], equals(''));
      expect(result['special'], contains('!@#'));
    });

    test('should preserve numeric values', () {
      final data = {
        'int': 42,
        'double': 3.14,
        'negative': -100,
        'zero': 0,
      };
      final result = mapToFirestore(data);
      expect(result['int'], equals(42));
      expect(result['double'], equals(3.14));
      expect(result['negative'], equals(-100));
      expect(result['zero'], equals(0));
    });
  });

  group('FirestoreUtilData with FFFirebaseStruct', () {
    test('should allow access to firestoreUtilData', () {
      const utilData = FirestoreUtilData(
        clearUnsetFields: false,
        create: true,
      );
      // Verify the object can be created and accessed
      expect(utilData.clearUnsetFields, isFalse);
      expect(utilData.create, isTrue);
    });

    test('should handle fieldValues correctly', () {
      const utilData = FirestoreUtilData(
        fieldValues: {
          'name': 'Test',
          'count': 5,
        },
      );
      expect(utilData.fieldValues['name'], equals('Test'));
      expect(utilData.fieldValues['count'], equals(5));
    });
  });

  group('safeGet', () {
    test('returns value when function succeeds', () {
      final result = safeGet<int>(() => 42);
      expect(result, equals(42));
    });

    test('returns null when function throws', () {
      final result = safeGet<String>(() {
        throw Exception('Test error');
      });
      expect(result, isNull);
    });

    test('calls reportError callback when function throws', () {
      dynamic capturedError;
      
      safeGet<String>(
        () => throw Exception('Test error'),
        (error) {
          capturedError = error;
        },
      );
      
      expect(capturedError, isNotNull);
      expect(capturedError.toString(), contains('Test error'));
    });

    test('does not call reportError when function succeeds', () {
      var callbackInvoked = false;
      
      safeGet<int>(
        () => 100,
        (_) {
          callbackInvoked = true;
        },
      );
      
      expect(callbackInvoked, isFalse);
    });
  });

  group('GeoPoint extensions', () {
    test('LatLng toGeoPoint conversion', () {
      final latLng = LatLng(37.7749, -122.4194); // San Francisco
      final geoPoint = latLng.toGeoPoint();
      
      expect(geoPoint.latitude, closeTo(37.7749, 0.0001));
      expect(geoPoint.longitude, closeTo(-122.4194, 0.0001));
    });

    test('GeoPoint toLatLng conversion', () {
      final geoPoint = GeoPoint(51.5074, -0.1278); // London
      final latLng = geoPoint.toLatLng();
      
      expect(latLng.latitude, closeTo(51.5074, 0.0001));
      expect(latLng.longitude, closeTo(-0.1278, 0.0001));
    });

    test('round-trip conversion preserves values', () {
      final original = LatLng(40.7589, -73.9851); // Times Square
      final geoPoint = original.toGeoPoint();
      final converted = geoPoint.toLatLng();
      
      expect(converted.latitude, closeTo(original.latitude, 0.0001));
      expect(converted.longitude, closeTo(original.longitude, 0.0001));
    });
  });

  group('convertToGeoPointList', () {
    test('converts list of LatLng to list of GeoPoint', () {
      final latLngs = [
        LatLng(40.7128, -74.0060),
        LatLng(34.0522, -118.2437),
      ];
      
      final geoPoints = convertToGeoPointList(latLngs);
      
      expect(geoPoints, isNotNull);
      expect(geoPoints!.length, equals(2));
      expect(geoPoints[0].latitude, closeTo(40.7128, 0.0001));
      expect(geoPoints[1].latitude, closeTo(34.0522, 0.0001));
    });

    test('returns null for null input', () {
      final result = convertToGeoPointList(null);
      expect(result, isNull);
    });

    test('handles empty list', () {
      final result = convertToGeoPointList([]);
      expect(result, isEmpty);
    });
  });
}

