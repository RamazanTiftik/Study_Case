import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percon_case_project/model/travel.dart';
import 'package:percon_case_project/service/travel_service.dart';

class TravelState {
  final List<Travel> allTravels;
  final List<Travel> filteredTravels;
  final String? selectedCountry;
  final String? selectedCategory;
  final DateTime? startDate;
  final DateTime? endDate;

  TravelState({
    required this.allTravels,
    required this.filteredTravels,
    this.selectedCountry,
    this.selectedCategory,
    this.startDate,
    this.endDate,
  });

  TravelState copyWith({
    List<Travel>? allTravels,
    List<Travel>? filteredTravels,
    Object? selectedCountry = _sentinel,
    Object? selectedCategory = _sentinel,
    Object? startDate = _sentinel,
    Object? endDate = _sentinel,
  }) {
    return TravelState(
      allTravels: allTravels ?? this.allTravels,
      filteredTravels: filteredTravels ?? this.filteredTravels,
      selectedCountry: selectedCountry == _sentinel
          ? this.selectedCountry
          : selectedCountry as String?,
      selectedCategory: selectedCategory == _sentinel
          ? this.selectedCategory
          : selectedCategory as String?,
      startDate: startDate == _sentinel
          ? this.startDate
          : startDate as DateTime?,
      endDate: endDate == _sentinel ? this.endDate : endDate as DateTime?,
    );
  }

  factory TravelState.initial() =>
      TravelState(allTravels: [], filteredTravels: []);
}

const _sentinel = Object();

final travelProvider = StateNotifierProvider<TripNotifier, TravelState>((ref) {
  return TripNotifier();
});

class TripNotifier extends StateNotifier<TravelState> {
  TripNotifier() : super(TravelState.initial());

  final _travelService = TravelService();

  Future<void> loadTrips() async {
    // read data from json
    final String jsonString = await rootBundle.loadString(
      'assets/json/travels.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);

    final trips = jsonData.map((e) => Travel.fromJson(e)).toList();

    final favoriteIds = await _travelService.getFavorites();

    final syncedTrips = trips.map((trip) {
      return trip.copyWith(isFavorite: favoriteIds.contains(trip.id));
    }).toList();

    state = state.copyWith(
      allTravels: syncedTrips,
      filteredTravels: syncedTrips,
    );
  }

  void applyFilter({
    String? country,
    String? category,
    DateTime? start,
    DateTime? end,
  }) {
    final filtered = state.allTravels.where((t) {
      final countryMatch = country == null || t.country == country;
      final categoryMatch = category == null || t.category == category;
      final startMatch = start == null || !t.startDate.isBefore(start);
      final endMatch = end == null || !t.endDate.isAfter(end);
      return countryMatch && categoryMatch && startMatch && endMatch;
    }).toList();

    state = state.copyWith(
      filteredTravels: filtered,
      selectedCountry: country,
      selectedCategory: category,
      startDate: start,
      endDate: end,
    );
  }

  void toggleFavorite(String tripId) async {
    final updatedAll = state.allTravels.map((trip) {
      if (trip.id == tripId) {
        return trip.copyWith(isFavorite: !trip.isFavorite);
      }
      return trip;
    }).toList();

    // filteredTravels'ı mevcut filtreye göre yeniden oluştur
    final updatedFiltered = updatedAll.where((t) {
      final countryMatch =
          state.selectedCountry == null || t.country == state.selectedCountry;
      final categoryMatch =
          state.selectedCategory == null ||
          t.category == state.selectedCategory;
      final startMatch =
          state.startDate == null || !t.startDate.isBefore(state.startDate!);
      final endMatch =
          state.endDate == null || !t.endDate.isAfter(state.endDate!);
      return countryMatch && categoryMatch && startMatch && endMatch;
    }).toList();

    state = state.copyWith(
      allTravels: updatedAll,
      filteredTravels: updatedFiltered,
    );

    final updatedTrip = updatedAll.firstWhere((t) => t.id == tripId);
    if (updatedTrip.isFavorite) {
      await _travelService.addFavorite(tripId);
    } else {
      await _travelService.removeFavorite(tripId);
    }
  }
}
