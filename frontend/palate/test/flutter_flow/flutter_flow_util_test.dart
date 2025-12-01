import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palate/flutter_flow/flutter_flow_util.dart';

void main() {
  group('valueOrDefault', () {
    test('should return value when value is not null and not empty', () {
      expect(valueOrDefault('test', 'default'), equals('test'));
      expect(valueOrDefault(42, 0), equals(42));
      expect(valueOrDefault(true, false), equals(true));
    });

    test('should return default when value is null', () {
      expect(valueOrDefault<String>(null, 'default'), equals('default'));
      expect(valueOrDefault<int>(null, 0), equals(0));
      expect(valueOrDefault<bool>(null, false), equals(false));
    });

    test('should return default when string value is empty', () {
      expect(valueOrDefault('', 'default'), equals('default'));
    });

    test('should return value when non-string value is provided', () {
      expect(valueOrDefault(0, 42), equals(0));
      expect(valueOrDefault(false, true), equals(false));
    });
  });

  group('dateTimeFormat', () {
    test('should return empty string for null dateTime', () {
      expect(dateTimeFormat('yyyy-MM-dd', null), equals(''));
    });

    test('should format date with standard format', () {
      final dateTime = DateTime(2024, 1, 15, 14, 30, 0);
      final result = dateTimeFormat('yyyy-MM-dd', dateTime);
      expect(result, equals('2024-01-15'));
    });

    test('should format time with HH:mm format', () {
      final dateTime = DateTime(2024, 1, 15, 14, 30, 0);
      final result = dateTimeFormat('HH:mm', dateTime);
      expect(result, equals('14:30'));
    });

    test('should format date and time together', () {
      final dateTime = DateTime(2024, 1, 15, 14, 30, 0);
      final result = dateTimeFormat('yyyy-MM-dd HH:mm', dateTime);
      expect(result, equals('2024-01-15 14:30'));
    });

    test('should format with custom pattern', () {
      final dateTime = DateTime(2024, 1, 15, 14, 30, 0);
      final result = dateTimeFormat('MMM dd, yyyy', dateTime);
      expect(result, equals('Jan 15, 2024'));
    });

    test('should handle relative format', () {
      final dateTime = DateTime.now().subtract(Duration(minutes: 5));
      final result = dateTimeFormat('relative', dateTime);
      expect(result, contains('ago'));
    });

    test('should handle day of week format', () {
      final dateTime = DateTime(2024, 1, 15); // Monday
      final result = dateTimeFormat('EEEE', dateTime);
      expect(result, equals('Monday'));
    });
  });

  group('colorFromCssString', () {
    test('should parse hex color', () {
      final result = colorFromCssString('#FF0000');
      expect(result, isA<Color>());
      expect(result, equals(Color(0xFFFF0000)));
    });

    test('should parse short hex color', () {
      final result = colorFromCssString('#F00');
      expect(result, isA<Color>());
    });

    test('should parse rgb color', () {
      final result = colorFromCssString('rgb(255, 0, 0)');
      expect(result, isA<Color>());
    });

    test('should parse rgba color', () {
      final result = colorFromCssString('rgba(255, 0, 0, 0.5)');
      expect(result, isA<Color>());
    });

    test('should return black for invalid color by default', () {
      final result = colorFromCssString('not-a-color');
      expect(result, equals(Colors.black));
    });

    test('should return custom default color for invalid color', () {
      final result = colorFromCssString('not-a-color', defaultColor: Colors.blue);
      expect(result, equals(Colors.blue));
    });

    test('should handle empty string with default', () {
      final result = colorFromCssString('', defaultColor: Colors.red);
      expect(result, equals(Colors.red));
    });
  });

  group('formatNumber', () {
    test('should return empty string for null value', () {
      expect(formatNumber(null, formatType: FormatType.decimal), equals(''));
    });

    test('should format decimal with automatic type', () {
      final result = formatNumber(
        1234.56,
        formatType: FormatType.decimal,
        decimalType: DecimalType.automatic,
      );
      expect(result, isNotEmpty);
      expect(result, contains('1'));
    });

    test('should format decimal with period decimal type', () {
      final result = formatNumber(
        1234.56,
        formatType: FormatType.decimal,
        decimalType: DecimalType.periodDecimal,
      );
      expect(result, isNotEmpty);
    });

    test('should format decimal with comma decimal type', () {
      final result = formatNumber(
        1234.56,
        formatType: FormatType.decimal,
        decimalType: DecimalType.commaDecimal,
      );
      expect(result, isNotEmpty);
    });

    test('should format percent', () {
      final result = formatNumber(
        0.75,
        formatType: FormatType.percent,
      );
      expect(result, contains('%'));
    });

    test('should format scientific notation', () {
      final result = formatNumber(
        1234567.89,
        formatType: FormatType.scientific,
      );
      expect(result, contains('E'));
    });

    test('should format compact', () {
      final result = formatNumber(
        1000000,
        formatType: FormatType.compact,
      );
      expect(result, isNotEmpty);
    });

    test('should format compact long', () {
      final result = formatNumber(
        1000000,
        formatType: FormatType.compactLong,
      );
      expect(result, isNotEmpty);
    });

    test('should format zero', () {
      final result = formatNumber(
        0,
        formatType: FormatType.decimal,
        decimalType: DecimalType.automatic,
      );
      expect(result, equals('0'));
    });

    test('should format negative numbers', () {
      final result = formatNumber(
        -1234.56,
        formatType: FormatType.decimal,
        decimalType: DecimalType.automatic,
      );
      expect(result, contains('-'));
      expect(result, contains('1'));
    });

    test('should handle toLowerCase option', () {
      final result = formatNumber(
        1000000,
        formatType: FormatType.compact,
        toLowerCase: true,
      );
      expect(result, isNotEmpty);
    });
  });

  group('DateTimeConversionExtension', () {
    test('secondsSinceEpoch should convert milliseconds to seconds', () {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(2000);
      expect(dateTime.secondsSinceEpoch, equals(2));
    });

    test('secondsSinceEpoch should round correctly', () {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(2499);
      expect(dateTime.secondsSinceEpoch, equals(2));
    });

    test('secondsSinceEpoch should handle zero', () {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(0);
      expect(dateTime.secondsSinceEpoch, equals(0));
    });
  });

  group('DateTimeComparisonOperators', () {
    final early = DateTime(2024, 1, 1);
    final late = DateTime(2024, 12, 31);

    test('< operator should compare dates', () {
      expect(early < late, isTrue);
      expect(late < early, isFalse);
    });

    test('> operator should compare dates', () {
      expect(late > early, isTrue);
      expect(early > late, isFalse);
    });

    test('<= operator should handle equal dates', () {
      final same = DateTime(2024, 1, 1);
      expect(early <= same, isTrue);
      expect(early <= late, isTrue);
      expect(late <= early, isFalse);
    });

    test('>= operator should handle equal dates', () {
      final same = DateTime(2024, 1, 1);
      expect(early >= same, isTrue);
      expect(late >= early, isTrue);
      expect(early >= late, isFalse);
    });
  });

  group('ListFilterExt', () {
    test('withoutNulls should remove null values', () {
      final list = [1, null, 2, null, 3];
      expect(list.withoutNulls, equals([1, 2, 3]));
    });

    test('withoutNulls should handle empty list', () {
      final List<int?> list = [];
      expect(list.withoutNulls, isEmpty);
    });

    test('withoutNulls should handle list with all nulls', () {
      final List<int?> list = [null, null, null];
      expect(list.withoutNulls, isEmpty);
    });

    test('withoutNulls should handle list without nulls', () {
      final list = [1, 2, 3];
      expect(list.withoutNulls, equals([1, 2, 3]));
    });

    test('withoutNulls should work with strings', () {
      final list = ['a', null, 'b', null, 'c'];
      expect(list.withoutNulls, equals(['a', 'b', 'c']));
    });
  });

  group('castToType', () {
    test('should return null for null input', () {
      expect(castToType<int>(null), isNull);
      expect(castToType<String>(null), isNull);
    });

    test('should cast to double from int', () {
      final result = castToType<double>(42);
      expect(result, equals(42.0));
      expect(result, isA<double>());
    });

    test('should cast to int from double when no decimal', () {
      final result = castToType<int>(42.0);
      expect(result, equals(42));
      expect(result, isA<int>());
    });

    test('should keep double with decimal as is', () {
      final result = castToType<double>(42.5);
      expect(result, equals(42.5));
    });

    test('should cast string types directly', () {
      final result = castToType<String>('test');
      expect(result, equals('test'));
    });
  });

  group('getCurrentTimestamp', () {
    test('should return current DateTime', () {
      final before = DateTime.now();
      final timestamp = getCurrentTimestamp;
      final after = DateTime.now();
      
      expect(timestamp.isAfter(before) || timestamp.isAtSameMomentAs(before), isTrue);
      expect(timestamp.isBefore(after) || timestamp.isAtSameMomentAs(after), isTrue);
    });
  });

  group('dateTimeFromSecondsSinceEpoch', () {
    test('should convert seconds to DateTime', () {
      final result = dateTimeFromSecondsSinceEpoch(2);
      expect(result.millisecondsSinceEpoch, equals(2000));
    });

    test('should handle zero', () {
      final result = dateTimeFromSecondsSinceEpoch(0);
      expect(result.millisecondsSinceEpoch, equals(0));
    });

    test('should handle large values', () {
      final result = dateTimeFromSecondsSinceEpoch(1609459200); // 2021-01-01 UTC
      expect(result.year, anyOf(equals(2020), equals(2021))); // Depends on timezone
      expect(result.month, anyOf(equals(12), equals(1)));
    });
  });

  group('getJsonField', () {
    test('should return null for empty path result', () {
      final json = {'name': 'test'};
      final result = getJsonField(json, '\$.invalid');
      expect(result, isNull);
    });

    test('should extract simple field', () {
      final json = {'name': 'test'};
      final result = getJsonField(json, '\$.name');
      expect(result, equals('test'));
    });

    test('should extract nested field', () {
      final json = {
        'user': {'name': 'John'}
      };
      final result = getJsonField(json, '\$.user.name');
      expect(result, equals('John'));
    });

    test('should return list for multiple matches', () {
      final json = {
        'items': [
          {'id': 1},
          {'id': 2}
        ]
      };
      final result = getJsonField(json, '\$.items[*].id');
      expect(result, isA<List>());
    });
  });

  group('ColorOpacityExt', () {
    test('withOpacity should change opacity', () {
      final color = Colors.red;
      final result = color.withOpacity(0.5);
      expect(result.opacity, closeTo(0.5, 0.01));
      expect(result.red, equals(color.red));
      expect(result.green, equals(color.green));
      expect(result.blue, equals(color.blue));
    });

    test('withOpacity should handle 0.0 opacity', () {
      final color = Colors.blue;
      final result = color.withOpacity(0.0);
      expect(result.opacity, equals(0.0));
    });

    test('withOpacity should handle 1.0 opacity', () {
      final color = Colors.green;
      final result = color.withOpacity(1.0);
      expect(result.opacity, equals(1.0));
    });
  });
}
