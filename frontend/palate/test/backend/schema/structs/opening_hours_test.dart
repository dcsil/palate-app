import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/periods_struct.dart';
import 'package:palate/backend/schema/structs/regular_opening_hours_struct.dart';
import 'package:palate/backend/schema/structs/open_struct.dart';
import 'package:palate/backend/schema/structs/close_struct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('PeriodsStruct Tests', () {
    test('Constructor initializes fields correctly', () {
      final open = OpenStruct(day: 1, hour: 9, minute: 0);
      final close = CloseStruct(day: 1, hour: 17, minute: 0);
      final period = PeriodsStruct(open: open, close: close);
      
      expect(period.open.day, equals(1));
      expect(period.open.hour, equals(9));
      expect(period.close.hour, equals(17));
    });

    test('Default values when fields are null', () {
      final period = PeriodsStruct();
      
      expect(period.open, isA<OpenStruct>());
      expect(period.close, isA<CloseStruct>());
      expect(period.open.day, equals(0));
      expect(period.close.day, equals(0));
    });

    test('Setters modify field values', () {
      final period = PeriodsStruct();
      final newOpen = OpenStruct(day: 3, hour: 8, minute: 30);
      final newClose = CloseStruct(day: 3, hour: 18, minute: 30);
      
      period.open = newOpen;
      period.close = newClose;
      
      expect(period.open.day, equals(3));
      expect(period.open.hour, equals(8));
      expect(period.open.minute, equals(30));
      expect(period.close.hour, equals(18));
    });

    test('updateOpen callback modifies open struct', () {
      final period = PeriodsStruct(
        open: OpenStruct(day: 1, hour: 9, minute: 0),
      );
      
      period.updateOpen((open) {
        open.hour = 10;
        open.minute = 30;
      });
      
      expect(period.open.hour, equals(10));
      expect(period.open.minute, equals(30));
    });

    test('updateClose callback modifies close struct', () {
      final period = PeriodsStruct(
        close: CloseStruct(day: 1, hour: 17, minute: 0),
      );
      
      period.updateClose((close) {
        close.hour = 18;
        close.minute = 45;
      });
      
      expect(period.close.hour, equals(18));
      expect(period.close.minute, equals(45));
    });

    test('hasOpen returns correct null check', () {
      final withOpen = PeriodsStruct(open: OpenStruct(day: 1));
      final withoutOpen = PeriodsStruct();
      
      expect(withOpen.hasOpen(), isTrue);
      expect(withoutOpen.hasOpen(), isFalse);
    });

    test('hasClose returns correct null check', () {
      final withClose = PeriodsStruct(close: CloseStruct(day: 1));
      final withoutClose = PeriodsStruct();
      
      expect(withClose.hasClose(), isTrue);
      expect(withoutClose.hasClose(), isFalse);
    });

    test('fromMap creates instance from map with nested structs', () {
      final map = {
        'open': {'day': 2, 'hour': 10, 'minute': 0},
        'close': {'day': 2, 'hour': 22, 'minute': 30},
      };
      final period = PeriodsStruct.fromMap(map);
      
      expect(period.open.day, equals(2));
      expect(period.open.hour, equals(10));
      expect(period.close.day, equals(2));
      expect(period.close.minute, equals(30));
    });

    test('fromMap handles OpenStruct instances', () {
      final openStruct = OpenStruct(day: 5, hour: 7, minute: 30);
      final closeStruct = CloseStruct(day: 5, hour: 23, minute: 0);
      final map = {
        'open': openStruct,
        'close': closeStruct,
      };
      final period = PeriodsStruct.fromMap(map);
      
      expect(period.open.day, equals(5));
      expect(period.close.hour, equals(23));
    });

    test('maybeFromMap returns instance for valid map', () {
      final map = {
        'open': {'day': 4, 'hour': 11, 'minute': 0},
        'close': {'day': 4, 'hour': 19, 'minute': 0},
      };
      final period = PeriodsStruct.maybeFromMap(map);
      
      expect(period, isNotNull);
      expect(period!.open.day, equals(4));
    });

    test('maybeFromMap returns null for non-map', () {
      expect(PeriodsStruct.maybeFromMap('not a map'), isNull);
      expect(PeriodsStruct.maybeFromMap(123), isNull);
      expect(PeriodsStruct.maybeFromMap(null), isNull);
    });

    test('toMap converts to map correctly', () {
      final period = PeriodsStruct(
        open: OpenStruct(day: 1, hour: 8, minute: 0),
        close: CloseStruct(day: 1, hour: 16, minute: 30),
      );
      final map = period.toMap();
      
      expect(map['open'], isA<Map>());
      expect(map['close'], isA<Map>());
      expect(map['open']['day'], equals(1));
      expect(map['close']['minute'], equals(30));
    });

    test('toMap excludes null fields', () {
      final period = PeriodsStruct();
      final map = period.toMap();
      
      expect(map.containsKey('open'), isFalse);
      expect(map.containsKey('close'), isFalse);
    });

    test('toSerializableMap produces correct output', () {
      final period = PeriodsStruct(
        open: OpenStruct(day: 3, hour: 9, minute: 15),
        close: CloseStruct(day: 3, hour: 21, minute: 45),
      );
      final map = period.toSerializableMap();
      
      expect(map.containsKey('open'), isTrue);
      expect(map.containsKey('close'), isTrue);
    });

    test('toString returns readable representation', () {
      final period = PeriodsStruct(
        open: OpenStruct(day: 1),
        close: CloseStruct(day: 1),
      );
      final str = period.toString();
      
      expect(str, contains('PeriodsStruct'));
      expect(str, contains('open'));
      expect(str, contains('close'));
    });

    test('Equality works correctly', () {
      final period1 = PeriodsStruct(
        open: OpenStruct(day: 2, hour: 9, minute: 0),
        close: CloseStruct(day: 2, hour: 17, minute: 0),
      );
      final period2 = PeriodsStruct(
        open: OpenStruct(day: 2, hour: 9, minute: 0),
        close: CloseStruct(day: 2, hour: 17, minute: 0),
      );
      final period3 = PeriodsStruct(
        open: OpenStruct(day: 2, hour: 10, minute: 0),
        close: CloseStruct(day: 2, hour: 17, minute: 0),
      );
      
      expect(period1 == period2, isTrue);
      expect(period1 == period3, isFalse);
    });

    test('hashCode is consistent', () {
      final period1 = PeriodsStruct(
        open: OpenStruct(day: 1, hour: 8),
        close: CloseStruct(day: 1, hour: 20),
      );
      final period2 = PeriodsStruct(
        open: OpenStruct(day: 1, hour: 8),
        close: CloseStruct(day: 1, hour: 20),
      );
      
      expect(period1.hashCode, equals(period2.hashCode));
    });
  });

  group('RegularOpeningHoursStruct Tests', () {
    test('Constructor initializes all fields correctly', () {
      final periods = [
        PeriodsStruct(
          open: OpenStruct(day: 1, hour: 9),
          close: CloseStruct(day: 1, hour: 17),
        ),
      ];
      final descriptions = ['Monday: 9:00 AM – 5:00 PM'];
      
      final hours = RegularOpeningHoursStruct(
        nextOpenTime: '2024-01-15T09:00:00',
        openNow: true,
        periods: periods,
        weekdayDescriptions: descriptions,
      );
      
      expect(hours.nextOpenTime, equals('2024-01-15T09:00:00'));
      expect(hours.openNow, isTrue);
      expect(hours.periods.length, equals(1));
      expect(hours.weekdayDescriptions.length, equals(1));
    });

    test('Default values when fields are null', () {
      final hours = RegularOpeningHoursStruct();
      
      expect(hours.nextOpenTime, equals(''));
      expect(hours.openNow, isFalse);
      expect(hours.periods, equals([]));
      expect(hours.weekdayDescriptions, equals([]));
    });

    test('Setters modify field values', () {
      final hours = RegularOpeningHoursStruct();
      
      hours.nextOpenTime = '2024-02-01T10:00:00';
      hours.openNow = true;
      hours.periods = [PeriodsStruct()];
      hours.weekdayDescriptions = ['Test description'];
      
      expect(hours.nextOpenTime, equals('2024-02-01T10:00:00'));
      expect(hours.openNow, isTrue);
      expect(hours.periods.length, equals(1));
      expect(hours.weekdayDescriptions.first, equals('Test description'));
    });

    test('hasNextOpenTime returns correct null check', () {
      final withTime = RegularOpeningHoursStruct(nextOpenTime: '2024-01-01');
      final withoutTime = RegularOpeningHoursStruct();
      
      expect(withTime.hasNextOpenTime(), isTrue);
      expect(withoutTime.hasNextOpenTime(), isFalse);
    });

    test('hasOpenNow returns correct null check', () {
      final withOpenNow = RegularOpeningHoursStruct(openNow: false);
      final withoutOpenNow = RegularOpeningHoursStruct();
      
      expect(withOpenNow.hasOpenNow(), isTrue);
      expect(withoutOpenNow.hasOpenNow(), isFalse);
    });

    test('hasPeriods returns correct null check', () {
      final withPeriods = RegularOpeningHoursStruct(periods: []);
      final withoutPeriods = RegularOpeningHoursStruct();
      
      expect(withPeriods.hasPeriods(), isTrue);
      expect(withoutPeriods.hasPeriods(), isFalse);
    });

    test('hasWeekdayDescriptions returns correct null check', () {
      final withDesc = RegularOpeningHoursStruct(weekdayDescriptions: []);
      final withoutDesc = RegularOpeningHoursStruct();
      
      expect(withDesc.hasWeekdayDescriptions(), isTrue);
      expect(withoutDesc.hasWeekdayDescriptions(), isFalse);
    });

    test('updatePeriods callback modifies periods list', () {
      final hours = RegularOpeningHoursStruct(periods: []);
      
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
      
      expect(hours.periods.length, equals(2));
      expect(hours.periods[0].open.day, equals(1));
      expect(hours.periods[1].open.hour, equals(10));
    });

    test('updateWeekdayDescriptions callback modifies list', () {
      final hours = RegularOpeningHoursStruct(weekdayDescriptions: ['Monday']);
      
      hours.updateWeekdayDescriptions((list) {
        list.add('Tuesday: 10:00 AM – 6:00 PM');
        list.add('Wednesday: 9:00 AM – 5:00 PM');
      });
      
      expect(hours.weekdayDescriptions.length, equals(3));
      expect(hours.weekdayDescriptions[0], equals('Monday'));
      expect(hours.weekdayDescriptions[2], contains('Wednesday'));
    });

    test('fromMap creates instance from map', () {
      final map = {
        'nextOpenTime': '2024-03-01T08:00:00',
        'openNow': true,
        'periods': [
          {
            'open': {'day': 1, 'hour': 8, 'minute': 0},
            'close': {'day': 1, 'hour': 20, 'minute': 0},
          },
        ],
        'weekdayDescriptions': ['Mon-Fri: 8:00 AM – 8:00 PM'],
      };
      final hours = RegularOpeningHoursStruct.fromMap(map);
      
      expect(hours.nextOpenTime, equals('2024-03-01T08:00:00'));
      expect(hours.openNow, isTrue);
      expect(hours.periods.length, equals(1));
      expect(hours.periods.first.open.hour, equals(8));
      expect(hours.weekdayDescriptions.first, contains('8:00 AM'));
    });

    test('fromMap handles empty lists', () {
      final map = {
        'nextOpenTime': 'test',
        'openNow': false,
        'periods': <Map<String, dynamic>>[],
        'weekdayDescriptions': <String>[],
      };
      final hours = RegularOpeningHoursStruct.fromMap(map);
      
      expect(hours.periods, equals([]));
      expect(hours.weekdayDescriptions, equals([]));
    });

    test('fromMap handles missing fields', () {
      final map = <String, dynamic>{};
      final hours = RegularOpeningHoursStruct.fromMap(map);
      
      expect(hours.nextOpenTime, equals(''));
      expect(hours.openNow, isFalse);
      expect(hours.periods, equals([]));
      expect(hours.weekdayDescriptions, equals([]));
    });

    test('maybeFromMap returns instance for valid map', () {
      final map = {
        'nextOpenTime': '2024-04-01',
        'openNow': false,
      };
      final hours = RegularOpeningHoursStruct.maybeFromMap(map);
      
      expect(hours, isNotNull);
      expect(hours!.nextOpenTime, equals('2024-04-01'));
    });

    test('maybeFromMap returns null for non-map', () {
      expect(RegularOpeningHoursStruct.maybeFromMap('invalid'), isNull);
      expect(RegularOpeningHoursStruct.maybeFromMap(42), isNull);
      expect(RegularOpeningHoursStruct.maybeFromMap(null), isNull);
    });

    test('toMap converts to map correctly', () {
      final hours = RegularOpeningHoursStruct(
        nextOpenTime: '2024-05-01',
        openNow: true,
        periods: [
          PeriodsStruct(
            open: OpenStruct(day: 1),
            close: CloseStruct(day: 1),
          ),
        ],
        weekdayDescriptions: ['Monday: Open'],
      );
      final map = hours.toMap();
      
      expect(map['nextOpenTime'], equals('2024-05-01'));
      expect(map['openNow'], isTrue);
      expect(map['periods'], isA<List>());
      expect(map['weekdayDescriptions'], isA<List>());
      expect(map['periods'].length, equals(1));
    });

    test('toMap excludes null fields', () {
      final hours = RegularOpeningHoursStruct();
      final map = hours.toMap();
      
      expect(map.containsKey('nextOpenTime'), isFalse);
      expect(map.containsKey('openNow'), isFalse);
      expect(map.containsKey('periods'), isFalse);
      expect(map.containsKey('weekdayDescriptions'), isFalse);
    });

    test('toSerializableMap produces correct output', () {
      final hours = RegularOpeningHoursStruct(
        nextOpenTime: 'test-time',
        openNow: false,
        periods: [PeriodsStruct()],
        weekdayDescriptions: ['desc'],
      );
      final map = hours.toSerializableMap();
      
      expect(map.containsKey('nextOpenTime'), isTrue);
      expect(map.containsKey('openNow'), isTrue);
      expect(map.containsKey('periods'), isTrue);
      expect(map.containsKey('weekdayDescriptions'), isTrue);
    });

    test('toString returns readable representation', () {
      final hours = RegularOpeningHoursStruct(
        nextOpenTime: 'test',
        openNow: true,
      );
      final str = hours.toString();
      
      expect(str, contains('RegularOpeningHoursStruct'));
    });

    test('Equality works correctly', () {
      final hours1 = RegularOpeningHoursStruct(
        nextOpenTime: 'same',
        openNow: true,
        periods: [],
        weekdayDescriptions: ['Mon'],
      );
      final hours2 = RegularOpeningHoursStruct(
        nextOpenTime: 'same',
        openNow: true,
        periods: [],
        weekdayDescriptions: ['Mon'],
      );
      final hours3 = RegularOpeningHoursStruct(
        nextOpenTime: 'different',
        openNow: true,
        periods: [],
        weekdayDescriptions: ['Mon'],
      );
      
      expect(hours1 == hours2, isTrue);
      expect(hours1 == hours3, isFalse);
    });

    test('hashCode is consistent', () {
      final hours1 = RegularOpeningHoursStruct(
        nextOpenTime: 'test',
        openNow: false,
      );
      final hours2 = RegularOpeningHoursStruct(
        nextOpenTime: 'test',
        openNow: false,
      );
      
      expect(hours1.hashCode, equals(hours2.hashCode));
    });

    test('Multiple periods in list', () {
      final periods = List.generate(
        7,
        (i) => PeriodsStruct(
          open: OpenStruct(day: i, hour: 9),
          close: CloseStruct(day: i, hour: 17),
        ),
      );
      
      final hours = RegularOpeningHoursStruct(periods: periods);
      
      expect(hours.periods.length, equals(7));
      expect(hours.periods[3].open.day, equals(3));
      expect(hours.periods[6].open.day, equals(6));
    });

    test('All weekday descriptions', () {
      final descriptions = [
        'Monday: 9:00 AM – 5:00 PM',
        'Tuesday: 9:00 AM – 5:00 PM',
        'Wednesday: 9:00 AM – 5:00 PM',
        'Thursday: 9:00 AM – 5:00 PM',
        'Friday: 9:00 AM – 5:00 PM',
        'Saturday: 10:00 AM – 3:00 PM',
        'Sunday: Closed',
      ];
      
      final hours = RegularOpeningHoursStruct(
        weekdayDescriptions: descriptions,
      );
      
      expect(hours.weekdayDescriptions.length, equals(7));
      expect(hours.weekdayDescriptions.last, equals('Sunday: Closed'));
    });

    test('Open now is true', () {
      final hours = RegularOpeningHoursStruct(openNow: true);
      
      expect(hours.openNow, isTrue);
      expect(hours.hasOpenNow(), isTrue);
    });

    test('Open now is false', () {
      final hours = RegularOpeningHoursStruct(openNow: false);
      
      expect(hours.openNow, isFalse);
      expect(hours.hasOpenNow(), isTrue);
    });
  });

  group('PeriodsStruct Helper Functions', () {
    test('createPeriodsStruct creates struct', () {
      final struct = createPeriodsStruct();
      expect(struct, isNotNull);
    });

    test('createPeriodsStruct with flags', () {
      final struct = createPeriodsStruct(
        create: true,
        clearUnsetFields: false,
      );
      expect(struct.firestoreUtilData.create, isTrue);
      expect(struct.firestoreUtilData.clearUnsetFields, isFalse);
    });

    test('createPeriodsStruct with delete flag', () {
      final struct = createPeriodsStruct(delete: true);
      expect(struct.firestoreUtilData.delete, isTrue);
    });

    test('updatePeriodsStruct updates struct', () {
      final original = PeriodsStruct(
        open: OpenStruct(day: 1),
        close: CloseStruct(day: 1),
      );
      final updated = updatePeriodsStruct(
        original,
        clearUnsetFields: false,
      );
      expect(updated, isNotNull);
    });

    test('updatePeriodsStruct returns null for null', () {
      final updated = updatePeriodsStruct(null);
      expect(updated, isNull);
    });

    test('addPeriodsStructData handles null', () {
      final firestoreData = <String, dynamic>{};
      addPeriodsStructData(firestoreData, null, 'periods');
      expect(firestoreData.containsKey('periods'), isFalse);
    });

    test('addPeriodsStructData with delete flag', () {
      final struct = createPeriodsStruct(delete: true);
      final firestoreData = <String, dynamic>{};
      addPeriodsStructData(firestoreData, struct, 'periods');
      expect(firestoreData['periods'], isA<FieldValue>());
    });

    test('addPeriodsStructData with data', () {
      final struct = PeriodsStruct(
        open: OpenStruct(day: 1),
        close: CloseStruct(day: 1),
      );
      final firestoreData = <String, dynamic>{};
      addPeriodsStructData(firestoreData, struct, 'periods');
      expect(firestoreData, isNotEmpty);
    });

    test('getPeriodsFirestoreData returns empty for null', () {
      final data = getPeriodsFirestoreData(null);
      expect(data, isEmpty);
    });

    test('getPeriodsFirestoreData returns data', () {
      final struct = PeriodsStruct(
        open: OpenStruct(day: 2),
      );
      final data = getPeriodsFirestoreData(struct);
      expect(data, isNotEmpty);
    });

    test('getPeriodsListFirestoreData handles null', () {
      final listData = getPeriodsListFirestoreData(null);
      expect(listData, isEmpty);
    });

    test('getPeriodsListFirestoreData processes list', () {
      final structs = [
        PeriodsStruct(open: OpenStruct(day: 1)),
        PeriodsStruct(open: OpenStruct(day: 2)),
      ];
      final listData = getPeriodsListFirestoreData(structs);
      expect(listData, hasLength(2));
    });
  });

  group('OpenStruct Helper Functions', () {
    test('createOpenStruct creates struct', () {
      final struct = createOpenStruct();
      expect(struct, isNotNull);
    });

    test('createOpenStruct with flags', () {
      final struct = createOpenStruct(
        create: true,
        clearUnsetFields: false,
      );
      expect(struct.firestoreUtilData.create, isTrue);
    });

    test('updateOpenStruct updates struct', () {
      final original = OpenStruct(day: 1, hour: 9);
      final updated = updateOpenStruct(original, clearUnsetFields: false);
      expect(updated, isNotNull);
      expect(updated!.day, equals(1));
    });

    test('updateOpenStruct returns null for null', () {
      final updated = updateOpenStruct(null);
      expect(updated, isNull);
    });

    test('addOpenStructData handles null', () {
      final firestoreData = <String, dynamic>{};
      addOpenStructData(firestoreData, null, 'open');
      expect(firestoreData.containsKey('open'), isFalse);
    });

    test('addOpenStructData with delete flag', () {
      final struct = createOpenStruct(delete: true);
      final firestoreData = <String, dynamic>{};
      addOpenStructData(firestoreData, struct, 'open');
      expect(firestoreData['open'], isA<FieldValue>());
    });

    test('getOpenFirestoreData returns empty for null', () {
      final data = getOpenFirestoreData(null);
      expect(data, isEmpty);
    });

    test('getOpenFirestoreData returns data', () {
      final struct = OpenStruct(day: 1, hour: 9);
      final data = getOpenFirestoreData(struct);
      expect(data, isNotEmpty);
    });

    test('getOpenListFirestoreData handles null', () {
      final listData = getOpenListFirestoreData(null);
      expect(listData, isEmpty);
    });
  });

  group('CloseStruct Helper Functions', () {
    test('createCloseStruct creates struct', () {
      final struct = createCloseStruct();
      expect(struct, isNotNull);
    });

    test('createCloseStruct with flags', () {
      final struct = createCloseStruct(
        create: true,
        clearUnsetFields: false,
      );
      expect(struct.firestoreUtilData.create, isTrue);
    });

    test('updateCloseStruct updates struct', () {
      final original = CloseStruct(day: 1, hour: 17);
      final updated = updateCloseStruct(original, clearUnsetFields: false);
      expect(updated, isNotNull);
      expect(updated!.day, equals(1));
    });

    test('updateCloseStruct returns null for null', () {
      final updated = updateCloseStruct(null);
      expect(updated, isNull);
    });

    test('addCloseStructData handles null', () {
      final firestoreData = <String, dynamic>{};
      addCloseStructData(firestoreData, null, 'close');
      expect(firestoreData.containsKey('close'), isFalse);
    });

    test('addCloseStructData with delete flag', () {
      final struct = createCloseStruct(delete: true);
      final firestoreData = <String, dynamic>{};
      addCloseStructData(firestoreData, struct, 'close');
      expect(firestoreData['close'], isA<FieldValue>());
    });

    test('getCloseFirestoreData returns empty for null', () {
      final data = getCloseFirestoreData(null);
      expect(data, isEmpty);
    });

    test('getCloseFirestoreData returns data', () {
      final struct = CloseStruct(day: 1, hour: 17);
      final data = getCloseFirestoreData(struct);
      expect(data, isNotEmpty);
    });

    test('getCloseListFirestoreData handles null', () {
      final listData = getCloseListFirestoreData(null);
      expect(listData, isEmpty);
    });
  });

  group('RegularOpeningHoursStruct Helper Functions', () {
    test('createRegularOpeningHoursStruct creates struct', () {
      final struct = createRegularOpeningHoursStruct();
      expect(struct, isNotNull);
    });

    test('createRegularOpeningHoursStruct with flags', () {
      final struct = createRegularOpeningHoursStruct(
        create: true,
        clearUnsetFields: false,
      );
      expect(struct.firestoreUtilData.create, isTrue);
      expect(struct.firestoreUtilData.clearUnsetFields, isFalse);
    });

    test('updateRegularOpeningHoursStruct updates struct', () {
      final original = RegularOpeningHoursStruct(openNow: true);
      final updated = updateRegularOpeningHoursStruct(
        original,
        clearUnsetFields: false,
      );
      expect(updated, isNotNull);
      expect(updated!.openNow, isTrue);
    });

    test('updateRegularOpeningHoursStruct returns null for null', () {
      final updated = updateRegularOpeningHoursStruct(null);
      expect(updated, isNull);
    });

    test('addRegularOpeningHoursStructData handles null', () {
      final firestoreData = <String, dynamic>{};
      addRegularOpeningHoursStructData(firestoreData, null, 'hours');
      expect(firestoreData.containsKey('hours'), isFalse);
    });

    test('addRegularOpeningHoursStructData with delete flag', () {
      final struct = createRegularOpeningHoursStruct(delete: true);
      final firestoreData = <String, dynamic>{};
      addRegularOpeningHoursStructData(firestoreData, struct, 'hours');
      expect(firestoreData['hours'], isA<FieldValue>());
    });

    test('getRegularOpeningHoursFirestoreData returns empty for null', () {
      final data = getRegularOpeningHoursFirestoreData(null);
      expect(data, isEmpty);
    });

    test('getRegularOpeningHoursFirestoreData returns data', () {
      final struct = RegularOpeningHoursStruct(openNow: true);
      final data = getRegularOpeningHoursFirestoreData(struct);
      expect(data, isNotEmpty);
    });

    test('getRegularOpeningHoursListFirestoreData handles null', () {
      final listData = getRegularOpeningHoursListFirestoreData(null);
      expect(listData, isEmpty);
    });

    test('getRegularOpeningHoursListFirestoreData processes list', () {
      final structs = [
        RegularOpeningHoursStruct(openNow: true),
        RegularOpeningHoursStruct(openNow: false),
      ];
      final listData = getRegularOpeningHoursListFirestoreData(structs);
      expect(listData, hasLength(2));
    });
  });
}

