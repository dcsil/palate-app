import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ff_commons/flutter_flow/lat_lng.dart';
import 'package:ff_commons/flutter_flow/place.dart';
import 'package:ff_commons/flutter_flow/uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

String newCustomFunction(int price) {
  // output dollar sign $ as number given in input. So if input = 3, "$$$".
  return '\$' * price;
}

double getLatitude(LatLng latlng) {
  return latlng.latitude;
}

List<LatLng> convertJsonToLatLng(List<dynamic> json) {
  return json.map((item) {
    final map = item as Map<String, dynamic>;
    return LatLng(
      (map['latitude'] as num).toDouble(),
      (map['longitude'] as num).toDouble(),
    );
  }).toList();
}

double getLongitude(LatLng latlng) {
  return latlng.longitude;
}

List<String> subarray(
  int start,
  int length,
  List<String> items,
) {
  if (items.isEmpty) return [];
  if (length <= 0) return [];

  // Clamp indice
  final n = items.length;
  int s = start < 0 ? 0 : start;
  if (s >= n) return [];

  int e = s + length;
  if (e > n) e = n;

  return items.sublist(s, e); // end is exclusive
}

List<DocumentReference> idToDoc(List<String> ids) {
  return ids
      .map((id) => FirebaseFirestore.instance.collection('restaurants').doc(id))
      .toList();
}

List<RestaurantStruct> convertJsonToRestaurant(List<dynamic> jsons) {
// Safe coercions
  T? _as<T>(dynamic v) {
    if (v == null) return null;
    if (v is T) return v;

    // numbers inside strings
    if ((T == double || T == int) && v is String) {
      final d = double.tryParse(v);
      if (d != null) {
        if (T == double) return d as T;
        if (T == int) return d.toInt() as T;
      }
    }
    if (T == double && v is num) return v.toDouble() as T;
    if (T == int && v is num) return v.toInt() as T;

    if (T == String) return v.toString() as T;
    return null;
  }

  // Convert any list-like value to List<String>
  List<String>? _asStringList(dynamic v) {
    if (v is List) {
      final out = <String>[];
      for (final e in v) {
        if (e == null) continue;
        out.add(e.toString());
      }
      return out;
    }
    return null;
  }

  final out = <RestaurantStruct>[];

  for (final item in jsons) {
    if (item is! Map) continue;
    final m = Map<String, dynamic>.from(item as Map);

    // Parse nextOpenTime safely (force to String)
    String? nextOpenTime;
    final roh = m['regular_opening_hours'];
    if (roh is Map && roh['nextOpenTime'] != null) {
      nextOpenTime = roh['nextOpenTime'].toString();
    }

    // --- NEW: parse editorial_summary safely ---
    EditorialSummaryStruct? editorial;
    final rawEditorial = m['editorial_summary'];
    if (rawEditorial is Map) {
      final em = Map<String, dynamic>.from(rawEditorial);
      editorial = createEditorialSummaryStruct(
        languageCode: _as<String>(em['languageCode']),
        text: _as<String>(em['text']),
        clearUnsetFields: false,
      );
    }
    // Build scalars first
    final r = createRestaurantStruct(
        name: _as<String>(m['name']),
        businessStatus: _as<String>(m['business_status']),
        rating: _as<double>(m['rating']),
        primaryType: _as<String>(m['primary_type']),
        userRatingCount: _as<int>(m['user_rating_count']),
        placeId: _as<String>(m['place_id']),
        editorialSummary: editorial,
        googleMapsUri: _as<String>(m['google_maps_uri']),
        clearUnsetFields: false);

    // Then set list fields (constructor often omits them)
    final types = _asStringList(m['types']);
    if (types != null) {
      r.types = types; // make sure your struct's field is named `types`
      r.nextOpenTime = nextOpenTime;
    }

    final photos = _asStringList(m['photos']);
    if (photos != null) {
      r.photos = photos; // for Image Path fields FF generates List<String>
    }

    out.add(r);
  }

  return out;
}

