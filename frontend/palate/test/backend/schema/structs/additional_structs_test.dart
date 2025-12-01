import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/photos_struct.dart';
import 'package:palate/backend/schema/structs/editorial_summary_struct.dart';

void main() {
  group('PhotosStruct', () {
    test('should create with imagepaths', () {
      final photos = PhotosStruct(imagepaths: ['path1.jpg', 'path2.jpg']);
      expect(photos.imagepaths, equals(['path1.jpg', 'path2.jpg']));
    });

    test('should create with empty imagepaths by default', () {
      final photos = PhotosStruct();
      expect(photos.imagepaths, isEmpty);
    });

    test('should set and get imagepaths', () {
      final photos = PhotosStruct();
      photos.imagepaths = ['new1.jpg', 'new2.jpg', 'new3.jpg'];
      expect(photos.imagepaths, hasLength(3));
      expect(photos.imagepaths[0], equals('new1.jpg'));
    });

    test('should update imagepaths with function', () {
      final photos = PhotosStruct(imagepaths: ['photo1.jpg']);
      photos.updateImagepaths((list) => list..add('photo2.jpg'));
      expect(photos.imagepaths, hasLength(2));
      expect(photos.imagepaths, contains('photo2.jpg'));
    });

    test('hasImagepaths should return true when set', () {
      final photos = PhotosStruct(imagepaths: ['path.jpg']);
      expect(photos.hasImagepaths(), isTrue);
    });

    test('hasImagepaths should return false when null', () {
      final photos = PhotosStruct();
      expect(photos.hasImagepaths(), isFalse);
    });

    test('should create from map', () {
      final data = {
        'imagepaths': ['map1.jpg', 'map2.jpg']
      };
      final photos = PhotosStruct.fromMap(data);
      expect(photos.imagepaths, equals(['map1.jpg', 'map2.jpg']));
    });

    test('maybeFromMap should return struct for valid map', () {
      final data = {'imagepaths': ['test.jpg']};
      final photos = PhotosStruct.maybeFromMap(data);
      expect(photos, isNotNull);
      expect(photos!.imagepaths, contains('test.jpg'));
    });

    test('maybeFromMap should return null for non-map', () {
      expect(PhotosStruct.maybeFromMap('not a map'), isNull);
      expect(PhotosStruct.maybeFromMap(123), isNull);
      expect(PhotosStruct.maybeFromMap(null), isNull);
    });

    test('should convert to map', () {
      final photos = PhotosStruct(imagepaths: ['path1.jpg']);
      final map = photos.toMap();
      expect(map['imagepaths'], equals(['path1.jpg']));
    });

    test('toMap should exclude null values', () {
      final photos = PhotosStruct();
      final map = photos.toMap();
      expect(map.containsKey('imagepaths'), isFalse);
    });

    test('should convert to serializable map', () {
      final photos = PhotosStruct(imagepaths: ['serial.jpg']);
      final map = photos.toSerializableMap();
      expect(map, isNotNull);
      expect(map.containsKey('imagepaths'), isTrue);
    });

    test('should handle serializable map data', () {
      final photos = PhotosStruct(imagepaths: ['test1.jpg', 'test2.jpg']);
      final serialized = photos.toSerializableMap();
      expect(serialized, isNotNull);
    });

    test('toString should return formatted string', () {
      final photos = PhotosStruct(imagepaths: ['test.jpg']);
      final str = photos.toString();
      expect(str, contains('PhotosStruct'));
      expect(str, contains('imagepaths'));
    });

    test('equality should work correctly', () {
      final photos1 = PhotosStruct(imagepaths: ['a.jpg', 'b.jpg']);
      final photos2 = PhotosStruct(imagepaths: ['a.jpg', 'b.jpg']);
      final photos3 = PhotosStruct(imagepaths: ['c.jpg']);

      expect(photos1 == photos2, isTrue);
      expect(photos1 == photos3, isFalse);
    });

    test('hashCode should be consistent for same data', () {
      final photos1 = PhotosStruct(imagepaths: ['a.jpg']);
      final photos2 = PhotosStruct(imagepaths: ['a.jpg']);
      // Objects with same data should be equal
      expect(photos1 == photos2, isTrue);
    });

    test('should handle empty list', () {
      final photos = PhotosStruct(imagepaths: []);
      expect(photos.imagepaths, isEmpty);
      expect(photos.hasImagepaths(), isTrue);
    });
  });

  group('EditorialSummaryStruct', () {
    test('should create with langaugeCode and text', () {
      final summary = EditorialSummaryStruct(
        langaugeCode: 'en',
        text: 'A great restaurant',
      );
      expect(summary.langaugeCode, equals('en'));
      expect(summary.text, equals('A great restaurant'));
    });

    test('should create with default empty strings', () {
      final summary = EditorialSummaryStruct();
      expect(summary.langaugeCode, equals(''));
      expect(summary.text, equals(''));
    });

    test('should set and get langaugeCode', () {
      final summary = EditorialSummaryStruct();
      summary.langaugeCode = 'fr';
      expect(summary.langaugeCode, equals('fr'));
      expect(summary.hasLangaugeCode(), isTrue);
    });

    test('should set and get text', () {
      final summary = EditorialSummaryStruct();
      summary.text = 'Updated text';
      expect(summary.text, equals('Updated text'));
      expect(summary.hasText(), isTrue);
    });

    test('hasLangaugeCode should return false when null', () {
      final summary = EditorialSummaryStruct();
      expect(summary.hasLangaugeCode(), isFalse);
    });

    test('hasText should return false when null', () {
      final summary = EditorialSummaryStruct();
      expect(summary.hasText(), isFalse);
    });

    test('should create from map', () {
      final data = {
        'langaugeCode': 'es',
        'text': 'Un gran restaurante',
      };
      final summary = EditorialSummaryStruct.fromMap(data);
      expect(summary.langaugeCode, equals('es'));
      expect(summary.text, equals('Un gran restaurante'));
    });

    test('maybeFromMap should return struct for valid map', () {
      final data = {'langaugeCode': 'de', 'text': 'Ein tolles Restaurant'};
      final summary = EditorialSummaryStruct.maybeFromMap(data);
      expect(summary, isNotNull);
      expect(summary!.langaugeCode, equals('de'));
      expect(summary.text, equals('Ein tolles Restaurant'));
    });

    test('maybeFromMap should return null for non-map', () {
      expect(EditorialSummaryStruct.maybeFromMap('not a map'), isNull);
      expect(EditorialSummaryStruct.maybeFromMap(123), isNull);
      expect(EditorialSummaryStruct.maybeFromMap(null), isNull);
    });

    test('should convert to map', () {
      final summary = EditorialSummaryStruct(
        langaugeCode: 'it',
        text: 'Un ottimo ristorante',
      );
      final map = summary.toMap();
      expect(map['langaugeCode'], equals('it'));
      expect(map['text'], equals('Un ottimo ristorante'));
    });

    test('toMap should exclude null values', () {
      final summary = EditorialSummaryStruct();
      final map = summary.toMap();
      expect(map.containsKey('langaugeCode'), isFalse);
      expect(map.containsKey('text'), isFalse);
    });

    test('should convert to serializable map', () {
      final summary = EditorialSummaryStruct(
        langaugeCode: 'pt',
        text: 'Um ótimo restaurante',
      );
      final map = summary.toSerializableMap();
      expect(map, isNotNull);
      expect(map.containsKey('langaugeCode'), isTrue);
      expect(map.containsKey('text'), isTrue);
    });

    test('should create from serializable map', () {
      final data = {
        'langaugeCode': 'ja',
        'text': '素晴らしいレストラン',
      };
      final summary = EditorialSummaryStruct.fromSerializableMap(data);
      expect(summary.langaugeCode, equals('ja'));
      expect(summary.text, equals('素晴らしいレストラン'));
    });

    test('toString should return formatted string', () {
      final summary = EditorialSummaryStruct(
        langaugeCode: 'en',
        text: 'Test',
      );
      final str = summary.toString();
      expect(str, contains('EditorialSummaryStruct'));
      expect(str, contains('langaugeCode'));
    });

    test('equality should work correctly', () {
      final summary1 = EditorialSummaryStruct(
        langaugeCode: 'en',
        text: 'Same text',
      );
      final summary2 = EditorialSummaryStruct(
        langaugeCode: 'en',
        text: 'Same text',
      );
      final summary3 = EditorialSummaryStruct(
        langaugeCode: 'fr',
        text: 'Different text',
      );

      expect(summary1 == summary2, isTrue);
      expect(summary1 == summary3, isFalse);
    });

    test('hashCode should be consistent', () {
      final summary1 = EditorialSummaryStruct(
        langaugeCode: 'en',
        text: 'Test',
      );
      final summary2 = EditorialSummaryStruct(
        langaugeCode: 'en',
        text: 'Test',
      );
      expect(summary1.hashCode, equals(summary2.hashCode));
    });

    test('should handle empty strings', () {
      final summary = EditorialSummaryStruct(
        langaugeCode: '',
        text: '',
      );
      expect(summary.langaugeCode, equals(''));
      expect(summary.text, equals(''));
    });

    test('should handle only langaugeCode set', () {
      final summary = EditorialSummaryStruct(langaugeCode: 'en');
      expect(summary.langaugeCode, equals('en'));
      expect(summary.text, equals(''));
      expect(summary.hasLangaugeCode(), isTrue);
      expect(summary.hasText(), isFalse);
    });

    test('should handle only text set', () {
      final summary = EditorialSummaryStruct(text: 'Some text');
      expect(summary.langaugeCode, equals(''));
      expect(summary.text, equals('Some text'));
      expect(summary.hasLangaugeCode(), isFalse);
      expect(summary.hasText(), isTrue);
    });

    test('should handle special characters in text', () {
      final summary = EditorialSummaryStruct(
        text: 'Text with special chars: !@#\$%^&*()',
      );
      expect(summary.text, contains('!@#'));
    });

    test('should handle long text', () {
      final longText = 'A' * 1000;
      final summary = EditorialSummaryStruct(text: longText);
      expect(summary.text.length, equals(1000));
    });
  });
}
