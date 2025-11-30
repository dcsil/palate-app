import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:convert';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'search_widget.dart' show SearchWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchModel extends FlutterFlowModel<SearchWidget> {
  ///  Local state fields for this page.

  List<String> placeIDs = [];
  void addToPlaceIDs(String item) => placeIDs.add(item);
  void removeFromPlaceIDs(String item) => placeIDs.remove(item);
  void removeAtIndexFromPlaceIDs(int index) => placeIDs.removeAt(index);
  void insertAtIndexInPlaceIDs(int index, String item) =>
      placeIDs.insert(index, item);
  void updatePlaceIDsAtIndex(int index, Function(String) updateFn) =>
      placeIDs[index] = updateFn(placeIDs[index]);

  List<RestaurantStruct> restaurants = [];
  void addToRestaurants(RestaurantStruct item) => restaurants.add(item);
  void removeFromRestaurants(RestaurantStruct item) => restaurants.remove(item);
  void removeAtIndexFromRestaurants(int index) => restaurants.removeAt(index);
  void insertAtIndexInRestaurants(int index, RestaurantStruct item) =>
      restaurants.insert(index, item);
  void updateRestaurantsAtIndex(
          int index, Function(RestaurantStruct) updateFn) =>
      restaurants[index] = updateFn(restaurants[index]);

  int? count;

  bool loaded = false;

  String loadingText = 'Find your next spot...';

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (search_agent_search_post)] action in TextField widget.
  ApiCallResponse? apisearchoutput;
  // Stores action output result for [Backend Call - API (Get Multiple Details)] action in TextField widget.
  ApiCallResponse? apidetailsoutput;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
