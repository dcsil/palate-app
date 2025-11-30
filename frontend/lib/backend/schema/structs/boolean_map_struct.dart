// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BooleanMapStruct extends FFFirebaseStruct {
  BooleanMapStruct({
    String? key,
    bool? value,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _key = key,
        _value = value,
        super(firestoreUtilData);

  // "key" field.
  String? _key;
  String get key => _key ?? '';
  set key(String? val) => _key = val;

  bool hasKey() => _key != null;

  // "value" field.
  bool? _value;
  bool get value => _value ?? false;
  set value(bool? val) => _value = val;

  bool hasValue() => _value != null;

  static BooleanMapStruct fromMap(Map<String, dynamic> data) =>
      BooleanMapStruct(
        key: data['key'] as String?,
        value: data['value'] as bool?,
      );

  static BooleanMapStruct? maybeFromMap(dynamic data) => data is Map
      ? BooleanMapStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'key': _key,
        'value': _value,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'key': serializeParam(
          _key,
          ParamType.String,
        ),
        'value': serializeParam(
          _value,
          ParamType.bool,
        ),
      }.withoutNulls;

  static BooleanMapStruct fromSerializableMap(Map<String, dynamic> data) =>
      BooleanMapStruct(
        key: deserializeParam(
          data['key'],
          ParamType.String,
          false,
        ),
        value: deserializeParam(
          data['value'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'BooleanMapStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is BooleanMapStruct &&
        key == other.key &&
        value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([key, value]);
}

BooleanMapStruct createBooleanMapStruct({
  String? key,
  bool? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    BooleanMapStruct(
      key: key,
      value: value,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

BooleanMapStruct? updateBooleanMapStruct(
  BooleanMapStruct? booleanMap, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    booleanMap
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addBooleanMapStructData(
  Map<String, dynamic> firestoreData,
  BooleanMapStruct? booleanMap,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (booleanMap == null) {
    return;
  }
  if (booleanMap.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && booleanMap.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final booleanMapData = getBooleanMapFirestoreData(booleanMap, forFieldValue);
  final nestedData = booleanMapData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = booleanMap.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getBooleanMapFirestoreData(
  BooleanMapStruct? booleanMap, [
  bool forFieldValue = false,
]) {
  if (booleanMap == null) {
    return {};
  }
  final firestoreData = mapToFirestore(booleanMap.toMap());

  // Add any Firestore field values
  booleanMap.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getBooleanMapListFirestoreData(
  List<BooleanMapStruct>? booleanMaps,
) =>
    booleanMaps?.map((e) => getBooleanMapFirestoreData(e, true)).toList() ?? [];
