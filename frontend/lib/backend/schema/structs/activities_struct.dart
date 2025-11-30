// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ActivitiesStruct extends FFFirebaseStruct {
  ActivitiesStruct({
    List<RestaurantStruct>? liked,
    List<RestaurantStruct>? saved,
    List<RestaurantStruct>? visited,
    List<RestaurantStruct>? disliked,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _liked = liked,
        _saved = saved,
        _visited = visited,
        _disliked = disliked,
        super(firestoreUtilData);

  // "liked" field.
  List<RestaurantStruct>? _liked;
  List<RestaurantStruct> get liked => _liked ?? const [];
  set liked(List<RestaurantStruct>? val) => _liked = val;

  void updateLiked(Function(List<RestaurantStruct>) updateFn) {
    updateFn(_liked ??= []);
  }

  bool hasLiked() => _liked != null;

  // "saved" field.
  List<RestaurantStruct>? _saved;
  List<RestaurantStruct> get saved => _saved ?? const [];
  set saved(List<RestaurantStruct>? val) => _saved = val;

  void updateSaved(Function(List<RestaurantStruct>) updateFn) {
    updateFn(_saved ??= []);
  }

  bool hasSaved() => _saved != null;

  // "visited" field.
  List<RestaurantStruct>? _visited;
  List<RestaurantStruct> get visited => _visited ?? const [];
  set visited(List<RestaurantStruct>? val) => _visited = val;

  void updateVisited(Function(List<RestaurantStruct>) updateFn) {
    updateFn(_visited ??= []);
  }

  bool hasVisited() => _visited != null;

  // "disliked" field.
  List<RestaurantStruct>? _disliked;
  List<RestaurantStruct> get disliked => _disliked ?? const [];
  set disliked(List<RestaurantStruct>? val) => _disliked = val;

  void updateDisliked(Function(List<RestaurantStruct>) updateFn) {
    updateFn(_disliked ??= []);
  }

  bool hasDisliked() => _disliked != null;

  static ActivitiesStruct fromMap(Map<String, dynamic> data) =>
      ActivitiesStruct(
        liked: getStructList(
          data['liked'],
          RestaurantStruct.fromMap,
        ),
        saved: getStructList(
          data['saved'],
          RestaurantStruct.fromMap,
        ),
        visited: getStructList(
          data['visited'],
          RestaurantStruct.fromMap,
        ),
        disliked: getStructList(
          data['disliked'],
          RestaurantStruct.fromMap,
        ),
      );

  static ActivitiesStruct? maybeFromMap(dynamic data) => data is Map
      ? ActivitiesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'liked': _liked?.map((e) => e.toMap()).toList(),
        'saved': _saved?.map((e) => e.toMap()).toList(),
        'visited': _visited?.map((e) => e.toMap()).toList(),
        'disliked': _disliked?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'liked': serializeParam(
          _liked,
          ParamType.DataStruct,
          isList: true,
        ),
        'saved': serializeParam(
          _saved,
          ParamType.DataStruct,
          isList: true,
        ),
        'visited': serializeParam(
          _visited,
          ParamType.DataStruct,
          isList: true,
        ),
        'disliked': serializeParam(
          _disliked,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static ActivitiesStruct fromSerializableMap(Map<String, dynamic> data) =>
      ActivitiesStruct(
        liked: deserializeStructParam<RestaurantStruct>(
          data['liked'],
          ParamType.DataStruct,
          true,
          structBuilder: RestaurantStruct.fromSerializableMap,
        ),
        saved: deserializeStructParam<RestaurantStruct>(
          data['saved'],
          ParamType.DataStruct,
          true,
          structBuilder: RestaurantStruct.fromSerializableMap,
        ),
        visited: deserializeStructParam<RestaurantStruct>(
          data['visited'],
          ParamType.DataStruct,
          true,
          structBuilder: RestaurantStruct.fromSerializableMap,
        ),
        disliked: deserializeStructParam<RestaurantStruct>(
          data['disliked'],
          ParamType.DataStruct,
          true,
          structBuilder: RestaurantStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'ActivitiesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ActivitiesStruct &&
        listEquality.equals(liked, other.liked) &&
        listEquality.equals(saved, other.saved) &&
        listEquality.equals(visited, other.visited) &&
        listEquality.equals(disliked, other.disliked);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([liked, saved, visited, disliked]);
}

ActivitiesStruct createActivitiesStruct({
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ActivitiesStruct(
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ActivitiesStruct? updateActivitiesStruct(
  ActivitiesStruct? activities, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    activities
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addActivitiesStructData(
  Map<String, dynamic> firestoreData,
  ActivitiesStruct? activities,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (activities == null) {
    return;
  }
  if (activities.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && activities.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final activitiesData = getActivitiesFirestoreData(activities, forFieldValue);
  final nestedData = activitiesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = activities.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getActivitiesFirestoreData(
  ActivitiesStruct? activities, [
  bool forFieldValue = false,
]) {
  if (activities == null) {
    return {};
  }
  final firestoreData = mapToFirestore(activities.toMap());

  // Add any Firestore field values
  activities.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getActivitiesListFirestoreData(
  List<ActivitiesStruct>? activitiess,
) =>
    activitiess?.map((e) => getActivitiesFirestoreData(e, true)).toList() ?? [];
