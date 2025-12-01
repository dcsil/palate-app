import 'package:flutter_test/flutter_test.dart';
import 'package:palate/pages/home_page/home_page_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  group('HomePageModel', () {
    late HomePageModel model;

    setUp(() {
      model = HomePageModel();
    });

    test('initial state values', () {
      expect(model.isLoaded, false);
      expect(model.resDocRefs, []);
      expect(model.currentBatch, 0);
      expect(model.placeIDs, []);
    });

    test('isLoaded can be set', () {
      model.isLoaded = true;
      expect(model.isLoaded, true);

      model.isLoaded = false;
      expect(model.isLoaded, false);
    });

    test('currentBatch can be incremented', () {
      expect(model.currentBatch, 0);
      model.currentBatch = 1;
      expect(model.currentBatch, 1);
      model.currentBatch++;
      expect(model.currentBatch, 2);
    });

    test('resDocRefs add operation', () {
      final fakeFirestore = FakeFirebaseFirestore();
      final docRef = fakeFirestore.collection('test').doc('doc1');
      
      model.addToResDocRefs(docRef);
      expect(model.resDocRefs.length, 1);
      expect(model.resDocRefs[0], docRef);
    });

    test('resDocRefs multiple add operations', () {
      final fakeFirestore = FakeFirebaseFirestore();
      final docRef1 = fakeFirestore.collection('test').doc('doc1');
      final docRef2 = fakeFirestore.collection('test').doc('doc2');
      
      model.addToResDocRefs(docRef1);
      model.addToResDocRefs(docRef2);
      expect(model.resDocRefs.length, 2);
    });

    test('resDocRefs remove operation', () {
      final fakeFirestore = FakeFirebaseFirestore();
      final docRef1 = fakeFirestore.collection('test').doc('doc1');
      final docRef2 = fakeFirestore.collection('test').doc('doc2');
      
      model.addToResDocRefs(docRef1);
      model.addToResDocRefs(docRef2);
      model.removeFromResDocRefs(docRef1);
      
      expect(model.resDocRefs.length, 1);
      expect(model.resDocRefs[0], docRef2);
    });

    test('resDocRefs removeAtIndex', () {
      final fakeFirestore = FakeFirebaseFirestore();
      final docRef1 = fakeFirestore.collection('test').doc('doc1');
      final docRef2 = fakeFirestore.collection('test').doc('doc2');
      final docRef3 = fakeFirestore.collection('test').doc('doc3');
      
      model.addToResDocRefs(docRef1);
      model.addToResDocRefs(docRef2);
      model.addToResDocRefs(docRef3);
      
      model.removeAtIndexFromResDocRefs(1);
      expect(model.resDocRefs.length, 2);
      expect(model.resDocRefs[0], docRef1);
      expect(model.resDocRefs[1], docRef3);
    });

    test('resDocRefs insertAtIndex', () {
      final fakeFirestore = FakeFirebaseFirestore();
      final docRef1 = fakeFirestore.collection('test').doc('doc1');
      final docRef2 = fakeFirestore.collection('test').doc('doc2');
      final docRef3 = fakeFirestore.collection('test').doc('doc3');
      
      model.addToResDocRefs(docRef1);
      model.addToResDocRefs(docRef3);
      model.insertAtIndexInResDocRefs(1, docRef2);
      
      expect(model.resDocRefs.length, 3);
      expect(model.resDocRefs[1], docRef2);
    });

    test('resDocRefs updateAtIndex', () {
      final fakeFirestore = FakeFirebaseFirestore();
      final docRef1 = fakeFirestore.collection('test').doc('doc1');
      final docRef2 = fakeFirestore.collection('test').doc('doc2');
      
      model.addToResDocRefs(docRef1);
      model.updateResDocRefsAtIndex(0, (ref) => docRef2);
      
      expect(model.resDocRefs[0], docRef2);
    });

    test('placeIDs add operation', () {
      model.addToPlaceIDs('place_id_1');
      expect(model.placeIDs.length, 1);
      expect(model.placeIDs[0], 'place_id_1');
    });

    test('placeIDs multiple operations', () {
      model.addToPlaceIDs('id1');
      model.addToPlaceIDs('id2');
      model.addToPlaceIDs('id3');
      expect(model.placeIDs.length, 3);
      
      model.removeFromPlaceIDs('id2');
      expect(model.placeIDs, ['id1', 'id3']);
    });

    test('placeIDs removeAtIndex', () {
      model.placeIDs = ['a', 'b', 'c'];
      model.removeAtIndexFromPlaceIDs(1);
      expect(model.placeIDs, ['a', 'c']);
    });

    test('placeIDs insertAtIndex', () {
      model.placeIDs = ['first', 'third'];
      model.insertAtIndexInPlaceIDs(1, 'second');
      expect(model.placeIDs, ['first', 'second', 'third']);
    });

    test('placeIDs updateAtIndex', () {
      model.placeIDs = ['old'];
      model.updatePlaceIDsAtIndex(0, (id) => 'new');
      expect(model.placeIDs[0], 'new');
    });

    test('initState does not throw', () {
      // Model can be created without errors
      expect(model.isLoaded, false);
    });
  });
}
