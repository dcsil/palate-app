import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "completed_onboarding" field.
  bool? _completedOnboarding;
  bool get completedOnboarding => _completedOnboarding ?? false;
  bool hasCompletedOnboarding() => _completedOnboarding != null;

  // "archetype" field.
  String? _archetype;
  String get archetype => _archetype ?? '';
  bool hasArchetype() => _archetype != null;

  // "allergens" field.
  List<String>? _allergens;
  List<String> get allergens => _allergens ?? const [];
  bool hasAllergens() => _allergens != null;

  // "ingredient_dislikes" field.
  List<String>? _ingredientDislikes;
  List<String> get ingredientDislikes => _ingredientDislikes ?? const [];
  bool hasIngredientDislikes() => _ingredientDislikes != null;

  // "cuisines" field.
  List<String>? _cuisines;
  List<String> get cuisines => _cuisines ?? const [];
  bool hasCuisines() => _cuisines != null;

  // "diet" field.
  List<String>? _diet;
  List<String> get diet => _diet ?? const [];
  bool hasDiet() => _diet != null;

  // "likedIDs" field.
  List<String>? _likedIDs;
  List<String> get likedIDs => _likedIDs ?? const [];
  bool hasLikedIDs() => _likedIDs != null;

  // "savedIDs" field.
  List<String>? _savedIDs;
  List<String> get savedIDs => _savedIDs ?? const [];
  bool hasSavedIDs() => _savedIDs != null;

  // "dislikedIDs" field.
  List<String>? _dislikedIDs;
  List<String> get dislikedIDs => _dislikedIDs ?? const [];
  bool hasDislikedIDs() => _dislikedIDs != null;

  // "visitedIDs" field.
  List<String>? _visitedIDs;
  List<String> get visitedIDs => _visitedIDs ?? const [];
  bool hasVisitedIDs() => _visitedIDs != null;

  // "activities" field.
  ActivitiesStruct? _activities;
  ActivitiesStruct get activities => _activities ?? ActivitiesStruct();
  bool hasActivities() => _activities != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _completedOnboarding = snapshotData['completed_onboarding'] as bool?;
    _archetype = snapshotData['archetype'] as String?;
    _allergens = getDataList(snapshotData['allergens']);
    _ingredientDislikes = getDataList(snapshotData['ingredient_dislikes']);
    _cuisines = getDataList(snapshotData['cuisines']);
    _diet = getDataList(snapshotData['diet']);
    _likedIDs = getDataList(snapshotData['likedIDs']);
    _savedIDs = getDataList(snapshotData['savedIDs']);
    _dislikedIDs = getDataList(snapshotData['dislikedIDs']);
    _visitedIDs = getDataList(snapshotData['visitedIDs']);
    _activities = snapshotData['activities'] is ActivitiesStruct
        ? snapshotData['activities']
        : ActivitiesStruct.maybeFromMap(snapshotData['activities']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  bool? completedOnboarding,
  String? archetype,
  ActivitiesStruct? activities,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'completed_onboarding': completedOnboarding,
      'archetype': archetype,
      'activities': ActivitiesStruct().toMap(),
    }.withoutNulls,
  );

  // Handle nested data for "activities" field.
  addActivitiesStructData(firestoreData, activities, 'activities');

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.completedOnboarding == e2?.completedOnboarding &&
        e1?.archetype == e2?.archetype &&
        listEquality.equals(e1?.allergens, e2?.allergens) &&
        listEquality.equals(e1?.ingredientDislikes, e2?.ingredientDislikes) &&
        listEquality.equals(e1?.cuisines, e2?.cuisines) &&
        listEquality.equals(e1?.diet, e2?.diet) &&
        listEquality.equals(e1?.likedIDs, e2?.likedIDs) &&
        listEquality.equals(e1?.savedIDs, e2?.savedIDs) &&
        listEquality.equals(e1?.dislikedIDs, e2?.dislikedIDs) &&
        listEquality.equals(e1?.visitedIDs, e2?.visitedIDs) &&
        e1?.activities == e2?.activities;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.completedOnboarding,
        e?.archetype,
        e?.allergens,
        e?.ingredientDislikes,
        e?.cuisines,
        e?.diet,
        e?.likedIDs,
        e?.savedIDs,
        e?.dislikedIDs,
        e?.visitedIDs,
        e?.activities
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
