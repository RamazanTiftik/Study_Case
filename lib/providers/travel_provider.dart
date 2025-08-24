import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percon_case_project/model/travel.dart';
import 'package:percon_case_project/service/travel_service.dart';

final travelProvider = StateNotifierProvider<TripNotifier, List<Travel>>((ref) {
  return TripNotifier();
});

class TripNotifier extends StateNotifier<List<Travel>> {
  TripNotifier() : super([]) {}

  final _travelService = TravelService();

  Future<void> loadTrips() async {
      // 1. JSON'dan verileri oku (isFavorite göz ardı ediliyor)
      final String jsonString = await rootBundle.loadString(
        'assets/json/travels.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);

      // JSON'daki isFavorite artık kullanılmayacak
      final trips = jsonData.map((e) => Travel.fromJson(e)).toList();

      // 2. Firestore'daki favorileri çek
      final favoriteIds = await _travelService.getFavorites();

      // 3. Favorileri senkronize et (UI için)
      state = trips.map((trip) {
        // JSON'dan gelen isFavorite yerine Firestore'dan gelen bilgiyi kullan
        return trip.copyWith(isFavorite: favoriteIds.contains(trip.id));
      }).toList();
    
  }

  Future<void> toggleFavorite(String tripId) async {
    // UI'da state güncelle
    state = [
      for (final trip in state)
        if (trip.id == tripId)
          trip.copyWith(isFavorite: !trip.isFavorite)
        else
          trip,
    ];

    // Firestore'a yaz
    final updatedTrip = state.firstWhere((t) => t.id == tripId);
    if (updatedTrip.isFavorite) {
      await _travelService.addFavorite(tripId);
    } else {
      await _travelService.removeFavorite(tripId);
    }
  }
}
