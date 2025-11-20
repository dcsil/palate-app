// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EditorialSummaryStruct extends FFFirebaseStruct {
  EditorialSummaryStruct({
    String? langaugeCode,
    String? text,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _langaugeCode = langaugeCode,
        _text = text,
        super(firestoreUtilData);

  // "langaugeCode" field.
  String? _langaugeCode;
  String get langaugeCode => _langaugeCode ?? '';
  set langaugeCode(String? val) => _langaugeCode = val;

  bool hasLangaugeCode() => _langaugeCode != null;

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  set text(String? val) => _text = val;

  bool hasText() => _text != null;

  static EditorialSummaryStruct fromMap(Map<String, dynamic> data) =>
      EditorialSummaryStruct(
        langaugeCode: data['langaugeCode'] as String?,
        text: data['text'] as String?,
      );

  static EditorialSummaryStruct? maybeFromMap(dynamic data) => data is Map
      ? EditorialSummaryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'langaugeCode': _langaugeCode,
        'text': _text,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'langaugeCode': serializeParam(
          _langaugeCode,
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
        langaugeCode: deserializeParam(
          data['langaugeCode'],
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
        langaugeCode == other.langaugeCode &&
        text == other.text;
  }

  @override
  int get hashCode => const ListEquality().hash([langaugeCode, text]);
}

EditorialSummaryStruct createEditorialSummaryStruct({
  String? langaugeCode,
  String? text,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    EditorialSummaryStruct(
      langaugeCode: langaugeCode,
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
