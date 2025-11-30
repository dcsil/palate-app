import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'recommendations_widget.dart' show RecommendationsWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RecommendationsModel extends FlutterFlowModel<RecommendationsWidget> {
  ///  Local state fields for this page.

  List<String> rankedPlaceIDs = [];
  void addToRankedPlaceIDs(String item) => rankedPlaceIDs.add(item);
  void removeFromRankedPlaceIDs(String item) => rankedPlaceIDs.remove(item);
  void removeAtIndexFromRankedPlaceIDs(int index) =>
      rankedPlaceIDs.removeAt(index);
  void insertAtIndexInRankedPlaceIDs(int index, String item) =>
      rankedPlaceIDs.insert(index, item);
  void updateRankedPlaceIDsAtIndex(int index, Function(String) updateFn) =>
      rankedPlaceIDs[index] = updateFn(rankedPlaceIDs[index]);

  bool isLoading = true;

  String displayText = 'Checking preferences...';

  List<String> justifications = [];
  void addToJustifications(String item) => justifications.add(item);
  void removeFromJustifications(String item) => justifications.remove(item);
  void removeAtIndexFromJustifications(int index) =>
      justifications.removeAt(index);
  void insertAtIndexInJustifications(int index, String item) =>
      justifications.insert(index, item);
  void updateJustificationsAtIndex(int index, Function(String) updateFn) =>
      justifications[index] = updateFn(justifications[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (Search Nearby)] action in recommendations widget.
  ApiCallResponse? searchNearby;
  // Stores action output result for [Backend Call - API (agentrank)] action in recommendations widget.
  ApiCallResponse? agentRank;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