RestaurantStruct convertJsonToSingleRes(dynamic singleJson) {
  // Safe coercions
  T? _as<T>(dynamic v) {
    if (v == null) return null;
    if (v is T) return v;

    // handle numeric strings
    if ((T == double || T == int) && v is String) {
      final d = double.tryParse(v);
      if (d != null) {
        if (T == double) return d as T;
        if (T == int) return d.toInt() as T;
      }
    }

    if (T == double && v is num) return v.toDouble() as T;
    if (T == int && v is num) return v.toInt() as T;

    if (T == String) return v.toString() as T;
    return null;
  }

  // Convert any list-like value to List<String>
  List<String>? _asStringList(dynamic v) {
    if (v is List) {
      return v.whereType<dynamic>().map((e) => e.toString()).toList();
    }
    return null;
  }

  if (singleJson is! Map) {
    throw ArgumentError('Expected a JSON map but got: $singleJson');
  }

  final m = Map<String, dynamic>.from(singleJson as Map);
  // Parse nextOpenTime safely (force to String)
  String? nextOpenTime;
  final roh = m['regular_opening_hours'];
  if (roh is Map && roh['nextOpenTime'] != null) {
    nextOpenTime = roh['nextOpenTime'].toString();
  }
  // Create the RestaurantStruct
  final restaurant = createRestaurantStruct(
    name: _as<String>(m['name']),
    businessStatus: _as<String>(m['business_status']),
    rating: _as<double>(m['rating']),
    primaryType: _as<String>(m['primary_type']),
    userRatingCount: _as<int>(m['user_rating_count']),
    placeId: _as<String>(m['place_id']),
    editorialSummary: _as<dynamic>(m['editorial_summary']),
    googleMapsUri: _as<String>(m['google_maps_uri']),
    clearUnsetFields: false,
  );
  restaurant.nextOpenTime = nextOpenTime;
  // Assign list fields
  final types = _asStringList(m['types']);
  if (types != null) {
    restaurant.types = types;
  }
  final photos = _asStringList(m['photos']);
  if (photos != null) restaurant.photos = photos;

  return restaurant;
}

String distanceToTime(double distanceMeters) {
  // Add 25% buffer to account for real walking paths
  const double pathBuffer = 1.2;
  const double walkingSpeedMps = 1.4;

  final double adjustedDistance = distanceMeters * pathBuffer;
  final double timeSeconds = adjustedDistance / walkingSpeedMps;

  final int minutes = (timeSeconds / 60).round();
  final int hours = minutes ~/ 60;
  final int remainingMinutes = minutes % 60;

  if (hours > 0) {
    return '$hours hr ${remainingMinutes > 0 ? '$remainingMinutes min' : ''}'
        .trim();
  } else {
    return '$minutes min';
  }
}

