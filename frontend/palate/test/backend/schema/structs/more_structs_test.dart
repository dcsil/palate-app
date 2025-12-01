import 'package:flutter_test/flutter_test.dart';
import 'package:palate/backend/schema/structs/string_map_struct.dart';
import 'package:palate/backend/schema/structs/payment_options_struct.dart';

void main() {
  group('StringMapStruct', () {
    test('should create with key and value', () {
      final struct = StringMapStruct(key: 'testKey', value: 'testValue');
      expect(struct.key, equals('testKey'));
      expect(struct.value, equals('testValue'));
    });

    test('should create with default empty strings', () {
      final struct = StringMapStruct();
      expect(struct.key, equals(''));
      expect(struct.value, equals(''));
      expect(struct.hasKey(), isFalse);
      expect(struct.hasValue(), isFalse);
    });

    test('should set and get key', () {
      final struct = StringMapStruct();
      struct.key = 'newKey';
      expect(struct.key, equals('newKey'));
      expect(struct.hasKey(), isTrue);
    });

    test('should set and get value', () {
      final struct = StringMapStruct();
      struct.value = 'newValue';
      expect(struct.value, equals('newValue'));
      expect(struct.hasValue(), isTrue);
    });

    test('hasKey should return false when null', () {
      final struct = StringMapStruct();
      expect(struct.hasKey(), isFalse);
    });

    test('hasValue should return false when null', () {
      final struct = StringMapStruct();
      expect(struct.hasValue(), isFalse);
    });

    test('should create from map', () {
      final data = {'key': 'mapKey', 'value': 'mapValue'};
      final struct = StringMapStruct.fromMap(data);
      expect(struct.key, equals('mapKey'));
      expect(struct.value, equals('mapValue'));
    });

    test('maybeFromMap should return struct for valid map', () {
      final data = {'key': 'testKey', 'value': 'testValue'};
      final struct = StringMapStruct.maybeFromMap(data);
      expect(struct, isNotNull);
      expect(struct!.key, equals('testKey'));
      expect(struct.value, equals('testValue'));
    });

    test('maybeFromMap should return null for non-map', () {
      expect(StringMapStruct.maybeFromMap('not a map'), isNull);
      expect(StringMapStruct.maybeFromMap(123), isNull);
      expect(StringMapStruct.maybeFromMap(null), isNull);
    });

    test('should convert to map', () {
      final struct = StringMapStruct(key: 'k1', value: 'v1');
      final map = struct.toMap();
      expect(map['key'], equals('k1'));
      expect(map['value'], equals('v1'));
    });

    test('toMap should exclude null values', () {
      final struct = StringMapStruct();
      final map = struct.toMap();
      expect(map.containsKey('key'), isFalse);
      expect(map.containsKey('value'), isFalse);
    });

    test('should convert to serializable map', () {
      final struct = StringMapStruct(key: 'serKey', value: 'serValue');
      final map = struct.toSerializableMap();
      expect(map, isNotNull);
      expect(map.containsKey('key'), isTrue);
      expect(map.containsKey('value'), isTrue);
    });

    test('should create from serializable map', () {
      final data = {'key': 'deserKey', 'value': 'deserValue'};
      final struct = StringMapStruct.fromSerializableMap(data);
      expect(struct.key, equals('deserKey'));
      expect(struct.value, equals('deserValue'));
    });

    test('toString should return formatted string', () {
      final struct = StringMapStruct(key: 'k', value: 'v');
      final str = struct.toString();
      expect(str, contains('StringMapStruct'));
    });

    test('equality should work correctly', () {
      final struct1 = StringMapStruct(key: 'key1', value: 'value1');
      final struct2 = StringMapStruct(key: 'key1', value: 'value1');
      final struct3 = StringMapStruct(key: 'key2', value: 'value2');

      expect(struct1 == struct2, isTrue);
      expect(struct1 == struct3, isFalse);
    });

    test('should handle empty key and value', () {
      final struct = StringMapStruct(key: '', value: '');
      expect(struct.key, equals(''));
      expect(struct.value, equals(''));
    });

    test('should handle special characters in key', () {
      final struct = StringMapStruct(key: 'key!@#\$%', value: 'value');
      expect(struct.key, contains('!@#'));
    });

    test('should handle special characters in value', () {
      final struct = StringMapStruct(key: 'key', value: 'value with spaces & symbols');
      expect(struct.value, contains('spaces'));
    });

    test('should handle unicode in key and value', () {
      final struct = StringMapStruct(key: '键', value: '值');
      expect(struct.key, equals('键'));
      expect(struct.value, equals('值'));
    });

    test('hashCode should be consistent', () {
      final struct1 = StringMapStruct(key: 'key', value: 'value');
      final struct2 = StringMapStruct(key: 'key', value: 'value');
      expect(struct1.hashCode, equals(struct2.hashCode));
    });
  });

  group('PaymentOptionsStruct', () {
    test('should create with all payment options', () {
      final struct = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsCreditCards: true,
        acceptsCashOnly: false,
        acceptsNfc: true,
      );
      expect(struct.acceptsDebitCards, isTrue);
      expect(struct.acceptsCreditCards, isTrue);
      expect(struct.acceptsCashOnly, isFalse);
      expect(struct.acceptsNfc, isTrue);
    });

    test('should create with default false values', () {
      final struct = PaymentOptionsStruct();
      expect(struct.acceptsDebitCards, isFalse);
      expect(struct.acceptsCreditCards, isFalse);
      expect(struct.acceptsCashOnly, isFalse);
      expect(struct.acceptsNfc, isFalse);
    });

    test('should set and get acceptsDebitCards', () {
      final struct = PaymentOptionsStruct();
      struct.acceptsDebitCards = true;
      expect(struct.acceptsDebitCards, isTrue);
      expect(struct.hasAcceptsDebitCards(), isTrue);
    });

    test('should set and get acceptsCreditCards', () {
      final struct = PaymentOptionsStruct();
      struct.acceptsCreditCards = true;
      expect(struct.acceptsCreditCards, isTrue);
      expect(struct.hasAcceptsCreditCards(), isTrue);
    });

    test('should set and get acceptsCashOnly', () {
      final struct = PaymentOptionsStruct();
      struct.acceptsCashOnly = true;
      expect(struct.acceptsCashOnly, isTrue);
      expect(struct.hasAcceptsCashOnly(), isTrue);
    });

    test('should set and get acceptsNfc', () {
      final struct = PaymentOptionsStruct();
      struct.acceptsNfc = true;
      expect(struct.acceptsNfc, isTrue);
      expect(struct.hasAcceptsNfc(), isTrue);
    });

    test('has methods should return false when null', () {
      final struct = PaymentOptionsStruct();
      expect(struct.hasAcceptsDebitCards(), isFalse);
      expect(struct.hasAcceptsCreditCards(), isFalse);
      expect(struct.hasAcceptsCashOnly(), isFalse);
      expect(struct.hasAcceptsNfc(), isFalse);
    });

    test('should create from map', () {
      final data = {
        'acceptsDebitCards': true,
        'acceptsCreditCards': false,
        'acceptsCashOnly': true,
        'acceptsNfc': false,
      };
      final struct = PaymentOptionsStruct.fromMap(data);
      expect(struct.acceptsDebitCards, isTrue);
      expect(struct.acceptsCreditCards, isFalse);
      expect(struct.acceptsCashOnly, isTrue);
      expect(struct.acceptsNfc, isFalse);
    });

    test('maybeFromMap should return struct for valid map', () {
      final data = {
        'acceptsDebitCards': true,
        'acceptsCreditCards': true,
      };
      final struct = PaymentOptionsStruct.maybeFromMap(data);
      expect(struct, isNotNull);
      expect(struct!.acceptsDebitCards, isTrue);
      expect(struct.acceptsCreditCards, isTrue);
    });

    test('maybeFromMap should return null for non-map', () {
      expect(PaymentOptionsStruct.maybeFromMap('not a map'), isNull);
      expect(PaymentOptionsStruct.maybeFromMap(123), isNull);
      expect(PaymentOptionsStruct.maybeFromMap(null), isNull);
    });

    test('should convert to map', () {
      final struct = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsCreditCards: false,
      );
      final map = struct.toMap();
      expect(map['acceptsDebitCards'], isTrue);
      expect(map['acceptsCreditCards'], isFalse);
    });

    test('toMap should exclude null values', () {
      final struct = PaymentOptionsStruct();
      final map = struct.toMap();
      expect(map.containsKey('acceptsDebitCards'), isFalse);
      expect(map.containsKey('acceptsCreditCards'), isFalse);
    });

    test('should convert to serializable map', () {
      final struct = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsNfc: true,
      );
      final map = struct.toSerializableMap();
      expect(map, isNotNull);
      expect(map.containsKey('acceptsDebitCards'), isTrue);
      expect(map.containsKey('acceptsNfc'), isTrue);
    });

    test('should work with serializable map', () {
      final struct = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsNfc: true,
      );
      final map = struct.toSerializableMap();
      expect(map, isNotNull);
      expect(map.containsKey('acceptsDebitCards'), isTrue);
      expect(map.containsKey('acceptsNfc'), isTrue);
    });

    test('toString should return formatted string', () {
      final struct = PaymentOptionsStruct(acceptsDebitCards: true);
      final str = struct.toString();
      expect(str, contains('PaymentOptionsStruct'));
    });

    test('equality should work correctly', () {
      final struct1 = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsCreditCards: false,
      );
      final struct2 = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsCreditCards: false,
      );
      final struct3 = PaymentOptionsStruct(
        acceptsDebitCards: false,
        acceptsCreditCards: true,
      );

      expect(struct1 == struct2, isTrue);
      expect(struct1 == struct3, isFalse);
    });

    test('should handle all payment methods accepted', () {
      final struct = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsCreditCards: true,
        acceptsCashOnly: true,
        acceptsNfc: true,
      );
      expect(struct.acceptsDebitCards, isTrue);
      expect(struct.acceptsCreditCards, isTrue);
      expect(struct.acceptsCashOnly, isTrue);
      expect(struct.acceptsNfc, isTrue);
    });

    test('should handle no payment methods accepted', () {
      final struct = PaymentOptionsStruct(
        acceptsDebitCards: false,
        acceptsCreditCards: false,
        acceptsCashOnly: false,
        acceptsNfc: false,
      );
      expect(struct.acceptsDebitCards, isFalse);
      expect(struct.acceptsCreditCards, isFalse);
      expect(struct.acceptsCashOnly, isFalse);
      expect(struct.acceptsNfc, isFalse);
    });

    test('should handle only cash accepted', () {
      final struct = PaymentOptionsStruct(
        acceptsDebitCards: false,
        acceptsCreditCards: false,
        acceptsCashOnly: true,
        acceptsNfc: false,
      );
      expect(struct.acceptsCashOnly, isTrue);
      expect(struct.acceptsDebitCards, isFalse);
      expect(struct.acceptsCreditCards, isFalse);
    });

    test('should handle only card payments', () {
      final struct = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsCreditCards: true,
        acceptsCashOnly: false,
        acceptsNfc: false,
      );
      expect(struct.acceptsDebitCards, isTrue);
      expect(struct.acceptsCreditCards, isTrue);
      expect(struct.acceptsCashOnly, isFalse);
    });

    test('should handle only NFC payments', () {
      final struct = PaymentOptionsStruct(
        acceptsDebitCards: false,
        acceptsCreditCards: false,
        acceptsCashOnly: false,
        acceptsNfc: true,
      );
      expect(struct.acceptsNfc, isTrue);
      expect(struct.acceptsDebitCards, isFalse);
    });

    test('hashCode should be consistent', () {
      final struct1 = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsCreditCards: false,
      );
      final struct2 = PaymentOptionsStruct(
        acceptsDebitCards: true,
        acceptsCreditCards: false,
      );
      expect(struct1.hashCode, equals(struct2.hashCode));
    });

    test('should toggle payment options', () {
      final struct = PaymentOptionsStruct(acceptsDebitCards: true);
      expect(struct.acceptsDebitCards, isTrue);
      
      struct.acceptsDebitCards = false;
      expect(struct.acceptsDebitCards, isFalse);
      
      struct.acceptsDebitCards = true;
      expect(struct.acceptsDebitCards, isTrue);
    });
  });
}
