// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ListOfImagePathsStruct extends FFFirebaseStruct {
  ListOfImagePathsStruct({
    List<String>? imgPaths,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _imgPaths = imgPaths,
        super(firestoreUtilData);

  // "imgPaths" field.
  List<String>? _imgPaths;
  List<String> get imgPaths => _imgPaths ?? const [];
  set imgPaths(List<String>? val) => _imgPaths = val;

  void updateImgPaths(Function(List<String>) updateFn) {
    updateFn(_imgPaths ??= []);
  }

  bool hasImgPaths() => _imgPaths != null;

  static ListOfImagePathsStruct fromMap(Map<String, dynamic> data) =>
      ListOfImagePathsStruct(
        imgPaths: getDataList(data['imgPaths']),
      );

  static ListOfImagePathsStruct? maybeFromMap(dynamic data) => data is Map
      ? ListOfImagePathsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'imgPaths': _imgPaths,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'imgPaths': serializeParam(
          _imgPaths,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static ListOfImagePathsStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ListOfImagePathsStruct(
        imgPaths: deserializeParam<String>(
          data['imgPaths'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'ListOfImagePathsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ListOfImagePathsStruct &&
        listEquality.equals(imgPaths, other.imgPaths);
  }

  @override
  int get hashCode => const ListEquality().hash([imgPaths]);
}

ListOfImagePathsStruct createListOfImagePathsStruct({
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ListOfImagePathsStruct(
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ListOfImagePathsStruct? updateListOfImagePathsStruct(
  ListOfImagePathsStruct? listOfImagePaths, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    listOfImagePaths
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addListOfImagePathsStructData(
  Map<String, dynamic> firestoreData,
  ListOfImagePathsStruct? listOfImagePaths,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (listOfImagePaths == null) {
    return;
  }
  if (listOfImagePaths.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && listOfImagePaths.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final listOfImagePathsData =
      getListOfImagePathsFirestoreData(listOfImagePaths, forFieldValue);
  final nestedData =
      listOfImagePathsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = listOfImagePaths.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getListOfImagePathsFirestoreData(
  ListOfImagePathsStruct? listOfImagePaths, [
  bool forFieldValue = false,
]) {
  if (listOfImagePaths == null) {
    return {};
  }
  final firestoreData = mapToFirestore(listOfImagePaths.toMap());

  // Add any Firestore field values
  listOfImagePaths.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getListOfImagePathsListFirestoreData(
  List<ListOfImagePathsStruct>? listOfImagePathss,
) =>
    listOfImagePathss
        ?.map((e) => getListOfImagePathsFirestoreData(e, true))
        .toList() ??
    [];
