import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/editorial_summary_struct.dart';
import 'package:palate/backend/schema/structs/photos_struct.dart';
import 'package:palate/backend/schema/structs/types_struct.dart';
import 'package:palate/backend/schema/structs/payment_options_struct.dart';
import 'package:palate/backend/schema/structs/string_map_struct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('EditorialSummaryStruct Helper Functions', () {
    test('createEditorialSummaryStruct creates struct', () {
      final struct = createEditorialSummaryStruct();
      expect(struct, isNotNull);
    });

    test('createEditorialSummaryStruct with flags', () {
      final struct = createEditorialSummaryStruct(
        create: true,
        clearUnsetFields: false,
      );
      expect(struct.firestoreUtilData.create, isTrue);
      expect(struct.firestoreUtilData.clearUnsetFields, isFalse);
    });

    test('createEditorialSummaryStruct with delete flag', () {
      final struct = createEditorialSummaryStruct(delete: true);
      expect(struct.firestoreUtilData.delete, isTrue);
    });

    test('createEditorialSummaryStruct with fieldValues', () {
      final struct = createEditorialSummaryStruct(
        fieldValues: {'custom': 'value'},
      );
      expect(struct.firestoreUtilData.fieldValues, containsPair('custom', 'value'));
    });

    test('updateEditorialSummaryStruct updates struct', () {
      final original = EditorialSummaryStruct(
        langaugeCode: 'en',
        text: 'Sample text',
      );
      final updated = updateEditorialSummaryStruct(
        original,
        clearUnsetFields: false,
      );
      expect(updated, isNotNull);
      expect(updated!.firestoreUtilData.clearUnsetFields, isFalse);
      expect(updated.langaugeCode, equals('en'));
    });

    test('updateEditorialSummaryStruct with create flag', () {
      final original = EditorialSummaryStruct();
      final updated = updateEditorialSummaryStruct(
        original,
        create: true,
      );
      expect(updated!.firestoreUtilData.create, isTrue);
    });

    test('updateEditorialSummaryStruct returns null for null', () {
      final updated = updateEditorialSummaryStruct(null);
      expect(updated, isNull);
    });

    test('addEditorialSummaryStructData handles null', () {
      final firestoreData = <String, dynamic>{};
      addEditorialSummaryStructData(firestoreData, null, 'field');
      expect(firestoreData.containsKey('field'), isFalse);
    });

    test('addEditorialSummaryStructData with delete flag', () {
      final struct = createEditorialSummaryStruct(delete: true);
      final firestoreData = <String, dynamic>{};
      addEditorialSummaryStructData(firestoreData, struct, 'summary');
      expect(firestoreData['summary'], isA<FieldValue>());
    });

    test('addEditorialSummaryStructData with clearFields', () {
      final struct = EditorialSummaryStruct(text: 'test');
      final firestoreData = <String, dynamic>{};
      addEditorialSummaryStructData(firestoreData, struct, 'summary');
      expect(firestoreData, isNotEmpty);
    });

    test('addEditorialSummaryStructData for field value', () {
      final struct = EditorialSummaryStruct(langaugeCode: 'en');
      final firestoreData = <String, dynamic>{};
      addEditorialSummaryStructData(firestoreData, struct, 'summary', true);
      expect(firestoreData, isNotEmpty);
    });

    test('getEditorialSummaryFirestoreData returns empty for null', () {
      final data = getEditorialSummaryFirestoreData(null);
      expect(data, isEmpty);
    });

    test('getEditorialSummaryFirestoreData returns data', () {
      final struct = EditorialSummaryStruct(
        langaugeCode: 'en',
        text: 'Editorial content',
      );
      final data = getEditorialSummaryFirestoreData(struct);
      expect(data, isNotEmpty);
    });

    test('getEditorialSummaryFirestoreData with forFieldValue', () {
      final struct = EditorialSummaryStruct(text: 'test');
      final data = getEditorialSummaryFirestoreData(struct, true);
      expect(data, isNotEmpty);
    });

    test('getEditorialSummaryFirestoreData includes field values', () {
      final struct = createEditorialSummaryStruct(
        fieldValues: {'extra': 'data'},
      );
      struct.text = 'test';
      final data = getEditorialSummaryFirestoreData(struct);
      expect(data['extra'], equals('data'));
    });

    test('getEditorialSummaryListFirestoreData handles null', () {
      final listData = getEditorialSummaryListFirestoreData(null);
      expect(listData, isEmpty);
    });

    test('getEditorialSummaryListFirestoreData processes list', () {
      final structs = [
        EditorialSummaryStruct(text: 'first'),
        EditorialSummaryStruct(text: 'second'),
      ];
      final listData = getEditorialSummaryListFirestoreData(structs);
      expect(listData, hasLength(2));
    });
  });

  group('PhotosStruct Helper Functions', () {
    test('createPhotosStruct creates struct', () {
      final struct = createPhotosStruct();
      expect(struct, isNotNull);
    });

    test('createPhotosStruct with flags', () {
      final struct = createPhotosStruct(
        create: true,
        clearUnsetFields: false,
      );
      expect(struct.firestoreUtilData.create, isTrue);
      expect(struct.firestoreUtilData.clearUnsetFields, isFalse);
    });

    test('createPhotosStruct with delete flag', () {
      final struct = createPhotosStruct(delete: true);
      expect(struct.firestoreUtilData.delete, isTrue);
    });

    test('createPhotosStruct with fieldValues', () {
      final struct = createPhotosStruct(
        fieldValues: {'metadata': 'value'},
      );
      expect(struct.firestoreUtilData.fieldValues['metadata'], equals('value'));
    });

    test('updatePhotosStruct updates struct', () {
      final original = PhotosStruct(imagepaths: ['photo1.jpg']);
      final updated = updatePhotosStruct(
        original,
        clearUnsetFields: false,
      );
      expect(updated, isNotNull);
      expect(updated!.firestoreUtilData.clearUnsetFields, isFalse);
      expect(updated.imagepaths, equals(['photo1.jpg']));
    });

    test('updatePhotosStruct with create flag', () {
      final original = PhotosStruct();
      final updated = updatePhotosStruct(
        original,
        create: true,
      );
      expect(updated!.firestoreUtilData.create, isTrue);
    });

    test('updatePhotosStruct returns null for null', () {
      final updated = updatePhotosStruct(null);
      expect(updated, isNull);
    });

    test('addPhotosStructData handles null', () {
      final firestoreData = <String, dynamic>{};
      addPhotosStructData(firestoreData, null, 'photos');
      expect(firestoreData.containsKey('photos'), isFalse);
    });

    test('addPhotosStructData with delete flag', () {
      final struct = createPhotosStruct(delete: true);
      final firestoreData = <String, dynamic>{};
      addPhotosStructData(firestoreData, struct, 'photos');
      expect(firestoreData['photos'], isA<FieldValue>());
    });

    test('addPhotosStructData with data', () {
      final struct = PhotosStruct(imagepaths: ['img1.jpg', 'img2.jpg']);
      final firestoreData = <String, dynamic>{};
      addPhotosStructData(firestoreData, struct, 'photos');
      expect(firestoreData, isNotEmpty);
    });

    test('addPhotosStructData for field value', () {
      final struct = PhotosStruct(imagepaths: ['test.jpg']);
      final firestoreData = <String, dynamic>{};
      addPhotosStructData(firestoreData, struct, 'photos', true);
      expect(firestoreData, isNotEmpty);
    });

    test('getPhotosFirestoreData returns empty for null', () {
      final data = getPhotosFirestoreData(null);
      expect(data, isEmpty);
    });

    test('getPhotosFirestoreData returns data', () {
      final struct = PhotosStruct(imagepaths: ['photo.jpg']);
      final data = getPhotosFirestoreData(struct);
      expect(data, isNotEmpty);
    });

    test('getPhotosFirestoreData with forFieldValue', () {
      final struct = PhotosStruct(imagepaths: ['test.jpg']);
      final data = getPhotosFirestoreData(struct, true);
      expect(data, isNotEmpty);
    });

    test('getPhotosFirestoreData includes field values', () {
      final struct = createPhotosStruct(
        fieldValues: {'size': '1024'},
      );
      struct.imagepaths = ['img.jpg'];
      final data = getPhotosFirestoreData(struct);
      expect(data['size'], equals('1024'));
    });

    test('getPhotosListFirestoreData handles null', () {
      final listData = getPhotosListFirestoreData(null);
      expect(listData, isEmpty);
    });

    test('getPhotosListFirestoreData processes list', () {
      final structs = [
        PhotosStruct(imagepaths: ['a.jpg']),
        PhotosStruct(imagepaths: ['b.jpg']),
        PhotosStruct(imagepaths: ['c.jpg']),
      ];
      final listData = getPhotosListFirestoreData(structs);
      expect(listData, hasLength(3));
    });
  });

  group('TypesStruct Helper Functions', () {
    test('createTypesStruct creates struct', () {
      final struct = createTypesStruct();
      expect(struct, isNotNull);
    });

    test('createTypesStruct with flags', () {
      final struct = createTypesStruct(
        create: true,
        clearUnsetFields: false,
      );
      expect(struct.firestoreUtilData.create, isTrue);
      expect(struct.firestoreUtilData.clearUnsetFields, isFalse);
    });

    test('createTypesStruct with delete flag', () {
      final struct = createTypesStruct(delete: true);
      expect(struct.firestoreUtilData.delete, isTrue);
    });

    test('updateTypesStruct updates struct', () {
      final original = TypesStruct(type: ['restaurant']);
      final updated = updateTypesStruct(
        original,
        clearUnsetFields: false,
      );
      expect(updated, isNotNull);
      expect(updated!.type, equals(['restaurant']));
    });

    test('updateTypesStruct returns null for null', () {
      final updated = updateTypesStruct(null);
      expect(updated, isNull);
    });

    test('addTypesStructData handles null', () {
      final firestoreData = <String, dynamic>{};
      addTypesStructData(firestoreData, null, 'types');
      expect(firestoreData.containsKey('types'), isFalse);
    });

    test('addTypesStructData with delete flag', () {
      final struct = createTypesStruct(delete: true);
      final firestoreData = <String, dynamic>{};
      addTypesStructData(firestoreData, struct, 'types');
      expect(firestoreData['types'], isA<FieldValue>());
    });

    test('addTypesStructData with data', () {
      final struct = TypesStruct(type: ['bar', 'restaurant']);
      final firestoreData = <String, dynamic>{};
      addTypesStructData(firestoreData, struct, 'types');
      expect(firestoreData, isNotEmpty);
    });

    test('getTypesFirestoreData returns empty for null', () {
      final data = getTypesFirestoreData(null);
      expect(data, isEmpty);
    });

    test('getTypesFirestoreData returns data', () {
      final struct = TypesStruct(type: ['cafe']);
      final data = getTypesFirestoreData(struct);
      expect(data, isNotEmpty);
    });

    test('getTypesListFirestoreData handles null', () {
      final listData = getTypesListFirestoreData(null);
      expect(listData, isEmpty);
    });

    test('getTypesListFirestoreData processes list', () {
      final structs = [
        TypesStruct(type: ['a']),
        TypesStruct(type: ['b']),
      ];
      final listData = getTypesListFirestoreData(structs);
      expect(listData, hasLength(2));
    });
  });

  group('PaymentOptionsStruct Helper Functions', () {
    test('createPaymentOptionsStruct creates struct', () {
      final struct = createPaymentOptionsStruct();
      expect(struct, isNotNull);
    });

    test('createPaymentOptionsStruct with flags', () {
      final struct = createPaymentOptionsStruct(
        create: true,
        clearUnsetFields: false,
      );
      expect(struct.firestoreUtilData.create, isTrue);
      expect(struct.firestoreUtilData.clearUnsetFields, isFalse);
    });

    test('createPaymentOptionsStruct with delete flag', () {
      final struct = createPaymentOptionsStruct(delete: true);
      expect(struct.firestoreUtilData.delete, isTrue);
    });

    test('updatePaymentOptionsStruct updates struct', () {
      final original = PaymentOptionsStruct(
        acceptsCreditCards: true,
        acceptsDebitCards: true,
      );
      final updated = updatePaymentOptionsStruct(
        original,
        clearUnsetFields: false,
      );
      expect(updated, isNotNull);
      expect(updated!.acceptsCreditCards, isTrue);
    });

    test('updatePaymentOptionsStruct returns null for null', () {
      final updated = updatePaymentOptionsStruct(null);
      expect(updated, isNull);
    });

    test('addPaymentOptionsStructData handles null', () {
      final firestoreData = <String, dynamic>{};
      addPaymentOptionsStructData(firestoreData, null, 'payment');
      expect(firestoreData.containsKey('payment'), isFalse);
    });

    test('addPaymentOptionsStructData with delete flag', () {
      final struct = createPaymentOptionsStruct(delete: true);
      final firestoreData = <String, dynamic>{};
      addPaymentOptionsStructData(firestoreData, struct, 'payment');
      expect(firestoreData['payment'], isA<FieldValue>());
    });

    test('addPaymentOptionsStructData with data', () {
      final struct = PaymentOptionsStruct(acceptsCashOnly: true);
      final firestoreData = <String, dynamic>{};
      addPaymentOptionsStructData(firestoreData, struct, 'payment');
      expect(firestoreData, isNotEmpty);
    });

    test('getPaymentOptionsFirestoreData returns empty for null', () {
      final data = getPaymentOptionsFirestoreData(null);
      expect(data, isEmpty);
    });

    test('getPaymentOptionsFirestoreData returns data', () {
      final struct = PaymentOptionsStruct(acceptsNfc: true);
      final data = getPaymentOptionsFirestoreData(struct);
      expect(data, isNotEmpty);
    });

    test('getPaymentOptionsListFirestoreData handles null', () {
      final listData = getPaymentOptionsListFirestoreData(null);
      expect(listData, isEmpty);
    });

    test('getPaymentOptionsListFirestoreData processes list', () {
      final structs = [
        PaymentOptionsStruct(acceptsCreditCards: true),
        PaymentOptionsStruct(acceptsDebitCards: true),
      ];
      final listData = getPaymentOptionsListFirestoreData(structs);
      expect(listData, hasLength(2));
    });
  });

  group('StringMapStruct Helper Functions', () {
    test('createStringMapStruct creates struct', () {
      final struct = createStringMapStruct();
      expect(struct, isNotNull);
    });

    test('createStringMapStruct with flags', () {
      final struct = createStringMapStruct(
        create: true,
        clearUnsetFields: false,
      );
      expect(struct.firestoreUtilData.create, isTrue);
      expect(struct.firestoreUtilData.clearUnsetFields, isFalse);
    });

    test('createStringMapStruct with delete flag', () {
      final struct = createStringMapStruct(delete: true);
      expect(struct.firestoreUtilData.delete, isTrue);
    });

    test('updateStringMapStruct updates struct', () {
      final original = StringMapStruct(
        key: 'name',
        value: 'John',
      );
      final updated = updateStringMapStruct(
        original,
        clearUnsetFields: false,
      );
      expect(updated, isNotNull);
      expect(updated!.key, equals('name'));
      expect(updated.value, equals('John'));
    });

    test('updateStringMapStruct returns null for null', () {
      final updated = updateStringMapStruct(null);
      expect(updated, isNull);
    });

    test('addStringMapStructData handles null', () {
      final firestoreData = <String, dynamic>{};
      addStringMapStructData(firestoreData, null, 'map');
      expect(firestoreData.containsKey('map'), isFalse);
    });

    test('addStringMapStructData with delete flag', () {
      final struct = createStringMapStruct(delete: true);
      final firestoreData = <String, dynamic>{};
      addStringMapStructData(firestoreData, struct, 'map');
      expect(firestoreData['map'], isA<FieldValue>());
    });

    test('addStringMapStructData with data', () {
      final struct = StringMapStruct(key: 'city', value: 'Toronto');
      final firestoreData = <String, dynamic>{};
      addStringMapStructData(firestoreData, struct, 'map');
      expect(firestoreData, isNotEmpty);
    });

    test('getStringMapFirestoreData returns empty for null', () {
      final data = getStringMapFirestoreData(null);
      expect(data, isEmpty);
    });

    test('getStringMapFirestoreData returns data', () {
      final struct = StringMapStruct(key: 'test', value: 'data');
      final data = getStringMapFirestoreData(struct);
      expect(data, isNotEmpty);
    });

    test('getStringMapListFirestoreData handles null', () {
      final listData = getStringMapListFirestoreData(null);
      expect(listData, isEmpty);
    });

    test('getStringMapListFirestoreData processes list', () {
      final structs = [
        StringMapStruct(key: 'a', value: '1'),
        StringMapStruct(key: 'b', value: '2'),
        StringMapStruct(key: 'c', value: '3'),
      ];
      final listData = getStringMapListFirestoreData(structs);
      expect(listData, hasLength(3));
    });
  });
}
