import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'package:ff_commons/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _neighborhood = '';
  String get neighborhood => _neighborhood;
  set neighborhood(String value) {
    _neighborhood = value;
  }

  List<RestaurantStruct> _restaurants = [];
  List<RestaurantStruct> get restaurants => _restaurants;
  set restaurants(List<RestaurantStruct> value) {
    _restaurants = value;
  }

  void addToRestaurants(RestaurantStruct value) {
    restaurants.add(value);
  }

  void removeFromRestaurants(RestaurantStruct value) {
    restaurants.remove(value);
  }

  void removeAtIndexFromRestaurants(int index) {
    restaurants.removeAt(index);
  }

  void updateRestaurantsAtIndex(
    int index,
    RestaurantStruct Function(RestaurantStruct) updateFn,
  ) {
    restaurants[index] = updateFn(_restaurants[index]);
  }

  void insertAtIndexInRestaurants(int index, RestaurantStruct value) {
    restaurants.insert(index, value);
  }

  List<String> _restaurantNames = [];
  List<String> get restaurantNames => _restaurantNames;
  set restaurantNames(List<String> value) {
    _restaurantNames = value;
  }

  void addToRestaurantNames(String value) {
    restaurantNames.add(value);
  }

  void removeFromRestaurantNames(String value) {
    restaurantNames.remove(value);
  }

  void removeAtIndexFromRestaurantNames(int index) {
    restaurantNames.removeAt(index);
  }

  void updateRestaurantNamesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    restaurantNames[index] = updateFn(_restaurantNames[index]);
  }

  void insertAtIndexInRestaurantNames(int index, String value) {
    restaurantNames.insert(index, value);
  }

  List<String> _restaurantCategories = [];
  List<String> get restaurantCategories => _restaurantCategories;
  set restaurantCategories(List<String> value) {
    _restaurantCategories = value;
  }

  void addToRestaurantCategories(String value) {
    restaurantCategories.add(value);
  }

  void removeFromRestaurantCategories(String value) {
    restaurantCategories.remove(value);
  }

  void removeAtIndexFromRestaurantCategories(int index) {
    restaurantCategories.removeAt(index);
  }

  void updateRestaurantCategoriesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    restaurantCategories[index] = updateFn(_restaurantCategories[index]);
  }

  void insertAtIndexInRestaurantCategories(int index, String value) {
    restaurantCategories.insert(index, value);
  }

  List<String> _deletingRestaurants = [];
  List<String> get deletingRestaurants => _deletingRestaurants;
  set deletingRestaurants(List<String> value) {
    _deletingRestaurants = value;
  }

  void addToDeletingRestaurants(String value) {
    deletingRestaurants.add(value);
  }

  void removeFromDeletingRestaurants(String value) {
    deletingRestaurants.remove(value);
  }

  void removeAtIndexFromDeletingRestaurants(int index) {
    deletingRestaurants.removeAt(index);
  }

  void updateDeletingRestaurantsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    deletingRestaurants[index] = updateFn(_deletingRestaurants[index]);
  }

  void insertAtIndexInDeletingRestaurants(int index, String value) {
    deletingRestaurants.insert(index, value);
  }
}
