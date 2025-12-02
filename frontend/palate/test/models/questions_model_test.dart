import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palate/pages/questions/questions_model.dart';

void main() {
  group('QuestionsModel', () {
    late QuestionsModel model;

    setUp(() {
      model = QuestionsModel();
    });

    test('initial answers state', () {
      expect(model.answers, [0, 0, 0, 0, 0, 0, 0, 0]);
      expect(model.answers.length, 8);
    });

    test('addToAnswers appends value', () {
      final initialLength = model.answers.length;
      model.addToAnswers(5);
      expect(model.answers.length, initialLength + 1);
      expect(model.answers.last, 5);
    });

    test('removeFromAnswers removes value', () {
      model.answers = [1, 2, 3, 2, 4];
      model.removeFromAnswers(2);
      expect(model.answers, [1, 3, 2, 4]);
    });

    test('removeAtIndexFromAnswers removes at index', () {
      model.answers = [1, 2, 3, 4];
      model.removeAtIndexFromAnswers(1);
      expect(model.answers, [1, 3, 4]);
    });

    test('insertAtIndexInAnswers inserts value', () {
      model.answers = [1, 3, 4];
      model.insertAtIndexInAnswers(1, 2);
      expect(model.answers, [1, 2, 3, 4]);
    });

    test('updateAnswersAtIndex updates value', () {
      model.answers = [1, 2, 3];
      model.updateAnswersAtIndex(1, (val) => val * 10);
      expect(model.answers, [1, 20, 3]);
    });

    test('updateAnswersAtIndex with replacement', () {
      model.answers = [0, 0, 0, 0, 0, 0, 0, 0];
      model.updateAnswersAtIndex(0, (_) => 1);
      model.updateAnswersAtIndex(1, (_) => 2);
      model.updateAnswersAtIndex(2, (_) => 3);
      
      expect(model.answers[0], 1);
      expect(model.answers[1], 2);
      expect(model.answers[2], 3);
    });

    test('initState does not throw', () {
      expect(() => model.initState(MockBuildContext()), returnsNormally);
    });

    test('dispose does not throw', () {
      expect(() => model.dispose(), returnsNormally);
    });

    test('answers can be fully replaced', () {
      model.answers = [1, 2, 3, 4, 5, 6, 7, 8];
      expect(model.answers.length, 8);
      expect(model.answers.first, 1);
      expect(model.answers.last, 8);
    });

    test('pageViewCurrentIndex returns 0 when controller is null', () {
      expect(model.pageViewController, null);
      expect(model.pageViewCurrentIndex, 0);
    });
  });
}

class MockBuildContext extends Fake implements BuildContext {}
