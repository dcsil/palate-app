import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:palate/backend/schema/users_record.dart';
import 'package:palate/backend/schema/deleting_restaurants_record.dart';

void main() {
  group('UsersRecord', () {
    late FakeFirebaseFirestore fakeFirestore;
    late CollectionReference usersCollection;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      usersCollection = fakeFirestore.collection('users');
    });

    group('Field Accessors', () {
      test('should return default values for all fields', () {
        final data = <String, dynamic>{};
        
        return usersCollection.doc('test').set(data).then((_) {
          return usersCollection.doc('test').get();
        }).then((snapshot) {
          final record = UsersRecord.fromSnapshot(snapshot);
          
          expect(record.email, '');
          expect(record.displayName, '');
          expect(record.photoUrl, '');
          expect(record.uid, '');
          expect(record.phoneNumber, '');
          expect(record.completedOnboarding, false);
          expect(record.archetype, '');
          expect(record.createdTime, isNull);
        });
      });

      test('should parse all string fields correctly', () {
        final data = <String, dynamic>{
          'email': 'test@example.com',
          'display_name': 'Test User',
          'photo_url': 'https://example.com/photo.jpg',
          'uid': 'user123',
          'phone_number': '+1234567890',
          'archetype': 'foodie',
        };
        
        return usersCollection.doc('test').set(data).then((_) {
          return usersCollection.doc('test').get();
        }).then((snapshot) {
          final record = UsersRecord.fromSnapshot(snapshot);
          
          expect(record.email, 'test@example.com');
          expect(record.displayName, 'Test User');
          expect(record.photoUrl, 'https://example.com/photo.jpg');
          expect(record.uid, 'user123');
          expect(record.phoneNumber, '+1234567890');
          expect(record.archetype, 'foodie');
        });
      });

      test('should parse boolean field correctly', () {
        final data = <String, dynamic>{
          'completed_onboarding': true,
        };
        
        return usersCollection.doc('test').set(data).then((_) {
          return usersCollection.doc('test').get();
        }).then((snapshot) {
          final record = UsersRecord.fromSnapshot(snapshot);
          
          expect(record.completedOnboarding, true);
          expect(record.hasCompletedOnboarding(), true);
        });
      });

      test('should parse DateTime field correctly', () {
        final now = DateTime.now();
        final data = <String, dynamic>{
          'created_time': Timestamp.fromDate(now),
        };
        
        return usersCollection.doc('test').set(data).then((_) {
          return usersCollection.doc('test').get();
        }).then((snapshot) {
          final record = UsersRecord.fromSnapshot(snapshot);
          
          expect(record.createdTime, isNotNull);
          expect(record.hasCreatedTime(), true);
        });
      });
    });

    group('Has Methods', () {
      test('should return false for missing optional fields', () {
        final data = <String, dynamic>{};
        
        return usersCollection.doc('test').set(data).then((_) {
          return usersCollection.doc('test').get();
        }).then((snapshot) {
          final record = UsersRecord.fromSnapshot(snapshot);
          
          expect(record.hasEmail(), false);
          expect(record.hasDisplayName(), false);
          expect(record.hasPhotoUrl(), false);
          expect(record.hasUid(), false);
          expect(record.hasCreatedTime(), false);
          expect(record.hasPhoneNumber(), false);
          expect(record.hasArchetype(), false);
        });
      });

      test('should return true for present optional fields', () {
        final data = <String, dynamic>{
          'email': 'test@example.com',
          'display_name': 'Test',
          'uid': 'user123',
        };
        
        return usersCollection.doc('test').set(data).then((_) {
          return usersCollection.doc('test').get();
        }).then((snapshot) {
          final record = UsersRecord.fromSnapshot(snapshot);
          
          expect(record.hasEmail(), true);
          expect(record.hasDisplayName(), true);
          expect(record.hasUid(), true);
        });
      });
    });

    group('Static Methods', () {
      test('should create from snapshot', () {
        final data = <String, dynamic>{
          'email': 'test@example.com',
          'display_name': 'Snapshot Test',
        };
        
        return usersCollection.doc('test').set(data).then((_) {
          return usersCollection.doc('test').get();
        }).then((snapshot) {
          final record = UsersRecord.fromSnapshot(snapshot);
          
          expect(record, isA<UsersRecord>());
          expect(record.email, 'test@example.com');
          expect(record.displayName, 'Snapshot Test');
        });
      });

      test('should get document as stream', () async {
        final data = <String, dynamic>{'email': 'stream@test.com'};
        await usersCollection.doc('stream-test').set(data);
        
        final docRef = usersCollection.doc('stream-test');
        final stream = UsersRecord.getDocument(docRef);
        
        expect(stream, isA<Stream<UsersRecord>>());
        
        final record = await stream.first;
        expect(record.email, 'stream@test.com');
      });

      test('should get document once as future', () async {
        final data = <String, dynamic>{'email': 'future@test.com'};
        await usersCollection.doc('future-test').set(data);
        
        final docRef = usersCollection.doc('future-test');
        final record = await UsersRecord.getDocumentOnce(docRef);
        
        expect(record, isA<UsersRecord>());
        expect(record.email, 'future@test.com');
      });

      test('should create from data with reference', () {
        final data = <String, dynamic>{
          'email': 'data@test.com',
          'uid': 'user456',
        };
        final docRef = usersCollection.doc('data-test');
        
        final record = UsersRecord.getDocumentFromData(data, docRef);
        
        expect(record, isA<UsersRecord>());
        expect(record.email, 'data@test.com');
        expect(record.uid, 'user456');
      });
    });

    group('Object Methods', () {
      test('should generate toString correctly', () async {
        final data = <String, dynamic>{'email': 'tostring@test.com'};
        await usersCollection.doc('tostring').set(data);
        
        final snapshot = await usersCollection.doc('tostring').get();
        final record = UsersRecord.fromSnapshot(snapshot);
        
        final str = record.toString();
        expect(str, contains('UsersRecord'));
        expect(str, contains('reference'));
      });

      test('should implement equality based on reference path', () async {
        final data = <String, dynamic>{'email': 'equality@test.com'};
        await usersCollection.doc('eq1').set(data);
        await usersCollection.doc('eq2').set(data);
        
        final snapshot1 = await usersCollection.doc('eq1').get();
        final snapshot2 = await usersCollection.doc('eq2').get();
        final snapshot1Again = await usersCollection.doc('eq1').get();
        
        final record1 = UsersRecord.fromSnapshot(snapshot1);
        final record2 = UsersRecord.fromSnapshot(snapshot2);
        final record1Again = UsersRecord.fromSnapshot(snapshot1Again);
        
        // Same path should be equal
        expect(record1 == record1Again, true);
        
        // Different paths should not be equal
        expect(record1 == record2, false);
      });

      test('should generate consistent hashCode', () async {
        final data = <String, dynamic>{'email': 'hash@test.com'};
        await usersCollection.doc('hash').set(data);
        
        final snapshot = await usersCollection.doc('hash').get();
        final record1 = UsersRecord.fromSnapshot(snapshot);
        final record2 = UsersRecord.fromSnapshot(snapshot);
        
        expect(record1.hashCode, equals(record2.hashCode));
      });
    });

    group('UsersRecordDocumentEquality', () {
      test('should compare records for equality based on field values', () async {
        final data1 = <String, dynamic>{
          'email': 'user@example.com',
          'uid': 'user123',
        };
        final data2 = <String, dynamic>{
          'email': 'user@example.com',
          'uid': 'user123',
        };
        final data3 = <String, dynamic>{
          'email': 'other@example.com',
          'uid': 'user456',
        };
        
        await usersCollection.doc('u1').set(data1);
        await usersCollection.doc('u2').set(data2);
        await usersCollection.doc('u3').set(data3);
        
        final snap1 = await usersCollection.doc('u1').get();
        final snap2 = await usersCollection.doc('u2').get();
        final snap3 = await usersCollection.doc('u3').get();
        
        final record1 = UsersRecord.fromSnapshot(snap1);
        final record2 = UsersRecord.fromSnapshot(snap2);
        final record3 = UsersRecord.fromSnapshot(snap3);
        
        const equality = UsersRecordDocumentEquality();
        
        expect(equality.equals(record1, record2), true);
        expect(equality.equals(record1, record3), false);
      });

      test('isValidKey should return true for UsersRecord', () async {
        final data = <String, dynamic>{'email': 'valid@test.com'};
        await usersCollection.doc('valid').set(data);
        
        final snapshot = await usersCollection.doc('valid').get();
        final record = UsersRecord.fromSnapshot(snapshot);
        
        const equality = UsersRecordDocumentEquality();
        
        expect(equality.isValidKey(record), true);
        expect(equality.isValidKey('not a record'), false);
        expect(equality.isValidKey(null), false);
      });
    });
  });

  group('DeletingRestaurantsRecord', () {
    late FakeFirebaseFirestore fakeFirestore;
    late CollectionReference deletingCollection;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      deletingCollection = fakeFirestore.collection('deleting_restaurants');
    });

    group('Field Accessors', () {
      test('should return default values for all fields', () {
        final data = <String, dynamic>{};
        
        return deletingCollection.doc('test').set(data).then((_) {
          return deletingCollection.doc('test').get();
        }).then((snapshot) {
          final record = DeletingRestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.placeId, '');
          expect(record.name, '');
          expect(record.address, '');
        });
      });

      test('should parse all fields correctly', () {
        final data = <String, dynamic>{
          'place_id': 'place123',
          'name': 'Old Restaurant',
          'address': '123 Closed St',
        };
        
        return deletingCollection.doc('test').set(data).then((_) {
          return deletingCollection.doc('test').get();
        }).then((snapshot) {
          final record = DeletingRestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.placeId, 'place123');
          expect(record.name, 'Old Restaurant');
          expect(record.address, '123 Closed St');
        });
      });
    });

    group('Has Methods', () {
      test('should return false for missing optional fields', () {
        final data = <String, dynamic>{};
        
        return deletingCollection.doc('test').set(data).then((_) {
          return deletingCollection.doc('test').get();
        }).then((snapshot) {
          final record = DeletingRestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.hasPlaceId(), false);
          expect(record.hasName(), false);
          expect(record.hasAddress(), false);
        });
      });

      test('should return true for present optional fields', () {
        final data = <String, dynamic>{
          'place_id': 'place456',
          'name': 'Present Restaurant',
        };
        
        return deletingCollection.doc('test').set(data).then((_) {
          return deletingCollection.doc('test').get();
        }).then((snapshot) {
          final record = DeletingRestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record.hasPlaceId(), true);
          expect(record.hasName(), true);
        });
      });
    });

    group('Static Methods', () {
      test('should create from snapshot', () {
        final data = <String, dynamic>{
          'place_id': 'snap123',
          'name': 'Snapshot Restaurant',
        };
        
        return deletingCollection.doc('test').set(data).then((_) {
          return deletingCollection.doc('test').get();
        }).then((snapshot) {
          final record = DeletingRestaurantsRecord.fromSnapshot(snapshot);
          
          expect(record, isA<DeletingRestaurantsRecord>());
          expect(record.placeId, 'snap123');
          expect(record.name, 'Snapshot Restaurant');
        });
      });

      test('should get document as stream', () async {
        final data = <String, dynamic>{'name': 'Stream Restaurant'};
        await deletingCollection.doc('stream-test').set(data);
        
        final docRef = deletingCollection.doc('stream-test');
        final stream = DeletingRestaurantsRecord.getDocument(docRef);
        
        expect(stream, isA<Stream<DeletingRestaurantsRecord>>());
        
        final record = await stream.first;
        expect(record.name, 'Stream Restaurant');
      });

      test('should get document once as future', () async {
        final data = <String, dynamic>{'name': 'Future Restaurant'};
        await deletingCollection.doc('future-test').set(data);
        
        final docRef = deletingCollection.doc('future-test');
        final record = await DeletingRestaurantsRecord.getDocumentOnce(docRef);
        
        expect(record, isA<DeletingRestaurantsRecord>());
        expect(record.name, 'Future Restaurant');
      });

      test('should create from data with reference', () {
        final data = <String, dynamic>{
          'place_id': 'data789',
          'name': 'Data Restaurant',
          'address': '789 Data Ave',
        };
        final docRef = deletingCollection.doc('data-test');
        
        final record = DeletingRestaurantsRecord.getDocumentFromData(data, docRef);
        
        expect(record, isA<DeletingRestaurantsRecord>());
        expect(record.placeId, 'data789');
        expect(record.name, 'Data Restaurant');
        expect(record.address, '789 Data Ave');
      });
    });

    group('Object Methods', () {
      test('should generate toString correctly', () async {
        final data = <String, dynamic>{'name': 'ToString Restaurant'};
        await deletingCollection.doc('tostring').set(data);
        
        final snapshot = await deletingCollection.doc('tostring').get();
        final record = DeletingRestaurantsRecord.fromSnapshot(snapshot);
        
        final str = record.toString();
        expect(str, contains('DeletingRestaurantsRecord'));
        expect(str, contains('reference'));
      });

      test('should implement equality based on reference path', () async {
        final data = <String, dynamic>{'name': 'Equality Restaurant'};
        await deletingCollection.doc('eq1').set(data);
        await deletingCollection.doc('eq2').set(data);
        
        final snapshot1 = await deletingCollection.doc('eq1').get();
        final snapshot2 = await deletingCollection.doc('eq2').get();
        final snapshot1Again = await deletingCollection.doc('eq1').get();
        
        final record1 = DeletingRestaurantsRecord.fromSnapshot(snapshot1);
        final record2 = DeletingRestaurantsRecord.fromSnapshot(snapshot2);
        final record1Again = DeletingRestaurantsRecord.fromSnapshot(snapshot1Again);
        
        expect(record1 == record1Again, true);
        expect(record1 == record2, false);
      });

      test('should generate consistent hashCode', () async {
        final data = <String, dynamic>{'name': 'Hash Restaurant'};
        await deletingCollection.doc('hash').set(data);
        
        final snapshot = await deletingCollection.doc('hash').get();
        final record1 = DeletingRestaurantsRecord.fromSnapshot(snapshot);
        final record2 = DeletingRestaurantsRecord.fromSnapshot(snapshot);
        
        expect(record1.hashCode, equals(record2.hashCode));
      });
    });

    group('createDeletingRestaurantsRecordData', () {
      test('should create data map with all fields', () {
        final data = createDeletingRestaurantsRecordData(
          placeId: 'place999',
          name: 'Create Restaurant',
          address: '999 Create Blvd',
        );
        
        expect(data, isA<Map<String, dynamic>>());
        expect(data['place_id'], 'place999');
        expect(data['name'], 'Create Restaurant');
        expect(data['address'], '999 Create Blvd');
      });

      test('should omit null values', () {
        final data = createDeletingRestaurantsRecordData(
          name: 'Only Name',
        );
        
        expect(data.containsKey('name'), true);
        expect(data.containsKey('place_id'), false);
        expect(data.containsKey('address'), false);
      });
    });

    group('DeletingRestaurantsRecordDocumentEquality', () {
      test('should compare records for equality', () async {
        final data1 = <String, dynamic>{
          'place_id': 'place1',
          'name': 'Restaurant A',
          'address': 'Address A',
        };
        final data2 = <String, dynamic>{
          'place_id': 'place1',
          'name': 'Restaurant A',
          'address': 'Address A',
        };
        final data3 = <String, dynamic>{
          'place_id': 'place2',
          'name': 'Restaurant B',
          'address': 'Address B',
        };
        
        await deletingCollection.doc('d1').set(data1);
        await deletingCollection.doc('d2').set(data2);
        await deletingCollection.doc('d3').set(data3);
        
        final snap1 = await deletingCollection.doc('d1').get();
        final snap2 = await deletingCollection.doc('d2').get();
        final snap3 = await deletingCollection.doc('d3').get();
        
        final record1 = DeletingRestaurantsRecord.fromSnapshot(snap1);
        final record2 = DeletingRestaurantsRecord.fromSnapshot(snap2);
        final record3 = DeletingRestaurantsRecord.fromSnapshot(snap3);
        
        const equality = DeletingRestaurantsRecordDocumentEquality();
        
        expect(equality.equals(record1, record2), true);
        expect(equality.equals(record1, record3), false);
      });

      test('isValidKey should return true for DeletingRestaurantsRecord', () async {
        final data = <String, dynamic>{'name': 'Valid Restaurant'};
        await deletingCollection.doc('valid').set(data);
        
        final snapshot = await deletingCollection.doc('valid').get();
        final record = DeletingRestaurantsRecord.fromSnapshot(snapshot);
        
        const equality = DeletingRestaurantsRecordDocumentEquality();
        
        expect(equality.isValidKey(record), true);
        expect(equality.isValidKey('not a record'), false);
        expect(equality.isValidKey(null), false);
      });
    });
  });
}
