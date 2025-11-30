// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NestedListofStringsStruct extends FFFirebaseStruct {
  NestedListofStringsStruct({
    List<String>? listOfStrings,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _listOfStrings = listOfStrings,
        super(firestoreUtilData);

  // "listOfStrings" field.
  List<String>? _listOfStrings;
  List<String> get listOfStrings => _listOfStrings ?? const [];
  set listOfStrings(List<String>? val) => _listOfStrings = val;

  void updateListOfStrings(Function(List<String>) updateFn) {
    updateFn(_listOfStrings ??= []);
  }

  bool hasListOfStrings() => _listOfStrings != null;

  static NestedListofStringsStruct fromMap(Map<String, dynamic> data) =>
      NestedListofStringsStruct(
        listOfStrings: getDataList(data['listOfStrings']),
      );

  static NestedListofStringsStruct? maybeFromMap(dynamic data) => data is Map
      ? NestedListofStringsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'listOfStrings': _listOfStrings,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'listOfStrings': serializeParam(
          _listOfStrings,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static NestedListofStringsStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      NestedListofStringsStruct(
        listOfStrings: deserializeParam<String>(
          data['listOfStrings'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'NestedListofStringsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is NestedListofStringsStruct &&
        listEquality.equals(listOfStrings, other.listOfStrings);
  }

  @override
  int get hashCode => const ListEquality().hash([listOfStrings]);
}

NestedListofStringsStruct createNestedListofStringsStruct({
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    NestedListofStringsStruct(
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

NestedListofStringsStruct? updateNestedListofStringsStruct(
  NestedListofStringsStruct? nestedListofStrings, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    nestedListofStrings
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addNestedListofStringsStructData(
  Map<String, dynamic> firestoreData,
  NestedListofStringsStruct? nestedListofStrings,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (nestedListofStrings == null) {
    return;
  }
  if (nestedListofStrings.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && nestedListofStrings.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final nestedListofStringsData =
      getNestedListofStringsFirestoreData(nestedListofStrings, forFieldValue);
  final nestedData =
      nestedListofStringsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      nestedListofStrings.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getNestedListofStringsFirestoreData(
  NestedListofStringsStruct? nestedListofStrings, [
  bool forFieldValue = false,
]) {
  if (nestedListofStrings == null) {
    return {};
  }
  final firestoreData = mapToFirestore(nestedListofStrings.toMap());

  // Add any Firestore field values
  nestedListofStrings.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getNestedListofStringsListFirestoreData(
  List<NestedListofStringsStruct>? nestedListofStringss,
) =>
    nestedListofStringss
        ?.map((e) => getNestedListofStringsFirestoreData(e, true))
        .toList() ??
    [];
