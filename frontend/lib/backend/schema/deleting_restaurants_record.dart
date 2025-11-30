import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DeletingRestaurantsRecord extends FirestoreRecord {
  DeletingRestaurantsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "place_id" field.
  String? _placeId;
  String get placeId => _placeId ?? '';
  bool hasPlaceId() => _placeId != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  void _initializeFields() {
    _placeId = snapshotData['place_id'] as String?;
    _name = snapshotData['name'] as String?;
    _address = snapshotData['address'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('deleting_restaurants');

  static Stream<DeletingRestaurantsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DeletingRestaurantsRecord.fromSnapshot(s));

  static Future<DeletingRestaurantsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => DeletingRestaurantsRecord.fromSnapshot(s));

  static DeletingRestaurantsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DeletingRestaurantsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DeletingRestaurantsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DeletingRestaurantsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DeletingRestaurantsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DeletingRestaurantsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDeletingRestaurantsRecordData({
  String? placeId,
  String? name,
  String? address,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'place_id': placeId,
      'name': name,
      'address': address,
    }.withoutNulls,
  );

  return firestoreData;
}

class DeletingRestaurantsRecordDocumentEquality
    implements Equality<DeletingRestaurantsRecord> {
  const DeletingRestaurantsRecordDocumentEquality();

  @override
  bool equals(DeletingRestaurantsRecord? e1, DeletingRestaurantsRecord? e2) {
    return e1?.placeId == e2?.placeId &&
        e1?.name == e2?.name &&
        e1?.address == e2?.address;
  }

  @override
  int hash(DeletingRestaurantsRecord? e) =>
      const ListEquality().hash([e?.placeId, e?.name, e?.address]);

  @override
  bool isValidKey(Object? o) => o is DeletingRestaurantsRecord;
}
