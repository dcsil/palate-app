import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/pc_navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:convert';
import 'dart:ui';
import '/index.dart';
import 'profile_widget.dart' show ProfileWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (Delete)] action in Button widget.
  ApiCallResponse? apiResulthl9;
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
