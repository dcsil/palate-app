import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RestaurantsRecord extends FirestoreRecord {
  RestaurantsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "accessibility_options" field.
  List<BooleanMapStruct>? _accessibilityOptions;
  List<BooleanMapStruct> get accessibilityOptions =>
      _accessibilityOptions ?? const [];
  bool hasAccessibilityOptions() => _accessibilityOptions != null;

  // "allow_dogs" field.
  bool? _allowDogs;
  bool get allowDogs => _allowDogs ?? false;
  bool hasAllowDogs() => _allowDogs != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "delivery" field.
  bool? _delivery;
  bool get delivery => _delivery ?? false;
  bool hasDelivery() => _delivery != null;

  // "dine_in" field.
  bool? _dineIn;
  bool get dineIn => _dineIn ?? false;
  bool hasDineIn() => _dineIn != null;

  // "distance_meters" field.
  double? _distanceMeters;
  double get distanceMeters => _distanceMeters ?? 0.0;
  bool hasDistanceMeters() => _distanceMeters != null;

  // "formatted_address" field.
  String? _formattedAddress;
  String get formattedAddress => _formattedAddress ?? '';
  bool hasFormattedAddress() => _formattedAddress != null;

  // "good_for_groups" field.
  bool? _goodForGroups;
  bool get goodForGroups => _goodForGroups ?? false;
  bool hasGoodForGroups() => _goodForGroups != null;

  // "good_for_watching_sports" field.
  bool? _goodForWatchingSports;
  bool get goodForWatchingSports => _goodForWatchingSports ?? false;
  bool hasGoodForWatchingSports() => _goodForWatchingSports != null;

  // "google_types" field.
  List<String>? _googleTypes;
  List<String> get googleTypes => _googleTypes ?? const [];
  bool hasGoogleTypes() => _googleTypes != null;

  // "has_restroom" field.
  List<bool>? _hasRestroom;
  List<bool> get hasRestroom => _hasRestroom ?? const [];
  bool hasHasRestroom() => _hasRestroom != null;

  // "last_updated" field.
  DateTime? _lastUpdated;
  DateTime? get lastUpdated => _lastUpdated;
  bool hasLastUpdated() => _lastUpdated != null;

  // "latitude" field.
  double? _latitude;
  double get latitude => _latitude ?? 0.0;
  bool hasLatitude() => _latitude != null;

  // "live_music" field.
  bool? _liveMusic;
  bool get liveMusic => _liveMusic ?? false;
  bool hasLiveMusic() => _liveMusic != null;

  // "map_links" field.
  List<StringMapStruct>? _mapLinks;
  List<StringMapStruct> get mapLinks => _mapLinks ?? const [];
  bool hasMapLinks() => _mapLinks != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "open_now" field.
  bool? _openNow;
  bool get openNow => _openNow ?? false;
  bool hasOpenNow() => _openNow != null;

  // "outdoor_seating" field.
  bool? _outdoorSeating;
  bool get outdoorSeating => _outdoorSeating ?? false;
  bool hasOutdoorSeating() => _outdoorSeating != null;

  // "parking_options" field.
  BooleanMapStruct? _parkingOptions;
  BooleanMapStruct get parkingOptions => _parkingOptions ?? BooleanMapStruct();
  bool hasParkingOptions() => _parkingOptions != null;

  // "payment_options" field.
  List<BooleanMapStruct>? _paymentOptions;
  List<BooleanMapStruct> get paymentOptions => _paymentOptions ?? const [];
  bool hasPaymentOptions() => _paymentOptions != null;

  // "place_id" field.
  String? _placeId;
  String get placeId => _placeId ?? '';
  bool hasPlaceId() => _placeId != null;

  // "price_range" field.
  int? _priceRange;
  int get priceRange => _priceRange ?? 0;
  bool hasPriceRange() => _priceRange != null;

  // "primary_type" field.
  String? _primaryType;
  String get primaryType => _primaryType ?? '';
  bool hasPrimaryType() => _primaryType != null;

  // "rating" field.
  double? _rating;
  double get rating => _rating ?? 0.0;
  bool hasRating() => _rating != null;

  // "reservable" field.
  bool? _reservable;
  bool get reservable => _reservable ?? false;
  bool hasReservable() => _reservable != null;

  // "serves_beer" field.
  bool? _servesBeer;
  bool get servesBeer => _servesBeer ?? false;
  bool hasServesBeer() => _servesBeer != null;

  // "serves_breakfast" field.
  bool? _servesBreakfast;
  bool get servesBreakfast => _servesBreakfast ?? false;
  bool hasServesBreakfast() => _servesBreakfast != null;

  // "serves_lunch" field.
  bool? _servesLunch;
  bool get servesLunch => _servesLunch ?? false;
  bool hasServesLunch() => _servesLunch != null;

  // "serves_vegetarian" field.
  bool? _servesVegetarian;
  bool get servesVegetarian => _servesVegetarian ?? false;
  bool hasServesVegetarian() => _servesVegetarian != null;

  // "serves_wine" field.
  bool? _servesWine;
  bool get servesWine => _servesWine ?? false;
  bool hasServesWine() => _servesWine != null;

  // "takeout" field.
  bool? _takeout;
  bool get takeout => _takeout ?? false;
  bool hasTakeout() => _takeout != null;

  // "types" field.
  List<String>? _types;
  List<String> get types => _types ?? const [];
  bool hasTypes() => _types != null;

  // "user_rating_count" field.
  int? _userRatingCount;
  int get userRatingCount => _userRatingCount ?? 0;
  bool hasUserRatingCount() => _userRatingCount != null;

  // "google_places_id" field.
  String? _googlePlacesId;
  String get googlePlacesId => _googlePlacesId ?? '';
  bool hasGooglePlacesId() => _googlePlacesId != null;

  // "longitude" field.
  double? _longitude;
  double get longitude => _longitude ?? 0.0;
  bool hasLongitude() => _longitude != null;

  // "search_timestamp" field.
  String? _searchTimestamp;
  String get searchTimestamp => _searchTimestamp ?? '';
  bool hasSearchTimestamp() => _searchTimestamp != null;

  // "images" field.
  List<String>? _images;
  List<String> get images => _images ?? const [];
  bool hasImages() => _images != null;

  void _initializeFields() {
    _accessibilityOptions = getStructList(
      snapshotData['accessibility_options'],
      BooleanMapStruct.fromMap,
    );
    _allowDogs = snapshotData['allow_dogs'] as bool?;
    _category = snapshotData['category'] as String?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _delivery = snapshotData['delivery'] as bool?;
    _dineIn = snapshotData['dine_in'] as bool?;
    _distanceMeters = castToType<double>(snapshotData['distance_meters']);
    _formattedAddress = snapshotData['formatted_address'] as String?;
    _goodForGroups = snapshotData['good_for_groups'] as bool?;
    _goodForWatchingSports = snapshotData['good_for_watching_sports'] as bool?;
    _googleTypes = getDataList(snapshotData['google_types']);
    _hasRestroom = getDataList(snapshotData['has_restroom']);
    _lastUpdated = snapshotData['last_updated'] as DateTime?;
    _latitude = castToType<double>(snapshotData['latitude']);
    _liveMusic = snapshotData['live_music'] as bool?;
    _mapLinks = getStructList(
      snapshotData['map_links'],
      StringMapStruct.fromMap,
    );
    _name = snapshotData['name'] as String?;
    _openNow = snapshotData['open_now'] as bool?;
    _outdoorSeating = snapshotData['outdoor_seating'] as bool?;
    _parkingOptions = snapshotData['parking_options'] is BooleanMapStruct
        ? snapshotData['parking_options']
        : BooleanMapStruct.maybeFromMap(snapshotData['parking_options']);
    _paymentOptions = getStructList(
      snapshotData['payment_options'],
      BooleanMapStruct.fromMap,
    );
    _placeId = snapshotData['place_id'] as String?;
    _priceRange = castToType<int>(snapshotData['price_range']);
    _primaryType = snapshotData['primary_type'] as String?;
    _rating = castToType<double>(snapshotData['rating']);
    _reservable = snapshotData['reservable'] as bool?;
    _servesBeer = snapshotData['serves_beer'] as bool?;
    _servesBreakfast = snapshotData['serves_breakfast'] as bool?;
    _servesLunch = snapshotData['serves_lunch'] as bool?;
    _servesVegetarian = snapshotData['serves_vegetarian'] as bool?;
    _servesWine = snapshotData['serves_wine'] as bool?;
    _takeout = snapshotData['takeout'] as bool?;
    _types = getDataList(snapshotData['types']);
    _userRatingCount = castToType<int>(snapshotData['user_rating_count']);
    _googlePlacesId = snapshotData['google_places_id'] as String?;
    _longitude = castToType<double>(snapshotData['longitude']);
    _searchTimestamp = snapshotData['search_timestamp'] as String?;
    _images = getDataList(snapshotData['images']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('restaurants');

  static Stream<RestaurantsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RestaurantsRecord.fromSnapshot(s));

  static Future<RestaurantsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RestaurantsRecord.fromSnapshot(s));

  static RestaurantsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RestaurantsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RestaurantsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RestaurantsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RestaurantsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RestaurantsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRestaurantsRecordData({
  bool? allowDogs,
  String? category,
  DateTime? createdAt,
  bool? delivery,
  bool? dineIn,
  double? distanceMeters,
  String? formattedAddress,
  bool? goodForGroups,
  bool? goodForWatchingSports,
  DateTime? lastUpdated,
  double? latitude,
  bool? liveMusic,
  String? name,
  bool? openNow,
  bool? outdoorSeating,
  BooleanMapStruct? parkingOptions,
  String? placeId,
  int? priceRange,
  String? primaryType,
  double? rating,
  bool? reservable,
  bool? servesBeer,
  bool? servesBreakfast,
  bool? servesLunch,
  bool? servesVegetarian,
  bool? servesWine,
  bool? takeout,
  int? userRatingCount,
  String? googlePlacesId,
  double? longitude,
  String? searchTimestamp,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'allow_dogs': allowDogs,
      'category': category,
      'created_at': createdAt,
      'delivery': delivery,
      'dine_in': dineIn,
      'distance_meters': distanceMeters,
      'formatted_address': formattedAddress,
      'good_for_groups': goodForGroups,
      'good_for_watching_sports': goodForWatchingSports,
      'last_updated': lastUpdated,
      'latitude': latitude,
      'live_music': liveMusic,
      'name': name,
      'open_now': openNow,
      'outdoor_seating': outdoorSeating,
      'parking_options': BooleanMapStruct().toMap(),
      'place_id': placeId,
      'price_range': priceRange,
      'primary_type': primaryType,
      'rating': rating,
      'reservable': reservable,
      'serves_beer': servesBeer,
      'serves_breakfast': servesBreakfast,
      'serves_lunch': servesLunch,
      'serves_vegetarian': servesVegetarian,
      'serves_wine': servesWine,
      'takeout': takeout,
      'user_rating_count': userRatingCount,
      'google_places_id': googlePlacesId,
      'longitude': longitude,
      'search_timestamp': searchTimestamp,
    }.withoutNulls,
  );

  // Handle nested data for "parking_options" field.
  addBooleanMapStructData(firestoreData, parkingOptions, 'parking_options');

  return firestoreData;
}

