import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percon_case_project/pages/mainPages/favorite_screen.dart';
import 'package:percon_case_project/pages/mainPages/profile_screen.dart';
import 'package:percon_case_project/providers/travel_provider.dart';
import 'package:percon_case_project/widgets/custom_app_bar.dart';
import 'package:percon_case_project/model/travel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isGridView = false;
  String? selectedCountry;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    // Firestore'dan favorilerle birlikte yükle
    await ref.read(travelProvider.notifier).loadTrips();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final travels = ref.watch(travelProvider);

    final filteredTravels = selectedCountry == null
        ? travels
        : travels.where((t) => t.country == selectedCountry).toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: "Home Screen",
        onFilterPressed: () async {
          final result = await showDialog<String>(
            context: context,
            builder: (ctx) => SimpleDialog(
              title: const Text("Filtrele (Ülke)"),
              children: [
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(ctx, null),
                  child: const Text("Hepsi"),
                ),
                ...travels
                    .map((t) => t.country)
                    .toSet()
                    .map(
                      (c) => SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, c),
                        child: Text(c),
                      ),
                    ),
              ],
            ),
          );
          setState(() {
            selectedCountry = result;
          });
        },
        onFavoritePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FavoriteScreen()),
          );
        },
        onProfilePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        },
      ),
      body: travels.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : isGridView
          ? GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              itemCount: filteredTravels.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 1,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final Travel travel = filteredTravels[index];
                return _buildTravelCard(travel);
              },
            )
          : ListView.builder(
              itemCount: filteredTravels.length,
              itemBuilder: (context, index) {
                final Travel travel = filteredTravels[index];
                return _buildTravelCard(travel);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isGridView = !isGridView;
          });
        },
        child: Icon(isGridView ? Icons.list : Icons.grid_view),
      ),
    );
  }

  Widget _buildTravelCard(Travel travel) {
    if (isGridView) {
      return Card(
        margin: const EdgeInsets.all(6),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.title, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          travel.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "${travel.country} - ${travel.region}",
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.description, size: 15),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          travel.description,
                          style: const TextStyle(fontSize: 15),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.category, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          travel.category,
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 35),
                ],
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  travel.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: travel.isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  ref.read(travelProvider.notifier).toggleFavorite(travel.id);
                },
              ),
            ),
          ],
        ),
      );
    }

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
          icon: Icon(
            travel.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: travel.isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            ref.read(travelProvider.notifier).toggleFavorite(travel.id);
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
