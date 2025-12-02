import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/payment_options_struct.dart';

void main() {
  group('PaymentOptionsStruct', () {
    test('constructor with all parameters', () {
      final payment = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsCreditCards: true,
        acceptsCashOnly: false,
        acceptsNfc: true,
      );

      expect(payment.acceptsDebitCards, true);
      expect(payment.acceptsCreditCards, true);
      expect(payment.acceptsCashOnly, false);
      expect(payment.acceptsNfc, true);
    });

    test('default values', () {
      final payment = PaymentOptionsStruct();
      expect(payment.acceptsDebitCards, false);
      expect(payment.acceptsCreditCards, false);
      expect(payment.acceptsCashOnly, false);
      expect(payment.acceptsNfc, false);
    });

    test('has methods', () {
      final payment = PaymentOptionsStruct();
      expect(payment.hasAcceptsDebitCards(), false);
      expect(payment.hasAcceptsCreditCards(), false);
      expect(payment.hasAcceptsCashOnly(), false);
      expect(payment.hasAcceptsNfc(), false);

      payment.acceptsDebitCards = true;
      payment.acceptsCreditCards = true;
      expect(payment.hasAcceptsDebitCards(), true);
      expect(payment.hasAcceptsCreditCards(), true);
    });

    test('setters work correctly', () {
      final payment = PaymentOptionsStruct();
      
      payment.acceptsDebitCards = true;
      payment.acceptsCreditCards = true;
      payment.acceptsCashOnly = false;
      payment.acceptsNfc = true;

      expect(payment.acceptsDebitCards, true);
      expect(payment.acceptsCreditCards, true);
      expect(payment.acceptsCashOnly, false);
      expect(payment.acceptsNfc, true);
    });

    test('fromMap', () {
      final data = {
        'acceptsDebitCards': true,
        'acceptsCreditCards': false,
        'acceptsCashOnly': false,
        'acceptsNfc': true,
      };
      final payment = PaymentOptionsStruct.fromMap(data);
      expect(payment.acceptsDebitCards, true);
      expect(payment.acceptsCreditCards, false);
      expect(payment.acceptsNfc, true);
    });

    test('maybeFromMap with valid map', () {
      final data = {
        'acceptsDebitCards': true,
        'acceptsCreditCards': true,
      };
      final payment = PaymentOptionsStruct.maybeFromMap(data);
      expect(payment, isNotNull);
      expect(payment!.acceptsDebitCards, true);
    });

    test('maybeFromMap with invalid data', () {
      expect(PaymentOptionsStruct.maybeFromMap(null), null);
      expect(PaymentOptionsStruct.maybeFromMap('string'), null);
      expect(PaymentOptionsStruct.maybeFromMap(123), null);
    });

    test('toMap', () {
      final payment = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsCreditCards: false,
        acceptsCashOnly: false,
        acceptsNfc: true,
      );
      final data = payment.toMap();
      expect(data['acceptsDebitCards'], true);
      expect(data['acceptsCreditCards'], false);
      expect(data['acceptsNfc'], true);
    });

    test('serialization roundtrip', () {
      final original = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsCreditCards: true,
        acceptsCashOnly: false,
        acceptsNfc: true,
      );
      final serialized = original.toSerializableMap();
      final reconstructed = PaymentOptionsStruct.fromSerializableMap(serialized);
      
      expect(reconstructed.acceptsDebitCards, original.acceptsDebitCards);
      expect(reconstructed.acceptsCreditCards, original.acceptsCreditCards);
      expect(reconstructed.acceptsCashOnly, original.acceptsCashOnly);
      expect(reconstructed.acceptsNfc, original.acceptsNfc);
    });

    test('equality', () {
      final p1 = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsCreditCards: true,
      );
      final p2 = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsCreditCards: true,
      );
      final p3 = PaymentOptionsStruct(
        acceptsDebitCards: false,
        acceptsCreditCards: false,
      );

      expect(p1 == p2, true);
      expect(p1 == p3, false);
    });

    test('toString', () {
      final payment = PaymentOptionsStruct(acceptsDebitCards: true);
      expect(payment.toString(), contains('PaymentOptionsStruct'));
    });

    test('all payment methods enabled', () {
      final payment = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsCreditCards: true,
        acceptsCashOnly: true,
        acceptsNfc: true,
      );

      expect(payment.acceptsDebitCards, true);
      expect(payment.acceptsCreditCards, true);
      expect(payment.acceptsCashOnly, true);
      expect(payment.acceptsNfc, true);
    });
  });
}
