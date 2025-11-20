// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PeriodsStruct extends FFFirebaseStruct {
  PeriodsStruct({
    OpenStruct? open,
    CloseStruct? close,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _open = open,
        _close = close,
        super(firestoreUtilData);

  // "open" field.
  OpenStruct? _open;
  OpenStruct get open => _open ?? OpenStruct();
  set open(OpenStruct? val) => _open = val;

  void updateOpen(Function(OpenStruct) updateFn) {
    updateFn(_open ??= OpenStruct());
  }

  bool hasOpen() => _open != null;

  // "close" field.
  CloseStruct? _close;
  CloseStruct get close => _close ?? CloseStruct();
  set close(CloseStruct? val) => _close = val;

  void updateClose(Function(CloseStruct) updateFn) {
    updateFn(_close ??= CloseStruct());
  }

  bool hasClose() => _close != null;

  static PeriodsStruct fromMap(Map<String, dynamic> data) => PeriodsStruct(
        open: data['open'] is OpenStruct
            ? data['open']
            : OpenStruct.maybeFromMap(data['open']),
        close: data['close'] is CloseStruct
            ? data['close']
            : CloseStruct.maybeFromMap(data['close']),
      );

  static PeriodsStruct? maybeFromMap(dynamic data) =>
      data is Map ? PeriodsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'open': _open?.toMap(),
        'close': _close?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'open': serializeParam(
          _open,
          ParamType.DataStruct,
        ),
        'close': serializeParam(
          _close,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static PeriodsStruct fromSerializableMap(Map<String, dynamic> data) =>
      PeriodsStruct(
        open: deserializeStructParam(
          data['open'],
          ParamType.DataStruct,
          false,
          structBuilder: OpenStruct.fromSerializableMap,
        ),
        close: deserializeStructParam(
          data['close'],
          ParamType.DataStruct,
          false,
          structBuilder: CloseStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'PeriodsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PeriodsStruct && open == other.open && close == other.close;
  }

  @override
  int get hashCode => const ListEquality().hash([open, close]);
}

PeriodsStruct createPeriodsStruct({
  OpenStruct? open,
  CloseStruct? close,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PeriodsStruct(
      open: open ?? (clearUnsetFields ? OpenStruct() : null),
      close: close ?? (clearUnsetFields ? CloseStruct() : null),
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PeriodsStruct? updatePeriodsStruct(
  PeriodsStruct? periods, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    periods
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPeriodsStructData(
  Map<String, dynamic> firestoreData,
  PeriodsStruct? periods,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (periods == null) {
    return;
  }
  if (periods.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && periods.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final periodsData = getPeriodsFirestoreData(periods, forFieldValue);
  final nestedData = periodsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = periods.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPeriodsFirestoreData(
  PeriodsStruct? periods, [
  bool forFieldValue = false,
]) {
  if (periods == null) {
    return {};
  }
  final firestoreData = mapToFirestore(periods.toMap());

  // Handle nested data for "open" field.
  addOpenStructData(
    firestoreData,
    periods.hasOpen() ? periods.open : null,
    'open',
    forFieldValue,
  );

  // Handle nested data for "close" field.
  addCloseStructData(
    firestoreData,
    periods.hasClose() ? periods.close : null,
    'close',
    forFieldValue,
  );

  // Add any Firestore field values
  periods.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPeriodsListFirestoreData(
  List<PeriodsStruct>? periodss,
) =>
    periodss?.map((e) => getPeriodsFirestoreData(e, true)).toList() ?? [];
