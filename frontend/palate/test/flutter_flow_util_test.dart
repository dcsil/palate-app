import 'package:flutter_test/flutter_test.dart';
import 'package:palate/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

void main() {
  group('flutter_flow_util', () {
    test('valueOrDefault returns default for null/empty', () {
      expect(valueOrDefault<String>(null, 'x'), 'x');
      expect(valueOrDefault<String>('', 'y'), 'y');
      expect(valueOrDefault<String>('hi', 'y'), 'hi');
      expect(valueOrDefault<int>(null, 5), 5);
      expect(valueOrDefault<int>(10, 5), 10);
      expect(valueOrDefault<double>(null, 1.5), 1.5);
      expect(valueOrDefault<double>(2.5, 1.5), 2.5);
    });

    test('dateTimeFormat relative and custom', () {
      final now = DateTime.now();
      final rel = dateTimeFormat('relative', now);
      expect(rel.isNotEmpty, true);
      
      final custom = dateTimeFormat('yyyy-MM-dd', DateTime(2020, 1, 2));
      expect(custom, '2020-01-02');
      
      final customTime = dateTimeFormat('HH:mm:ss', DateTime(2020, 1, 1, 14, 30, 45));
      expect(customTime, '14:30:45');
      
      // Test null datetime
      expect(dateTimeFormat('yyyy-MM-dd', null), '');
    });

    test('colorFromCssString parses valid/invalid', () {
      expect(colorFromCssString('#ff0000'), const Color(0xFFFF0000));
      expect(colorFromCssString('#00ff00'), const Color(0xFF00FF00));
      expect(colorFromCssString('#0000ff'), const Color(0xFF0000FF));
      
      final fallback = colorFromCssString('not-a-color', defaultColor: Colors.blue);
      expect(fallback, Colors.blue);
      
      final black = colorFromCssString('invalid');
      expect(black, Colors.black);
    });

    test('formatNumber decimal and percent', () {
      expect(
        formatNumber(1234,
            formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal),
        isNotEmpty,
      );
      expect(
        formatNumber(0.5, formatType: FormatType.percent),
        contains('%'),
      );
      expect(
        formatNumber(null, formatType: FormatType.decimal, decimalType: DecimalType.automatic),
        '',
      );
      expect(
        formatNumber(1000000, formatType: FormatType.compact),
        isNotEmpty,
      );
    });

    test('dateTime conversions', () {
      final ts = getCurrentTimestamp;
      expect(ts.isBefore(DateTime.now().add(const Duration(seconds: 1))), true);
      
      final dt = dateTimeFromSecondsSinceEpoch(1000);
      expect(dt.millisecondsSinceEpoch, 1000 * 1000);
      
      expect(DateTime(2020).secondsSinceEpoch, isA<int>());
      expect(DateTime(2020, 6, 15).secondsSinceEpoch, isA<int>());
      
      final dt2 = dateTimeFromSecondsSinceEpoch(0);
      expect(dt2.millisecondsSinceEpoch, 0);
    });

    test('castToType for int/double', () {
      expect(castToType<int>(1.0), 1);
      expect(castToType<int>(5.0), 5);
      expect(castToType<double>(1), 1.0);
      expect(castToType<double>(42), 42.0);
      expect(castToType<int>(null), null);
      expect(castToType<double>(null), null);
    });

    test('DateTime comparison operators', () {
      final earlier = DateTime(2024, 1, 1);
      final later = DateTime(2024, 12, 31);
      final same = DateTime(2024, 1, 1);
      
      expect(earlier < later, isTrue);
      expect(later > earlier, isTrue);
      expect(earlier <= same, isTrue);
      expect(earlier >= same, isTrue);
      expect(earlier <= later, isTrue);
      expect(later >= earlier, isTrue);
      
      expect(later < earlier, isFalse);
      expect(earlier > later, isFalse);
    });

    test('formatNumber with all decimal types', () {
      expect(
        formatNumber(1234.56,
            formatType: FormatType.decimal, 
            decimalType: DecimalType.automatic),
        isNotEmpty,
      );
      
      expect(
        formatNumber(1234.56,
            formatType: FormatType.decimal,
            decimalType: DecimalType.periodDecimal),
        contains('1,234'),
      );
      
      expect(
        formatNumber(1234.56,
            formatType: FormatType.decimal,
            decimalType: DecimalType.commaDecimal),
        isNotEmpty,
      );
    });

    test('formatNumber with currency', () {
      final result = formatNumber(
        100.50,
        formatType: FormatType.decimal,
        decimalType: DecimalType.periodDecimal,
        currency: '\$',
      );
      
      expect(result, contains('\$'));
      expect(result, contains('100'));
    });

    test('formatNumber with empty currency uses default', () {
      final result = formatNumber(
        50.0,
        formatType: FormatType.decimal,
        decimalType: DecimalType.periodDecimal,
        currency: '',
      );
      
      expect(result, isNotEmpty);
    });

    test('formatNumber scientific with toLowerCase', () {
      final result = formatNumber(
        123000,
        formatType: FormatType.scientific,
        toLowerCase: true,
      );
      
      expect(result, contains('e'));
    });

    test('formatNumber compactLong', () {
      final result = formatNumber(
        1500000,
        formatType: FormatType.compactLong,
      );
      
      expect(result, isNotEmpty);
    });

    test('formatNumber custom format', () {
      final result = formatNumber(
        1234.5,
        formatType: FormatType.custom,
        format: '#,##0.00',
      );
      
      expect(result, isNotEmpty);
    });

    test('formatNumber custom format with locale', () {
      final result = formatNumber(
        9999.99,
        formatType: FormatType.custom,
        format: '#,##0.00',
        locale: 'en_US',
      );
      
      expect(result, isNotEmpty);
    });

    test('getJsonField extracts simple field', () {
      final json = {'name': 'John', 'age': 30};
      
      expect(getJsonField(json, r'$.name'), equals('John'));
      expect(getJsonField(json, r'$.age'), equals(30));
    });

    test('getJsonField returns null for missing field', () {
      final json = {'name': 'John'};
      
      expect(getJsonField(json, r'$.missing'), isNull);
    });

    test('getJsonField extracts nested field', () {
      final json = {
        'user': {'name': 'Jane', 'address': {'city': 'NYC'}}
      };
      
      expect(getJsonField(json, r'$.user.name'), equals('Jane'));
      expect(getJsonField(json, r'$.user.address.city'), equals('NYC'));
    });

    test('getJsonField extracts list', () {
      final json = {'items': ['a', 'b', 'c']};
      
      final result = getJsonField(json, r'$.items[*]');
      expect(result, isA<List>());
      expect(result, equals(['a', 'b', 'c']));
    });

    test('getJsonField with isForList wraps single value', () {
      final json = {'value': 'single'};
      
      final result = getJsonField(json, r'$.value', true);
      expect(result, isA<List>());
      expect(result, equals(['single']));
    });

    test('dateTimeFormat with locale', () {
      final date = DateTime(2024, 6, 15);
      
      final result = dateTimeFormat('MMMM d, yyyy', date, locale: 'en_US');
      expect(result, contains('June'));
    });

    test('roundTo and gradient alignment', () {
      expect(roundTo(1.2345, 2), '1.23');
      // roundTo returns '10.0' not '10.00' when rounding whole numbers
      expect(roundTo(9.9999, 2).startsWith('10.'), true);
      expect(roundTo(5.0, 1), '5.0');
      expect(roundTo(123.456789, 4), '123.4568');
      
      expect(computeGradientAlignmentX(0), isA<double>());
      expect(computeGradientAlignmentX(90), isA<double>());
      expect(computeGradientAlignmentX(180), isA<double>());
      
      expect(computeGradientAlignmentY(0), isA<double>());
      expect(computeGradientAlignmentY(45), isA<double>());
      expect(computeGradientAlignmentY(270), isA<double>());
    });

    test('list extension withoutNulls', () {
      expect([1, null, 3, null, 5].withoutNulls, [1, 3, 5]);
      expect([null, null].withoutNulls, []);
      expect([1, 2, 3].withoutNulls, [1, 2, 3]);
    });

    test('list extension unique', () {
      expect([1, 2, 2, 3, 3, 3].unique((x) => x), [1, 2, 3]);
      expect(['a', 'b', 'a', 'c'].unique((x) => x), ['a', 'b', 'c']);
    });

    test('containsMap checks map equality', () {
      final list = [
        {'a': 1},
        {'b': 2}
      ];
      expect(list.containsMap({'a': 1}), true);
      expect(list.containsMap({'c': 3}), false);
    });

    testWidgets('responsiveVisibility respects width breakpoints', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: Builder(
            key: key,
            builder: (context) {
              final phoneVisible = responsiveVisibility(
                context: context, 
                phone: true, 
                tablet: false, 
                desktop: false
              );
              expect(phoneVisible, true);
              
              final tabletVisible = responsiveVisibility(
                context: context,
                phone: false,
                tablet: true,
                desktop: false
              );
              expect(tabletVisible, false);
              
              return const SizedBox.shrink();
            },
          ),
        ),
      ));
    });

    testWidgets('responsiveVisibility with tablet size', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(800, 600)),
          child: Builder(
            builder: (context) {
              final tabletVisible = responsiveVisibility(
                context: context,
                phone: false,
                tablet: true,
                desktop: false
              );
              expect(tabletVisible, true);
              
              return const SizedBox.shrink();
            },
          ),
        ),
      ));
    });
    
    testWidgets('responsiveVisibility with desktop size', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(1400, 1000)),
          child: Builder(
            builder: (context) {
              final desktopVisible = responsiveVisibility(
                context: context,
                phone: false,
                tablet: false,
                desktop: true
              );
              expect(desktopVisible, true);
              
              return const SizedBox.shrink();
            },
          ),
        ),
      ));
    });

    test('FFStringExt maybeHandleOverflow truncates when needed', () {
      expect('hello world'.maybeHandleOverflow(maxChars: 5), 'hello');
      expect('hello world'.maybeHandleOverflow(maxChars: 5, replacement: '...'), 'hello...');
      expect('hi'.maybeHandleOverflow(maxChars: 10), 'hi');
      expect('test'.maybeHandleOverflow(), 'test');
    });

    test('FFStringExt toCapitalization handles all cases', () {
      expect('hello world'.toCapitalization(TextCapitalization.none), 'hello world');
      expect('hello world'.toCapitalization(TextCapitalization.words), 'Hello World');
      expect('hello. world'.toCapitalization(TextCapitalization.sentences), 'Hello. world');
      expect('hello world'.toCapitalization(TextCapitalization.characters), 'HELLO WORLD');
    });

    test('MapFilterExtensions withoutNulls removes null values', () {
      final map = {'a': 1, 'b': null, 'c': 3, 'd': null};
      expect(map.withoutNulls, {'a': 1, 'c': 3});
      
      final emptyMap = <String, int?>{};
      expect(emptyMap.withoutNulls, {});
      
      final noNulls = {'x': 5, 'y': 10};
      expect(noNulls.withoutNulls, {'x': 5, 'y': 10});
    });

    test('IterableExt sortedList sorts ascending by default', () {
      expect([3, 1, 4, 1, 5].sortedList(), [1, 1, 3, 4, 5]);
      expect(['c', 'a', 'b'].sortedList(), ['a', 'b', 'c']);
    });

    test('IterableExt sortedList sorts descending when specified', () {
      expect([3, 1, 4, 1, 5].sortedList(desc: true), [5, 4, 3, 1, 1]);
      expect(['c', 'a', 'b'].sortedList(desc: true), ['c', 'b', 'a']);
    });

    test('IterableExt sortedList with keyOf function', () {
      final items = ['aaa', 'b', 'cc'];
      expect(items.sortedList(keyOf: (s) => s.length), ['b', 'cc', 'aaa']);
      expect(items.sortedList(keyOf: (s) => s.length, desc: true), ['aaa', 'cc', 'b']);
    });

    test('IterableExt mapIndexed provides index', () {
      final result = ['a', 'b', 'c'].mapIndexed((i, s) => '$i:$s');
      expect(result, ['0:a', '1:b', '2:c']);
      
      final empty = <String>[].mapIndexed((i, s) => '$i:$s');
      expect(empty, []);
    });

    test('castToType handles various type conversions', () {
      // castToType expects compatible types, not string conversions
      expect(castToType<String>('hello'), 'hello');
      expect(castToType<String>('world'), 'world');
      
      expect(castToType<int>(42), 42);
      expect(castToType<int>(42.0), 42); // int stored as double
      
      expect(castToType<double>(10), 10.0);
      expect(castToType<double>(2.5), 2.5);
      expect(castToType<double>(100), 100.0);
      
      expect(castToType<bool>(true), true);
      expect(castToType<bool>(false), false);
      
      expect(castToType<List>([1, 2, 3]), [1, 2, 3]);
      expect(castToType<List>(['a', 'b']), ['a', 'b']);
      
      // Null handling
      expect(castToType<String>(null), null);
      expect(castToType<int>(null), null);
      expect(castToType<double>(null), null);
    });

    test('formatNumber handles percent format', () {
      final result = formatNumber(0.75, formatType: FormatType.percent);
      expect(result, isNotEmpty);
      expect(result, contains('%'));
    });

    test('formatNumber handles compact format', () {
      final result = formatNumber(1500, formatType: FormatType.compact);
      expect(result, isNotEmpty);
    });

    test('formatNumber returns empty string for null', () {
      final result = formatNumber(null, formatType: FormatType.decimal, decimalType: DecimalType.automatic);
      expect(result, '');
    });

    test('dateTimeFromSecondsSinceEpoch converts correctly', () {
      final seconds = 1609459200; // 2021-01-01 00:00:00 UTC
      final dateTime = dateTimeFromSecondsSinceEpoch(seconds);
      // Check the timestamp value instead of specific date parts (due to timezone)
      expect(dateTime.millisecondsSinceEpoch, 1609459200000);
    });

    test('DateTimeConversionExtension secondsSinceEpoch', () {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(1609459200000);
      final seconds = dateTime.secondsSinceEpoch;
      expect(seconds, 1609459200);
    });

    test('getCurrentTimestamp returns current time', () {
      final before = DateTime.now();
      final timestamp = getCurrentTimestamp;
      final after = DateTime.now();
      
      expect(timestamp.isAfter(before) || timestamp.isAtSameMomentAs(before), true);
      expect(timestamp.isBefore(after) || timestamp.isAtSameMomentAs(after), true);
    });

    testWidgets('ListDivideExt divide adds widget between elements', (tester) async {
      final widgets = [
        const Text('A'),
        const Text('B'),
        const Text('C'),
      ];
      
      final divided = widgets.divide(const Text('-'));
      expect(divided.length, 5); // A, -, B, -, C
    });

    testWidgets('ListDivideExt addToStart adds widget at beginning', (tester) async {
      final widgets = [const Text('B'), const Text('C')];
      final result = widgets.addToStart(const Text('A'));
      expect(result.length, 3);
    });

    testWidgets('ListDivideExt addToEnd adds widget at end', (tester) async {
      final widgets = [const Text('A'), const Text('B')];
      final result = widgets.addToEnd(const Text('C'));
      expect(result.length, 3);
    });

    testWidgets('ListDivideExt around adds widget at both ends', (tester) async {
      final widgets = [const Text('B')];
      final result = widgets.around(const Text('A'));
      expect(result.length, 3);
    });

    testWidgets('ListDivideExt paddingTopEach adds padding', (tester) async {
      final widgets = [const Text('A'), const Text('B')];
      final result = widgets.paddingTopEach(10.0);
      expect(result.length, 2);
      expect(result[0], isA<Padding>());
      expect(result[1], isA<Padding>());
    });

    test('ColorOpacityExt applyAlpha changes alpha', () {
      final color = const Color(0xFF0000FF); // Blue with full alpha
      final semiTransparent = color.applyAlpha(0.5);
      // alpha ranges from 0-255, so 0.5 means 128 (approximately)
      expect(semiTransparent.alpha, closeTo(128, 1));
    });

    test('colorFromCssString parses valid CSS colors', () {
      final red = colorFromCssString('#FF0000');
      expect(red, isNotNull);
      expect(red, isA<Color>());
      
      final blue = colorFromCssString('rgb(0, 0, 255)');
      expect(blue, isNotNull);
    });

    test('colorFromCssString returns default on invalid color', () {
      final defaultRed = Colors.red;
      final result = colorFromCssString('invalid', defaultColor: defaultRed);
      expect(result, defaultRed);
    });

    test('colorFromCssString returns black when no default provided', () {
      final result = colorFromCssString('invalid-color');
      expect(result, Colors.black);
    });

    test('valueOrDefault returns value when valid', () {
      expect(valueOrDefault('hello', 'default'), 'hello');
      expect(valueOrDefault(42, 0), 42);
      expect(valueOrDefault(true, false), true);
    });

    test('valueOrDefault returns default for null', () {
      expect(valueOrDefault<String?>(null, 'default'), 'default');
      expect(valueOrDefault<int?>(null, 100), 100);
    });

    test('valueOrDefault returns default for empty string', () {
      expect(valueOrDefault('', 'default'), 'default');
    });

    test('valueOrDefault does not treat other falsy values as empty', () {
      expect(valueOrDefault(0, 100), 0);
      expect(valueOrDefault(false, true), false);
    });

    test('dateTimeFormat handles null dateTime', () {
      final result = dateTimeFormat('yyyy-MM-dd', null);
      expect(result, '');
    });

    test('dateTimeFormat formats with various patterns', () {
      final date = DateTime(2024, 12, 25, 10, 30);
      
      expect(dateTimeFormat('yyyy', date), '2024');
      expect(dateTimeFormat('MM', date), '12');
      expect(dateTimeFormat('dd', date), '25');
    });

    test('dateTimeFormat handles relative format', () {
      final recentDate = DateTime.now().subtract(Duration(hours: 2));
      final result = dateTimeFormat('relative', recentDate);
      
      expect(result, isNotEmpty);
      expect(result, contains('ago'));
    });

    test('formatNumber uses currency symbol fallback', () {
      final result = formatNumber(
        100.0,
        formatType: FormatType.decimal,
        decimalType: DecimalType.automatic,
        currency: '',
      );
      
      expect(result, isNotEmpty);
      expect(result, contains(RegExp(r'[\$€£¥]'))); // Should have some currency symbol
    });

    test('formatNumber handles commaDecimal with currency', () {
      final result = formatNumber(
        1234.56,
        formatType: FormatType.decimal,
        decimalType: DecimalType.commaDecimal,
        currency: '€',
      );
      
      expect(result, contains('€'));
    });

    test('formatNumber handles periodDecimal with currency', () {
      final result = formatNumber(
        1234.56,
        formatType: FormatType.decimal,
        decimalType: DecimalType.periodDecimal,
        currency: '\$',
      );
      
      expect(result, contains('\$'));
    });
  });
}

