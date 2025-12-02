import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/restaurant_struct.dart';

void main() {
  group('RestaurantStruct', () {
    test('should create struct with all fields', () {
      final restaurant = RestaurantStruct(
        name: 'Test Restaurant',
        businessStatus: 'OPERATIONAL',
        rating: 4.5,
        priceLevel: 2,
        primaryType: 'restaurant',
        types: ['restaurant', 'food'],
        photos: ['photo1.jpg', 'photo2.jpg'],
        userRatingCount: 100,
        placeId: 'place_123',
        description: 'A great place',
      );

      expect(restaurant.name, equals('Test Restaurant'));
      expect(restaurant.businessStatus, equals('OPERATIONAL'));
      expect(restaurant.rating, equals(4.5));
      expect(restaurant.priceLevel, equals(2));
      expect(restaurant.primaryType, equals('restaurant'));
      expect(restaurant.types, equals(['restaurant', 'food']));
      expect(restaurant.photos, equals(['photo1.jpg', 'photo2.jpg']));
      expect(restaurant.userRatingCount, equals(100));
      expect(restaurant.placeId, equals('place_123'));
      expect(restaurant.description, equals('A great place'));
    });

    test('should create struct with default values', () {
      final restaurant = RestaurantStruct();

      expect(restaurant.name, equals(''));
      expect(restaurant.businessStatus, equals(''));
      expect(restaurant.rating, equals(0.0));
      expect(restaurant.priceLevel, equals(0));
      expect(restaurant.primaryType, equals(''));
      expect(restaurant.types, isEmpty);
      expect(restaurant.photos, isEmpty);
      expect(restaurant.userRatingCount, equals(0));
      expect(restaurant.placeId, equals(''));
      expect(restaurant.description, equals(''));
    });

    test('should set and get name', () {
      final restaurant = RestaurantStruct();
      restaurant.name = 'New Name';
      expect(restaurant.name, equals('New Name'));
      expect(restaurant.hasName(), isTrue);
    });

    test('should set and get businessStatus', () {
      final restaurant = RestaurantStruct();
      restaurant.businessStatus = 'CLOSED_TEMPORARILY';
      expect(restaurant.businessStatus, equals('CLOSED_TEMPORARILY'));
      expect(restaurant.hasBusinessStatus(), isTrue);
    });

    test('should set and get rating', () {
      final restaurant = RestaurantStruct();
      restaurant.rating = 3.8;
      expect(restaurant.rating, equals(3.8));
      expect(restaurant.hasRating(), isTrue);
    });

    test('should increment rating', () {
      final restaurant = RestaurantStruct(rating: 4.0);
      restaurant.incrementRating(0.5);
      expect(restaurant.rating, equals(4.5));
    });

    test('should set and get priceLevel', () {
      final restaurant = RestaurantStruct();
      restaurant.priceLevel = 3;
      expect(restaurant.priceLevel, equals(3));
      expect(restaurant.hasPriceLevel(), isTrue);
    });

    test('should increment priceLevel', () {
      final restaurant = RestaurantStruct(priceLevel: 1);
      restaurant.incrementPriceLevel(1);
      expect(restaurant.priceLevel, equals(2));
    });

    test('should set and get primaryType', () {
      final restaurant = RestaurantStruct();
      restaurant.primaryType = 'cafe';
      expect(restaurant.primaryType, equals('cafe'));
      expect(restaurant.hasPrimaryType(), isTrue);
    });

    test('should set and get types list', () {
      final restaurant = RestaurantStruct();
      restaurant.types = ['cafe', 'bakery'];
      expect(restaurant.types, equals(['cafe', 'bakery']));
    });

    test('should update types with function', () {
      final restaurant = RestaurantStruct(types: ['restaurant']);
      restaurant.updateTypes((list) => list..add('bar'));
      expect(restaurant.types, contains('bar'));
    });

    test('should set and get photos list', () {
      final restaurant = RestaurantStruct();
      restaurant.photos = ['photo1.jpg'];
      expect(restaurant.photos, equals(['photo1.jpg']));
    });

    test('should update photos with function', () {
      final restaurant = RestaurantStruct(photos: ['photo1.jpg']);
      restaurant.updatePhotos((list) => list..add('photo2.jpg'));
      expect(restaurant.photos.length, equals(2));
    });

    test('should set and get userRatingCount', () {
      final restaurant = RestaurantStruct();
      restaurant.userRatingCount = 250;
      expect(restaurant.userRatingCount, equals(250));
      expect(restaurant.hasUserRatingCount(), isTrue);
    });

    test('should increment userRatingCount', () {
      final restaurant = RestaurantStruct(userRatingCount: 100);
      restaurant.incrementUserRatingCount(50);
      expect(restaurant.userRatingCount, equals(150));
    });

    test('should set and get placeId', () {
      final restaurant = RestaurantStruct();
      restaurant.placeId = 'place_456';
      expect(restaurant.placeId, equals('place_456'));
      expect(restaurant.hasPlaceId(), isTrue);
    });

    test('should set and get description', () {
      final restaurant = RestaurantStruct();
      restaurant.description = 'Updated description';
      expect(restaurant.description, equals('Updated description'));
      expect(restaurant.hasDescription(), isTrue);
    });

    test('hasX methods should return false for null values', () {
      final restaurant = RestaurantStruct();
      expect(restaurant.hasName(), isFalse);
      expect(restaurant.hasBusinessStatus(), isFalse);
      expect(restaurant.hasRating(), isFalse);
      expect(restaurant.hasPriceLevel(), isFalse);
      expect(restaurant.hasPrimaryType(), isFalse);
      expect(restaurant.hasUserRatingCount(), isFalse);
      expect(restaurant.hasPlaceId(), isFalse);
      expect(restaurant.hasDescription(), isFalse);
    });

    test('should create from map', () {
      final data = {
        'name': 'Map Restaurant',
        'business_status': 'OPERATIONAL',
        'rating': 4.2,
        'price_level': 2,
        'primary_type': 'restaurant',
        'types': ['restaurant', 'food', 'bar'],
        'photos': ['photo1.jpg', 'photo2.jpg', 'photo3.jpg'],
        'user_rating_count': 150,
        'place_id': 'place_789',
        'description': 'From map description',
      };

      final restaurant = RestaurantStruct.fromMap(data);

      expect(restaurant.name, equals('Map Restaurant'));
      expect(restaurant.businessStatus, equals('OPERATIONAL'));
      expect(restaurant.rating, equals(4.2));
      expect(restaurant.priceLevel, equals(2));
      expect(restaurant.primaryType, equals('restaurant'));
      expect(restaurant.types, hasLength(3));
      expect(restaurant.photos, hasLength(3));
      expect(restaurant.userRatingCount, equals(150));
      expect(restaurant.placeId, equals('place_789'));
      expect(restaurant.description, equals('From map description'));
    });

    test('maybeFromMap should return struct for valid map', () {
      final data = {
        'name': 'Valid Restaurant',
        'place_id': 'place_valid',
      };

      final restaurant = RestaurantStruct.maybeFromMap(data);

      expect(restaurant, isNotNull);
      expect(restaurant!.name, equals('Valid Restaurant'));
      expect(restaurant.placeId, equals('place_valid'));
    });

    test('maybeFromMap should return null for non-map data', () {
      expect(RestaurantStruct.maybeFromMap('not a map'), isNull);
      expect(RestaurantStruct.maybeFromMap(123), isNull);
      expect(RestaurantStruct.maybeFromMap(null), isNull);
    });

    test('should convert to map', () {
      final restaurant = RestaurantStruct(
        name: 'To Map Restaurant',
        rating: 4.7,
        priceLevel: 3,
        placeId: 'place_map',
      );

      final map = restaurant.toMap();

      expect(map['name'], equals('To Map Restaurant'));
      expect(map['rating'], equals(4.7));
      expect(map['price_level'], equals(3));
      expect(map['place_id'], equals('place_map'));
    });

    test('toMap should exclude null values', () {
      final restaurant = RestaurantStruct(
        name: 'Partial Restaurant',
        // Other fields left null
      );

      final map = restaurant.toMap();

      expect(map.containsKey('name'), isTrue);
      expect(map.containsKey('business_status'), isFalse);
      expect(map.containsKey('rating'), isFalse);
      expect(map.containsKey('description'), isFalse);
    });

    test('should convert to serializable map', () {
      final restaurant = RestaurantStruct(
        name: 'Serializable Restaurant',
        rating: 4.5,
        types: ['restaurant', 'food'],
        photos: ['photo.jpg'],
      );

      final map = restaurant.toSerializableMap();

      expect(map, isNotNull);
      expect(map.containsKey('name'), isTrue);
      expect(map.containsKey('rating'), isTrue);
      expect(map.containsKey('types'), isTrue);
      expect(map.containsKey('photos'), isTrue);
    });

    test('should handle serializable map data', () {
      final restaurant = RestaurantStruct(
        name: 'Test Restaurant',
        rating: 4.5,
        types: ['restaurant', 'food'],
      );
      final serialized = restaurant.toSerializableMap();
      expect(serialized, isNotNull);
      expect(serialized.containsKey('name'), isTrue);
    });

    test('should handle empty types list', () {
      final restaurant = RestaurantStruct(types: []);
      expect(restaurant.types, isEmpty);
    });

    test('should handle empty photos list', () {
      final restaurant = RestaurantStruct(photos: []);
      expect(restaurant.photos, isEmpty);
    });

    test('should handle zero rating', () {
      final restaurant = RestaurantStruct(rating: 0.0);
      expect(restaurant.rating, equals(0.0));
      expect(restaurant.hasRating(), isTrue);
    });

    test('should handle zero priceLevel', () {
      final restaurant = RestaurantStruct(priceLevel: 0);
      expect(restaurant.priceLevel, equals(0));
      expect(restaurant.hasPriceLevel(), isTrue);
    });

    test('should handle zero userRatingCount', () {
      final restaurant = RestaurantStruct(userRatingCount: 0);
      expect(restaurant.userRatingCount, equals(0));
      expect(restaurant.hasUserRatingCount(), isTrue);
    });

    test('should handle negative rating increment', () {
      final restaurant = RestaurantStruct(rating: 4.0);
      restaurant.incrementRating(-0.5);
      expect(restaurant.rating, equals(3.5));
    });

    test('should handle negative priceLevel increment', () {
      final restaurant = RestaurantStruct(priceLevel: 3);
      restaurant.incrementPriceLevel(-1);
      expect(restaurant.priceLevel, equals(2));
    });

    test('should handle negative userRatingCount increment', () {
      final restaurant = RestaurantStruct(userRatingCount: 100);
      restaurant.incrementUserRatingCount(-20);
      expect(restaurant.userRatingCount, equals(80));
    });

    test('should handle empty string values', () {
      final restaurant = RestaurantStruct(
        name: '',
        businessStatus: '',
        primaryType: '',
        placeId: '',
        description: '',
      );

      expect(restaurant.name, equals(''));
      expect(restaurant.businessStatus, equals(''));
      expect(restaurant.primaryType, equals(''));
      expect(restaurant.placeId, equals(''));
      expect(restaurant.description, equals(''));
    });

    test('should maintain list references correctly', () {
      final types = ['restaurant'];
      final restaurant = RestaurantStruct(types: types);
      
      types.add('bar');
      expect(restaurant.types, contains('bar')); // Should reflect changes
    });
  });
}
