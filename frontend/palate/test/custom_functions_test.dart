import 'package:flutter_test/flutter_test.dart';
import 'package:palate/flutter_flow/custom_functions.dart' as f;
import 'package:ff_commons/flutter_flow/lat_lng.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  group('custom_functions', () {
    test('newCustomFunction repeats dollar', () {
      expect(f.newCustomFunction(3), '\$\$\$');
      expect(f.newCustomFunction(0), '');
      expect(f.newCustomFunction(1), '\$');
      expect(f.newCustomFunction(5), '\$\$\$\$\$');
    });

    test('latlng conversions', () {
      final latlng = LatLng(45.0, -73.0);
      expect(f.getLatitude(latlng), 45.0);
      expect(f.getLongitude(latlng), -73.0);
      
      final latlng2 = LatLng(0.0, 0.0);
      expect(f.getLatitude(latlng2), 0.0);
      expect(f.getLongitude(latlng2), 0.0);
    });

    test('convertJsonToLatLng', () {
      final json = [
        {'latitude': 1, 'longitude': 2},
        {'latitude': 3.5, 'longitude': -4.2},
      ];
      final res = f.convertJsonToLatLng(json);
      expect(res.length, 2);
      expect(res[0].latitude, 1.0);
      expect(res[1].longitude, -4.2);
      
      // Test empty list
      expect(f.convertJsonToLatLng([]), []);
    });

    test('subarray clamps bounds', () {
      final items = ['a','b','c'];
      expect(f.subarray(-1, 2, items), ['a','b']);
      expect(f.subarray(2, 5, items), ['c']);
      expect(f.subarray(10, 1, items), []);
      expect(f.subarray(0, 0, items), []);
      expect(f.subarray(0, 3, items), ['a','b','c']);
      expect(f.subarray(1, 2, items), ['b','c']);
    });

    test('distanceToTime human friendly', () {
      final t = f.distanceToTime(1400);
      expect(t.isNotEmpty, true);
      
      final t2 = f.distanceToTime(500);
      expect(t2.isNotEmpty, true);
      
      final t3 = f.distanceToTime(5000);
      expect(t3.isNotEmpty, true);
    });

    test('distanceToTime formats hours correctly', () {
      // Test long distance that should show hours
      final longDistance = 10000.0; // ~10km walk
      final result = f.distanceToTime(longDistance);
      expect(result, contains('hr'));
    });

    test('distanceToTime with only hours (no remaining minutes)', () {
      // Find distance that gives exactly X hours with 0 remaining minutes
      // walkingSpeed=1.4m/s, buffer=1.2
      // For 1 hour exactly: 3600s * 1.4m/s / 1.2 = 4200m
      final exactHour = 4200.0;
      final result = f.distanceToTime(exactHour);
      expect(result, contains('hr'));
    });

    test('findArchetype returns string for 8 answers', () {
      final answers = [1,2,3,4,1,2,3,4];
      final res = f.findArchetype(answers);
      expect(res.isNotEmpty, true);
      
      final answers2 = [1,1,1,1,1,1,1,1];
      final res2 = f.findArchetype(answers2);
      expect(res2.isNotEmpty, true);
    });

    test('findArchetype handles insufficient answers', () {
      final tooFew = [1,2,3];
      expect(f.findArchetype(tooFew), '');
      expect(f.findArchetype([]), '');
    });

    test('findArchetype Explorer scoring', () {
      // Q1=1 (Always try new) +3, Q3=3 (Gut feeling) +2, Q4=1 (Most unique) +3, Q6=1 (Hidden gem) +3, Q8=3 (Minimal research) +2
      final explorerAnswers = [1, 1, 3, 1, 1, 1, 1, 3];
      expect(f.findArchetype(explorerAnswers), 'Explorer');
    });

    test('findArchetype Purist scoring', () {
      // Q2=1 (Food quality) +3, Q4=2 (Chef's signature) +2, Q6=2 (Michelin) +3, Q7=3 (Depends) +1
      final puristAnswers = [2, 1, 1, 2, 3, 2, 3, 1];
      expect(f.findArchetype(puristAnswers), 'Purist');
    });

    test('findArchetype Social Curator scoring', () {
      // Q2=3 (Social experience) +3, Q3=2 (Friend recommendations) +2, Q7=1 (Essential) +3
      final socialAnswers = [2, 3, 2, 2, 2, 3, 1, 2];
      expect(f.findArchetype(socialAnswers), 'Social Curator');
    });

    test('findArchetype Trend Seeker scoring', () {
      // Q2=4 (Popularity) +3, Q3=1 (Online reviews) +2, Q4=3 (What everyone gets) +2, Q6=3 (Buzziest spot) +3, Q8=1 (Research extensively) +2
      final trendAnswers = [2, 4, 1, 3, 1, 3, 2, 1];
      expect(f.findArchetype(trendAnswers), 'Trend Seeker');
    });

    test('findArchetype Conformist scoring', () {
      // Q1=4 (Rarely) +3, Q1=3 (Sometimes) +1, Q3=4 (Regular spots) +2, Q4=4 (Familiar) +3, Q8=4 (No research) +2
      final conformistAnswers = [4, 1, 4, 4, 4, 3, 2, 4];
      expect(f.findArchetype(conformistAnswers), 'Conformist');
    });

    test('findArchetype Aestheticist scoring', () {
      // Q2=2 (Ambiance) +3, Q5=1 (Always photo) +3, Q6=4 (Stunning & photogenic) +3, Q8=2 (Some research) +1
      final aestheticistAnswers = [2, 2, 1, 2, 1, 4, 2, 2];
      expect(f.findArchetype(aestheticistAnswers), 'Aestheticist');
    });

    test('findArchetype Q1 coverage - all cases', () {
      // Case 1: Always
      expect(f.findArchetype([1,1,1,1,1,1,1,1]), isNotEmpty);
      // Case 2: Often (already covered above)
      // Case 3: Sometimes
      expect(f.findArchetype([3,1,1,1,1,1,1,1]), isNotEmpty);
      // Case 4: Rarely (covered in conformist)
    });

    test('findArchetype Q5 coverage - photo taking', () {
      // Case 1: Always (covered in aestheticist)
      // Case 2: Sometimes
      expect(f.findArchetype([2,2,1,1,2,1,1,1]), isNotEmpty);
      // Case 3: Rarely
      expect(f.findArchetype([2,1,1,2,3,2,3,1]), isNotEmpty);
      // Case 4: Never
      expect(f.findArchetype([2,1,1,1,4,1,1,1]), isNotEmpty);
    });

    test('findArchetype Q7 coverage - dining companions', () {
      // Case 1: Essential (covered in social)
      // Case 2: Preferred
      expect(f.findArchetype([2,3,2,2,2,3,2,2]), isNotEmpty);
      // Case 3: Depends (covered in purist)
      // Case 4: Solo
      expect(f.findArchetype([2,1,1,2,3,2,4,1]), isNotEmpty);
    });

    test('idToDoc converts strings to DocumentReferences', () {
      // Skip: requires Firebase initialization which is complex in unit tests
      // This function is thin wrapper: ids.map((id) => FirebaseFirestore.instance.collection('restaurants').doc(id))
    }, skip: true);

    test('convertJsonToRestaurant with valid data', () {
      final json = [
        {
          'name': 'Test Restaurant',
          'business_status': 'OPERATIONAL',
          'rating': 4.5,
          'price_level': 2,
          'primary_type': 'restaurant',
          'user_rating_count': 100,
          'place_id': 'place123',
          'types': ['restaurant', 'food'],
          'photos': ['photo1.jpg', 'photo2.jpg'],
        },
        {
          'name': 'Another Place',
          'rating': '3.8', // string rating
          'price_level': '1', // string price
          'place_id': 'place456',
        }
      ];

      final restaurants = f.convertJsonToRestaurant(json);
      expect(restaurants.length, 2);
      expect(restaurants[0].name, 'Test Restaurant');
      expect(restaurants[0].rating, 4.5);
      expect(restaurants[0].priceLevel, 2);
      expect(restaurants[0].types.length, 2);
      expect(restaurants[0].photos.length, 2);
      
      // Check string-to-number conversion
      expect(restaurants[1].name, 'Another Place');
      expect(restaurants[1].rating, 3.8);
      expect(restaurants[1].priceLevel, 1);
    });

    test('convertJsonToRestaurant handles empty and invalid data', () {
      expect(f.convertJsonToRestaurant([]), []);
      
      final mixedJson = [
        {'name': 'Valid'},
        'invalid',
        null,
        {'name': 'Another Valid'},
      ];
      final result = f.convertJsonToRestaurant(mixedJson);
      expect(result.length, 2);
      expect(result[0].name, 'Valid');
      expect(result[1].name, 'Another Valid');
    });

    test('convertJsonToRestaurant converts non-string values to strings', () {
      final json = [
        {
          'name': 12345, // Number as name should be converted to string via toString()
          'business_status': true, // Boolean should be converted to string
          'place_id': 999,
        }
      ];
      final result = f.convertJsonToRestaurant(json);
      expect(result.length, 1);
      expect(result[0].name, '12345');
      expect(result[0].businessStatus, 'true');
      expect(result[0].placeId, '999');
    });

    test('convertJsonToSingleRes creates restaurant from single object', () {
      final json = {
        'name': 'Single Restaurant',
        'business_status': 'OPERATIONAL',
        'rating': 4.2,
        'price_level': 3,
        'primary_type': 'cafe',
        'user_rating_count': 250,
        'place_id': 'single_place',
        'types': ['cafe', 'bakery'],
        'photos': ['photo_a.jpg'],
      };

      final restaurant = f.convertJsonToSingleRes(json);
      expect(restaurant.name, 'Single Restaurant');
      expect(restaurant.rating, 4.2);
      expect(restaurant.priceLevel, 3);
      expect(restaurant.placeId, 'single_place');
    });

    test('convertJsonToSingleRes handles string numbers', () {
      final json = {
        'name': 'String Numbers',
        'rating': '4.7',
        'price_level': '2',
        'user_rating_count': '500',
      };

      final restaurant = f.convertJsonToSingleRes(json);
      expect(restaurant.rating, 4.7);
      expect(restaurant.priceLevel, 2);
      expect(restaurant.userRatingCount, 500);
    });

    test('convertJsonToSingleRes converts non-string values to strings', () {
      final json = {
        'name': 54321, // Number as name
        'primary_type': false, // Boolean as primary_type
        'place_id': 777, // Number as place_id
      };

      final restaurant = f.convertJsonToSingleRes(json);
      expect(restaurant.name, '54321');
      expect(restaurant.primaryType, 'false');
      expect(restaurant.placeId, '777');
    });

    test('convertJsonToSingleRes throws on invalid input', () {
      expect(() => f.convertJsonToSingleRes('not a map'), throwsArgumentError);
      expect(() => f.convertJsonToSingleRes(123), throwsArgumentError);
      expect(() => f.convertJsonToSingleRes(null), throwsArgumentError);
      expect(() => f.convertJsonToSingleRes([]), throwsArgumentError);
    });

    // Note: idToDoc tests require Firebase initialization, skipping in unit tests
    test('idToDoc handles empty list', () {
      final docs = f.idToDoc([]);
      expect(docs, []);
    });

    test('convertJsonToRestaurant handles all numeric types', () {
      final json = [
        {
          'name': 'Test',
          'rating': 4, // int instead of double
          'price_level': 2.0, // double instead of int
          'user_rating_count': 100.5, // double that should convert to int
        }
      ];

      final restaurants = f.convertJsonToRestaurant(json);
      expect(restaurants.length, 1);
      expect(restaurants[0].rating, isA<double>());
      expect(restaurants[0].priceLevel, isA<int>());
    });

    test('convertJsonToRestaurant handles empty strings in lists', () {
      final json = [
        {
          'name': 'Test',
          'types': ['cafe', '', 'restaurant', null, 'bar'],
          'photos': ['photo1.jpg', '', 'photo2.jpg'],
        }
      ];

      final restaurants = f.convertJsonToRestaurant(json);
      expect(restaurants.length, 1);
      expect(restaurants[0].types.length, greaterThan(0));
      expect(restaurants[0].photos.length, greaterThan(0));
    });

    test('convertJsonToRestaurant handles description field', () {
      final json = [
        {
          'name': 'Test',
          'editorial': 'Great place to eat',
        }
      ];

      final restaurants = f.convertJsonToRestaurant(json);
      expect(restaurants.length, 1);
      // description field may be present
    });

    test('convertJsonToSingleRes handles all field types', () {
      final json = {
        'name': 'Complete',
        'business_status': 'OPERATIONAL',
        'rating': 4.8,
        'price_level': 4,
        'primary_type': 'fine_dining',
        'user_rating_count': 1000,
        'place_id': 'complete_place',
        'types': ['restaurant', 'fine_dining', 'upscale'],
        'photos': ['p1.jpg', 'p2.jpg', 'p3.jpg'],
      };

      final restaurant = f.convertJsonToSingleRes(json);
      expect(restaurant.name, 'Complete');
      expect(restaurant.businessStatus, 'OPERATIONAL');
      expect(restaurant.rating, 4.8);
      expect(restaurant.priceLevel, 4);
      expect(restaurant.primaryType, 'fine_dining');
      expect(restaurant.userRatingCount, 1000);
      expect(restaurant.placeId, 'complete_place');
      expect(restaurant.types.length, 3);
      expect(restaurant.photos.length, 3);
    });

    test('convertJsonToSingleRes handles missing optional fields', () {
      final json = {
        'name': 'Minimal',
      };

      final restaurant = f.convertJsonToSingleRes(json);
      expect(restaurant.name, 'Minimal');
      // Optional fields may have default values like empty strings
    });

    test('convertJsonToSingleRes coerces numeric types', () {
      final json = {
        'name': 'Coerce',
        'rating': 5, // int to double
        'price_level': 3.0, // double to int
        'user_rating_count': 250, // int stays int
      };

      final restaurant = f.convertJsonToSingleRes(json);
      expect(restaurant.rating, 5.0);
      expect(restaurant.priceLevel, 3);
      expect(restaurant.userRatingCount, 250);
    });

    test('subarray handles edge cases with length', () {
      final items = ['a', 'b', 'c', 'd', 'e'];
      
      // Length of 1
      expect(f.subarray(0, 1, items), ['a']);
      expect(f.subarray(2, 1, items), ['c']);
      
      // Exact remaining length
      expect(f.subarray(3, 2, items), ['d', 'e']);
      
      // Start at end
      expect(f.subarray(5, 1, items), []);
    });

    test('distanceToTime edge cases', () {
      // Very short distance
      expect(f.distanceToTime(50), isNotEmpty);
      
      // Exactly 1 minute worth
      expect(f.distanceToTime(100), isNotEmpty);
      
      // Large distance with hours and minutes
      expect(f.distanceToTime(15000), contains('hr'));
    });

    test('newCustomFunction edge cases', () {
      expect(f.newCustomFunction(10), '\$\$\$\$\$\$\$\$\$\$');
      expect(f.newCustomFunction(2), '\$\$');
    });

    test('convertJsonToLatLng handles various number types', () {
      final json = [
        {'latitude': 1, 'longitude': 2}, // ints
        {'latitude': 3.5, 'longitude': -4.2}, // doubles
        {'latitude': 0, 'longitude': 0}, // zeros
      ];
      
      final result = f.convertJsonToLatLng(json);
      expect(result.length, 3);
      expect(result[0].latitude, 1.0);
      expect(result[1].longitude, -4.2);
      expect(result[2].latitude, 0.0);
    });
  });
}
