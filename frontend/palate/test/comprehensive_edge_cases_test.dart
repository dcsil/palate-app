import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:palate/flutter_flow/flutter_flow_util.dart';
import 'package:palate/flutter_flow/custom_functions.dart' as cf;
import 'package:ff_commons/flutter_flow/lat_lng.dart';
import 'package:palate/backend/schema/structs/restaurant_struct.dart';

void main() {
  group('Comprehensive Edge Case Testing', () {
    group('formatNumber Edge Cases', () {
      test('formatNumber with all FormatType variations', () {
        expect(
          formatNumber(1000, formatType: FormatType.percent),
          isNotEmpty,
        );
        expect(
          formatNumber(999, formatType: FormatType.scientific, toLowerCase: true),
          contains('e'),
        );
        expect(
          formatNumber(5000, formatType: FormatType.compact),
          isNotEmpty,
        );
        expect(
          formatNumber(10000, formatType: FormatType.compactLong),
          isNotEmpty,
        );
      });

      test('formatNumber with custom format and locale combinations', () {
        final result1 = formatNumber(
          1234.56,
          formatType: FormatType.custom,
          format: '###,###.##',
          locale: 'en_US',
        );
        expect(result1, isNotEmpty);

        final result2 = formatNumber(
          9876.54,
          formatType: FormatType.custom,
          format: '#,##0.00',
        );
        expect(result2, isNotEmpty);
      });

      test('formatNumber with currency variations', () {
        // With currency symbol
        final withCurrency = formatNumber(
          100.0,
          formatType: FormatType.decimal,
          decimalType: DecimalType.automatic,
          currency: '\$',
        );
        expect(withCurrency, contains('\$'));

        // Empty currency (should use default)
        final emptyCurrency = formatNumber(
          100.0,
          formatType: FormatType.decimal,
          decimalType: DecimalType.automatic,
          currency: '',
        );
        expect(emptyCurrency, isNotEmpty);

        // With commaDecimal and currency
        final commaDecimalCurrency = formatNumber(
          5000.25,
          formatType: FormatType.decimal,
          decimalType: DecimalType.commaDecimal,
          currency: '€',
        );
        expect(commaDecimalCurrency, contains('€'));

        // With periodDecimal and currency
        final periodDecimalCurrency = formatNumber(
          3000.75,
          formatType: FormatType.decimal,
          decimalType: DecimalType.periodDecimal,
          currency: '£',
        );
        expect(periodDecimalCurrency, contains('£'));
      });

      test('formatNumber edge values', () {
        expect(formatNumber(0, formatType: FormatType.compact), isNotEmpty);
        expect(formatNumber(-100.5, formatType: FormatType.decimal, decimalType: DecimalType.automatic), isNotEmpty);
        expect(formatNumber(0.001, formatType: FormatType.scientific), isNotEmpty);
        expect(formatNumber(999999999, formatType: FormatType.compactLong), isNotEmpty);
      });
    });

    group('Custom Functions Helper Edge Cases', () {
      test('_as helper with various type conversions', () {
        // Test through convertJsonToRestaurant which uses _as internally
        final jsonWithMixedTypes = [
          {
            'name': 'Test',
            'rating': '4.5', // String to double
            'price_level': 3.0, // Double to int
            'user_rating_count': 100, // Int stays int
          }
        ];

        final restaurants = cf.convertJsonToRestaurant(jsonWithMixedTypes);
        expect(restaurants.length, 1);
        expect(restaurants[0].rating, isA<double>());
        expect(restaurants[0].priceLevel, isA<int>());
      });

      test('_asStringList helper through convertJsonToRestaurant', () {
        final jsonWithLists = [
          {
            'name': 'Test',
            'types': ['cafe', 'restaurant', 'bakery'],
            'photos': ['photo1.jpg', 'photo2.jpg'],
          }
        ];

        final restaurants = cf.convertJsonToRestaurant(jsonWithLists);
        expect(restaurants[0].types, isA<List<String>>());
        expect(restaurants[0].photos, isA<List<String>>());
      });

      test('convertJsonToRestaurant with all fields populated', () {
        final completeJson = [
          {
            'name': 'Complete Restaurant',
            'business_status': 'OPERATIONAL',
            'rating': 4.8,
            'price_level': 3,
            'primary_type': 'restaurant',
            'user_rating_count': 500,
            'place_id': 'complete_123',
            'types': ['restaurant', 'cafe'],
            'photos': ['p1.jpg', 'p2.jpg'],
            'editorial': 'Great place',
          }
        ];

        final restaurants = cf.convertJsonToRestaurant(completeJson);
        expect(restaurants.length, 1);
        expect(restaurants[0].name, 'Complete Restaurant');
        expect(restaurants[0].businessStatus, 'OPERATIONAL');
        expect(restaurants[0].rating, 4.8);
        expect(restaurants[0].priceLevel, 3);
      });

      test('convertJsonToSingleRes with all type coercions', () {
        final json = {
          'name': 'Coercion Test',
          'rating': 5, // int to double
          'price_level': 2.0, // double to int
          'user_rating_count': '250', // string to int
        };

        final restaurant = cf.convertJsonToSingleRes(json);
        expect(restaurant.rating, 5.0);
        expect(restaurant.priceLevel, 2);
        expect(restaurant.userRatingCount, 250);
      });

      test('distanceToTime with various distances', () {
        // Very short
        expect(cf.distanceToTime(100), isNotEmpty);
        
        // Medium
        expect(cf.distanceToTime(2000), isNotEmpty);
        
        // Long with hours
        expect(cf.distanceToTime(10000), contains('hr'));
        
        // Exact hour boundary
        expect(cf.distanceToTime(4200), contains('hr'));
      });

      test('subarray with all boundary conditions', () {
        final items = ['a', 'b', 'c', 'd', 'e'];
        
        // Empty list
        expect(cf.subarray(0, 0, []), []);
        
        // Zero length
        expect(cf.subarray(0, 0, items), []);
        
        // Negative length
        expect(cf.subarray(0, -1, items), []);
        
        // Start beyond end
        expect(cf.subarray(10, 1, items), []);
        
        // Negative start (clamped to 0)
        expect(cf.subarray(-5, 2, items), ['a', 'b']);
        
        // Length exceeds remaining
        expect(cf.subarray(3, 10, items), ['d', 'e']);
        
        // Exact fit
        expect(cf.subarray(0, 5, items), ['a', 'b', 'c', 'd', 'e']);
      });
    });

    group('DateTime Utility Edge Cases', () {
      test('dateTimeFromSecondsSinceEpoch boundary values', () {
        final epoch = dateTimeFromSecondsSinceEpoch(0);
        expect(epoch.millisecondsSinceEpoch, 0);

        final recent = dateTimeFromSecondsSinceEpoch(1700000000);
        expect(recent.millisecondsSinceEpoch, 1700000000000);
      });

      test('DateTimeConversionExtension roundtrip', () {
        final original = DateTime(2024, 6, 15, 10, 30, 45);
        final seconds = original.secondsSinceEpoch;
        final restored = dateTimeFromSecondsSinceEpoch(seconds);
        
        // Should be within 1 second due to rounding
        expect((original.millisecondsSinceEpoch - restored.millisecondsSinceEpoch).abs(), lessThan(1000));
      });

      test('DateTime comparison operators comprehensive', () {
        final early = DateTime(2024, 1, 1);
        final middle = DateTime(2024, 6, 1);
        final late = DateTime(2024, 12, 31);
        final sameAsMiddle = DateTime(2024, 6, 1);

        // Less than
        expect(early < middle, true);
        expect(middle < late, true);
        expect(middle < early, false);

        // Greater than
        expect(late > middle, true);
        expect(middle > early, true);
        expect(early > middle, false);

        // Less than or equal
        expect(early <= middle, true);
        expect(middle <= sameAsMiddle, true);
        expect(late <= middle, false);

        // Greater than or equal
        expect(late >= middle, true);
        expect(middle >= sameAsMiddle, true);
        expect(early >= middle, false);
      });
    });

    group('Color and String Utilities', () {
      test('colorFromCssString with all valid formats', () {
        // Hex 6-digit
        expect(colorFromCssString('#FF0000'), isA<Color>());
        
        // Hex 3-digit
        expect(colorFromCssString('#F00'), isA<Color>());
        
        // RGB
        expect(colorFromCssString('rgb(255, 0, 0)'), isA<Color>());
        
        // RGBA
        expect(colorFromCssString('rgba(0, 0, 255, 0.5)'), isA<Color>());
      });

      test('colorFromCssString with invalid inputs uses default', () {
        final customDefault = Colors.purple;
        expect(colorFromCssString('not-a-color', defaultColor: customDefault), customDefault);
        expect(colorFromCssString('', defaultColor: customDefault), customDefault);
        expect(colorFromCssString('invalid'), Colors.black);
      });

      test('FFStringExt maybeHandleOverflow comprehensive', () {
        // No overflow
        expect('short'.maybeHandleOverflow(maxChars: 10), 'short');
        
        // Exact length
        expect('exact'.maybeHandleOverflow(maxChars: 5), 'exact');
        
        // With overflow
        expect('too long text'.maybeHandleOverflow(maxChars: 7), 'too lon');
        
        // With replacement
        expect('very long text'.maybeHandleOverflow(maxChars: 8, replacement: '...'), 'very lon...');
        
        // No max (no truncation)
        expect('any length'.maybeHandleOverflow(), 'any length');
      });

      test('FFStringExt toCapitalization all modes', () {
        final text = 'hello world. how are you';
        
        expect(text.toCapitalization(TextCapitalization.none), text);
        expect(text.toCapitalization(TextCapitalization.words), 'Hello World. How Are You');
        expect(text.toCapitalization(TextCapitalization.sentences), 'Hello world. how are you');
        expect(text.toCapitalization(TextCapitalization.characters), 'HELLO WORLD. HOW ARE YOU');
      });
    });

    group('Collection Utilities Edge Cases', () {
      test('ListFilterExt withoutNulls comprehensive', () {
        expect(<int?>[].withoutNulls, []);
        expect(<int?>[null].withoutNulls, []);
        expect(<int?>[null, null, null].withoutNulls, []);
        expect([1, null, 2, null, 3].withoutNulls, [1, 2, 3]);
        expect([null, 1, null, 2, null].withoutNulls, [1, 2]);
        expect([1, 2, 3].withoutNulls, [1, 2, 3]);
      });

      test('MapFilterExtensions withoutNulls comprehensive', () {
        expect(<String, int?>{}.withoutNulls, {});
        expect({'a': null, 'b': null}.withoutNulls, {});
        expect({'a': 1, 'b': null, 'c': 3}.withoutNulls, {'a': 1, 'c': 3});
        expect({'x': 5, 'y': 10}.withoutNulls, {'x': 5, 'y': 10});
      });

      test('IterableExt sortedList with complex objects', () {
        final ages = [25, 30, 20];

        final sortedAges = ages.sortedList();
        expect(sortedAges, [20, 25, 30]);

        final sortedAgesDesc = ages.sortedList(desc: true);
        expect(sortedAgesDesc, [30, 25, 20]);

        final names = ['Charlie', 'Alice', 'Bob'];
        final sortedNames = names.sortedList();
        expect(sortedNames, ['Alice', 'Bob', 'Charlie']);
      });

      test('IterableExt mapIndexed with transformations', () {
        final result = ['a', 'b', 'c'].mapIndexed((i, s) => '$s${i * 2}');
        expect(result, ['a0', 'b2', 'c4']);

        final empty = <String>[].mapIndexed((i, s) => '$i:$s');
        expect(empty, []);
      });

      test('ListUniqueExt unique with duplicates', () {
        expect([1, 2, 2, 3, 3, 3, 4].unique((x) => x), [1, 2, 3, 4]);
        expect(['a', 'b', 'a', 'c', 'b'].unique((x) => x), ['a', 'b', 'c']);
        expect([1, 2, 3].unique((x) => x), [1, 2, 3]);
        expect(<int>[].unique((x) => x), []);
      });

      test('containsMap with complex maps', () {
        final list = [
          {'name': 'Alice', 'age': 30},
          {'name': 'Bob', 'age': 25},
        ];

        expect(list.containsMap({'name': 'Alice', 'age': 30}), true);
        expect(list.containsMap({'name': 'Charlie', 'age': 35}), false);
        expect(list.containsMap({'age': 30}), false); // Partial match shouldn't work
      });
    });

    group('Type Casting Edge Cases', () {
      test('castToType comprehensive type conversions', () {
        // String pass-through
        expect(castToType<String>('test'), 'test');
        
        // Int conversions
        expect(castToType<int>(42), 42);
        expect(castToType<int>(42.0), 42);
        // Note: castToType only converts if value.toInt() == value
        
        // Double conversions
        expect(castToType<double>(10), 10.0);
        expect(castToType<double>(5.5), 5.5);
        
        // Bool pass-through
        expect(castToType<bool>(true), true);
        expect(castToType<bool>(false), false);
        
        // List pass-through
        expect(castToType<List>([1, 2, 3]), [1, 2, 3]);
        
        // Null handling
        expect(castToType<String>(null), null);
        expect(castToType<int>(null), null);
      });
    });

    group('Gradient and Math Utilities', () {
      test('roundTo with various precision levels', () {
        expect(roundTo(1.2345, 0), contains('1'));
        expect(roundTo(1.2345, 1), contains('1.2'));
        expect(roundTo(1.2345, 2), '1.23');
        expect(roundTo(1.2345, 3), contains('1.23'));
        expect(roundTo(1.2345, 4), '1.2345');
      });

      test('computeGradientAlignmentX at key angles', () {
        expect(computeGradientAlignmentX(0), isA<double>());
        expect(computeGradientAlignmentX(45), isA<double>());
        expect(computeGradientAlignmentX(90), isA<double>());
        expect(computeGradientAlignmentX(135), isA<double>());
        expect(computeGradientAlignmentX(180), isA<double>());
        expect(computeGradientAlignmentX(225), isA<double>());
        expect(computeGradientAlignmentX(270), isA<double>());
        expect(computeGradientAlignmentX(315), isA<double>());
      });

      test('computeGradientAlignmentY at key angles', () {
        expect(computeGradientAlignmentY(0), isA<double>());
        expect(computeGradientAlignmentY(45), isA<double>());
        expect(computeGradientAlignmentY(90), isA<double>());
        expect(computeGradientAlignmentY(135), isA<double>());
        expect(computeGradientAlignmentY(180), isA<double>());
        expect(computeGradientAlignmentY(225), isA<double>());
        expect(computeGradientAlignmentY(270), isA<double>());
        expect(computeGradientAlignmentY(315), isA<double>());
      });

      test('gradient functions handle angle wrapping', () {
        // Angles > 360 should wrap
        expect(computeGradientAlignmentX(370), closeTo(computeGradientAlignmentX(10), 0.01));
        expect(computeGradientAlignmentY(450), closeTo(computeGradientAlignmentY(90), 0.01));
      });
    });

    group('LatLng and Conversion Utilities', () {
      test('convertJsonToLatLng with edge cases', () {
        // Empty list
        expect(cf.convertJsonToLatLng([]), []);
        
        // Single item
        final single = cf.convertJsonToLatLng([{'latitude': 1.0, 'longitude': 2.0}]);
        expect(single.length, 1);
        
        // Large coordinates
        final large = cf.convertJsonToLatLng([{'latitude': 89.9, 'longitude': 179.9}]);
        expect(large[0].latitude, closeTo(89.9, 0.01));
        
        // Negative coordinates
        final negative = cf.convertJsonToLatLng([{'latitude': -45.0, 'longitude': -122.0}]);
        expect(negative[0].latitude, -45.0);
        expect(negative[0].longitude, -122.0);
      });

      test('LatLng helper functions', () {
        final latLng = LatLng(40.7128, -74.0060);
        
        expect(cf.getLatitude(latLng), 40.7128);
        expect(cf.getLongitude(latLng), -74.0060);
      });
    });
  });
}
