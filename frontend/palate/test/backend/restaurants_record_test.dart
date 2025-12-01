import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:palate/backend/schema/restaurants_record.dart';
import 'package:palate/backend/schema/structs/boolean_map_struct.dart';
import 'package:palate/backend/schema/structs/string_map_struct.dart';

void main() {
  group('RestaurantsRecord', () {
    late FakeFirebaseFirestore fakeFirestore;
    late CollectionReference restaurantsCollection;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      restaurantsCollection = fakeFirestore.collection('restaurants');
    });

    group('Field Accessors', () {
      test('should return default values for all boolean fields', () {
        final data = <String, dynamic>{};
        final doc = restaurantsCollection.doc('test');
        
        // Add document to Firestore
        restaurantsCollection.doc('test').set(data);
        
        // Get the document
        return restaurantsCollection.doc('test').get().then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.allowDogs, false);
          expect(record.delivery, false);
          expect(record.dineIn, false);
          expect(record.goodForGroups, false);
          expect(record.goodForWatchingSports, false);
          expect(record.liveMusic, false);
          expect(record.openNow, false);
          expect(record.outdoorSeating, false);
          expect(record.reservable, false);
          expect(record.servesBeer, false);
          expect(record.servesBreakfast, false);
          expect(record.servesLunch, false);
          expect(record.servesVegetarian, false);
          expect(record.servesWine, false);
          expect(record.takeout, false);
        });
      });

      test('should return default values for string fields', () {
        final data = <String, dynamic>{};
        
        return restaurantsCollection.doc('test').set(data).then((_) {
          return restaurantsCollection.doc('test').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.category, '');
          expect(record.formattedAddress, '');
          expect(record.name, '');
          expect(record.placeId, '');
          expect(record.primaryType, '');
          expect(record.googlePlacesId, '');
          expect(record.searchTimestamp, '');
        });
      });

      test('should return default values for numeric fields', () {
        final data = <String, dynamic>{};
        
        return restaurantsCollection.doc('test').set(data).then((_) {
          return restaurantsCollection.doc('test').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.distanceMeters, 0.0);
          expect(record.latitude, 0.0);
          expect(record.longitude, 0.0);
          expect(record.rating, 0.0);
          expect(record.priceRange, 0);
          expect(record.userRatingCount, 0);
        });
      });

      test('should return empty lists for list fields', () {
        final data = <String, dynamic>{};
        
        return restaurantsCollection.doc('test').set(data).then((_) {
          return restaurantsCollection.doc('test').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.accessibilityOptions, isEmpty);
          expect(record.googleTypes, isEmpty);
          expect(record.hasRestroom, isEmpty);
          expect(record.mapLinks, isEmpty);
          expect(record.paymentOptions, isEmpty);
          expect(record.types, isEmpty);
          expect(record.images, isEmpty);
        });
      });

      test('should parse all boolean fields correctly', () {
        final data = <String, dynamic>{
          'allow_dogs': true,
          'delivery': true,
          'dine_in': true,
          'good_for_groups': true,
          'good_for_watching_sports': true,
          'live_music': true,
          'open_now': true,
          'outdoor_seating': true,
          'reservable': true,
          'serves_beer': true,
          'serves_breakfast': true,
          'serves_lunch': true,
          'serves_vegetarian': true,
          'serves_wine': true,
          'takeout': true,
        };
        
        return restaurantsCollection.doc('test').set(data).then((_) {
          return restaurantsCollection.doc('test').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.allowDogs, true);
          expect(record.delivery, true);
          expect(record.dineIn, true);
          expect(record.goodForGroups, true);
          expect(record.goodForWatchingSports, true);
          expect(record.liveMusic, true);
          expect(record.openNow, true);
          expect(record.outdoorSeating, true);
          expect(record.reservable, true);
          expect(record.servesBeer, true);
          expect(record.servesBreakfast, true);
          expect(record.servesLunch, true);
          expect(record.servesVegetarian, true);
          expect(record.servesWine, true);
          expect(record.takeout, true);
        });
      });

      test('should parse string fields correctly', () {
        final data = <String, dynamic>{
          'category': 'Italian Restaurant',
          'formatted_address': '123 Main St, Toronto, ON',
          'name': 'Test Restaurant',
          'place_id': 'ChIJ123abc',
          'primary_type': 'restaurant',
          'google_places_id': 'google123',
          'search_timestamp': '2025-01-01T12:00:00Z',
        };
        
        return restaurantsCollection.doc('test').set(data).then((_) {
          return restaurantsCollection.doc('test').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.category, 'Italian Restaurant');
          expect(record.formattedAddress, '123 Main St, Toronto, ON');
          expect(record.name, 'Test Restaurant');
          expect(record.placeId, 'ChIJ123abc');
          expect(record.primaryType, 'restaurant');
          expect(record.googlePlacesId, 'google123');
          expect(record.searchTimestamp, '2025-01-01T12:00:00Z');
        });
      });

      test('should parse numeric fields correctly', () {
        final data = <String, dynamic>{
          'distance_meters': 1500.5,
          'latitude': 43.6532,
          'longitude': -79.3832,
          'rating': 4.5,
          'price_range': 2,
          'user_rating_count': 250,
        };
        
        return restaurantsCollection.doc('test').set(data).then((_) {
          return restaurantsCollection.doc('test').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.distanceMeters, 1500.5);
          expect(record.latitude, 43.6532);
          expect(record.longitude, -79.3832);
          expect(record.rating, 4.5);
          expect(record.priceRange, 2);
          expect(record.userRatingCount, 250);
        });
      });

      test('should parse DateTime fields correctly', () {
        final now = DateTime.now();
        final data = <String, dynamic>{
          'created_at': Timestamp.fromDate(now),
          'last_updated': Timestamp.fromDate(now),
        };
        
        return restaurantsCollection.doc('test').set(data).then((_) {
          return restaurantsCollection.doc('test').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.createdAt, isNotNull);
          expect(record.lastUpdated, isNotNull);
          expect(record.hasCreatedAt(), true);
          expect(record.hasLastUpdated(), true);
        });
      });

      test('should parse list fields correctly', () {
        final data = <String, dynamic>{
          'google_types': ['restaurant', 'food', 'point_of_interest'],
          'types': ['italian_restaurant', 'pizza_place'],
          'has_restroom': [true, false],
          'images': ['image1.jpg', 'image2.jpg', 'image3.jpg'],
        };
        
        return restaurantsCollection.doc('test').set(data).then((_) {
          return restaurantsCollection.doc('test').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.googleTypes, ['restaurant', 'food', 'point_of_interest']);
          expect(record.types, ['italian_restaurant', 'pizza_place']);
          expect(record.hasRestroom, [true, false]);
          expect(record.images, ['image1.jpg', 'image2.jpg', 'image3.jpg']);
        });
      });
    });

    group('Has Methods', () {
      test('should return false for missing optional fields', () {
        final data = <String, dynamic>{};
        
        return restaurantsCollection.doc('test').set(data).then((_) {
          return restaurantsCollection.doc('test').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.hasCategory(), false);
          expect(record.hasName(), false);
          expect(record.hasPlaceId(), false);
          expect(record.hasCreatedAt(), false);
          expect(record.hasLastUpdated(), false);
        });
      });

      test('should return true for present optional fields', () {
        final data = <String, dynamic>{
          'category': 'Restaurant',
          'name': 'Test Place',
          'place_id': 'place123',
          'created_at': Timestamp.now(),
        };
        
        return restaurantsCollection.doc('test').set(data).then((_) {
          return restaurantsCollection.doc('test').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.hasCategory(), true);
          expect(record.hasName(), true);
          expect(record.hasPlaceId(), true);
          expect(record.hasCreatedAt(), true);
        });
      });
    });

    group('Struct Fields', () {
      test('should parse parking options struct', () {
        final data = <String, dynamic>{
          'parking_options': {
            'free_parking_lot': true,
            'paid_parking_lot': false,
          },
        };
        
        return restaurantsCollection.doc('test').set(data).then((_) {
          return restaurantsCollection.doc('test').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.hasParkingOptions(), true);
          expect(record.parkingOptions, isA<BooleanMapStruct>());
        });
      });

      test('should parse list of BooleanMapStruct for accessibility options', () {
        final data = <String, dynamic>{
          'accessibility_options': [
            {'wheelchair_accessible': true},
            {'wheelchair_accessible_entrance': true},
          ],
        };
        
        return restaurantsCollection.doc('test').set(data).then((_) {
          return restaurantsCollection.doc('test').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.hasAccessibilityOptions(), true);
          expect(record.accessibilityOptions, hasLength(2));
          expect(record.accessibilityOptions[0], isA<BooleanMapStruct>());
        });
      });

      test('should parse list of BooleanMapStruct for payment options', () {
        final data = <String, dynamic>{
          'payment_options': [
            {'cash_only': false},
            {'credit_cards': true},
            {'debit_cards': true},
          ],
        };
        
        return restaurantsCollection.doc('test').set(data).then((_) {
          return restaurantsCollection.doc('test').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.hasPaymentOptions(), true);
          expect(record.paymentOptions, hasLength(3));
          expect(record.paymentOptions[0], isA<BooleanMapStruct>());
        });
      });

      test('should parse list of StringMapStruct for map links', () {
        final data = <String, dynamic>{
          'map_links': [
            {'google_maps': 'https://maps.google.com/place123'},
            {'apple_maps': 'https://maps.apple.com/place123'},
          ],
        };
        
        return restaurantsCollection.doc('test').set(data).then((_) {
          return restaurantsCollection.doc('test').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.hasMapLinks(), true);
          expect(record.mapLinks, hasLength(2));
          expect(record.mapLinks[0], isA<StringMapStruct>());
        });
      });
    });

    group('Static Methods (with fake Firestore)', () {
      test('should create from snapshot', () {
        final data = <String, dynamic>{
          'name': 'Test Restaurant',
          'rating': 4.5,
        };
        
        return restaurantsCollection.doc('test').set(data).then((_) {
          return restaurantsCollection.doc('test').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record, isA<RestaurantsRecord>());
          expect(record.name, 'Test Restaurant');
          expect(record.rating, 4.5);
        });
      });

      test('should get document as stream', () async {
        final data = <String, dynamic>{'name': 'Stream Test'};
        await restaurantsCollection.doc('stream-test').set(data);
        
        final docRef = restaurantsCollection.doc('stream-test');
        final stream = RestaurantsRecord.getDocument(docRef);
        
        expect(stream, isA<Stream<RestaurantsRecord>>());
        
        final record = await stream.first;
        expect(record.name, 'Stream Test');
      });

      test('should get document once as future', () async {
        final data = <String, dynamic>{'name': 'Future Test'};
        await restaurantsCollection.doc('future-test').set(data);
        
        final docRef = restaurantsCollection.doc('future-test');
        final record = await RestaurantsRecord.getDocumentOnce(docRef);
        
        expect(record, isA<RestaurantsRecord>());
        expect(record.name, 'Future Test');
      });

      test('should create from data with reference', () {
        final data = <String, dynamic>{
          'name': 'Data Test',
          'rating': 3.5,
          'place_id': 'place789',
        };
        final docRef = restaurantsCollection.doc('data-test');
        
        final record = RestaurantsRecord.getDocumentFromData(data, docRef);
        
        expect(record, isA<RestaurantsRecord>());
        expect(record.name, 'Data Test');
        expect(record.rating, 3.5);
        expect(record.placeId, 'place789');
      });
    });

    group('Object Methods', () {
      test('should generate toString correctly', () async {
        final data = <String, dynamic>{'name': 'ToString Test'};
        await restaurantsCollection.doc('tostring').set(data);
        
        final snapshot = await restaurantsCollection.doc('tostring').get();
        final record = RestaurantsRecord.fromSnapshot(snapshot);
        
        final str = record.toString();
        expect(str, contains('RestaurantsRecord'));
        expect(str, contains('reference'));
      });

      test('should implement equality based on reference path', () async {
        final data = <String, dynamic>{'name': 'Equality Test'};
        await restaurantsCollection.doc('eq1').set(data);
        await restaurantsCollection.doc('eq2').set(data);
        
        final snapshot1 = await restaurantsCollection.doc('eq1').get();
        final snapshot2 = await restaurantsCollection.doc('eq2').get();
        final snapshot1Again = await restaurantsCollection.doc('eq1').get();
        
        final record1 = RestaurantsRecord.fromSnapshot(snapshot1);
        final record2 = RestaurantsRecord.fromSnapshot(snapshot2);
        final record1Again = RestaurantsRecord.fromSnapshot(snapshot1Again);
        
        // Same path should be equal
        expect(record1 == record1Again, true);
        
        // Different paths should not be equal
        expect(record1 == record2, false);
      });

      test('should generate consistent hashCode', () async {
        final data = <String, dynamic>{'name': 'Hash Test'};
        await restaurantsCollection.doc('hash').set(data);
        
        final snapshot = await restaurantsCollection.doc('hash').get();
        final record1 = RestaurantsRecord.fromSnapshot(snapshot);
        final record2 = RestaurantsRecord.fromSnapshot(snapshot);
        
        expect(record1.hashCode, equals(record2.hashCode));
      });
    });

    group('createRestaurantsRecordData', () {
      test('should create data map with all fields', () {
        final parkingOptions = BooleanMapStruct();
        
        final data = createRestaurantsRecordData(
          allowDogs: true,
          category: 'Italian',
          createdAt: DateTime.now(),
          delivery: true,
          dineIn: true,
          distanceMeters: 500.0,
          formattedAddress: '456 Oak St',
          goodForGroups: true,
          goodForWatchingSports: false,
          lastUpdated: DateTime.now(),
          latitude: 43.0,
          liveMusic: true,
          name: 'Test Pizzeria',
          openNow: true,
          outdoorSeating: false,
          parkingOptions: parkingOptions,
          placeId: 'placeXYZ',
          priceRange: 2,
          primaryType: 'restaurant',
          rating: 4.2,
          reservable: true,
          servesBeer: true,
          servesBreakfast: false,
          servesLunch: true,
          servesVegetarian: true,
          servesWine: true,
          takeout: true,
          userRatingCount: 150,
          googlePlacesId: 'googleABC',
          longitude: -79.0,
          searchTimestamp: '2025-01-15',
        );
        
        expect(data, isA<Map<String, dynamic>>());
        expect(data['allow_dogs'], true);
        expect(data['category'], 'Italian');
        expect(data['delivery'], true);
        expect(data['name'], 'Test Pizzeria');
        expect(data['rating'], 4.2);
        expect(data['user_rating_count'], 150);
      });

      test('should omit null values', () {
        final data = createRestaurantsRecordData(
          name: 'Only Name',
          // All other fields null
        );
        
        expect(data.containsKey('name'), true);
        expect(data.containsKey('category'), false);
        expect(data.containsKey('allow_dogs'), false);
      });

      test('should handle nested struct data', () {
        final parkingOptions = BooleanMapStruct();
        
        final data = createRestaurantsRecordData(
          parkingOptions: parkingOptions,
          name: 'Struct Test',
        );
        
        expect(data.containsKey('parking_options'), true);
        expect(data['parking_options'], isA<Map>());
      });
    });

    group('RestaurantsRecordDocumentEquality', () {
      test('should compare records for equality', () async {
        final data1 = <String, dynamic>{
          'name': 'Restaurant A',
          'rating': 4.5,
          'place_id': 'place1',
        };
        final data2 = <String, dynamic>{
          'name': 'Restaurant A',
          'rating': 4.5,
          'place_id': 'place1',
        };
        final data3 = <String, dynamic>{
          'name': 'Restaurant B',
          'rating': 3.5,
          'place_id': 'place2',
        };
        
        await restaurantsCollection.doc('rec1').set(data1);
        await restaurantsCollection.doc('rec2').set(data2);
        await restaurantsCollection.doc('rec3').set(data3);
        
        final snap1 = await restaurantsCollection.doc('rec1').get();
        final snap2 = await restaurantsCollection.doc('rec2').get();
        final snap3 = await restaurantsCollection.doc('rec3').get();
        
        final record1 = RestaurantsRecord.fromSnapshot(snap1);
        final record2 = RestaurantsRecord.fromSnapshot(snap2);
        final record3 = RestaurantsRecord.fromSnapshot(snap3);
        
        const equality = RestaurantsRecordDocumentEquality();
        
        // Same field values should be equal
        expect(equality.equals(record1, record2), true);
        
        // Different values should not be equal
        expect(equality.equals(record1, record3), false);
      });

      test('should generate consistent hash for same data', () async {
        final data = <String, dynamic>{
          'name': 'Hash Restaurant',
          'rating': 4.0,
        };
        
        await restaurantsCollection.doc('h1').set(data);
        await restaurantsCollection.doc('h2').set(data);
        
        final snap1 = await restaurantsCollection.doc('h1').get();
        final snap2 = await restaurantsCollection.doc('h2').get();
        
        final record1 = RestaurantsRecord.fromSnapshot(snap1);
        final record2 = RestaurantsRecord.fromSnapshot(snap2);
        
        const equality = RestaurantsRecordDocumentEquality();
        
        expect(equality.hash(record1), equals(equality.hash(record2)));
      });

      test('isValidKey should return true for RestaurantsRecord', () async {
        final data = <String, dynamic>{'name': 'Valid Key Test'};
        await restaurantsCollection.doc('valid').set(data);
        
        final snapshot = await restaurantsCollection.doc('valid').get();
        final record = RestaurantsRecord.fromSnapshot(snapshot);
        
        const equality = RestaurantsRecordDocumentEquality();
        
        expect(equality.isValidKey(record), true);
        expect(equality.isValidKey('not a record'), false);
        expect(equality.isValidKey(null), false);
      });
    });

    group('Complex Scenarios', () {
      test('should handle fully populated restaurant record', () {
        final data = <String, dynamic>{
          'name': 'Full Restaurant',
          'place_id': 'place_full_123',
          'google_places_id': 'google_full_123',
          'formatted_address': '789 Full St, Toronto, ON M5V 1A1',
          'latitude': 43.6532,
          'longitude': -79.3832,
          'rating': 4.7,
          'user_rating_count': 500,
          'price_range': 3,
          'category': 'Fine Dining',
          'primary_type': 'restaurant',
          'google_types': ['restaurant', 'food', 'establishment'],
          'types': ['fine_dining', 'italian_restaurant'],
          'allow_dogs': false,
          'delivery': true,
          'dine_in': true,
          'takeout': true,
          'reservable': true,
          'serves_breakfast': true,
          'serves_lunch': true,
          'serves_beer': true,
          'serves_wine': true,
          'serves_vegetarian': true,
          'good_for_groups': true,
          'good_for_watching_sports': false,
          'live_music': true,
          'open_now': true,
          'outdoor_seating': true,
          'distance_meters': 1200.5,
          'search_timestamp': '2025-01-15T10:30:00Z',
          'images': ['img1.jpg', 'img2.jpg', 'img3.jpg'],
          'created_at': Timestamp.now(),
          'last_updated': Timestamp.now(),
        };
        
        return restaurantsCollection.doc('full').set(data).then((_) {
          return restaurantsCollection.doc('full').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.name, 'Full Restaurant');
          expect(record.rating, 4.7);
          expect(record.userRatingCount, 500);
          expect(record.googleTypes, hasLength(3));
          expect(record.delivery, true);
          expect(record.reservable, true);
          expect(record.liveMusic, true);
          expect(record.images, hasLength(3));
        });
      });

      test('should handle minimal restaurant record', () {
        final data = <String, dynamic>{
          'name': 'Minimal Restaurant',
          'place_id': 'place_min_456',
        };
        
        return restaurantsCollection.doc('minimal').set(data).then((_) {
          return restaurantsCollection.doc('minimal').get();
        }).then((snapshot) {
          final record = RestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.name, 'Minimal Restaurant');
          expect(record.placeId, 'place_min_456');
          // All other fields should have defaults
          expect(record.rating, 0.0);
          expect(record.delivery, false);
          expect(record.googleTypes, isEmpty);
        });
      });
    });
  });
}
