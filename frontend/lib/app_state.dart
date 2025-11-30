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

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _longitude = prefs.getDouble('ff_longitude') ?? _longitude;
    });
    _safeInit(() {
      _latitude = prefs.getDouble('ff_latitude') ?? _latitude;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

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

  List<String> _nearbyPlaceIDs = [];
  List<String> get nearbyPlaceIDs => _nearbyPlaceIDs;
  set nearbyPlaceIDs(List<String> value) {
    _nearbyPlaceIDs = value;
  }

  void addToNearbyPlaceIDs(String value) {
    nearbyPlaceIDs.add(value);
  }

  void removeFromNearbyPlaceIDs(String value) {
    nearbyPlaceIDs.remove(value);
  }

  void removeAtIndexFromNearbyPlaceIDs(int index) {
    nearbyPlaceIDs.removeAt(index);
  }

  void updateNearbyPlaceIDsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    nearbyPlaceIDs[index] = updateFn(_nearbyPlaceIDs[index]);
  }

  void insertAtIndexInNearbyPlaceIDs(int index, String value) {
    nearbyPlaceIDs.insert(index, value);
  }

  List<String> _loadingTexts = [
    'Checking preferences…',
    'Matching options…',
    'Scanning nearby…',
    'Filtering noise…',
    'Comparing picks…',
    'Ranking results…',
    'Finalizing choice…'
  ];
  List<String> get loadingTexts => _loadingTexts;
  set loadingTexts(List<String> value) {
    _loadingTexts = value;
  }

  void addToLoadingTexts(String value) {
    loadingTexts.add(value);
  }

  void removeFromLoadingTexts(String value) {
    loadingTexts.remove(value);
  }

  void removeAtIndexFromLoadingTexts(int index) {
    loadingTexts.removeAt(index);
  }

  void updateLoadingTextsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    loadingTexts[index] = updateFn(_loadingTexts[index]);
  }

  void insertAtIndexInLoadingTexts(int index, String value) {
    loadingTexts.insert(index, value);
  }

  double _longitude = 0.0;
  double get longitude => _longitude;
  set longitude(double value) {
    _longitude = value;
    prefs.setDouble('ff_longitude', value);
  }

  double _latitude = 0.0;
  double get latitude => _latitude;
  set latitude(double value) {
    _latitude = value;
    prefs.setDouble('ff_latitude', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
