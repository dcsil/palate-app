// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PaymentOptionsStruct extends FFFirebaseStruct {
  PaymentOptionsStruct({
    bool? acceptsDebitCards,
    bool? acceptsCreditCards,
    bool? acceptsCashOnly,
    bool? acceptsNfc,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _acceptsDebitCards = acceptsDebitCards,
        _acceptsCreditCards = acceptsCreditCards,
        _acceptsCashOnly = acceptsCashOnly,
        _acceptsNfc = acceptsNfc,
        super(firestoreUtilData);

  // "acceptsDebitCards" field.
  bool? _acceptsDebitCards;
  bool get acceptsDebitCards => _acceptsDebitCards ?? false;
  set acceptsDebitCards(bool? val) => _acceptsDebitCards = val;

  bool hasAcceptsDebitCards() => _acceptsDebitCards != null;

  // "acceptsCreditCards" field.
  bool? _acceptsCreditCards;
  bool get acceptsCreditCards => _acceptsCreditCards ?? false;
  set acceptsCreditCards(bool? val) => _acceptsCreditCards = val;

  bool hasAcceptsCreditCards() => _acceptsCreditCards != null;

  // "acceptsCashOnly" field.
  bool? _acceptsCashOnly;
  bool get acceptsCashOnly => _acceptsCashOnly ?? false;
  set acceptsCashOnly(bool? val) => _acceptsCashOnly = val;

  bool hasAcceptsCashOnly() => _acceptsCashOnly != null;

  // "acceptsNfc" field.
  bool? _acceptsNfc;
  bool get acceptsNfc => _acceptsNfc ?? false;
  set acceptsNfc(bool? val) => _acceptsNfc = val;

  bool hasAcceptsNfc() => _acceptsNfc != null;

  static PaymentOptionsStruct fromMap(Map<String, dynamic> data) =>
      PaymentOptionsStruct(
        acceptsDebitCards: data['acceptsDebitCards'] as bool?,
        acceptsCreditCards: data['acceptsCreditCards'] as bool?,
        acceptsCashOnly: data['acceptsCashOnly'] as bool?,
        acceptsNfc: data['acceptsNfc'] as bool?,
      );

  static PaymentOptionsStruct? maybeFromMap(dynamic data) => data is Map
      ? PaymentOptionsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'acceptsDebitCards': _acceptsDebitCards,
        'acceptsCreditCards': _acceptsCreditCards,
        'acceptsCashOnly': _acceptsCashOnly,
        'acceptsNfc': _acceptsNfc,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'acceptsDebitCards': serializeParam(
          _acceptsDebitCards,
          ParamType.bool,
        ),
        'acceptsCreditCards': serializeParam(
          _acceptsCreditCards,
          ParamType.bool,
        ),
        'acceptsCashOnly': serializeParam(
          _acceptsCashOnly,
          ParamType.bool,
        ),
        'acceptsNfc': serializeParam(
          _acceptsNfc,
          ParamType.bool,
        ),
      }.withoutNulls;

  static PaymentOptionsStruct fromSerializableMap(Map<String, dynamic> data) =>
      PaymentOptionsStruct(
        acceptsDebitCards: deserializeParam(
          data['acceptsDebitCards'],
          ParamType.bool,
          false,
        ),
        acceptsCreditCards: deserializeParam(
          data['acceptsCreditCards'],
          ParamType.bool,
          false,
        ),
        acceptsCashOnly: deserializeParam(
          data['acceptsCashOnly'],
          ParamType.bool,
          false,
        ),
        acceptsNfc: deserializeParam(
          data['acceptsNfc'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'PaymentOptionsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PaymentOptionsStruct &&
        acceptsDebitCards == other.acceptsDebitCards &&
        acceptsCreditCards == other.acceptsCreditCards &&
        acceptsCashOnly == other.acceptsCashOnly &&
        acceptsNfc == other.acceptsNfc;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [acceptsDebitCards, acceptsCreditCards, acceptsCashOnly, acceptsNfc]);
}

PaymentOptionsStruct createPaymentOptionsStruct({
  bool? acceptsDebitCards,
  bool? acceptsCreditCards,
  bool? acceptsCashOnly,
  bool? acceptsNfc,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PaymentOptionsStruct(
      acceptsDebitCards: acceptsDebitCards,
      acceptsCreditCards: acceptsCreditCards,
      acceptsCashOnly: acceptsCashOnly,
      acceptsNfc: acceptsNfc,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PaymentOptionsStruct? updatePaymentOptionsStruct(
  PaymentOptionsStruct? paymentOptions, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    paymentOptions
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPaymentOptionsStructData(
  Map<String, dynamic> firestoreData,
  PaymentOptionsStruct? paymentOptions,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (paymentOptions == null) {
    return;
  }
  if (paymentOptions.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && paymentOptions.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final paymentOptionsData =
      getPaymentOptionsFirestoreData(paymentOptions, forFieldValue);
  final nestedData =
      paymentOptionsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = paymentOptions.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPaymentOptionsFirestoreData(
  PaymentOptionsStruct? paymentOptions, [
  bool forFieldValue = false,
]) {
  if (paymentOptions == null) {
    return {};
  }
  final firestoreData = mapToFirestore(paymentOptions.toMap());

  // Add any Firestore field values
  paymentOptions.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPaymentOptionsListFirestoreData(
  List<PaymentOptionsStruct>? paymentOptionss,
) =>
    paymentOptionss
        ?.map((e) => getPaymentOptionsFirestoreData(e, true))
        .toList() ??
    [];
