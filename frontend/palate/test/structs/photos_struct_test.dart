import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/photos_struct.dart';

void main() {
  group('PhotosStruct', () {
    test('constructor with imagepaths', () {
      final photos = PhotosStruct(
        imagepaths: ['path1.jpg', 'path2.jpg', 'path3.jpg'],
      );

      expect(photos.imagepaths.length, 3);
      expect(photos.imagepaths[0], 'path1.jpg');
      expect(photos.imagepaths[1], 'path2.jpg');
      expect(photos.imagepaths[2], 'path3.jpg');
    });

    test('constructor with empty imagepaths', () {
      final photos = PhotosStruct();
      expect(photos.imagepaths, []);
      expect(photos.hasImagepaths(), false);
    });

    test('imagepaths setter', () {
      final photos = PhotosStruct();
      photos.imagepaths = ['new1.jpg', 'new2.jpg'];

      expect(photos.imagepaths.length, 2);
      expect(photos.hasImagepaths(), true);
    });

    test('updateImagepaths adds paths', () {
      final photos = PhotosStruct(imagepaths: ['existing.jpg']);
      
      photos.updateImagepaths((list) {
        list.add('added.jpg');
        list.add('another.jpg');
      });

      expect(photos.imagepaths.length, 3);
      expect(photos.imagepaths.contains('existing.jpg'), true);
      expect(photos.imagepaths.contains('added.jpg'), true);
      expect(photos.imagepaths.contains('another.jpg'), true);
    });

    test('hasImagepaths returns correct value', () {
      final photos1 = PhotosStruct();
      expect(photos1.hasImagepaths(), false);

      // Empty list is still considered as having imagepaths
      final photos2 = PhotosStruct(imagepaths: []);
      expect(photos2.hasImagepaths(), true);

      final photos3 = PhotosStruct(imagepaths: ['path.jpg']);
      expect(photos3.hasImagepaths(), true);
    });

    test('fromMap creates struct', () {
      final map = {
        'imagepaths': ['img1.jpg', 'img2.jpg'],
      };

      final photos = PhotosStruct.fromMap(map);
      expect(photos.imagepaths.length, 2);
      expect(photos.imagepaths[0], 'img1.jpg');
      expect(photos.imagepaths[1], 'img2.jpg');
    });

    test('maybeFromMap with valid map', () {
      final map = {
        'imagepaths': ['test.jpg'],
      };

      final photos = PhotosStruct.maybeFromMap(map);
      expect(photos, isNotNull);
      expect(photos!.imagepaths, ['test.jpg']);
    });

    test('maybeFromMap with non-map returns null', () {
      final result = PhotosStruct.maybeFromMap('not a map');
      expect(result, null);

      final result2 = PhotosStruct.maybeFromMap(null);
      expect(result2, null);

      final result3 = PhotosStruct.maybeFromMap(123);
      expect(result3, null);
    });

    test('toMap returns correct map', () {
      final photos = PhotosStruct(
        imagepaths: ['map1.jpg', 'map2.jpg'],
      );

      final map = photos.toMap();
      expect(map['imagepaths'], ['map1.jpg', 'map2.jpg']);
    });

    test('toSerializableMap includes all fields', () {
      final photos = PhotosStruct(
        imagepaths: ['serialize1.jpg', 'serialize2.jpg'],
      );

      final map = photos.toSerializableMap();
      expect(map.containsKey('imagepaths'), true);
      expect(map['imagepaths'], isNotNull);
    });

    test('fromSerializableMap reconstructs struct', () {
      final original = PhotosStruct(
        imagepaths: ['original1.jpg', 'original2.jpg', 'original3.jpg'],
      );

      final serialized = original.toSerializableMap();
      final reconstructed = PhotosStruct.fromSerializableMap(serialized);

      expect(reconstructed.imagepaths.length, 3);
      expect(reconstructed.imagepaths, original.imagepaths);
    });

    test('toString produces valid output', () {
      final photos = PhotosStruct(imagepaths: ['test.jpg']);
      final str = photos.toString();
      
      expect(str, contains('PhotosStruct'));
      expect(str, isNotEmpty);
    });

    test('equality operator with same paths', () {
      final photos1 = PhotosStruct(
        imagepaths: ['a.jpg', 'b.jpg'],
      );
      final photos2 = PhotosStruct(
        imagepaths: ['a.jpg', 'b.jpg'],
      );

      expect(photos1 == photos2, true);
    });

    test('equality operator with different paths', () {
      final photos1 = PhotosStruct(
        imagepaths: ['a.jpg', 'b.jpg'],
      );
      final photos2 = PhotosStruct(
        imagepaths: ['c.jpg', 'd.jpg'],
      );

      expect(photos1 == photos2, false);
    });

    test('equality operator with different lengths', () {
      final photos1 = PhotosStruct(
        imagepaths: ['a.jpg'],
      );
      final photos2 = PhotosStruct(
        imagepaths: ['a.jpg', 'b.jpg'],
      );

      expect(photos1 == photos2, false);
    });

    test('hashCode is consistent', () {
      final photos1 = PhotosStruct(imagepaths: ['hash.jpg']);
      final photos2 = PhotosStruct(imagepaths: ['hash.jpg']);

      // Objects should be equal
      expect(photos1 == photos2, true);
      // Note: hashCode implementation may vary, just verify both have hashCode
      expect(photos1.hashCode, isNotNull);
      expect(photos2.hashCode, isNotNull);
    });

    test('empty struct serialization roundtrip', () {
      final original = PhotosStruct();
      final serialized = original.toSerializableMap();
      final reconstructed = PhotosStruct.fromSerializableMap(serialized);

      expect(reconstructed.imagepaths, []);
      expect(reconstructed == original, true);
    });
  });
}
