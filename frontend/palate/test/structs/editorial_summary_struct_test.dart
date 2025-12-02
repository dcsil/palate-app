import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/editorial_summary_struct.dart';

void main() {
  group('EditorialSummaryStruct', () {
    test('constructor with parameters', () {
      final summary = EditorialSummaryStruct(
        langaugeCode: 'en',
        text: 'A wonderful restaurant',
      );

      expect(summary.langaugeCode, 'en');
      expect(summary.text, 'A wonderful restaurant');
    });

    test('constructor with default values', () {
      final summary = EditorialSummaryStruct();
      expect(summary.langaugeCode, '');
      expect(summary.text, '');
    });

    test('langaugeCode setter and hasLangaugeCode', () {
      final summary = EditorialSummaryStruct();
      expect(summary.hasLangaugeCode(), false);

      summary.langaugeCode = 'fr';
      expect(summary.langaugeCode, 'fr');
      expect(summary.hasLangaugeCode(), true);
    });

    test('text setter and hasText', () {
      final summary = EditorialSummaryStruct();
      expect(summary.hasText(), false);

      summary.text = 'Great food and atmosphere';
      expect(summary.text, 'Great food and atmosphere');
      expect(summary.hasText(), true);
    });

    test('fromMap creates struct', () {
      final data = {
        'langaugeCode': 'es',
        'text': 'Un restaurante excelente',
      };

      final summary = EditorialSummaryStruct.fromMap(data);
      expect(summary.langaugeCode, 'es');
      expect(summary.text, 'Un restaurante excelente');
    });

    test('maybeFromMap with valid map', () {
      final data = {
        'langaugeCode': 'de',
        'text': 'Ein tolles Restaurant',
      };
      final summary = EditorialSummaryStruct.maybeFromMap(data);
      
      expect(summary, isNotNull);
      expect(summary!.langaugeCode, 'de');
      expect(summary.text, 'Ein tolles Restaurant');
    });

    test('maybeFromMap with non-map returns null', () {
      expect(EditorialSummaryStruct.maybeFromMap(null), null);
      expect(EditorialSummaryStruct.maybeFromMap('string'), null);
      expect(EditorialSummaryStruct.maybeFromMap(123), null);
    });

    test('toMap returns correct map', () {
      final summary = EditorialSummaryStruct(
        langaugeCode: 'it',
        text: 'Un ristorante fantastico',
      );
      final data = summary.toMap();

      expect(data['langaugeCode'], 'it');
      expect(data['text'], 'Un ristorante fantastico');
    });

    test('toSerializableMap', () {
      final summary = EditorialSummaryStruct(
        langaugeCode: 'pt',
        text: 'Um restaurante incrível',
      );
      final data = summary.toSerializableMap();

      expect(data.containsKey('langaugeCode'), true);
      expect(data.containsKey('text'), true);
    });

    test('fromSerializableMap reconstructs struct', () {
      final original = EditorialSummaryStruct(
        langaugeCode: 'ja',
        text: 'すばらしいレストラン',
      );
      final serialized = original.toSerializableMap();
      final reconstructed = EditorialSummaryStruct.fromSerializableMap(serialized);

      expect(reconstructed.langaugeCode, original.langaugeCode);
      expect(reconstructed.text, original.text);
    });

    test('toString produces valid output', () {
      final summary = EditorialSummaryStruct(langaugeCode: 'en', text: 'Test');
      final str = summary.toString();
      expect(str, contains('EditorialSummaryStruct'));
    });

    test('equality operator', () {
      final sum1 = EditorialSummaryStruct(langaugeCode: 'en', text: 'Same');
      final sum2 = EditorialSummaryStruct(langaugeCode: 'en', text: 'Same');
      final sum3 = EditorialSummaryStruct(langaugeCode: 'fr', text: 'Different');

      expect(sum1 == sum2, true);
      expect(sum1 == sum3, false);
    });

    test('hashCode consistency', () {
      final sum1 = EditorialSummaryStruct(langaugeCode: 'en', text: 'Hash');
      final sum2 = EditorialSummaryStruct(langaugeCode: 'en', text: 'Hash');

      expect(sum1.hashCode, sum2.hashCode);
    });

    test('empty struct serialization roundtrip', () {
      final original = EditorialSummaryStruct();
      final serialized = original.toSerializableMap();
      final reconstructed = EditorialSummaryStruct.fromSerializableMap(serialized);

      expect(reconstructed.langaugeCode, '');
      expect(reconstructed.text, '');
      expect(reconstructed == original, true);
    });
  });
}
