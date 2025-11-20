// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RegularOpeningHoursStruct extends FFFirebaseStruct {
  RegularOpeningHoursStruct({
    String? nextOpenTime,
    bool? openNow,
    List<PeriodsStruct>? periods,
    List<String>? weekdayDescriptions,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _nextOpenTime = nextOpenTime,
        _openNow = openNow,
        _periods = periods,
        _weekdayDescriptions = weekdayDescriptions,
        super(firestoreUtilData);

  // "nextOpenTime" field.
  String? _nextOpenTime;
  String get nextOpenTime => _nextOpenTime ?? '';
  set nextOpenTime(String? val) => _nextOpenTime = val;

  bool hasNextOpenTime() => _nextOpenTime != null;

  // "openNow" field.
  bool? _openNow;
  bool get openNow => _openNow ?? false;
  set openNow(bool? val) => _openNow = val;

  bool hasOpenNow() => _openNow != null;

  // "periods" field.
  List<PeriodsStruct>? _periods;
  List<PeriodsStruct> get periods => _periods ?? const [];
  set periods(List<PeriodsStruct>? val) => _periods = val;

  void updatePeriods(Function(List<PeriodsStruct>) updateFn) {
    updateFn(_periods ??= []);
  }

  bool hasPeriods() => _periods != null;

  // "weekdayDescriptions" field.
  List<String>? _weekdayDescriptions;
  List<String> get weekdayDescriptions => _weekdayDescriptions ?? const [];
  set weekdayDescriptions(List<String>? val) => _weekdayDescriptions = val;

  void updateWeekdayDescriptions(Function(List<String>) updateFn) {
    updateFn(_weekdayDescriptions ??= []);
  }

  bool hasWeekdayDescriptions() => _weekdayDescriptions != null;

  static RegularOpeningHoursStruct fromMap(Map<String, dynamic> data) =>
      RegularOpeningHoursStruct(
        nextOpenTime: data['nextOpenTime'] as String?,
        openNow: data['openNow'] as bool?,
        periods: getStructList(
          data['periods'],
          PeriodsStruct.fromMap,
        ),
        weekdayDescriptions: getDataList(data['weekdayDescriptions']),
      );

  static RegularOpeningHoursStruct? maybeFromMap(dynamic data) => data is Map
      ? RegularOpeningHoursStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nextOpenTime': _nextOpenTime,
        'openNow': _openNow,
        'periods': _periods?.map((e) => e.toMap()).toList(),
        'weekdayDescriptions': _weekdayDescriptions,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nextOpenTime': serializeParam(
          _nextOpenTime,
          ParamType.String,
        ),
        'openNow': serializeParam(
          _openNow,
          ParamType.bool,
        ),
        'periods': serializeParam(
          _periods,
          ParamType.DataStruct,
          isList: true,
        ),
        'weekdayDescriptions': serializeParam(
          _weekdayDescriptions,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static RegularOpeningHoursStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      RegularOpeningHoursStruct(
        nextOpenTime: deserializeParam(
          data['nextOpenTime'],
          ParamType.String,
          false,
        ),
        openNow: deserializeParam(
          data['openNow'],
          ParamType.bool,
          false,
        ),
        periods: deserializeStructParam<PeriodsStruct>(
          data['periods'],
          ParamType.DataStruct,
          true,
          structBuilder: PeriodsStruct.fromSerializableMap,
        ),
        weekdayDescriptions: deserializeParam<String>(
          data['weekdayDescriptions'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'RegularOpeningHoursStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is RegularOpeningHoursStruct &&
        nextOpenTime == other.nextOpenTime &&
        openNow == other.openNow &&
        listEquality.equals(periods, other.periods) &&
        listEquality.equals(weekdayDescriptions, other.weekdayDescriptions);
  }

  @override
  int get hashCode => const ListEquality()
      .hash([nextOpenTime, openNow, periods, weekdayDescriptions]);
}

RegularOpeningHoursStruct createRegularOpeningHoursStruct({
  String? nextOpenTime,
  bool? openNow,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RegularOpeningHoursStruct(
      nextOpenTime: nextOpenTime,
      openNow: openNow,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RegularOpeningHoursStruct? updateRegularOpeningHoursStruct(
  RegularOpeningHoursStruct? regularOpeningHours, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    regularOpeningHours
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRegularOpeningHoursStructData(
  Map<String, dynamic> firestoreData,
  RegularOpeningHoursStruct? regularOpeningHours,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (regularOpeningHours == null) {
    return;
  }
  if (regularOpeningHours.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && regularOpeningHours.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final regularOpeningHoursData =
      getRegularOpeningHoursFirestoreData(regularOpeningHours, forFieldValue);
  final nestedData =
      regularOpeningHoursData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      regularOpeningHours.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRegularOpeningHoursFirestoreData(
  RegularOpeningHoursStruct? regularOpeningHours, [
  bool forFieldValue = false,
]) {
  if (regularOpeningHours == null) {
    return {};
  }
  final firestoreData = mapToFirestore(regularOpeningHours.toMap());

  // Add any Firestore field values
  regularOpeningHours.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRegularOpeningHoursListFirestoreData(
  List<RegularOpeningHoursStruct>? regularOpeningHourss,
) =>
    regularOpeningHourss
        ?.map((e) => getRegularOpeningHoursFirestoreData(e, true))
        .toList() ??
    [];
