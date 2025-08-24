import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percon_case_project/model/travel.dart';
import 'package:percon_case_project/pages/mainPages/profile_screen.dart';
import 'package:percon_case_project/service/travel_service.dart';
import 'package:percon_case_project/widgets/custom_app_bar.dart';
import 'package:percon_case_project/l10n/app_localizations.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  //travel service
  final TravelService _travelService = TravelService();

  //trip list from json
  Future<List<Travel>>? _favoriteTripsFuture;

  @override
  void initState() {
    super.initState();
    _favoriteTripsFuture = _loadFavoriteTrips();
  }

  //load trip from json method
  Future<List<Travel>> _loadFavoriteTrips() async {
    final String jsonString = await rootBundle.loadString(
      'assets/json/travels.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    final allTrips = jsonData.map((e) => Travel.fromJson(e)).toList();

    final favoriteIds = await _travelService.getFavorites();

    final favoriteTrips = allTrips
        .where((trip) => favoriteIds.contains(trip.id))
        .toList();

    return favoriteTrips;
  }

  @override
  Widget build(BuildContext context) {
    //localization
    final loc = AppLocalizations.of(context)!;

    //VIEW
    return Scaffold(
      appBar: CustomAppBar(
        title: loc.myFavorites,
        showBackButton: true,
        onFilterPressed: () => Navigator.pop(context),
        onFavoritePressed: () {},
        onProfilePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        },
      ),
      body: FutureBuilder<List<Travel>>(
        future: _favoriteTripsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("${loc.error}: ${snapshot.error}"));
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return Center(
              child: Text(
                loc.noFavoriteTrips,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final travel = favorites[index];
              return _buildTravelCard(travel, loc);
            },
          );
        },
      ),
    );
  }

  //travel card view
  Widget _buildTravelCard(Travel travel, AppLocalizations loc) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: Text(
          travel.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          "${travel.country} - ${travel.region}",
          style: const TextStyle(fontSize: 16),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () async {
            await _travelService.removeFavorite(travel.id);
            setState(() {
              _favoriteTripsFuture = _loadFavoriteTrips();
            });
          },
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.category, size: 14),
                    const SizedBox(width: 6),
                    Text(travel.category, style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      travel.startDate.toLocal().toString().split(' ')[0],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      travel.endDate.toLocal().toString().split(' ')[0],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.description, size: 15),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        travel.description,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
