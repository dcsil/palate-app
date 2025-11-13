import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'questions_widget.dart' show QuestionsWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class QuestionsModel extends FlutterFlowModel<QuestionsWidget> {
  ///  Local state fields for this page.

  List<int> answers = [0, 0, 0, 0, 0, 0, 0, 0];
  void addToAnswers(int item) => answers.add(item);
  void removeFromAnswers(int item) => answers.remove(item);
  void removeAtIndexFromAnswers(int index) => answers.removeAt(index);
  void insertAtIndexInAnswers(int index, int item) =>
      answers.insert(index, item);
  void updateAnswersAtIndex(int index, Function(int) updateFn) =>
      answers[index] = updateFn(answers[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
