import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'myprofile_widget.dart' show MyprofileWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyprofileModel extends FlutterFlowModel<MyprofileWidget> {
  ///  Local state fields for this page.

  List<String> liked = [];
  void addToLiked(String item) => liked.add(item);
  void removeFromLiked(String item) => liked.remove(item);
  void removeAtIndexFromLiked(int index) => liked.removeAt(index);
  void insertAtIndexInLiked(int index, String item) =>
      liked.insert(index, item);
  void updateLikedAtIndex(int index, Function(String) updateFn) =>
      liked[index] = updateFn(liked[index]);

  List<String> saved = [];
  void addToSaved(String item) => saved.add(item);
  void removeFromSaved(String item) => saved.remove(item);
  void removeAtIndexFromSaved(int index) => saved.removeAt(index);
  void insertAtIndexInSaved(int index, String item) =>
      saved.insert(index, item);
  void updateSavedAtIndex(int index, Function(String) updateFn) =>
      saved[index] = updateFn(saved[index]);

  List<String> disliked = [];
  void addToDisliked(String item) => disliked.add(item);
  void removeFromDisliked(String item) => disliked.remove(item);
  void removeAtIndexFromDisliked(int index) => disliked.removeAt(index);
  void insertAtIndexInDisliked(int index, String item) =>
      disliked.insert(index, item);
  void updateDislikedAtIndex(int index, Function(String) updateFn) =>
      disliked[index] = updateFn(disliked[index]);

  List<String> visited = [];
  void addToVisited(String item) => visited.add(item);
  void removeFromVisited(String item) => visited.remove(item);
  void removeAtIndexFromVisited(int index) => visited.removeAt(index);
  void insertAtIndexInVisited(int index, String item) =>
      visited.insert(index, item);
  void updateVisitedAtIndex(int index, Function(String) updateFn) =>
      visited[index] = updateFn(visited[index]);

  bool loaded = false;

  String? archetype;

  ///  State fields for stateful widgets in this page.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController1;
  String? get choiceChipsValue1 =>
      choiceChipsValueController1?.value?.firstOrNull;
  set choiceChipsValue1(String? val) =>
      choiceChipsValueController1?.value = val != null ? [val] : [];
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController2;
  String? get choiceChipsValue2 =>
      choiceChipsValueController2?.value?.firstOrNull;
  set choiceChipsValue2(String? val) =>
      choiceChipsValueController2?.value = val != null ? [val] : [];
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController3;
  String? get choiceChipsValue3 =>
      choiceChipsValueController3?.value?.firstOrNull;
  set choiceChipsValue3(String? val) =>
      choiceChipsValueController3?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
