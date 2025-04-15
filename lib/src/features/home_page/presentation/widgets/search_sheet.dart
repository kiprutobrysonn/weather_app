import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weather_app/src/features/home_page/domain/models/location.dart';
import 'package:weather_app/src/features/home_page/presentation/cubit/location_search_cubit.dart';

class SearchSheet extends HookWidget {
  const SearchSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final debounceTimer = useState<Future<void>?>(null);

    void performSearch(String query) {
      if (query.isEmpty || query.length < 3) {
        return;
      }

      if (debounceTimer.value != null) {
        debounceTimer.value;
      }

      debounceTimer.value = Future.delayed(
        const Duration(milliseconds: 500),
        () async {
          context.read<LocationSearchCubit>().searchLocations(query);
        },
      );
    }

    return Material(
      color: Colors.black.withOpacity(0.5),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon:
                      searchController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              // Clear search results
                              context.read<LocationSearchCubit>().clearSearch();
                            },
                          )
                          : null,
                  hintText: 'Search for a city',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
                onChanged: performSearch,
              ),
              const SizedBox(height: 16),
              BlocBuilder<LocationSearchCubit, LocationSearchState>(
                builder: (context, state) {
                  if (state is LocationSearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LocationSearchError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        state.message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (state is LocationSearchLoaded) {
                    return Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.locations.length,
                        itemBuilder: (context, index) {
                          final location = state.locations[index];
                          final subtitle =
                              location.country != null
                                  ? '${location.country}'
                                  : 'Lat: ${location.latitude.toStringAsFixed(2)}, Lon: ${location.longitude.toStringAsFixed(2)}';
                          return ListTile(
                            leading: const Icon(Icons.location_on_outlined),
                            title: Text(location.name),
                            subtitle: Text(subtitle),
                            onTap: () {
                              Navigator.of(context).pop(location);
                            },
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
