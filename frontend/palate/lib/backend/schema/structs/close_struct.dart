// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CloseStruct extends FFFirebaseStruct {
  CloseStruct({
    int? day,
    int? minute,
    int? hour,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _day = day,
        _minute = minute,
        _hour = hour,
        super(firestoreUtilData);

  // "day" field.
  int? _day;
  int get day => _day ?? 0;
  set day(int? val) => _day = val;

  void incrementDay(int amount) => day = day + amount;

  bool hasDay() => _day != null;

  // "minute" field.
  int? _minute;
  int get minute => _minute ?? 0;
  set minute(int? val) => _minute = val;

  void incrementMinute(int amount) => minute = minute + amount;

  bool hasMinute() => _minute != null;

  // "hour" field.
  int? _hour;
  int get hour => _hour ?? 0;
  set hour(int? val) => _hour = val;

  void incrementHour(int amount) => hour = hour + amount;

  bool hasHour() => _hour != null;

  static CloseStruct fromMap(Map<String, dynamic> data) => CloseStruct(
        day: castToType<int>(data['day']),
        minute: castToType<int>(data['minute']),
        hour: castToType<int>(data['hour']),
      );

  static CloseStruct? maybeFromMap(dynamic data) =>
      data is Map ? CloseStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'day': _day,
        'minute': _minute,
        'hour': _hour,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'day': serializeParam(
          _day,
          ParamType.int,
        ),
        'minute': serializeParam(
          _minute,
          ParamType.int,
        ),
        'hour': serializeParam(
          _hour,
          ParamType.int,
        ),
      }.withoutNulls;

  static CloseStruct fromSerializableMap(Map<String, dynamic> data) =>
      CloseStruct(
        day: deserializeParam(
          data['day'],
          ParamType.int,
          false,
        ),
        minute: deserializeParam(
          data['minute'],
          ParamType.int,
          false,
        ),
        hour: deserializeParam(
          data['hour'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'CloseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CloseStruct &&
        day == other.day &&
        minute == other.minute &&
        hour == other.hour;
  }

  @override
  int get hashCode => const ListEquality().hash([day, minute, hour]);
}

CloseStruct createCloseStruct({
  int? day,
  int? minute,
  int? hour,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CloseStruct(
      day: day,
      minute: minute,
      hour: hour,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CloseStruct? updateCloseStruct(
  CloseStruct? close, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    close
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCloseStructData(
  Map<String, dynamic> firestoreData,
  CloseStruct? close,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (close == null) {
    return;
  }
  if (close.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && close.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final closeData = getCloseFirestoreData(close, forFieldValue);
  final nestedData = closeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = close.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCloseFirestoreData(
  CloseStruct? close, [
  bool forFieldValue = false,
]) {
  if (close == null) {
    return {};
  }
  final firestoreData = mapToFirestore(close.toMap());

  // Add any Firestore field values
  close.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCloseListFirestoreData(
  List<CloseStruct>? closes,
) =>
    closes?.map((e) => getCloseFirestoreData(e, true)).toList() ?? [];
