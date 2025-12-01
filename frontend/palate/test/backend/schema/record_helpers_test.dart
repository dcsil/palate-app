import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:palate/backend/schema/users_record.dart';
import 'package:palate/backend/schema/restaurants_record.dart';
import 'package:palate/backend/schema/structs/restaurant_struct.dart';

void main() {
  group('UsersRecord Helper Functions', () {
    test('createUsersRecordData creates map with all fields', () {
      final data = createUsersRecordData(
        email: 'test@example.com',
        displayName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        uid: 'user123',
        createdTime: DateTime(2024, 1, 1),
        phoneNumber: '+1234567890',
        completedOnboarding: true,
        archetype: 'foodie',
      );

      expect(data, isNotEmpty);
      expect(data['email'], equals('test@example.com'));
      expect(data['display_name'], equals('Test User'));
      expect(data['photo_url'], equals('https://example.com/photo.jpg'));
      expect(data['uid'], equals('user123'));
      expect(data['phone_number'], equals('+1234567890'));
      expect(data['completed_onboarding'], isTrue);
      expect(data['archetype'], equals('foodie'));
    });

    test('createUsersRecordData with minimal fields', () {
      final data = createUsersRecordData(
        email: 'minimal@test.com',
      );

      expect(data, isNotEmpty);
      expect(data['email'], equals('minimal@test.com'));
      expect(data.containsKey('display_name'), isFalse);
    });

    test('createUsersRecordData with null values', () {
      final data = createUsersRecordData();

      // All null values should be excluded
      expect(data.containsKey('email'), isFalse);
      expect(data.containsKey('display_name'), isFalse);
      expect(data.containsKey('uid'), isFalse);
    });

    test('createUsersRecordData with empty strings', () {
      final data = createUsersRecordData(
        email: '',
        displayName: '',
      );

      expect(data['email'], equals(''));
      expect(data['display_name'], equals(''));
    });

    test('createUsersRecordData with special characters', () {
      final data = createUsersRecordData(
        email: 'test+tag@example.com',
        displayName: 'José María',
        phoneNumber: '+1 (555) 123-4567',
      );

      expect(data['email'], equals('test+tag@example.com'));
      expect(data['display_name'], equals('José María'));
      expect(data['phone_number'], equals('+1 (555) 123-4567'));
    });

    test('createUsersRecordData with unicode', () {
      final data = createUsersRecordData(
        displayName: '张伟',
        archetype: '美食家',
      );

      expect(data['display_name'], equals('张伟'));
      expect(data['archetype'], equals('美食家'));
    });
  });

  group('UsersRecordDocumentEquality', () {
    late FakeFirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
    });

    test('equals returns true for identical records', () {
      final ref = firestore.collection('users').doc('user1');
      final data = {
        'email': 'test@example.com',
        'display_name': 'Test',
        'photo_url': 'url',
        'uid': '123',
        'created_time': DateTime(2024, 1, 1),
        'phone_number': '+1234',
        'completed_onboarding': true,
        'archetype': 'foodie',
      };

      final record1 = UsersRecord.getDocumentFromData(data, ref);
      final record2 = UsersRecord.getDocumentFromData(data, ref);

      const equality = UsersRecordDocumentEquality();
      expect(equality.equals(record1, record2), isTrue);
    });

    test('equals returns false for different emails', () {
      final ref = firestore.collection('users').doc('user1');
      final data1 = {'email': 'test1@example.com'};
      final data2 = {'email': 'test2@example.com'};

      final record1 = UsersRecord.getDocumentFromData(data1, ref);
      final record2 = UsersRecord.getDocumentFromData(data2, ref);

      const equality = UsersRecordDocumentEquality();
      expect(equality.equals(record1, record2), isFalse);
    });

    test('equals returns false for different display names', () {
      final ref = firestore.collection('users').doc('user1');
      final data1 = {'display_name': 'User One'};
      final data2 = {'display_name': 'User Two'};

      final record1 = UsersRecord.getDocumentFromData(data1, ref);
      final record2 = UsersRecord.getDocumentFromData(data2, ref);

      const equality = UsersRecordDocumentEquality();
      expect(equality.equals(record1, record2), isFalse);
    });

    test('equals returns false for different uids', () {
      final ref = firestore.collection('users').doc('user1');
      final data1 = {'uid': 'uid1'};
      final data2 = {'uid': 'uid2'};

      final record1 = UsersRecord.getDocumentFromData(data1, ref);
      final record2 = UsersRecord.getDocumentFromData(data2, ref);

      const equality = UsersRecordDocumentEquality();
      expect(equality.equals(record1, record2), isFalse);
    });

    test('equals handles null records', () {
      const equality = UsersRecordDocumentEquality();
      expect(equality.equals(null, null), isTrue);
      
      final ref = firestore.collection('users').doc('user1');
      final record = UsersRecord.getDocumentFromData({}, ref);
      expect(equality.equals(record, null), isFalse);
      expect(equality.equals(null, record), isFalse);
    });

    test('hash returns same value for identical records', () {
      final ref = firestore.collection('users').doc('user1');
      final data = {
        'email': 'test@example.com',
        'uid': '123',
      };

      final record1 = UsersRecord.getDocumentFromData(data, ref);
      final record2 = UsersRecord.getDocumentFromData(data, ref);

      const equality = UsersRecordDocumentEquality();
      expect(equality.hash(record1), equals(equality.hash(record2)));
    });

    test('hash returns different values for different records', () {
      final ref = firestore.collection('users').doc('user1');
      final data1 = {'email': 'test1@example.com'};
      final data2 = {'email': 'test2@example.com'};

      final record1 = UsersRecord.getDocumentFromData(data1, ref);
      final record2 = UsersRecord.getDocumentFromData(data2, ref);

      const equality = UsersRecordDocumentEquality();
      expect(equality.hash(record1), isNot(equals(equality.hash(record2))));
    });

    test('hash handles null record', () {
      const equality = UsersRecordDocumentEquality();
      expect(equality.hash(null), isA<int>());
    });

    test('isValidKey returns true for UsersRecord', () {
      final ref = firestore.collection('users').doc('user1');
      final record = UsersRecord.getDocumentFromData({}, ref);

      const equality = UsersRecordDocumentEquality();
      expect(equality.isValidKey(record), isTrue);
    });

    test('isValidKey returns false for non-UsersRecord', () {
      const equality = UsersRecordDocumentEquality();
      expect(equality.isValidKey('not a record'), isFalse);
      expect(equality.isValidKey(123), isFalse);
      expect(equality.isValidKey(null), isFalse);
    });

    test('equals compares all fields correctly', () {
      final ref = firestore.collection('users').doc('user1');
      final baseData = {
        'email': 'test@example.com',
        'display_name': 'Test User',
        'photo_url': 'https://example.com/photo.jpg',
        'uid': 'user123',
        'created_time': DateTime(2024, 1, 1),
        'phone_number': '+1234567890',
        'completed_onboarding': true,
        'archetype': 'foodie',
      };

      final base = UsersRecord.getDocumentFromData(baseData, ref);
      const equality = UsersRecordDocumentEquality();

      // Test each field difference
      var modified = Map<String, dynamic>.from(baseData);
      modified['photo_url'] = 'different.jpg';
      expect(
        equality.equals(
          base,
          UsersRecord.getDocumentFromData(modified, ref),
        ),
        isFalse,
      );

      modified = Map<String, dynamic>.from(baseData);
      modified['phone_number'] = 'different';
      expect(
        equality.equals(
          base,
          UsersRecord.getDocumentFromData(modified, ref),
        ),
        isFalse,
      );

      modified = Map<String, dynamic>.from(baseData);
      modified['completed_onboarding'] = false;
      expect(
        equality.equals(
          base,
          UsersRecord.getDocumentFromData(modified, ref),
        ),
        isFalse,
      );

      modified = Map<String, dynamic>.from(baseData);
      modified['archetype'] = 'different';
      expect(
        equality.equals(
          base,
          UsersRecord.getDocumentFromData(modified, ref),
        ),
        isFalse,
      );
    });
  });

  group('RestaurantStruct Helper Functions', () {
    test('createRestaurantStruct creates struct', () {
      final struct = createRestaurantStruct();
      expect(struct, isNotNull);
    });

    test('createRestaurantStruct with flags', () {
      final struct = createRestaurantStruct(
        create: true,
        clearUnsetFields: false,
      );
      expect(struct.firestoreUtilData.create, isTrue);
      expect(struct.firestoreUtilData.clearUnsetFields, isFalse);
    });

    test('createRestaurantStruct with delete flag', () {
      final struct = createRestaurantStruct(delete: true);
      expect(struct.firestoreUtilData.delete, isTrue);
    });

    test('createRestaurantStruct with fieldValues', () {
      final struct = createRestaurantStruct(
        fieldValues: {'rating': '4.5'},
      );
      expect(struct.firestoreUtilData.fieldValues['rating'], equals('4.5'));
    });

    test('updateRestaurantStruct updates struct', () {
      final original = RestaurantStruct(
        name: 'Test Restaurant',
        placeId: 'place123',
      );
      final updated = updateRestaurantStruct(
        original,
        clearUnsetFields: false,
      );
      expect(updated, isNotNull);
      expect(updated!.name, equals('Test Restaurant'));
    });

    test('updateRestaurantStruct returns null for null', () {
      final updated = updateRestaurantStruct(null);
      expect(updated, isNull);
    });

    test('addRestaurantStructData handles null', () {
      final firestoreData = <String, dynamic>{};
      addRestaurantStructData(firestoreData, null, 'restaurant');
      expect(firestoreData.containsKey('restaurant'), isFalse);
    });

    test('addRestaurantStructData with delete flag', () {
      final struct = createRestaurantStruct(delete: true);
      final firestoreData = <String, dynamic>{};
      addRestaurantStructData(firestoreData, struct, 'restaurant');
      expect(firestoreData['restaurant'], isA<FieldValue>());
    });

    test('addRestaurantStructData with data', () {
      final struct = RestaurantStruct(
        name: 'My Restaurant',
        placeId: 'xyz789',
      );
      final firestoreData = <String, dynamic>{};
      addRestaurantStructData(firestoreData, struct, 'restaurant');
      expect(firestoreData, isNotEmpty);
    });

    test('getRestaurantFirestoreData returns empty for null', () {
      final data = getRestaurantFirestoreData(null);
      expect(data, isEmpty);
    });

    test('getRestaurantFirestoreData returns data', () {
      final struct = RestaurantStruct(
        name: 'Restaurant',
        placeId: 'place456',
      );
      final data = getRestaurantFirestoreData(struct);
      expect(data, isNotEmpty);
    });

    test('getRestaurantFirestoreData with forFieldValue', () {
      final struct = RestaurantStruct(name: 'Test');
      final data = getRestaurantFirestoreData(struct, true);
      expect(data, isNotEmpty);
    });

    test('getRestaurantListFirestoreData handles null', () {
      final listData = getRestaurantListFirestoreData(null);
      expect(listData, isEmpty);
    });

    test('getRestaurantListFirestoreData processes list', () {
      final structs = [
        RestaurantStruct(name: 'Restaurant A'),
        RestaurantStruct(name: 'Restaurant B'),
        RestaurantStruct(name: 'Restaurant C'),
      ];
      final listData = getRestaurantListFirestoreData(structs);
      expect(listData, hasLength(3));
    });

    test('getRestaurantListFirestoreData with empty list', () {
      final listData = getRestaurantListFirestoreData([]);
      expect(listData, isEmpty);
    });
  });
}
