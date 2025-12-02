import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/list_of_image_paths_struct.dart';
import 'package:palate/backend/schema/structs/nested_listof_strings_struct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('ListOfImagePathsStruct', () {
    test('should create with imgPaths', () {
      final struct = ListOfImagePathsStruct(imgPaths: ['img1.jpg', 'img2.png']);
      expect(struct.imgPaths, equals(['img1.jpg', 'img2.png']));
      expect(struct.imgPaths, hasLength(2));
    });

    test('should create with empty imgPaths by default', () {
      final struct = ListOfImagePathsStruct();
      expect(struct.imgPaths, isEmpty);
      expect(struct.hasImgPaths(), isFalse);
    });

    test('should set and get imgPaths', () {
      final struct = ListOfImagePathsStruct();
      struct.imgPaths = ['path1.jpg', 'path2.jpg', 'path3.jpg'];
      expect(struct.imgPaths, hasLength(3));
      expect(struct.imgPaths[0], equals('path1.jpg'));
      expect(struct.hasImgPaths(), isTrue);
    });

    test('should update imgPaths with function', () {
      final struct = ListOfImagePathsStruct(imgPaths: ['img1.jpg']);
      struct.updateImgPaths((list) => list..add('img2.jpg'));
      expect(struct.imgPaths, hasLength(2));
      expect(struct.imgPaths, contains('img2.jpg'));
    });

    test('should update imgPaths on initially null list', () {
      final struct = ListOfImagePathsStruct();
      struct.updateImgPaths((list) => list..add('new.jpg'));
      expect(struct.imgPaths, contains('new.jpg'));
      expect(struct.hasImgPaths(), isTrue);
    });

    test('hasImgPaths should return true when set', () {
      final struct = ListOfImagePathsStruct(imgPaths: ['test.jpg']);
      expect(struct.hasImgPaths(), isTrue);
    });

    test('should create from map', () {
      final data = {'imgPaths': ['map1.jpg', 'map2.jpg', 'map3.jpg']};
      final struct = ListOfImagePathsStruct.fromMap(data);
      expect(struct.imgPaths, equals(['map1.jpg', 'map2.jpg', 'map3.jpg']));
      expect(struct.imgPaths, hasLength(3));
    });

    test('should create from map with empty list', () {
      final data = {'imgPaths': <String>[]};
      final struct = ListOfImagePathsStruct.fromMap(data);
      expect(struct.imgPaths, isEmpty);
    });

    test('maybeFromMap should return struct for valid map', () {
      final data = {'imgPaths': ['test1.jpg', 'test2.jpg']};
      final struct = ListOfImagePathsStruct.maybeFromMap(data);
      expect(struct, isNotNull);
      expect(struct!.imgPaths, hasLength(2));
      expect(struct.imgPaths, contains('test1.jpg'));
    });

    test('maybeFromMap should return null for non-map', () {
      expect(ListOfImagePathsStruct.maybeFromMap('not a map'), isNull);
      expect(ListOfImagePathsStruct.maybeFromMap(123), isNull);
      expect(ListOfImagePathsStruct.maybeFromMap(null), isNull);
      expect(ListOfImagePathsStruct.maybeFromMap([]), isNull);
    });

    test('should convert to map', () {
      final struct = ListOfImagePathsStruct(imgPaths: ['path1.jpg', 'path2.jpg']);
      final map = struct.toMap();
      expect(map['imgPaths'], equals(['path1.jpg', 'path2.jpg']));
      expect(map['imgPaths'], isA<List>());
    });

    test('toMap should exclude null values', () {
      final struct = ListOfImagePathsStruct();
      final map = struct.toMap();
      expect(map.containsKey('imgPaths'), isFalse);
      expect(map, isEmpty);
    });

    test('should convert to serializable map', () {
      final struct = ListOfImagePathsStruct(imgPaths: ['serial1.jpg', 'serial2.jpg']);
      final map = struct.toSerializableMap();
      expect(map, isNotNull);
      expect(map.containsKey('imgPaths'), isTrue);
    });

    test('toString should return formatted string', () {
      final struct = ListOfImagePathsStruct(imgPaths: ['test.jpg']);
      final str = struct.toString();
      expect(str, contains('ListOfImagePathsStruct'));
      expect(str, contains('imgPaths'));
    });

    test('equality should work correctly', () {
      final struct1 = ListOfImagePathsStruct(imgPaths: ['a.jpg', 'b.jpg']);
      final struct2 = ListOfImagePathsStruct(imgPaths: ['a.jpg', 'b.jpg']);
      final struct3 = ListOfImagePathsStruct(imgPaths: ['c.jpg']);

      expect(struct1 == struct2, isTrue);
      expect(struct1 == struct3, isFalse);
      expect(struct2 == struct3, isFalse);
    });

    test('equality should handle empty lists', () {
      final struct1 = ListOfImagePathsStruct(imgPaths: []);
      final struct2 = ListOfImagePathsStruct(imgPaths: []);
      expect(struct1 == struct2, isTrue);
    });

    test('should handle single path', () {
      final struct = ListOfImagePathsStruct(imgPaths: ['single.jpg']);
      expect(struct.imgPaths, hasLength(1));
      expect(struct.imgPaths.first, equals('single.jpg'));
    });

    test('should handle many paths', () {
      final paths = List.generate(100, (i) => 'img$i.jpg');
      final struct = ListOfImagePathsStruct(imgPaths: paths);
      expect(struct.imgPaths, hasLength(100));
      expect(struct.imgPaths.last, equals('img99.jpg'));
    });

    test('should handle paths with different extensions', () {
      final struct = ListOfImagePathsStruct(
        imgPaths: ['img.jpg', 'img.png', 'img.gif', 'img.webp'],
      );
      expect(struct.imgPaths, hasLength(4));
      expect(struct.imgPaths, contains('img.png'));
    });

    test('should handle paths with special characters', () {
      final struct = ListOfImagePathsStruct(
        imgPaths: ['path/to/img.jpg', 'path\\to\\img.jpg', 'img 1.jpg'],
      );
      expect(struct.imgPaths, hasLength(3));
    });

    test('updateImgPaths should allow removing items', () {
      final struct = ListOfImagePathsStruct(imgPaths: ['a.jpg', 'b.jpg', 'c.jpg']);
      struct.updateImgPaths((list) => list.remove('b.jpg'));
      expect(struct.imgPaths, hasLength(2));
      expect(struct.imgPaths, isNot(contains('b.jpg')));
    });

    test('updateImgPaths should allow clearing', () {
      final struct = ListOfImagePathsStruct(imgPaths: ['a.jpg', 'b.jpg']);
      struct.updateImgPaths((list) => list.clear());
      expect(struct.imgPaths, isEmpty);
    });
  });

  group('NestedListofStringsStruct', () {
    test('should create with listOfStrings', () {
      final struct = NestedListofStringsStruct(listOfStrings: ['str1', 'str2']);
      expect(struct.listOfStrings, equals(['str1', 'str2']));
      expect(struct.listOfStrings, hasLength(2));
    });

    test('should create with empty listOfStrings by default', () {
      final struct = NestedListofStringsStruct();
      expect(struct.listOfStrings, isEmpty);
      expect(struct.hasListOfStrings(), isFalse);
    });

    test('should set and get listOfStrings', () {
      final struct = NestedListofStringsStruct();
      struct.listOfStrings = ['item1', 'item2', 'item3'];
      expect(struct.listOfStrings, hasLength(3));
      expect(struct.listOfStrings[0], equals('item1'));
      expect(struct.hasListOfStrings(), isTrue);
    });

    test('should update listOfStrings with function', () {
      final struct = NestedListofStringsStruct(listOfStrings: ['first']);
      struct.updateListOfStrings((list) => list..add('second'));
      expect(struct.listOfStrings, hasLength(2));
      expect(struct.listOfStrings, contains('second'));
    });

    test('should update listOfStrings on initially null list', () {
      final struct = NestedListofStringsStruct();
      struct.updateListOfStrings((list) => list..add('new'));
      expect(struct.listOfStrings, contains('new'));
      expect(struct.hasListOfStrings(), isTrue);
    });

    test('hasListOfStrings should return true when set', () {
      final struct = NestedListofStringsStruct(listOfStrings: ['test']);
      expect(struct.hasListOfStrings(), isTrue);
    });

    test('should create from map', () {
      final data = {'listOfStrings': ['map1', 'map2', 'map3']};
      final struct = NestedListofStringsStruct.fromMap(data);
      expect(struct.listOfStrings, equals(['map1', 'map2', 'map3']));
      expect(struct.listOfStrings, hasLength(3));
    });

    test('should create from map with empty list', () {
      final data = {'listOfStrings': <String>[]};
      final struct = NestedListofStringsStruct.fromMap(data);
      expect(struct.listOfStrings, isEmpty);
    });

    test('maybeFromMap should return struct for valid map', () {
      final data = {'listOfStrings': ['test1', 'test2']};
      final struct = NestedListofStringsStruct.maybeFromMap(data);
      expect(struct, isNotNull);
      expect(struct!.listOfStrings, hasLength(2));
      expect(struct.listOfStrings, contains('test1'));
    });

    test('maybeFromMap should return null for non-map', () {
      expect(NestedListofStringsStruct.maybeFromMap('not a map'), isNull);
      expect(NestedListofStringsStruct.maybeFromMap(123), isNull);
      expect(NestedListofStringsStruct.maybeFromMap(null), isNull);
      expect(NestedListofStringsStruct.maybeFromMap([]), isNull);
    });

    test('should convert to map', () {
      final struct = NestedListofStringsStruct(listOfStrings: ['item1', 'item2']);
      final map = struct.toMap();
      expect(map['listOfStrings'], equals(['item1', 'item2']));
      expect(map['listOfStrings'], isA<List>());
    });

    test('toMap should exclude null values', () {
      final struct = NestedListofStringsStruct();
      final map = struct.toMap();
      expect(map.containsKey('listOfStrings'), isFalse);
      expect(map, isEmpty);
    });

    test('should convert to serializable map', () {
      final struct = NestedListofStringsStruct(listOfStrings: ['serial1', 'serial2']);
      final map = struct.toSerializableMap();
      expect(map, isNotNull);
      expect(map.containsKey('listOfStrings'), isTrue);
    });

    test('toString should return formatted string', () {
      final struct = NestedListofStringsStruct(listOfStrings: ['test']);
      final str = struct.toString();
      expect(str, contains('NestedListofStringsStruct'));
      expect(str, contains('listOfStrings'));
    });

    test('equality should work correctly', () {
      final struct1 = NestedListofStringsStruct(listOfStrings: ['a', 'b']);
      final struct2 = NestedListofStringsStruct(listOfStrings: ['a', 'b']);
      final struct3 = NestedListofStringsStruct(listOfStrings: ['c']);

      expect(struct1 == struct2, isTrue);
      expect(struct1 == struct3, isFalse);
      expect(struct2 == struct3, isFalse);
    });

    test('equality should handle empty lists', () {
      final struct1 = NestedListofStringsStruct(listOfStrings: []);
      final struct2 = NestedListofStringsStruct(listOfStrings: []);
      expect(struct1 == struct2, isTrue);
    });

    test('should handle single string', () {
      final struct = NestedListofStringsStruct(listOfStrings: ['single']);
      expect(struct.listOfStrings, hasLength(1));
      expect(struct.listOfStrings.first, equals('single'));
    });

    test('should handle many strings', () {
      final strings = List.generate(100, (i) => 'str$i');
      final struct = NestedListofStringsStruct(listOfStrings: strings);
      expect(struct.listOfStrings, hasLength(100));
      expect(struct.listOfStrings.last, equals('str99'));
    });

    test('should handle empty strings', () {
      final struct = NestedListofStringsStruct(
        listOfStrings: ['', 'nonempty', ''],
      );
      expect(struct.listOfStrings, hasLength(3));
      expect(struct.listOfStrings[0], equals(''));
      expect(struct.listOfStrings[1], equals('nonempty'));
    });

    test('should handle strings with special characters', () {
      final struct = NestedListofStringsStruct(
        listOfStrings: ['hello world', 'test!@#', '123', 'café'],
      );
      expect(struct.listOfStrings, hasLength(4));
      expect(struct.listOfStrings, contains('café'));
    });

    test('should handle unicode strings', () {
      final struct = NestedListofStringsStruct(
        listOfStrings: ['こんにちは', '你好', '안녕하세요'],
      );
      expect(struct.listOfStrings, hasLength(3));
      expect(struct.listOfStrings[0], equals('こんにちは'));
    });

    test('updateListOfStrings should allow removing items', () {
      final struct = NestedListofStringsStruct(listOfStrings: ['a', 'b', 'c']);
      struct.updateListOfStrings((list) => list.remove('b'));
      expect(struct.listOfStrings, hasLength(2));
      expect(struct.listOfStrings, isNot(contains('b')));
    });

    test('updateListOfStrings should allow clearing', () {
      final struct = NestedListofStringsStruct(listOfStrings: ['a', 'b']);
      struct.updateListOfStrings((list) => list.clear());
      expect(struct.listOfStrings, isEmpty);
    });

    test('updateListOfStrings should allow sorting', () {
      final struct = NestedListofStringsStruct(listOfStrings: ['c', 'a', 'b']);
      struct.updateListOfStrings((list) => list.sort());
      expect(struct.listOfStrings, equals(['a', 'b', 'c']));
    });

    test('should handle long strings', () {
      final longString = 'a' * 1000;
      final struct = NestedListofStringsStruct(listOfStrings: [longString]);
      expect(struct.listOfStrings.first.length, equals(1000));
    });

    test('should handle duplicate strings', () {
      final struct = NestedListofStringsStruct(
        listOfStrings: ['dup', 'dup', 'unique', 'dup'],
      );
      expect(struct.listOfStrings, hasLength(4));
      expect(struct.listOfStrings.where((s) => s == 'dup'), hasLength(3));
    });
  });

  group('ListOfImagePathsStruct Helper Functions', () {
    test('createListOfImagePathsStruct creates struct with metadata', () {
      final struct = createListOfImagePathsStruct(
        clearUnsetFields: false,
      );
      expect(struct, isNotNull);
      expect(struct.firestoreUtilData.clearUnsetFields, isFalse);
    });

    test('createListOfImagePathsStruct with fieldValues', () {
      final struct = createListOfImagePathsStruct(
        fieldValues: {'customField': 'value'},
        clearUnsetFields: false,
      );
      expect(struct, isNotNull);
      expect(struct.firestoreUtilData.fieldValues, containsPair('customField', 'value'));
      expect(struct.firestoreUtilData.clearUnsetFields, isFalse);
    });

    test('createListOfImagePathsStruct with create flag', () {
      final struct = createListOfImagePathsStruct(
        create: true,
      );
      expect(struct.firestoreUtilData.create, isTrue);
    });

    test('createListOfImagePathsStruct with delete flag', () {
      final struct = createListOfImagePathsStruct(
        delete: true,
      );
      expect(struct.firestoreUtilData.delete, isTrue);
    });

    test('updateListOfImagePathsStruct updates existing struct', () {
      final original = ListOfImagePathsStruct(imgPaths: ['orig.jpg']);
      final updated = updateListOfImagePathsStruct(
        original,
        clearUnsetFields: false,
      );
      expect(updated, isNotNull);
      expect(updated!.firestoreUtilData.clearUnsetFields, isFalse);
      expect(updated.imgPaths, equals(['orig.jpg']));
    });

    test('updateListOfImagePathsStruct with create flag', () {
      final original = ListOfImagePathsStruct();
      final updated = updateListOfImagePathsStruct(
        original,
        create: true,
        clearUnsetFields: true,
      );
      expect(updated!.firestoreUtilData.create, isTrue);
      expect(updated.firestoreUtilData.clearUnsetFields, isTrue);
    });

    test('updateListOfImagePathsStruct returns null for null input', () {
      final updated = updateListOfImagePathsStruct(null);
      expect(updated, isNull);
    });

    test('addListOfImagePathsStructData handles null struct', () {
      final firestoreData = <String, dynamic>{'existing': 'value'};
      addListOfImagePathsStructData(firestoreData, null, 'testField');
      expect(firestoreData.containsKey('testField'), isFalse);
      expect(firestoreData['existing'], equals('value'));
    });

    test('addListOfImagePathsStructData with delete flag', () {
      final struct = createListOfImagePathsStruct(delete: true);
      final firestoreData = <String, dynamic>{};
      addListOfImagePathsStructData(firestoreData, struct, 'images');
      expect(firestoreData['images'], isA<FieldValue>());
    });

    test('addListOfImagePathsStructData with clearFields', () {
      final struct = ListOfImagePathsStruct(imgPaths: ['test.jpg']);
      final firestoreData = <String, dynamic>{};
      addListOfImagePathsStructData(firestoreData, struct, 'images');
      expect(firestoreData, isNotEmpty);
    });

    test('addListOfImagePathsStructData for field value', () {
      final struct = ListOfImagePathsStruct(imgPaths: ['field.jpg']);
      final firestoreData = <String, dynamic>{};
      addListOfImagePathsStructData(firestoreData, struct, 'images', true);
      expect(firestoreData, isNotEmpty);
    });

    test('getListOfImagePathsFirestoreData returns empty for null', () {
      final data = getListOfImagePathsFirestoreData(null);
      expect(data, isEmpty);
    });

    test('getListOfImagePathsFirestoreData returns data for struct', () {
      final struct = ListOfImagePathsStruct(imgPaths: ['fire1.jpg', 'fire2.jpg']);
      final data = getListOfImagePathsFirestoreData(struct);
      expect(data, isNotEmpty);
      expect(data.keys, contains('imgPaths'));
    });

    test('getListOfImagePathsFirestoreData with forFieldValue', () {
      final struct = ListOfImagePathsStruct(imgPaths: ['field.jpg']);
      final data = getListOfImagePathsFirestoreData(struct, true);
      expect(data, isNotEmpty);
    });

    test('getListOfImagePathsFirestoreData includes field values', () {
      final struct = createListOfImagePathsStruct(
        fieldValues: {'extra': 'data'},
      );
      struct.imgPaths = ['test.jpg'];
      final data = getListOfImagePathsFirestoreData(struct);
      expect(data.keys, contains('extra'));
      expect(data['extra'], equals('data'));
    });

    test('getListOfImagePathsListFirestoreData returns empty for null', () {
      final listData = getListOfImagePathsListFirestoreData(null);
      expect(listData, isEmpty);
    });

    test('getListOfImagePathsListFirestoreData processes list', () {
      final structs = [
        ListOfImagePathsStruct(imgPaths: ['img1.jpg']),
        ListOfImagePathsStruct(imgPaths: ['img2.jpg']),
      ];
      final listData = getListOfImagePathsListFirestoreData(structs);
      expect(listData, hasLength(2));
      expect(listData[0], isA<Map>());
      expect(listData[1], isA<Map>());
    });

    test('getListOfImagePathsListFirestoreData handles empty list', () {
      final listData = getListOfImagePathsListFirestoreData([]);
      expect(listData, isEmpty);
    });
  });

  group('NestedListofStringsStruct Helper Functions', () {
    test('createNestedListofStringsStruct creates struct', () {
      final struct = createNestedListofStringsStruct();
      expect(struct, isNotNull);
    });

    test('createNestedListofStringsStruct with flags', () {
      final struct = createNestedListofStringsStruct(
        create: true,
        clearUnsetFields: false,
      );
      expect(struct.firestoreUtilData.create, isTrue);
      expect(struct.firestoreUtilData.clearUnsetFields, isFalse);
    });

    test('createNestedListofStringsStruct with delete flag', () {
      final struct = createNestedListofStringsStruct(delete: true);
      expect(struct.firestoreUtilData.delete, isTrue);
    });

    test('updateNestedListofStringsStruct updates struct', () {
      final original = NestedListofStringsStruct(listOfStrings: ['orig']);
      final updated = updateNestedListofStringsStruct(
        original,
        clearUnsetFields: false,
      );
      expect(updated, isNotNull);
      expect(updated!.firestoreUtilData.clearUnsetFields, isFalse);
    });

    test('updateNestedListofStringsStruct returns null for null', () {
      final updated = updateNestedListofStringsStruct(null);
      expect(updated, isNull);
    });

    test('addNestedListofStringsStructData handles null', () {
      final firestoreData = <String, dynamic>{};
      addNestedListofStringsStructData(firestoreData, null, 'field');
      expect(firestoreData.containsKey('field'), isFalse);
    });

    test('addNestedListofStringsStructData with delete flag', () {
      final struct = createNestedListofStringsStruct(delete: true);
      final firestoreData = <String, dynamic>{};
      addNestedListofStringsStructData(firestoreData, struct, 'strings');
      expect(firestoreData['strings'], isA<FieldValue>());
    });

    test('addNestedListofStringsStructData with data', () {
      final struct = NestedListofStringsStruct(listOfStrings: ['data']);
      final firestoreData = <String, dynamic>{};
      addNestedListofStringsStructData(firestoreData, struct, 'strings');
      expect(firestoreData, isNotEmpty);
    });

    test('getNestedListofStringsFirestoreData returns empty for null', () {
      final data = getNestedListofStringsFirestoreData(null);
      expect(data, isEmpty);
    });

    test('getNestedListofStringsFirestoreData returns data', () {
      final struct = NestedListofStringsStruct(listOfStrings: ['test']);
      final data = getNestedListofStringsFirestoreData(struct);
      expect(data, isNotEmpty);
      expect(data.keys, contains('listOfStrings'));
    });

    test('getNestedListofStringsListFirestoreData handles null', () {
      final listData = getNestedListofStringsListFirestoreData(null);
      expect(listData, isEmpty);
    });

    test('getNestedListofStringsListFirestoreData processes list', () {
      final structs = [
        NestedListofStringsStruct(listOfStrings: ['a']),
        NestedListofStringsStruct(listOfStrings: ['b']),
      ];
      final listData = getNestedListofStringsListFirestoreData(structs);
      expect(listData, hasLength(2));
    });
  });
}

