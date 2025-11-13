// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StringMapStruct extends FFFirebaseStruct {
  StringMapStruct({
    String? key,
    String? value,
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
  String? _value;
  String get value => _value ?? '';
  set value(String? val) => _value = val;

  bool hasValue() => _value != null;

  static StringMapStruct fromMap(Map<String, dynamic> data) => StringMapStruct(
        key: data['key'] as String?,
        value: data['value'] as String?,
      );

  static StringMapStruct? maybeFromMap(dynamic data) => data is Map
      ? StringMapStruct.fromMap(data.cast<String, dynamic>())
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
          ParamType.String,
        ),
      }.withoutNulls;

  static StringMapStruct fromSerializableMap(Map<String, dynamic> data) =>
      StringMapStruct(
        key: deserializeParam(
          data['key'],
          ParamType.String,
          false,
        ),
        value: deserializeParam(
          data['value'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'StringMapStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StringMapStruct && key == other.key && value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([key, value]);
}

StringMapStruct createStringMapStruct({
  String? key,
  String? value,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    StringMapStruct(
      key: key,
      value: value,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

StringMapStruct? updateStringMapStruct(
  StringMapStruct? stringMap, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    stringMap
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addStringMapStructData(
  Map<String, dynamic> firestoreData,
  StringMapStruct? stringMap,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (stringMap == null) {
    return;
  }
  if (stringMap.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && stringMap.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final stringMapData = getStringMapFirestoreData(stringMap, forFieldValue);
  final nestedData = stringMapData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = stringMap.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getStringMapFirestoreData(
  StringMapStruct? stringMap, [
  bool forFieldValue = false,
]) {
  if (stringMap == null) {
    return {};
  }
  final firestoreData = mapToFirestore(stringMap.toMap());

  // Add any Firestore field values
  stringMap.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getStringMapListFirestoreData(
  List<StringMapStruct>? stringMaps,
) =>
    stringMaps?.map((e) => getStringMapFirestoreData(e, true)).toList() ?? [];
