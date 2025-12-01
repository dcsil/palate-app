import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palate/components/carousel_model.dart';

void main() {
  group('CarouselModel', () {
    late CarouselModel model;

    setUp(() {
      model = CarouselModel();
    });

    test('initial state has null pageViewController', () {
      expect(model.pageViewController, null);
    });

    test('pageViewCurrentIndex returns 0 when controller is null', () {
      expect(model.pageViewCurrentIndex, 0);
    });

    test('initState does not throw', () {
      expect(() => model.initState(MockBuildContext()), returnsNormally);
    });

    test('dispose does not throw', () {
      expect(() => model.dispose(), returnsNormally);
    });

    test('pageViewController can be assigned', () {
      final controller = PageController();
      model.pageViewController = controller;
      expect(model.pageViewController, isNotNull);
      expect(model.pageViewController, controller);
      controller.dispose();
    });
  });
}

class MockBuildContext extends Fake implements BuildContext {}
