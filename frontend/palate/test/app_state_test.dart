import 'package:flutter_test/flutter_test.dart';
import 'package:palate/app_state.dart';
import 'package:palate/backend/schema/structs/restaurant_struct.dart';

void main() {
  group('FFAppState', () {
    late FFAppState appState;

    setUp(() {
      FFAppState.reset();
      appState = FFAppState();
    });

    test('singleton instance', () {
      final instance1 = FFAppState();
      final instance2 = FFAppState();
      expect(identical(instance1, instance2), true);
    });

    test('neighborhood getter and setter', () {
      expect(appState.neighborhood, '');
      appState.neighborhood = 'Downtown';
      expect(appState.neighborhood, 'Downtown');
    });

    test('restaurants list operations', () {
      expect(appState.restaurants, []);
      
      final restaurant1 = RestaurantStruct(name: 'Restaurant 1');
      final restaurant2 = RestaurantStruct(name: 'Restaurant 2');
      
      appState.addToRestaurants(restaurant1);
      expect(appState.restaurants.length, 1);
      expect(appState.restaurants[0].name, 'Restaurant 1');
      
      appState.addToRestaurants(restaurant2);
      expect(appState.restaurants.length, 2);
      
      appState.removeFromRestaurants(restaurant1);
      expect(appState.restaurants.length, 1);
      expect(appState.restaurants[0].name, 'Restaurant 2');
    });

    test('restaurants list - removeAtIndex', () {
      final r1 = RestaurantStruct(name: 'R1');
      final r2 = RestaurantStruct(name: 'R2');
      final r3 = RestaurantStruct(name: 'R3');
      
      appState.restaurants = [r1, r2, r3];
      appState.removeAtIndexFromRestaurants(1);
      expect(appState.restaurants.length, 2);
      expect(appState.restaurants[0].name, 'R1');
      expect(appState.restaurants[1].name, 'R3');
    });

    test('restaurants list - updateAtIndex', () {
      final r1 = RestaurantStruct(name: 'Original');
      appState.restaurants = [r1];
      
      appState.updateRestaurantsAtIndex(0, (r) => RestaurantStruct(name: 'Updated'));
      expect(appState.restaurants[0].name, 'Updated');
    });

    test('restaurants list - insertAtIndex', () {
      final r1 = RestaurantStruct(name: 'First');
      final r2 = RestaurantStruct(name: 'Third');
      appState.restaurants = [r1, r2];
      
      final r3 = RestaurantStruct(name: 'Second');
      appState.insertAtIndexInRestaurants(1, r3);
      expect(appState.restaurants.length, 3);
      expect(appState.restaurants[1].name, 'Second');
    });

    test('restaurantNames list operations', () {
      expect(appState.restaurantNames, []);
      
      appState.addToRestaurantNames('Sushi Place');
      expect(appState.restaurantNames, ['Sushi Place']);
      
      appState.addToRestaurantNames('Pizza Joint');
      expect(appState.restaurantNames.length, 2);
      
      appState.removeFromRestaurantNames('Sushi Place');
      expect(appState.restaurantNames, ['Pizza Joint']);
    });

    test('restaurantNames - removeAtIndex', () {
      appState.restaurantNames = ['A', 'B', 'C'];
      appState.removeAtIndexFromRestaurantNames(1);
      expect(appState.restaurantNames, ['A', 'C']);
    });

    test('restaurantNames - updateAtIndex', () {
      appState.restaurantNames = ['Old Name'];
      appState.updateRestaurantNamesAtIndex(0, (name) => 'New Name');
      expect(appState.restaurantNames[0], 'New Name');
    });

    test('restaurantNames - insertAtIndex', () {
      appState.restaurantNames = ['First', 'Third'];
      appState.insertAtIndexInRestaurantNames(1, 'Second');
      expect(appState.restaurantNames, ['First', 'Second', 'Third']);
    });

    test('restaurantCategories operations', () {
      expect(appState.restaurantCategories, []);
      
      appState.addToRestaurantCategories('Italian');
      appState.addToRestaurantCategories('Japanese');
      expect(appState.restaurantCategories.length, 2);
      
      appState.removeFromRestaurantCategories('Italian');
      expect(appState.restaurantCategories, ['Japanese']);
    });

    test('restaurantCategories - removeAtIndex', () {
      appState.restaurantCategories = ['Cat1', 'Cat2', 'Cat3'];
      appState.removeAtIndexFromRestaurantCategories(0);
      expect(appState.restaurantCategories, ['Cat2', 'Cat3']);
    });

    test('restaurantCategories - updateAtIndex', () {
      appState.restaurantCategories = ['OldCat'];
      appState.updateRestaurantCategoriesAtIndex(0, (cat) => 'NewCat');
      expect(appState.restaurantCategories[0], 'NewCat');
    });

    test('restaurantCategories - insertAtIndex', () {
      appState.restaurantCategories = ['First', 'Third'];
      appState.insertAtIndexInRestaurantCategories(1, 'Second');
      expect(appState.restaurantCategories, ['First', 'Second', 'Third']);
    });

    test('deletingRestaurants operations', () {
      expect(appState.deletingRestaurants, []);
      
      appState.addToDeletingRestaurants('place_id_1');
      appState.addToDeletingRestaurants('place_id_2');
      expect(appState.deletingRestaurants.length, 2);
      
      appState.removeFromDeletingRestaurants('place_id_1');
      expect(appState.deletingRestaurants, ['place_id_2']);
    });

    test('deletingRestaurants - removeAtIndex', () {
      appState.deletingRestaurants = ['id1', 'id2', 'id3'];
      appState.removeAtIndexFromDeletingRestaurants(1);
      expect(appState.deletingRestaurants, ['id1', 'id3']);
    });

    test('deletingRestaurants - updateAtIndex', () {
      appState.deletingRestaurants = ['old_id'];
      appState.updateDeletingRestaurantsAtIndex(0, (id) => 'new_id');
      expect(appState.deletingRestaurants[0], 'new_id');
    });

    test('deletingRestaurants - insertAtIndex', () {
      appState.deletingRestaurants = ['id1', 'id3'];
      appState.insertAtIndexInDeletingRestaurants(1, 'id2');
      expect(appState.deletingRestaurants, ['id1', 'id2', 'id3']);
    });

    test('update callback triggers notifyListeners', () {
      bool listenerCalled = false;
      appState.addListener(() {
        listenerCalled = true;
      });
      
      appState.update(() {
        appState.neighborhood = 'Test';
      });
      
      expect(listenerCalled, true);
      expect(appState.neighborhood, 'Test');
    });

    test('reset creates new instance', () {
      appState.neighborhood = 'SomeValue';
      FFAppState.reset();
      final newInstance = FFAppState();
      expect(newInstance.neighborhood, '');
    });
  });
}
