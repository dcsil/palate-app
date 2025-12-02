import 'package:flutter_test/flutter_test.dart';
import 'package:palate/flutter_flow/form_field_controller.dart';

void main() {
  group('FormFieldController', () {
    test('initializes with initial value', () {
      final controller = FormFieldController<String>('initial');
      expect(controller.value, 'initial');
      expect(controller.initialValue, 'initial');
    });

    test('initializes with null', () {
      final controller = FormFieldController<String>(null);
      expect(controller.value, isNull);
      expect(controller.initialValue, isNull);
    });

    test('value can be updated', () {
      final controller = FormFieldController<int>(10);
      expect(controller.value, 10);
      
      controller.value = 20;
      expect(controller.value, 20);
    });

    test('reset() restores initial value', () {
      final controller = FormFieldController<String>('start');
      controller.value = 'modified';
      expect(controller.value, 'modified');
      
      controller.reset();
      expect(controller.value, 'start');
    });

    test('reset() restores null when initial was null', () {
      final controller = FormFieldController<String>(null);
      controller.value = 'something';
      expect(controller.value, 'something');
      
      controller.reset();
      expect(controller.value, isNull);
    });

    test('update() triggers notifyListeners', () {
      final controller = FormFieldController<String>('value');
      var notified = false;
      
      controller.addListener(() {
        notified = true;
      });
      
      controller.update();
      expect(notified, isTrue);
    });

    test('value change triggers listeners', () {
      final controller = FormFieldController<int>(5);
      var notificationCount = 0;
      
      controller.addListener(() {
        notificationCount++;
      });
      
      controller.value = 10;
      expect(notificationCount, 1);
      
      controller.value = 15;
      expect(notificationCount, 2);
    });
  });

  group('FormListFieldController', () {
    test('initializes with list copy', () {
      final initialList = ['a', 'b', 'c'];
      final controller = FormListFieldController<String>(initialList);
      
      expect(controller.value, ['a', 'b', 'c']);
      expect(controller.initialValue, ['a', 'b', 'c']);
      // Note: The value is the same reference as initialValue from parent constructor
      // but _initialListValue is a separate copy
    });

    test('initializes with null', () {
      final controller = FormListFieldController<String>(null);
      expect(controller.value, isNull);
      expect(controller.initialValue, isNull);
    });

    test('initializes with empty list', () {
      final controller = FormListFieldController<int>([]);
      expect(controller.value, isEmpty);
    });

    test('list modifications affect the controller value', () {
      final initialList = ['x', 'y'];
      final controller = FormListFieldController<String>(initialList);
      
      // Modify the initial list (affects controller since same reference)
      initialList.add('z');
      expect(controller.value, ['x', 'y', 'z']);
      expect(initialList, ['x', 'y', 'z']);
    });

    test('reset() creates new list copy from initial', () {
      final controller = FormListFieldController<String>(['a', 'b']);
      
      // Modify the list
      controller.value?.add('c');
      expect(controller.value, ['a', 'b', 'c']);
      
      // Reset should restore to initial (from the internal copy)
      controller.reset();
      expect(controller.value, ['a', 'b']);
      
      // Further modifications should not affect reset
      controller.value?.add('d');
      expect(controller.value, ['a', 'b', 'd']);
      
      controller.reset();
      expect(controller.value, ['a', 'b']);
    });

    test('reset() with null initial value', () {
      final controller = FormListFieldController<int>(null);
      controller.value = [1, 2, 3];
      expect(controller.value, [1, 2, 3]);
      
      controller.reset();
      expect(controller.value, isEmpty);
    });

    test('reset() creates independent copies', () {
      final controller = FormListFieldController<String>(['first']);
      
      controller.reset();
      final firstReset = controller.value;
      firstReset?.add('modified');
      
      controller.reset();
      final secondReset = controller.value;
      
      // Second reset should not have the modification from first reset
      expect(secondReset, ['first']);
      expect(firstReset, ['first', 'modified']);
      expect(identical(firstReset, secondReset), isFalse);
    });

    test('update() triggers notifyListeners for list controller', () {
      final controller = FormListFieldController<String>(['value']);
      var notified = false;
      
      controller.addListener(() {
        notified = true;
      });
      
      controller.update();
      expect(notified, isTrue);
    });
  });
}
