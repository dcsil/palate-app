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
    String? primaryType,
    List<String>? types,
    List<String>? photos,
    int? userRatingCount,
    String? placeId,
    EditorialSummaryStruct? editorialSummary,
    String? googleMapsUri,
    String? nextOpenTime,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _name = name,
        _businessStatus = businessStatus,
        _rating = rating,
        _primaryType = primaryType,
        _types = types,
        _photos = photos,
        _userRatingCount = userRatingCount,
        _placeId = placeId,
        _editorialSummary = editorialSummary,
        _googleMapsUri = googleMapsUri,
        _nextOpenTime = nextOpenTime,
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

  // "editorial_summary" field.
  EditorialSummaryStruct? _editorialSummary;
  EditorialSummaryStruct get editorialSummary =>
      _editorialSummary ?? EditorialSummaryStruct();
  set editorialSummary(EditorialSummaryStruct? val) => _editorialSummary = val;

  void updateEditorialSummary(Function(EditorialSummaryStruct) updateFn) {
    updateFn(_editorialSummary ??= EditorialSummaryStruct());
  }

  bool hasEditorialSummary() => _editorialSummary != null;

  // "google_maps_uri" field.
  String? _googleMapsUri;
  String get googleMapsUri => _googleMapsUri ?? '';
  set googleMapsUri(String? val) => _googleMapsUri = val;

  bool hasGoogleMapsUri() => _googleMapsUri != null;

  // "nextOpenTime" field.
  String? _nextOpenTime;
  String get nextOpenTime => _nextOpenTime ?? '';
  set nextOpenTime(String? val) => _nextOpenTime = val;

  bool hasNextOpenTime() => _nextOpenTime != null;

  static RestaurantStruct fromMap(Map<String, dynamic> data) =>
      RestaurantStruct(
        name: data['name'] as String?,
        businessStatus: data['business_status'] as String?,
        rating: castToType<double>(data['rating']),
        primaryType: data['primary_type'] as String?,
        types: getDataList(data['types']),
        photos: getDataList(data['photos']),
        userRatingCount: castToType<int>(data['user_rating_count']),
        placeId: data['place_id'] as String?,
        editorialSummary: data['editorial_summary'] is EditorialSummaryStruct
            ? data['editorial_summary']
            : EditorialSummaryStruct.maybeFromMap(data['editorial_summary']),
        googleMapsUri: data['google_maps_uri'] as String?,
        nextOpenTime: data['nextOpenTime'] as String?,
      );

  static RestaurantStruct? maybeFromMap(dynamic data) => data is Map
      ? RestaurantStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'business_status': _businessStatus,
        'rating': _rating,
        'primary_type': _primaryType,
        'types': _types,
        'photos': _photos,
        'user_rating_count': _userRatingCount,
        'place_id': _placeId,
        'editorial_summary': _editorialSummary?.toMap(),
        'google_maps_uri': _googleMapsUri,
        'nextOpenTime': _nextOpenTime,
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
        'editorial_summary': serializeParam(
          _editorialSummary,
          ParamType.DataStruct,
        ),
        'google_maps_uri': serializeParam(
          _googleMapsUri,
          ParamType.String,
        ),
        'nextOpenTime': serializeParam(
          _nextOpenTime,
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
        editorialSummary: deserializeStructParam(
          data['editorial_summary'],
          ParamType.DataStruct,
          false,
          structBuilder: EditorialSummaryStruct.fromSerializableMap,
        ),
        googleMapsUri: deserializeParam(
          data['google_maps_uri'],
          ParamType.String,
          false,
        ),
        nextOpenTime: deserializeParam(
          data['nextOpenTime'],
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
        primaryType == other.primaryType &&
        listEquality.equals(types, other.types) &&
        listEquality.equals(photos, other.photos) &&
        userRatingCount == other.userRatingCount &&
        placeId == other.placeId &&
        editorialSummary == other.editorialSummary &&
        googleMapsUri == other.googleMapsUri &&
        nextOpenTime == other.nextOpenTime;
  }

  @override
  int get hashCode => const ListEquality().hash([
        name,
        businessStatus,
        rating,
        primaryType,
        types,
        photos,
        userRatingCount,
        placeId,
        editorialSummary,
        googleMapsUri,
        nextOpenTime
      ]);
}

RestaurantStruct createRestaurantStruct({
  String? name,
  String? businessStatus,
  double? rating,
  String? primaryType,
  int? userRatingCount,
  String? placeId,
  EditorialSummaryStruct? editorialSummary,
  String? googleMapsUri,
  String? nextOpenTime,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RestaurantStruct(
      name: name,
      businessStatus: businessStatus,
      rating: rating,
      primaryType: primaryType,
      userRatingCount: userRatingCount,
      placeId: placeId,
      editorialSummary: editorialSummary ??
          (clearUnsetFields ? EditorialSummaryStruct() : null),
      googleMapsUri: googleMapsUri,
      nextOpenTime: nextOpenTime,
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

  // Handle nested data for "editorial_summary" field.
  addEditorialSummaryStructData(
    firestoreData,
    restaurant.hasEditorialSummary() ? restaurant.editorialSummary : null,
    'editorial_summary',
    forFieldValue,
  );

  // Add any Firestore field values
  restaurant.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRestaurantListFirestoreData(
  List<RestaurantStruct>? restaurants,
) =>
    restaurants?.map((e) => getRestaurantFirestoreData(e, true)).toList() ?? [];
