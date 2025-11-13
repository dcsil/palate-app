import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'onboarding3_copy_widget.dart' show Onboarding3CopyWidget;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Onboarding3CopyModel extends FlutterFlowModel<Onboarding3CopyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue1;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue2;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue3;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue4;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue5;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue6;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue7;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue8;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue9;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue10;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue11;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue12;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue13;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue14;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue15;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue16;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue17;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue18;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue19;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue20;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue21;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue22;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue23;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue24;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue25;
  // State field(s) for CheckboxListTile widget.
  bool? checkboxListTileValue26;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
