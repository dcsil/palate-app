import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/restaurant_struct.dart';

void main() {
  group('RestaurantStruct', () {
    test('constructor with all parameters', () {
      final restaurant = RestaurantStruct(
        name: 'Test Restaurant',
        businessStatus: 'OPERATIONAL',
        rating: 4.5,
        priceLevel: 2,
        primaryType: 'restaurant',
        types: ['restaurant', 'food'],
        photos: ['photo1.jpg', 'photo2.jpg'],
        userRatingCount: 150,
        placeId: 'place_123',
        description: 'A great place to eat',
      );

      expect(restaurant.name, 'Test Restaurant');
      expect(restaurant.businessStatus, 'OPERATIONAL');
      expect(restaurant.rating, 4.5);
      expect(restaurant.priceLevel, 2);
      expect(restaurant.primaryType, 'restaurant');
      expect(restaurant.types, ['restaurant', 'food']);
      expect(restaurant.photos, ['photo1.jpg', 'photo2.jpg']);
      expect(restaurant.userRatingCount, 150);
      expect(restaurant.placeId, 'place_123');
      expect(restaurant.description, 'A great place to eat');
    });

    test('constructor with default values', () {
      final restaurant = RestaurantStruct();

      expect(restaurant.name, '');
      expect(restaurant.businessStatus, '');
      expect(restaurant.rating, 0.0);
      expect(restaurant.priceLevel, 0);
      expect(restaurant.primaryType, '');
      expect(restaurant.types, []);
      expect(restaurant.photos, []);
      expect(restaurant.userRatingCount, 0);
      expect(restaurant.placeId, '');
      expect(restaurant.description, '');
    });

    test('name setter and hasName', () {
      final restaurant = RestaurantStruct();
      expect(restaurant.hasName(), false);

      restaurant.name = 'New Name';
      expect(restaurant.name, 'New Name');
      expect(restaurant.hasName(), true);
    });

    test('businessStatus setter and hasBusinessStatus', () {
      final restaurant = RestaurantStruct();
      expect(restaurant.hasBusinessStatus(), false);

      restaurant.businessStatus = 'CLOSED';
      expect(restaurant.businessStatus, 'CLOSED');
      expect(restaurant.hasBusinessStatus(), true);
    });

    test('rating setter and increment', () {
      final restaurant = RestaurantStruct(rating: 3.5);
      expect(restaurant.hasRating(), true);
      expect(restaurant.rating, 3.5);

      restaurant.incrementRating(0.5);
      expect(restaurant.rating, 4.0);

      restaurant.rating = 5.0;
      expect(restaurant.rating, 5.0);
    });

    test('priceLevel setter and increment', () {
      final restaurant = RestaurantStruct(priceLevel: 2);
      expect(restaurant.hasPriceLevel(), true);
      expect(restaurant.priceLevel, 2);

      restaurant.incrementPriceLevel(1);
      expect(restaurant.priceLevel, 3);

      restaurant.priceLevel = 4;
      expect(restaurant.priceLevel, 4);
    });

    test('primaryType setter and hasPrimaryType', () {
      final restaurant = RestaurantStruct();
      expect(restaurant.hasPrimaryType(), false);

      restaurant.primaryType = 'cafe';
      expect(restaurant.primaryType, 'cafe');
      expect(restaurant.hasPrimaryType(), true);
    });

    test('types list operations', () {
      final restaurant = RestaurantStruct();
      expect(restaurant.hasTypes(), false);

      restaurant.types = ['restaurant', 'bar'];
      expect(restaurant.hasTypes(), true);
      expect(restaurant.types.length, 2);

      restaurant.updateTypes((list) {
        list.add('nightclub');
      });
      expect(restaurant.types.length, 3);
      expect(restaurant.types.contains('nightclub'), true);
    });

    test('photos list operations', () {
      final restaurant = RestaurantStruct();
      expect(restaurant.hasPhotos(), false);

      restaurant.photos = ['img1.jpg'];
      expect(restaurant.hasPhotos(), true);
      expect(restaurant.photos.length, 1);

      restaurant.updatePhotos((list) {
        list.add('img2.jpg');
        list.add('img3.jpg');
      });
      expect(restaurant.photos.length, 3);
    });

    test('userRatingCount increment and setter', () {
      final restaurant = RestaurantStruct(userRatingCount: 100);
      expect(restaurant.hasUserRatingCount(), true);
      expect(restaurant.userRatingCount, 100);

      restaurant.incrementUserRatingCount(50);
      expect(restaurant.userRatingCount, 150);

      restaurant.userRatingCount = 200;
      expect(restaurant.userRatingCount, 200);
    });

    test('placeId setter and hasPlaceId', () {
      final restaurant = RestaurantStruct();
      expect(restaurant.hasPlaceId(), false);

      restaurant.placeId = 'ChIJ123abc';
      expect(restaurant.placeId, 'ChIJ123abc');
      expect(restaurant.hasPlaceId(), true);
    });

    test('description setter and hasDescription', () {
      final restaurant = RestaurantStruct();
      expect(restaurant.hasDescription(), false);

      restaurant.description = 'Amazing food';
      expect(restaurant.description, 'Amazing food');
      expect(restaurant.hasDescription(), true);
    });

    test('serialize and deserialize', () {
      final original = RestaurantStruct(
        name: 'Serialized Restaurant',
        rating: 4.2,
        priceLevel: 3,
        types: ['italian', 'pizza'],
      );

      final map = original.toSerializableMap();
      expect(map['name'], 'Serialized Restaurant');
      // Rating might be serialized as string
      expect(map['rating'].toString(), '4.2');
      expect(map['price_level'].toString(), '3');

      final deserialized = RestaurantStruct.fromSerializableMap(map);
      expect(deserialized.name, original.name);
      expect(deserialized.rating, original.rating);
      expect(deserialized.priceLevel, original.priceLevel);
    });

    test('fromMap creates struct from map', () {
      final map = {
        'name': 'Mapped Restaurant',
        'business_status': 'OPERATIONAL',
        'rating': 4.8,
        'price_level': 2,
      };

      final restaurant = RestaurantStruct.fromMap(map);
      expect(restaurant.name, 'Mapped Restaurant');
      expect(restaurant.businessStatus, 'OPERATIONAL');
      expect(restaurant.rating, 4.8);
      expect(restaurant.priceLevel, 2);
    });

    test('maybeFromMap returns null for non-map', () {
      final result = RestaurantStruct.maybeFromMap('not a map');
      expect(result, null);
    });

    test('maybeFromMap returns struct for map', () {
      final map = {'name': 'Maybe Restaurant'};
      final result = RestaurantStruct.maybeFromMap(map);
      expect(result, isNotNull);
      expect(result!.name, 'Maybe Restaurant');
    });

    test('equality operator', () {
      final r1 = RestaurantStruct(
        name: 'Same',
        placeId: 'place1',
        rating: 4.0,
      );
      final r2 = RestaurantStruct(
        name: 'Same',
        placeId: 'place1',
        rating: 4.0,
      );
      final r3 = RestaurantStruct(
        name: 'Different',
        placeId: 'place2',
        rating: 3.0,
      );

      expect(r1 == r2, true);
      expect(r1 == r3, false);
    });

    test('hashCode consistency', () {
      final r1 = RestaurantStruct(name: 'Hash', placeId: 'p1');
      final r2 = RestaurantStruct(name: 'Hash', placeId: 'p1');

      expect(r1.hashCode, r2.hashCode);
    });

    test('toString produces valid output', () {
      final restaurant = RestaurantStruct(name: 'ToString Test');
      final str = restaurant.toString();
      expect(str, contains('RestaurantStruct'));
    });
  });
}
