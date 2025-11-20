// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RestaurantStruct extends FFFirebaseStruct {
  RestaurantStruct({
    String? name,
    String? businessStatus,
    double? rating,
    int? priceLevel,
    String? primaryType,
    List<String>? types,
    List<String>? photos,
    int? userRatingCount,
    String? placeId,
    String? description,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _name = name,
        _businessStatus = businessStatus,
        _rating = rating,
        _priceLevel = priceLevel,
        _primaryType = primaryType,
        _types = types,
        _photos = photos,
        _userRatingCount = userRatingCount,
        _placeId = placeId,
        _description = description,
        super(firestoreUtilData);

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "business_status" field.
  String? _businessStatus;
  String get businessStatus => _businessStatus ?? '';
  set businessStatus(String? val) => _businessStatus = val;

  bool hasBusinessStatus() => _businessStatus != null;

  // "rating" field.
  double? _rating;
  double get rating => _rating ?? 0.0;
  set rating(double? val) => _rating = val;

  void incrementRating(double amount) => rating = rating + amount;

  bool hasRating() => _rating != null;

  // "price_level" field.
  int? _priceLevel;
  int get priceLevel => _priceLevel ?? 0;
  set priceLevel(int? val) => _priceLevel = val;

  void incrementPriceLevel(int amount) => priceLevel = priceLevel + amount;

  bool hasPriceLevel() => _priceLevel != null;

  // "primary_type" field.
  String? _primaryType;
  String get primaryType => _primaryType ?? '';
  set primaryType(String? val) => _primaryType = val;

  bool hasPrimaryType() => _primaryType != null;

  // "types" field.
  List<String>? _types;
  List<String> get types => _types ?? const [];
  set types(List<String>? val) => _types = val;

  void updateTypes(Function(List<String>) updateFn) {
    updateFn(_types ??= []);
  }

  bool hasTypes() => _types != null;

  // "photos" field.
  List<String>? _photos;
  List<String> get photos => _photos ?? const [];
  set photos(List<String>? val) => _photos = val;

  void updatePhotos(Function(List<String>) updateFn) {
    updateFn(_photos ??= []);
  }

  bool hasPhotos() => _photos != null;

  // "user_rating_count" field.
  int? _userRatingCount;
  int get userRatingCount => _userRatingCount ?? 0;
  set userRatingCount(int? val) => _userRatingCount = val;

  void incrementUserRatingCount(int amount) =>
      userRatingCount = userRatingCount + amount;

  bool hasUserRatingCount() => _userRatingCount != null;

  // "place_id" field.
  String? _placeId;
  String get placeId => _placeId ?? '';
  set placeId(String? val) => _placeId = val;

  bool hasPlaceId() => _placeId != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  static RestaurantStruct fromMap(Map<String, dynamic> data) =>
      RestaurantStruct(
        name: data['name'] as String?,
        businessStatus: data['business_status'] as String?,
        rating: castToType<double>(data['rating']),
        priceLevel: castToType<int>(data['price_level']),
        primaryType: data['primary_type'] as String?,
        types: getDataList(data['types']),
        photos: getDataList(data['photos']),
        userRatingCount: castToType<int>(data['user_rating_count']),
        placeId: data['place_id'] as String?,
        description: data['description'] as String?,
      );

  static RestaurantStruct? maybeFromMap(dynamic data) => data is Map
      ? RestaurantStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'business_status': _businessStatus,
        'rating': _rating,
        'price_level': _priceLevel,
        'primary_type': _primaryType,
        'types': _types,
        'photos': _photos,
        'user_rating_count': _userRatingCount,
        'place_id': _placeId,
        'description': _description,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'business_status': serializeParam(
          _businessStatus,
          ParamType.String,
        ),
        'rating': serializeParam(
          _rating,
          ParamType.double,
        ),
        'price_level': serializeParam(
          _priceLevel,
          ParamType.int,
        ),
        'primary_type': serializeParam(
          _primaryType,
          ParamType.String,
        ),
        'types': serializeParam(
          _types,
          ParamType.String,
          isList: true,
        ),
        'photos': serializeParam(
          _photos,
          ParamType.String,
          isList: true,
        ),
        'user_rating_count': serializeParam(
          _userRatingCount,
          ParamType.int,
        ),
        'place_id': serializeParam(
          _placeId,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
      }.withoutNulls;

  static RestaurantStruct fromSerializableMap(Map<String, dynamic> data) =>
      RestaurantStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        businessStatus: deserializeParam(
          data['business_status'],
          ParamType.String,
          false,
        ),
        rating: deserializeParam(
          data['rating'],
          ParamType.double,
          false,
        ),
        priceLevel: deserializeParam(
          data['price_level'],
          ParamType.int,
          false,
        ),
        primaryType: deserializeParam(
          data['primary_type'],
          ParamType.String,
          false,
        ),
        types: deserializeParam<String>(
          data['types'],
          ParamType.String,
          true,
        ),
        photos: deserializeParam<String>(
          data['photos'],
          ParamType.String,
          true,
        ),
        userRatingCount: deserializeParam(
          data['user_rating_count'],
          ParamType.int,
          false,
        ),
        placeId: deserializeParam(
          data['place_id'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'RestaurantStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is RestaurantStruct &&
        name == other.name &&
        businessStatus == other.businessStatus &&
        rating == other.rating &&
        priceLevel == other.priceLevel &&
        primaryType == other.primaryType &&
        listEquality.equals(types, other.types) &&
        listEquality.equals(photos, other.photos) &&
        userRatingCount == other.userRatingCount &&
        placeId == other.placeId &&
        description == other.description;
  }

  @override
  int get hashCode => const ListEquality().hash([
        name,
        businessStatus,
        rating,
        priceLevel,
        primaryType,
        types,
        photos,
        userRatingCount,
        placeId,
        description
      ]);
}

RestaurantStruct createRestaurantStruct({
  String? name,
  String? businessStatus,
  double? rating,
  int? priceLevel,
  String? primaryType,
  int? userRatingCount,
  String? placeId,
  String? description,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RestaurantStruct(
      name: name,
      businessStatus: businessStatus,
      rating: rating,
      priceLevel: priceLevel,
      primaryType: primaryType,
      userRatingCount: userRatingCount,
      placeId: placeId,
      description: description,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RestaurantStruct? updateRestaurantStruct(
  RestaurantStruct? restaurant, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    restaurant
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRestaurantStructData(
  Map<String, dynamic> firestoreData,
  RestaurantStruct? restaurant,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (restaurant == null) {
    return;
  }
  if (restaurant.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && restaurant.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final restaurantData = getRestaurantFirestoreData(restaurant, forFieldValue);
  final nestedData = restaurantData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = restaurant.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRestaurantFirestoreData(
  RestaurantStruct? restaurant, [
  bool forFieldValue = false,
]) {
  if (restaurant == null) {
    return {};
  }
  final firestoreData = mapToFirestore(restaurant.toMap());

  // Add any Firestore field values
  restaurant.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRestaurantListFirestoreData(
  List<RestaurantStruct>? restaurants,
) =>
    restaurants?.map((e) => getRestaurantFirestoreData(e, true)).toList() ?? [];
