import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/regular_opening_hours_struct.dart';
import 'package:palate/backend/schema/structs/periods_struct.dart';
import 'package:palate/backend/schema/structs/open_struct.dart';
import 'package:palate/backend/schema/structs/close_struct.dart';

void main() {
  group('RegularOpeningHoursStruct', () {
    test('constructor with all parameters', () {
      final period1 = PeriodsStruct(
        open: OpenStruct(day: 1, hour: 9),
        close: CloseStruct(day: 1, hour: 17),
      );
      
      final hours = RegularOpeningHoursStruct(
        nextOpenTime: '2024-01-01T09:00:00',
        openNow: true,
        periods: [period1],
        weekdayDescriptions: ['Monday: 9:00 AM – 5:00 PM'],
      );

      expect(hours.nextOpenTime, '2024-01-01T09:00:00');
      expect(hours.openNow, true);
      expect(hours.periods.length, 1);
      expect(hours.weekdayDescriptions.length, 1);
    });

    test('default values', () {
      final hours = RegularOpeningHoursStruct();
      expect(hours.nextOpenTime, '');
      expect(hours.openNow, false);
      expect(hours.periods, []);
      expect(hours.weekdayDescriptions, []);
    });

    test('nextOpenTime setter and has method', () {
      final hours = RegularOpeningHoursStruct();
      expect(hours.hasNextOpenTime(), false);

      hours.nextOpenTime = '2024-12-25T10:00:00';
      expect(hours.nextOpenTime, '2024-12-25T10:00:00');
      expect(hours.hasNextOpenTime(), true);
    });

    test('openNow setter and has method', () {
      final hours = RegularOpeningHoursStruct();
      expect(hours.hasOpenNow(), false);

      hours.openNow = true;
      expect(hours.openNow, true);
      expect(hours.hasOpenNow(), true);

      hours.openNow = false;
      expect(hours.openNow, false);
    });

    test('periods list operations', () {
      final hours = RegularOpeningHoursStruct();
      expect(hours.hasPeriods(), false);

      final period1 = PeriodsStruct(
        open: OpenStruct(day: 1, hour: 9),
        close: CloseStruct(day: 1, hour: 17),
      );
      final period2 = PeriodsStruct(
        open: OpenStruct(day: 2, hour: 9),
        close: CloseStruct(day: 2, hour: 17),
      );

      hours.periods = [period1, period2];
      expect(hours.hasPeriods(), true);
      expect(hours.periods.length, 2);
    });

    test('updatePeriods adds new periods', () {
      final hours = RegularOpeningHoursStruct();
      
      hours.updatePeriods((list) {
        list.add(PeriodsStruct(
          open: OpenStruct(day: 1, hour: 9),
          close: CloseStruct(day: 1, hour: 17),
        ));
        list.add(PeriodsStruct(
          open: OpenStruct(day: 2, hour: 10),
          close: CloseStruct(day: 2, hour: 18),
        ));
      });

      expect(hours.periods.length, 2);
      expect(hours.periods[0].open.day, 1);
      expect(hours.periods[1].open.hour, 10);
    });

    test('weekdayDescriptions operations', () {
      final hours = RegularOpeningHoursStruct();
      expect(hours.hasWeekdayDescriptions(), false);

      hours.weekdayDescriptions = [
        'Monday: 9:00 AM – 5:00 PM',
        'Tuesday: 9:00 AM – 5:00 PM',
        'Wednesday: 9:00 AM – 5:00 PM',
      ];

      expect(hours.hasWeekdayDescriptions(), true);
      expect(hours.weekdayDescriptions.length, 3);
      expect(hours.weekdayDescriptions[0], 'Monday: 9:00 AM – 5:00 PM');
    });

    test('updateWeekdayDescriptions adds descriptions', () {
      final hours = RegularOpeningHoursStruct();
      
      hours.updateWeekdayDescriptions((list) {
        list.add('Monday: 9:00 AM – 9:00 PM');
        list.add('Tuesday: 9:00 AM – 9:00 PM');
      });

      expect(hours.weekdayDescriptions.length, 2);
      expect(hours.weekdayDescriptions[1], 'Tuesday: 9:00 AM – 9:00 PM');
    });

    test('fromMap creates struct', () {
      final data = {
        'nextOpenTime': '2024-01-15T08:00:00',
        'openNow': true,
        'periods': [
          {
            'open': {'day': 1, 'hour': 9, 'minute': 0},
            'close': {'day': 1, 'hour': 17, 'minute': 0},
          }
        ],
        'weekdayDescriptions': ['Mon: 9 AM - 5 PM'],
      };

      final hours = RegularOpeningHoursStruct.fromMap(data);
      expect(hours.nextOpenTime, '2024-01-15T08:00:00');
      expect(hours.openNow, true);
      expect(hours.periods.length, 1);
      expect(hours.weekdayDescriptions.length, 1);
    });

    test('maybeFromMap with valid map', () {
      final data = {
        'openNow': false,
        'nextOpenTime': 'tomorrow',
      };
      final hours = RegularOpeningHoursStruct.maybeFromMap(data);
      
      expect(hours, isNotNull);
      expect(hours!.openNow, false);
      expect(hours.nextOpenTime, 'tomorrow');
    });

    test('maybeFromMap with invalid data', () {
      expect(RegularOpeningHoursStruct.maybeFromMap(null), null);
      expect(RegularOpeningHoursStruct.maybeFromMap('string'), null);
      expect(RegularOpeningHoursStruct.maybeFromMap(123), null);
    });

    test('toMap returns correct structure', () {
      final period = PeriodsStruct(
        open: OpenStruct(day: 3, hour: 11),
        close: CloseStruct(day: 3, hour: 20),
      );
      
      final hours = RegularOpeningHoursStruct(
        nextOpenTime: '2024-06-01T11:00:00',
        openNow: true,
        periods: [period],
        weekdayDescriptions: ['Wed: 11 AM - 8 PM'],
      );

      final map = hours.toMap();
      expect(map['nextOpenTime'], '2024-06-01T11:00:00');
      expect(map['openNow'], true);
      expect(map['periods'], isNotNull);
      expect(map['weekdayDescriptions'], isNotNull);
    });

    test('serialization roundtrip', () {
      final original = RegularOpeningHoursStruct(
        nextOpenTime: '2024-12-31T23:59:59',
        openNow: false,
        periods: [
          PeriodsStruct(
            open: OpenStruct(day: 5, hour: 18),
            close: CloseStruct(day: 5, hour: 23),
          ),
        ],
        weekdayDescriptions: ['Friday: 6:00 PM – 11:00 PM'],
      );

      final serialized = original.toSerializableMap();
      final reconstructed = RegularOpeningHoursStruct.fromSerializableMap(serialized);

      expect(reconstructed.nextOpenTime, original.nextOpenTime);
      expect(reconstructed.openNow, original.openNow);
      expect(reconstructed.periods.length, original.periods.length);
      expect(reconstructed.weekdayDescriptions.length, original.weekdayDescriptions.length);
    });

    test('equality operator', () {
      final hours1 = RegularOpeningHoursStruct(
        openNow: true,
        nextOpenTime: 'now',
      );
      final hours2 = RegularOpeningHoursStruct(
        openNow: true,
        nextOpenTime: 'now',
      );
      final hours3 = RegularOpeningHoursStruct(
        openNow: false,
        nextOpenTime: 'later',
      );

      expect(hours1 == hours2, true);
      expect(hours1 == hours3, false);
    });

    test('toString produces valid output', () {
      final hours = RegularOpeningHoursStruct(openNow: true);
      final str = hours.toString();
      expect(str, contains('RegularOpeningHoursStruct'));
    });

    test('multiple periods handling', () {
      final hours = RegularOpeningHoursStruct();
      
      hours.updatePeriods((list) {
        for (int day = 1; day <= 5; day++) {
          list.add(PeriodsStruct(
            open: OpenStruct(day: day, hour: 9, minute: 0),
            close: CloseStruct(day: day, hour: 17, minute: 30),
          ));
        }
      });

      expect(hours.periods.length, 5);
      expect(hours.periods[0].open.day, 1);
      expect(hours.periods[4].open.day, 5);
      expect(hours.periods[2].close.hour, 17);
    });

    test('empty struct serialization', () {
      final empty = RegularOpeningHoursStruct();
      final serialized = empty.toSerializableMap();
      final reconstructed = RegularOpeningHoursStruct.fromSerializableMap(serialized);

      expect(reconstructed.openNow, false);
      expect(reconstructed.nextOpenTime, '');
      expect(reconstructed.periods, []);
    });
  });
}
