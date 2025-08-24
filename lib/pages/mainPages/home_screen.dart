import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percon_case_project/pages/mainPages/favorite_screen.dart';
import 'package:percon_case_project/pages/mainPages/profile_screen.dart';
import 'package:percon_case_project/providers/travel_provider.dart';
import 'package:percon_case_project/widgets/custom_app_bar.dart';
import 'package:percon_case_project/model/travel.dart';
import 'package:percon_case_project/widgets/custom_dropdown.dart';
import 'package:percon_case_project/l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // isGridView check
  bool isGridView = false;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    await ref.read(travelProvider.notifier).loadTrips();
  }

  void _showFilterDialog(
    BuildContext context,
    List<String> countries,
    List<String> categories,
  ) async {
    final loc = AppLocalizations.of(context)!;
    final state = ref.read(travelProvider);

    // geçici filtre değerleri (dialog içinde değişecek)
    String? tempCountry = state.selectedCountry;
    String? tempCategory = state.selectedCategory;
    DateTime? tempStartDate = state.startDate;
    DateTime? tempEndDate = state.endDate;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text(loc.filter),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomDropdown(
                      items: countries,
                      hint: loc.selectCountry,
                      value: tempCountry,
                      onChanged: (value) => setState(() => tempCountry = value),
                    ),
                    const SizedBox(height: 12),
                    CustomDropdown(
                      items: categories,
                      hint: loc.selectCategory,
                      value: tempCategory,
                      onChanged: (value) =>
                          setState(() => tempCategory = value),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: tempStartDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() => tempStartDate = picked);
                              }
                            },
                            child: Text(
                              tempStartDate == null
                                  ? loc.startDate
                                  : tempStartDate!.toLocal().toString().split(
                                      ' ',
                                    )[0],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: tempEndDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() => tempEndDate = picked);
                              }
                            },
                            child: Text(
                              tempEndDate == null
                                  ? loc.endDate
                                  : tempEndDate!.toLocal().toString().split(
                                      ' ',
                                    )[0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          loc.cancel,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ref
                              .read(travelProvider.notifier)
                              .applyFilter(
                                country: tempCountry,
                                category: tempCategory,
                                start: tempStartDate,
                                end: tempEndDate,
                              );
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          loc.apply,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(travelProvider);

    final filteredTravels = state.filteredTravels;
    final countries = state.allTravels.map((t) => t.country).toSet().toList();
    final categories = state.allTravels.map((t) => t.category).toSet().toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: loc.homeScreenTitle,
        onFilterPressed: () =>
            _showFilterDialog(context, countries, categories),
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
      body: filteredTravels.isEmpty
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
