import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:palate/backend/schema/util/schema_util.dart';
import 'package:palate/backend/schema/structs/restaurant_struct.dart';
import 'package:palate/backend/schema/structs/boolean_map_struct.dart';
import 'package:palate/flutter_flow/flutter_flow_util.dart';

void main() {
  group('schema_util', () {
    group('getStructList', () {
      test('should return null for non-list values', () {
        expect(getStructList(null, BooleanMapStruct.fromMap), isNull);
        expect(getStructList('string', BooleanMapStruct.fromMap), isNull);
        expect(getStructList(42, BooleanMapStruct.fromMap), isNull);
        expect(getStructList({}, BooleanMapStruct.fromMap), isNull);
      });

      test('should return empty list for empty list', () {
        final result = getStructList<BooleanMapStruct>(
          [],
          BooleanMapStruct.fromMap,
        );
        
        expect(result, isNotNull);
        expect(result, isEmpty);
      });

      test('should filter out non-Map elements', () {
        final input = [
          {'key': 'value'},
          'not a map',
          123,
          {'another': 'map'},
        ];
        
        final result = getStructList<BooleanMapStruct>(
          input,
          BooleanMapStruct.fromMap,
        );
        
        expect(result, hasLength(2));
      });

      test('should build structs from valid maps', () {
        final input = [
          {'wheelchair_accessible': true},
          {'wheelchair_accessible_entrance': false},
        ];
        
        final result = getStructList<BooleanMapStruct>(
          input,
          BooleanMapStruct.fromMap,
        );
        
        expect(result, hasLength(2));
        expect(result![0], isA<BooleanMapStruct>());
        expect(result[1], isA<BooleanMapStruct>());
      });

      test('should handle mixed valid and invalid data', () {
        final input = [
          {'valid': true},
          null,
          {'another': false},
          [],
          {'third': true},
        ];
        
        final result = getStructList<BooleanMapStruct>(
          input,
          BooleanMapStruct.fromMap,
        );
        
        expect(result, hasLength(3));
      });

      test('should work with RestaurantStruct', () {
        final input = [
          {
            'name': 'Restaurant 1',
            'rating': 4.5,
            'place_id': 'place1',
          },
          {
            'name': 'Restaurant 2',
            'rating': 3.8,
            'place_id': 'place2',
          },
        ];
        
        final result = getStructList<RestaurantStruct>(
          input,
          RestaurantStruct.fromMap,
        );
        
        expect(result, hasLength(2));
        expect(result![0].name, 'Restaurant 1');
        expect(result[1].name, 'Restaurant 2');
      });
    });

    group('getSchemaColor', () {
      test('should return null for null value', () {
        expect(getSchemaColor(null), isNull);
      });

      test('should return null for invalid types', () {
        expect(getSchemaColor(123), isNull);
        expect(getSchemaColor(true), isNull);
        expect(getSchemaColor([]), isNull);
        expect(getSchemaColor({}), isNull);
      });

      test('should parse CSS color strings', () {
        final red = getSchemaColor('#FF0000');
        expect(red, isNotNull);
        expect(red, isA<Color>());
        
        final blue = getSchemaColor('#0000FF');
        expect(blue, isNotNull);
        
        final green = getSchemaColor('rgb(0, 255, 0)');
        expect(green, isNotNull);
      });

      test('should return Color objects as-is', () {
        const color = Colors.red;
        final result = getSchemaColor(color);
        
        expect(result, equals(color));
        expect(result, isA<Color>());
      });

      test('should handle various CSS color formats', () {
        expect(getSchemaColor('#FFFFFF'), isNotNull);
        expect(getSchemaColor('#000'), isNotNull);
        expect(getSchemaColor('rgb(255, 0, 0)'), isNotNull);
        expect(getSchemaColor('rgba(0, 0, 255, 0.5)'), isNotNull);
      });

      test('should throw FormatException for invalid CSS strings', () {
        expect(() => getSchemaColor('not-a-color'), throwsFormatException);
      });
    });

    group('getColorsList', () {
      test('should return null for non-list values', () {
        expect(getColorsList(null), isNull);
        expect(getColorsList('string'), isNull);
        expect(getColorsList(42), isNull);
        expect(getColorsList({}), isNull);
      });

      test('should return empty list for empty list', () {
        final result = getColorsList([]);
        expect(result, isNotNull);
        expect(result, isEmpty);
      });

      test('should parse list of CSS color strings', () {
        final input = ['#FF0000', '#00FF00', '#0000FF'];
        final result = getColorsList(input);
        
        expect(result, hasLength(3));
        expect(result![0], isA<Color>());
        expect(result[1], isA<Color>());
        expect(result[2], isA<Color>());
      });

      test('should handle list of Color objects', () {
        final input = [Colors.red, Colors.green, Colors.blue];
        final result = getColorsList(input);
        
        expect(result, hasLength(3));
        expect(result![0], equals(Colors.red));
        expect(result[1], equals(Colors.green));
        expect(result[2], equals(Colors.blue));
      });

      test('should handle mixed valid and invalid color values', () {
        final input = [
          '#FF0000',
          '#00FF00',
          Colors.blue,
        ];
        final result = getColorsList(input);
        
        expect(result, hasLength(3)); // All valid colors
      });

      test('should handle mixed Color and string values', () {
        final input = [
          Colors.red,
          '#00FF00',
          'rgb(0, 0, 255)',
        ];
        final result = getColorsList(input);
        
        expect(result, hasLength(3));
        expect(result![0], isA<Color>());
        expect(result[1], isA<Color>());
        expect(result[2], isA<Color>());
      });

      test('should parse valid color values', () {
        final input = ['#FF0000', '#00FF00', '#0000FF'];
        final result = getColorsList(input);
        
        expect(result, hasLength(3));
      });
    });

    group('getDataList', () {
      test('should return null for non-list values', () {
        expect(getDataList<int>(null), isNull);
        expect(getDataList<String>('string'), isNull);
        expect(getDataList<int>(42), isNull);
        expect(getDataList<bool>({}), isNull);
      });

      test('should return empty list for empty list', () {
        final result = getDataList<int>([]);
        expect(result, isNotNull);
        expect(result, isEmpty);
      });

      test('should convert list of integers', () {
        final input = [1, 2, 3, 4, 5];
        final result = getDataList<int>(input);
        
        expect(result, hasLength(5));
        expect(result![0], 1);
        expect(result[1], 2);
        expect(result[4], 5);
      });

      test('should convert list of strings', () {
        final input = ['a', 'b', 'c'];
        final result = getDataList<String>(input);
        
        expect(result, hasLength(3));
        expect(result![0], 'a');
        expect(result[1], 'b');
        expect(result[2], 'c');
      });

      test('should convert list of doubles', () {
        final input = [1.5, 2.7, 3.9];
        final result = getDataList<double>(input);
        
        expect(result, hasLength(3));
        expect(result![0], 1.5);
        expect(result[1], 2.7);
        expect(result[2], 3.9);
      });

      test('should convert list of booleans', () {
        final input = [true, false, true];
        final result = getDataList<bool>(input);
        
        expect(result, hasLength(3));
        expect(result![0], true);
        expect(result[1], false);
        expect(result[2], true);
      });

      test('should handle numeric type conversions', () {
        final input = [1, 2.5, 3];
        final result = getDataList<num>(input);
        
        expect(result, hasLength(3));
        expect(result![0], 1);
        expect(result[1], 2.5);
        expect(result[2], 3);
      });

      test('should handle mixed integer and double as num', () {
        final input = [1, 2.0, 3, 4.5];
        final result = getDataList<num>(input);
        
        expect(result, hasLength(4));
        expect(result![0], isA<num>());
        expect(result[3], 4.5);
      });
    });

    group('deserializeStructParam', () {
      test('should return null for null param', () {
        final result = deserializeStructParam<BooleanMapStruct>(
          null,
          ParamType.DataStruct,
          false,
          structBuilder: BooleanMapStruct.fromMap,
        );
        
        expect(result, isNull);
      });

      test('should deserialize single struct from Map', () {
        final data = {'wheelchair_accessible': true};
        final result = deserializeStructParam<BooleanMapStruct>(
          data,
          ParamType.DataStruct,
          false,
          structBuilder: BooleanMapStruct.fromMap,
        );
        
        expect(result, isA<BooleanMapStruct>());
      });

      test('should deserialize list of structs from Iterable', () {
        final data = [
          {'key1': true},
          {'key2': false},
        ];
        final result = deserializeStructParam<BooleanMapStruct>(
          data,
          ParamType.DataStruct,
          true,
          structBuilder: BooleanMapStruct.fromMap,
        ) as List<BooleanMapStruct>?;
        
        expect(result, hasLength(2));
        expect(result![0], isA<BooleanMapStruct>());
        expect(result[1], isA<BooleanMapStruct>());
      });

      test('should return null for invalid JSON when isList is true', () {
        final result = deserializeStructParam<BooleanMapStruct>(
          'invalid json',
          ParamType.DataStruct,
          true,
          structBuilder: BooleanMapStruct.fromMap,
        );
        
        expect(result, isNull);
      });

      test('should handle empty list', () {
        final result = deserializeStructParam<BooleanMapStruct>(
          [],
          ParamType.DataStruct,
          true,
          structBuilder: BooleanMapStruct.fromMap,
        ) as List<BooleanMapStruct>?;
        
        expect(result, isEmpty);
      });

      test('should deserialize nested structs', () {
        final data = {
          'name': 'Test Restaurant',
          'rating': 4.5,
          'place_id': 'place123',
        };
        final result = deserializeStructParam<RestaurantStruct>(
          data,
          ParamType.DataStruct,
          false,
          structBuilder: RestaurantStruct.fromMap,
        );
        
        expect(result, isA<RestaurantStruct>());
        expect((result as RestaurantStruct).name, 'Test Restaurant');
      });

      test('should handle list with non-Iterable result', () {
        final result = deserializeStructParam<BooleanMapStruct>(
          'not-iterable',
          ParamType.DataStruct,
          true,
          structBuilder: BooleanMapStruct.fromMap,
        );
        
        // Should return null when JSON decode results in non-iterable
        expect(result, isNull);
      });
    });

    group('BaseStruct', () {
      test('should serialize struct to JSON string', () {
        final struct = BooleanMapStruct();
        final serialized = struct.serialize();
        
        expect(serialized, isA<String>());
        expect(() => jsonDecode(serialized), returnsNormally);
      });

      test('should create serializable map', () {
        final struct = BooleanMapStruct();
        final map = struct.toSerializableMap();
        
        expect(map, isA<Map<String, dynamic>>());
      });
    });

    group('Edge Cases', () {
      test('getStructList should handle very large lists', () {
        final input = List.generate(
          1000,
          (index) => {'index': index, 'value': true},
        );
        
        final result = getStructList<BooleanMapStruct>(
          input,
          BooleanMapStruct.fromMap,
        );
        
        expect(result, hasLength(1000));
      });

      test('getColorsList should handle valid color values', () {
        final input = ['#FF0000', '#00FF00'];
        final result = getColorsList(input);
        
        expect(result, hasLength(2));
      });

      test('getDataList should preserve order', () {
        final input = [5, 4, 3, 2, 1];
        final result = getDataList<int>(input);
        
        expect(result, [5, 4, 3, 2, 1]);
      });

      test('getSchemaColor should handle hex colors with alpha', () {
        final color = getSchemaColor('#FF0000FF');
        expect(color, isNotNull);
      });

      test('deserializeStructParam should handle complex nested data', () {
        final data = [
          {
            'name': 'Complex Restaurant',
            'rating': 5.0,
            'place_id': 'complex123',
          },
        ];
        
        final result = deserializeStructParam<RestaurantStruct>(
          data,
          ParamType.DataStruct,
          true,
          structBuilder: RestaurantStruct.fromMap,
        ) as List<RestaurantStruct>?;
        
        expect(result, isNotNull);
        expect(result, hasLength(1));
      });

      test('getStructList filters nulls from results', () {
        final input = [
          {'valid': true},
          {'another': false},
        ];
        
        final result = getStructList<BooleanMapStruct>(
          input,
          BooleanMapStruct.fromMap,
        );
        
        expect(result, isNotNull);
        expect(result!.length, greaterThan(0));
      });

      test('getDataList handles single element', () {
        final result = getDataList<String>(['single']);
        expect(result, ['single']);
      });

      test('getSchemaColor handles lowercase hex', () {
        final color = getSchemaColor('#ff0000');
        expect(color, isNotNull);
      });

      test('getColorsList filters invalid colors', () {
        final input = [null, 123];
        final result = getColorsList(input);
        
        // Should filter out invalid colors, leaving empty list
        expect(result, isNotNull);
        expect(result, isEmpty);
      });

      test('deserializeStructParam with JSON-encoded string list', () {
        final jsonList = jsonEncode([
          {'key': 'value1'},
          {'key': 'value2'},
        ]);
        
        final result = deserializeStructParam<BooleanMapStruct>(
          jsonList,
          ParamType.DataStruct,
          true,
          structBuilder: BooleanMapStruct.fromMap,
        ) as List<BooleanMapStruct>?;
        
        expect(result, isNotNull);
        expect(result, hasLength(2));
      });

      test('getDataList casts int to double', () {
        final input = [1, 2, 3];
        final result = getDataList<double>(input);
        
        expect(result, hasLength(3));
        expect(result![0], isA<double>());
      });

      test('getStructList with completely invalid input', () {
        final result = getStructList<RestaurantStruct>(
          ['not', 'maps', 'at', 'all'],
          RestaurantStruct.fromMap,
        );
        
        expect(result, isEmpty);
      });
    });
  });
}
