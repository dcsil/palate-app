import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:math';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'hashtags_model.dart';
export 'hashtags_model.dart';

class HashtagsWidget extends StatefulWidget {
  const HashtagsWidget({
    super.key,
    this.parameter1,
  });

  final List<String>? parameter1;

  @override
  State<HashtagsWidget> createState() => _HashtagsWidgetState();
}

class _HashtagsWidgetState extends State<HashtagsWidget>
    with TickerProviderStateMixin {
  late HashtagsModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HashtagsModel());

    animationsMap.addAll({
      'choiceChipsOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.linear,
            delay: 0.0.ms,
            duration: 5200.0.ms,
            begin: Offset(0.0, 0.0),
            end: Offset(-100.0, 0.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterFlowChoiceChips(
      options: widget!.parameter1!.map((label) => ChipData(label)).toList(),
      onChanged: true
          ? null
          : (val) =>
              safeSetState(() => _model.choiceChipsValue = val?.firstOrNull),
      selectedChipStyle: ChipStyle(
        backgroundColor: Color(0xFF57636C),
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              color: FlutterFlowTheme.of(context).info,
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        iconColor: FlutterFlowTheme.of(context).info,
        iconSize: 16.0,
        elevation: 0.0,
        borderRadius: BorderRadius.circular(24.0),
      ),
      unselectedChipStyle: ChipStyle(
        backgroundColor: Color(0xFF2F2F2F),
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              color: Colors.white,
              fontSize: 12.0,
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
        iconColor: FlutterFlowTheme.of(context).secondaryText,
        iconSize: 16.0,
        elevation: 0.0,
        borderRadius: BorderRadius.circular(24.0),
      ),
      chipSpacing: 8.0,
      rowSpacing: 8.0,
      multiselect: false,
      alignment: WrapAlignment.start,
      controller: _model.choiceChipsValueController ??=
          FormFieldController<List<String>>(
        [],
      ),
      disabledColor: Color(0x6E57636C),
      wrapped: false,
    ).animateOnPageLoad(animationsMap['choiceChipsOnPageLoadAnimation']!);
  }
}