class RestaurantsRecordDocumentEquality implements Equality<RestaurantsRecord> {
  const RestaurantsRecordDocumentEquality();

  @override
  bool equals(RestaurantsRecord? e1, RestaurantsRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(
            e1?.accessibilityOptions, e2?.accessibilityOptions) &&
        e1?.allowDogs == e2?.allowDogs &&
        e1?.category == e2?.category &&
        e1?.createdAt == e2?.createdAt &&
        e1?.delivery == e2?.delivery &&
        e1?.dineIn == e2?.dineIn &&
        e1?.distanceMeters == e2?.distanceMeters &&
        e1?.formattedAddress == e2?.formattedAddress &&
        e1?.goodForGroups == e2?.goodForGroups &&
        e1?.goodForWatchingSports == e2?.goodForWatchingSports &&
        listEquality.equals(e1?.googleTypes, e2?.googleTypes) &&
        listEquality.equals(e1?.hasRestroom, e2?.hasRestroom) &&
        e1?.lastUpdated == e2?.lastUpdated &&
        e1?.latitude == e2?.latitude &&
        e1?.liveMusic == e2?.liveMusic &&
        listEquality.equals(e1?.mapLinks, e2?.mapLinks) &&
        e1?.name == e2?.name &&
        e1?.openNow == e2?.openNow &&
        e1?.outdoorSeating == e2?.outdoorSeating &&
        e1?.parkingOptions == e2?.parkingOptions &&
        listEquality.equals(e1?.paymentOptions, e2?.paymentOptions) &&
        e1?.placeId == e2?.placeId &&
        e1?.priceRange == e2?.priceRange &&
        e1?.primaryType == e2?.primaryType &&
        e1?.rating == e2?.rating &&
        e1?.reservable == e2?.reservable &&
        e1?.servesBeer == e2?.servesBeer &&
        e1?.servesBreakfast == e2?.servesBreakfast &&
        e1?.servesLunch == e2?.servesLunch &&
        e1?.servesVegetarian == e2?.servesVegetarian &&
        e1?.servesWine == e2?.servesWine &&
        e1?.takeout == e2?.takeout &&
        listEquality.equals(e1?.types, e2?.types) &&
        e1?.userRatingCount == e2?.userRatingCount &&
        e1?.googlePlacesId == e2?.googlePlacesId &&
        e1?.longitude == e2?.longitude &&
        e1?.searchTimestamp == e2?.searchTimestamp &&
        listEquality.equals(e1?.images, e2?.images);
  }

  @override
  int hash(RestaurantsRecord? e) => const ListEquality().hash([
        e?.accessibilityOptions,
        e?.allowDogs,
        e?.category,
        e?.createdAt,
        e?.delivery,
        e?.dineIn,
        e?.distanceMeters,
        e?.formattedAddress,
        e?.goodForGroups,
        e?.goodForWatchingSports,
        e?.googleTypes,
        e?.hasRestroom,
        e?.lastUpdated,
        e?.latitude,
        e?.liveMusic,
        e?.mapLinks,
        e?.name,
        e?.openNow,
        e?.outdoorSeating,
        e?.parkingOptions,
        e?.paymentOptions,
        e?.placeId,
        e?.priceRange,
        e?.primaryType,
        e?.rating,
        e?.reservable,
        e?.servesBeer,
        e?.servesBreakfast,
        e?.servesLunch,
        e?.servesVegetarian,
        e?.servesWine,
        e?.takeout,
        e?.types,
        e?.userRatingCount,
        e?.googlePlacesId,
        e?.longitude,
        e?.searchTimestamp,
        e?.images
      ]);

  @override
  bool isValidKey(Object? o) => o is RestaurantsRecord;
}
