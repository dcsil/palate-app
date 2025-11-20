import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/carousel_widget.dart';
import '/components/pc_navbar_widget.dart';
import '/components/popup_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'home_page_widget.dart' show HomePageWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  bool isLoaded = false;

  List<DocumentReference> resDocRefs = [];
  void addToResDocRefs(DocumentReference item) => resDocRefs.add(item);
  void removeFromResDocRefs(DocumentReference item) => resDocRefs.remove(item);
  void removeAtIndexFromResDocRefs(int index) => resDocRefs.removeAt(index);
  void insertAtIndexInResDocRefs(int index, DocumentReference item) =>
      resDocRefs.insert(index, item);
  void updateResDocRefsAtIndex(
          int index, Function(DocumentReference) updateFn) =>
      resDocRefs[index] = updateFn(resDocRefs[index]);

  int currentBatch = 0;

  List<String> placeIDs = [];
  void addToPlaceIDs(String item) => placeIDs.add(item);
  void removeFromPlaceIDs(String item) => placeIDs.remove(item);
  void removeAtIndexFromPlaceIDs(int index) => placeIDs.removeAt(index);
  void insertAtIndexInPlaceIDs(int index, String item) =>
      placeIDs.insert(index, item);
  void updatePlaceIDsAtIndex(int index, Function(String) updateFn) =>
      placeIDs[index] = updateFn(placeIDs[index]);

  bool secondscall = false;

  int counter = 0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (Search Nearby)] action in HomePage widget.
  ApiCallResponse? searchNearbyOutput;
  // Stores action output result for [Backend Call - API (Get Multiple Details)] action in HomePage widget.
  ApiCallResponse? resDetailsOutput;
  // Stores action output result for [Backend Call - API (Get Location Info)] action in HomePage widget.
  ApiCallResponse? locationApiOutput;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Stores action output result for [Backend Call - API (Get Multiple Details)] action in PageView widget.
  ApiCallResponse? sequentialOutput;
  // Model for pcNavbar component.
  late PcNavbarModel pcNavbarModel;

  @override
  void initState(BuildContext context) {
    pcNavbarModel = createModel(context, () => PcNavbarModel());
  }

  @override
  void dispose() {
    pcNavbarModel.dispose();
  }
}
