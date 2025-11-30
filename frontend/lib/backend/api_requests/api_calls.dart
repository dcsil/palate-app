import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_commons/api_requests/api_manager.dart';

import 'package:ff_commons/api_requests/api_paging_params.dart';

export 'package:ff_commons/api_requests/api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start Restaurant Search API Group Code

class RestaurantSearchAPIGroup {
  static String getBaseUrl() =>
      'https://cicd-restaurant-search-api-371653324669.us-central1.run.app/';
  static Map<String, String> headers = {};
  static RootGetCall rootGetCall = RootGetCall();
  static ResAPIHealthCall resAPIHealthCall = ResAPIHealthCall();
  static ReadinessReadyGetCall readinessReadyGetCall = ReadinessReadyGetCall();
  static GetLocationInfoCall getLocationInfoCall = GetLocationInfoCall();
  static SearchNearbyCall searchNearbyCall = SearchNearbyCall();
  static GetSingleDetailCall getSingleDetailCall = GetSingleDetailCall();
  static GetMultipleDetailsCall getMultipleDetailsCall =
      GetMultipleDetailsCall();
  static DeleteCall deleteCall = DeleteCall();
}

class RootGetCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = RestaurantSearchAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'root__get',
      apiUrl: '${baseUrl}/',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ResAPIHealthCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = RestaurantSearchAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'ResAPIHealth',
      apiUrl: '${baseUrl}/health',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ReadinessReadyGetCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = RestaurantSearchAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'readiness_ready_get',
      apiUrl: '${baseUrl}/ready',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetLocationInfoCall {
  Future<ApiCallResponse> call({
    double? latitude = 43.66204749676708,
    double? longitude = -79.39372718223954,
  }) async {
    final baseUrl = RestaurantSearchAPIGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "latitude": ${latitude},
  "longitude": ${longitude}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Location Info',
      apiUrl: '${baseUrl}/location',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? city(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.city''',
      ));
  String? neighborhood(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.neighborhood''',
      ));
}

