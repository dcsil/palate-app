import '/components/pc_navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'social_widget.dart' show SocialWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SocialModel extends FlutterFlowModel<SocialWidget> {
  ///  State fields for stateful widgets in this page.

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