String findArchetype(List<int> answers) {
  // Expecting 8 answers, values 1–4
  if (answers.length < 8) {
    return '';
  }

  // Initialize scores for each archetype
  final scores = <String, int>{
    'Explorer': 0,
    'Purist': 0,
    'Social Curator': 0,
    'Trend Seeker': 0,
    'Conformist': 0,
    'Aestheticist': 0,
  };

  void addScore(String archetype, int points) {
    scores[archetype] = (scores[archetype] ?? 0) + points;
  }

  // Q1: How often do you try new cuisines? (answers[0])
  switch (answers[0]) {
    case 1: // "Always"
      addScore('Explorer', 3);
      break;
    case 2: // "Often"
      addScore('Explorer', 2);
      break;
    case 3: // "Sometimes"
      addScore('Conformist', 1);
      break;
    case 4: // "Rarely"
      addScore('Conformist', 3);
      break;
  }

  // Q2: What's most important when dining out? (answers[1])
  switch (answers[1]) {
    case 1: // "Food quality & taste"
      addScore('Purist', 3);
      break;
    case 2: // "Ambiance & aesthetics"
      addScore('Aestheticist', 3);
      break;
    case 3: // "Social experience"
      addScore('Social Curator', 3);
      break;
    case 4: // "Popularity & buzz"
      addScore('Trend Seeker', 3);
      break;
  }

  // Q3: How do you decide where to eat? (answers[2])
  switch (answers[2]) {
    case 1: // "Online reviews & ratings"
      addScore('Trend Seeker', 2);
      break;
    case 2: // "Friend recommendations"
      addScore('Social Curator', 2);
      break;
    case 3: // "Gut feeling & curiosity"
      addScore('Explorer', 2);
      break;
    case 4: // "My regular spots"
      addScore('Conformist', 2);
      break;
  }

  // Q4: What do you order from the menu? (answers[3])
  switch (answers[3]) {
    case 1: // "Most unique/experimental dish"
      addScore('Explorer', 3);
      break;
    case 2: // "Chef's signature dish"
      addScore('Purist', 2);
      break;
    case 3: // "What everyone else is getting"
      addScore('Trend Seeker', 2);
      break;
    case 4: // "Something familiar and safe"
      addScore('Conformist', 3);
      break;
  }

  // Q5: Do you take photos of food/restaurant? (answers[4])
  switch (answers[4]) {
    case 1: // "Always"
      addScore('Aestheticist', 3);
      break;
    case 2: // "Sometimes"
      addScore('Aestheticist', 1);
      break;
    case 3: // "Rarely"
      addScore('Purist', 1);
      break;
    case 4: // "Never"
      // no points
      break;
  }

  // Q6: Your ideal restaurant is... (answers[5])
  switch (answers[5]) {
    case 1: // "A hidden gem"
      addScore('Explorer', 3);
      break;
    case 2: // "Michelin-starred"
      addScore('Purist', 3);
      break;
    case 3: // "The buzziest spot in town"
      addScore('Trend Seeker', 3);
      break;
    case 4: // "Stunning & photogenic"
      addScore('Aestheticist', 3);
      break;
  }

  // Q7: How important are dining companions? (answers[6])
  switch (answers[6]) {
    case 1: // "Essential"
      addScore('Social Curator', 3);
      break;
    case 2: // "Preferred"
      addScore('Social Curator', 2);
      break;
    case 3: // "It depends"
      addScore('Purist', 1);
      break;
    case 4: // "I often dine solo"
      addScore('Purist', 2);
      break;
  }

  // Q8: Before visiting a new restaurant... (answers[7])
  switch (answers[7]) {
    case 1: // "Research extensively"
      addScore('Trend Seeker', 2);
      break;
    case 2: // "Do some research"
      addScore('Aestheticist', 1);
      break;
    case 3: // "Minimal research"
      addScore('Explorer', 2);
      break;
    case 4: // "No research"
      addScore('Conformist', 2);
      break;
  }

  // Pick the archetype with the highest score
  // Tie-breaker: fixed order for determinism
  const archetypeOrder = [
    'Explorer',
    'Purist',
    'Social Curator',
    'Trend Seeker',
    'Conformist',
    'Aestheticist',
  ];

  String bestArchetype = archetypeOrder.first;
  int bestScore = -1;

  for (final archetype in archetypeOrder) {
    final score = scores[archetype] ?? 0;
    if (score > bestScore) {
      bestScore = score;
      bestArchetype = archetype;
    }
  }

  return bestArchetype;
}

List<String> flattenJustifications(dynamic inputJson) {
  if (inputJson == null) return [];

  dynamic root = inputJson;

  // If it's a JSON string, decode it
  if (root is String) {
    try {
      root = jsonDecode(root);
    } catch (_) {
      // Not valid JSON
      return [];
    }
  }

  if (root is! Map) return [];

  final ranked = root['ranked_restaurants'];
  if (ranked is! List) return [];

  final List<String> results = [];

  for (final item in ranked) {
    if (item is Map) {
      final just = item['justification'];
      if (just is List) {
        for (final j in just) {
          final s = j?.toString().trim();
          if (s != null && s.isNotEmpty) {
            results.add(s);
          }
        }
      }
    }
  }

  return results;
}

List<dynamic>? stringToListOfJson(List<String>? jsonStrings) {
  if (jsonStrings == null || jsonStrings.isEmpty) {
    return null;
  }

  try {
    final List<dynamic> result = [];

    for (final s in jsonStrings) {
      if (s.trim().isEmpty) continue;

      final decoded = json.decode(s);

      // Only accept JSON objects
      if (decoded is Map<String, dynamic>) {
        result.add(decoded);
      }
    }

    return result;
  } catch (e) {
    return null;
  }
}
