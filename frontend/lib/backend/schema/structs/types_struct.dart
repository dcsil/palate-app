// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TypesStruct extends FFFirebaseStruct {
  TypesStruct({
    List<String>? type,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _type = type,
        super(firestoreUtilData);

  // "type" field.
  List<String>? _type;
  List<String> get type => _type ?? const [];
  set type(List<String>? val) => _type = val;

  void updateType(Function(List<String>) updateFn) {
    updateFn(_type ??= []);
  }

  bool hasType() => _type != null;

  static TypesStruct fromMap(Map<String, dynamic> data) => TypesStruct(
        type: getDataList(data['type']),
      );

  static TypesStruct? maybeFromMap(dynamic data) =>
      data is Map ? TypesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'type': _type,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'type': serializeParam(
          _type,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static TypesStruct fromSerializableMap(Map<String, dynamic> data) =>
      TypesStruct(
        type: deserializeParam<String>(
          data['type'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'TypesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is TypesStruct && listEquality.equals(type, other.type);
  }

  @override
  int get hashCode => const ListEquality().hash([type]);
}

TypesStruct createTypesStruct({
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    TypesStruct(
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

TypesStruct? updateTypesStruct(
  TypesStruct? types, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    types
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addTypesStructData(
  Map<String, dynamic> firestoreData,
  TypesStruct? types,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (types == null) {
    return;
  }
  if (types.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && types.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final typesData = getTypesFirestoreData(types, forFieldValue);
  final nestedData = typesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = types.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getTypesFirestoreData(
  TypesStruct? types, [
  bool forFieldValue = false,
]) {
  if (types == null) {
    return {};
  }
  final firestoreData = mapToFirestore(types.toMap());

  // Add any Firestore field values
  types.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getTypesListFirestoreData(
  List<TypesStruct>? typess,
) =>
    typess?.map((e) => getTypesFirestoreData(e, true)).toList() ?? [];