class SearchNearbyCall {
  Future<ApiCallResponse> call({
    double? latitude = 43.66204749676708,
    double? longitude = -79.39372718223954,
    double? radiusKm,
  }) async {
    final baseUrl = RestaurantSearchAPIGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "center": {
    "latitude": ${latitude},
    "longitude": ${longitude}
  },
  "radius_km": ${radiusKm}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Search Nearby',
      apiUrl: '${baseUrl}/restaurants/search',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List<String>? docIDs(dynamic response) => (getJsonField(
        response,
        r'''$.restaurants[:].doc_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? placeIDs(dynamic response) => (getJsonField(
        response,
        r'''$.restaurants[:].place_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<double>? distance(dynamic response) => (getJsonField(
        response,
        r'''$.restaurants[:].distance_km''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<double>(x))
          .withoutNulls
          .toList();
  List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$.restaurants[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GetSingleDetailCall {
  Future<ApiCallResponse> call({
    String? placeId = '',
    double? latitude = 43.66204749676708,
    double? longitude = -79.39372718223954,
  }) async {
    final baseUrl = RestaurantSearchAPIGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "place_id": "${escapeStringForJson(placeId)}",
  "location": {
    "latitude": ${latitude},
    "longitude": ${longitude}
  }
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Single Detail',
      apiUrl: '${baseUrl}/restaurant_details',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetMultipleDetailsCall {
  Future<ApiCallResponse> call({
    List<String>? placeIdsList,
    double? latitude = 43.66205,
    double? longitude = -79.39371,
  }) async {
    final baseUrl = RestaurantSearchAPIGroup.getBaseUrl();
    final placeIds = _serializeList(placeIdsList);

    final ffApiRequestBody = '''
{
  "place_ids": ${placeIds},
  "location": {
    "latitude": ${latitude},
    "longitude": ${longitude}
  }
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Get Multiple Details',
      apiUrl: '${baseUrl}/multiple_restaurant_details',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List<String>? status(dynamic response) => (getJsonField(
        response,
        r'''$.restaurants[:].business_status''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? placeIDs(dynamic response) => (getJsonField(
        response,
        r'''$.restaurants[:].place_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? names(dynamic response) => (getJsonField(
        response,
        r'''$.restaurants[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<double>? ratings(dynamic response) => (getJsonField(
        response,
        r'''$.restaurants[:].rating''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<double>(x))
          .withoutNulls
          .toList();
  List<String>? primaryTypes(dynamic response) => (getJsonField(
        response,
        r'''$.restaurants[:].primary_type''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List? types(dynamic response) => getJsonField(
        response,
        r'''$.restaurants[:].types''',
        true,
      ) as List?;
  List<int>? ratingCount(dynamic response) => (getJsonField(
        response,
        r'''$.restaurants[:].user_rating_count''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  List? photos(dynamic response) => getJsonField(
        response,
        r'''$.restaurants[:].photos''',
        true,
      ) as List?;
  List? priceLevels(dynamic response) => getJsonField(
        response,
        r'''$.restaurants[:].price_level''',
        true,
      ) as List?;
  List? restaurants(dynamic response) => getJsonField(
        response,
        r'''$.restaurants''',
        true,
      ) as List?;
  List? editorialSummary(dynamic response) => getJsonField(
        response,
        r'''$.restaurants[:].editorial_summary''',
        true,
      ) as List?;
  List<String>? googleMapsUri(dynamic response) => (getJsonField(
        response,
        r'''$.restaurants[:].google_maps_uri''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class DeleteCall {
  Future<ApiCallResponse> call({
    String? placeId = '',
  }) async {
    final baseUrl = RestaurantSearchAPIGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
"place_id": "${escapeStringForJson(placeId)}"}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Delete',
      apiUrl: '${baseUrl}/restaurant',
      callType: ApiCallType.DELETE,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: true,
    );
  }
}

/// End Restaurant Search API Group Code

/// Start Agent API Group Code

class AgentAPIGroup {
  static String getBaseUrl() =>
      'https://cicd-agent-api-371653324669.us-central1.run.app/';
  static Map<String, String> headers = {};
  static AgentAPIHealthCall agentAPIHealthCall = AgentAPIHealthCall();
  static SearchAgentSearchPostCall searchAgentSearchPostCall =
      SearchAgentSearchPostCall();
  static AgentrankCall agentrankCall = AgentrankCall();
}

class AgentAPIHealthCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = AgentAPIGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'AgentAPIHealth',
      apiUrl: '${baseUrl}/health',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SearchAgentSearchPostCall {
  Future<ApiCallResponse> call({
    String? query = '',
    String? address = '',
    String? googlePlaceId = '',
    double? lat,
    double? lng,
    int? radiusM,
    String? source = '',
  }) async {
    final baseUrl = AgentAPIGroup.getBaseUrl();

    final ffApiRequestBody = '''
{
  "query": "${escapeStringForJson(query)}",
  "address": "${escapeStringForJson(address)}",
  "google_place_id": "${escapeStringForJson(googlePlaceId)}",
  "lat": "${lat}",
  "lng": "${lng}",
  "radius_m": "${radiusM}",
  "source": "${escapeStringForJson(source)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'search_agent_search_post',
      apiUrl: '${baseUrl}/agent/search',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List<String>? gpplaceIDs(dynamic response) => (getJsonField(
        response,
        r'''$.items[:].google_place_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? dbplaceIDs(dynamic response) => (getJsonField(
        response,
        r'''$.items[:].place_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class AgentrankCall {
  Future<ApiCallResponse> call({
    List<String>? placeIdsList,
    String? palateArchetype = '',
    dynamic? userDataJson,
  }) async {
    final baseUrl = AgentAPIGroup.getBaseUrl();
    final placeIds = _serializeList(placeIdsList);
    final userData = _serializeJson(userDataJson);
    final ffApiRequestBody = '''
{
  "place_ids": ${placeIds},
  "palate_archetype": "${escapeStringForJson(palateArchetype)}",
  "user_data": ${userData}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'agentrank',
      apiUrl: '${baseUrl}/agent/rank',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List? rankedRestaurants(dynamic response) => getJsonField(
        response,
        r'''$.ranked_restaurants''',
        true,
      ) as List?;
  List<String>? placeIDs(dynamic response) => (getJsonField(
        response,
        r'''$.ranked_restaurants[:].restaurant.place_id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? justifications(dynamic response) => (getJsonField(
        response,
        r'''$.ranked_restaurants[:].justification[0]''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  int? total(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.total_restaurants''',
      ));
  List<String>? names(dynamic response) => (getJsonField(
        response,
        r'''$.ranked_restaurants[:].restaurant.name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? address(dynamic response) => (getJsonField(
        response,
        r'''$.ranked_restaurants[:].restaurant.formatted_address''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  List<String>? category(dynamic response) => (getJsonField(
        response,
        r'''$.ranked_restaurants[:].restaurant.category''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

/// End Agent API Group Code

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
