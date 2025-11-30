// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EditorialSummaryStruct extends FFFirebaseStruct {
  EditorialSummaryStruct({
    String? languageCode,
    String? text,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _languageCode = languageCode,
        _text = text,
        super(firestoreUtilData);

  // "languageCode" field.
  String? _languageCode;
  String get languageCode => _languageCode ?? '';
  set languageCode(String? val) => _languageCode = val;

  bool hasLanguageCode() => _languageCode != null;

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  set text(String? val) => _text = val;

  bool hasText() => _text != null;

  static EditorialSummaryStruct fromMap(Map<String, dynamic> data) =>
      EditorialSummaryStruct(
        languageCode: data['languageCode'] as String?,
        text: data['text'] as String?,
      );

  static EditorialSummaryStruct? maybeFromMap(dynamic data) => data is Map
      ? EditorialSummaryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'languageCode': _languageCode,
        'text': _text,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'languageCode': serializeParam(
          _languageCode,
          ParamType.String,
        ),
        'text': serializeParam(
          _text,
          ParamType.String,
        ),
      }.withoutNulls;

  static EditorialSummaryStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      EditorialSummaryStruct(
        languageCode: deserializeParam(
          data['languageCode'],
          ParamType.String,
          false,
        ),
        text: deserializeParam(
          data['text'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'EditorialSummaryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is EditorialSummaryStruct &&
        languageCode == other.languageCode &&
        text == other.text;
  }

  @override
  int get hashCode => const ListEquality().hash([languageCode, text]);
}

EditorialSummaryStruct createEditorialSummaryStruct({
  String? languageCode,
  String? text,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    EditorialSummaryStruct(
      languageCode: languageCode,
      text: text,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

EditorialSummaryStruct? updateEditorialSummaryStruct(
  EditorialSummaryStruct? editorialSummary, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    editorialSummary
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addEditorialSummaryStructData(
  Map<String, dynamic> firestoreData,
  EditorialSummaryStruct? editorialSummary,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (editorialSummary == null) {
    return;
  }
  if (editorialSummary.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && editorialSummary.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final editorialSummaryData =
      getEditorialSummaryFirestoreData(editorialSummary, forFieldValue);
  final nestedData =
      editorialSummaryData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = editorialSummary.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getEditorialSummaryFirestoreData(
  EditorialSummaryStruct? editorialSummary, [
  bool forFieldValue = false,
]) {
  if (editorialSummary == null) {
    return {};
  }
  final firestoreData = mapToFirestore(editorialSummary.toMap());

  // Add any Firestore field values
  editorialSummary.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getEditorialSummaryListFirestoreData(
  List<EditorialSummaryStruct>? editorialSummarys,
) =>
    editorialSummarys
        ?.map((e) => getEditorialSummaryFirestoreData(e, true))
        .toList() ??
    [];
