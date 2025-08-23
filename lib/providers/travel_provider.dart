import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percon_case_project/model/travel.dart';

final travelProvider = StateNotifierProvider<TripNotifier, List<Travel>>((ref) {
  return TripNotifier();
});

class TripNotifier extends StateNotifier<List<Travel>> {
  TripNotifier() : super([]) {
    loadTrips();
  }

  Future<void> loadTrips() async {
    final String jsonString = await rootBundle.loadString(
      'assets/json/travels.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    state = jsonData.map((e) => Travel.fromJson(e)).toList();
  }

  void toggleFavorite(String tripId) {
    state = [
      for (final trip in state)
        if (trip.id == tripId)
          Travel(
            id: trip.id,
            title: trip.title,
            country: trip.country,
            region: trip.region,
            startDate: trip.startDate,
            endDate: trip.endDate,
            category: trip.category,
            description: trip.description,
            isFavorite: !trip.isFavorite,
          )
        else
          trip,
    ];
  }
}
