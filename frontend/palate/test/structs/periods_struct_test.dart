import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/periods_struct.dart';
import 'package:palate/backend/schema/structs/open_struct.dart';
import 'package:palate/backend/schema/structs/close_struct.dart';

void main() {
  group('PeriodsStruct', () {
    test('constructor with parameters', () {
      final open = OpenStruct(day: 1, hour: 9, minute: 0);
      final close = CloseStruct(day: 1, hour: 17, minute: 0);
      final period = PeriodsStruct(open: open, close: close);

      expect(period.open.day, 1);
      expect(period.open.hour, 9);
      expect(period.close.hour, 17);
    });

    test('default values', () {
      final period = PeriodsStruct();
      expect(period.open.day, 0);
      expect(period.close.day, 0);
    });

    test('has methods', () {
      final period = PeriodsStruct();
      expect(period.hasOpen(), false);
      expect(period.hasClose(), false);

      period.open = OpenStruct(day: 1);
      period.close = CloseStruct(day: 1);
      expect(period.hasOpen(), true);
      expect(period.hasClose(), true);
    });

    test('updateOpen', () {
      final period = PeriodsStruct();
      period.updateOpen((open) {
        open.day = 3;
        open.hour = 10;
      });
      expect(period.open.day, 3);
      expect(period.open.hour, 10);
    });

    test('updateClose', () {
      final period = PeriodsStruct();
      period.updateClose((close) {
        close.day = 4;
        close.hour = 22;
      });
      expect(period.close.day, 4);
      expect(period.close.hour, 22);
    });

    test('fromMap', () {
      final data = {
        'open': {'day': 1, 'hour': 8, 'minute': 30},
        'close': {'day': 1, 'hour': 20, 'minute': 0},
      };
      final period = PeriodsStruct.fromMap(data);
      expect(period.open.day, 1);
      expect(period.open.hour, 8);
      expect(period.close.hour, 20);
    });

    test('maybeFromMap', () {
      final data = {
        'open': {'day': 2, 'hour': 9},
        'close': {'day': 2, 'hour': 21},
      };
      final period = PeriodsStruct.maybeFromMap(data);
      expect(period, isNotNull);
      expect(period!.open.day, 2);
    });

    test('maybeFromMap with invalid data', () {
      expect(PeriodsStruct.maybeFromMap(null), null);
      expect(PeriodsStruct.maybeFromMap('string'), null);
    });

    test('toMap', () {
      final period = PeriodsStruct(
        open: OpenStruct(day: 1, hour: 9),
        close: CloseStruct(day: 1, hour: 22),
      );
      final data = period.toMap();
      expect(data['open'], isNotNull);
      expect(data['close'], isNotNull);
    });

    test('serialization roundtrip', () {
      final original = PeriodsStruct(
        open: OpenStruct(day: 3, hour: 11, minute: 30),
        close: CloseStruct(day: 3, hour: 23, minute: 0),
      );
      final serialized = original.toSerializableMap();
      final reconstructed = PeriodsStruct.fromSerializableMap(serialized);
      expect(reconstructed.open.day, original.open.day);
      expect(reconstructed.close.hour, original.close.hour);
    });

    test('equality', () {
      final p1 = PeriodsStruct(
        open: OpenStruct(day: 1, hour: 9),
        close: CloseStruct(day: 1, hour: 17),
      );
      final p2 = PeriodsStruct(
        open: OpenStruct(day: 1, hour: 9),
        close: CloseStruct(day: 1, hour: 17),
      );
      expect(p1 == p2, true);
    });

    test('toString', () {
      final period = PeriodsStruct();
      expect(period.toString(), contains('PeriodsStruct'));
    });
  });
}
