import 'package:flutter/material.dart';
import 'package:luf_turism_app/models/place.dart';
import 'package:luf_turism_app/pages/Map/search_map.dart';
import 'package:luf_turism_app/services/favorites_service.dart';
import 'package:luf_turism_app/services/pocket_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:async';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  static final PocketBase pb =
      PocketBase('https://boring-carpenter.pockethost.io');

  List<Place> places = [];
  List<Place> filteredPlaces = [];
  bool isLoading = true; // Variable para controlar la carga

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final placesFavorites = await LocalStorageService.getPlacesFavorites();
      final List<Place> records = await PocketBaseService.getFavorites(placesFavorites);
      setState(() {
        places = records;
        filteredPlaces = records;
        isLoading = false; // La carga ha finalizado
      });
    } catch (error) {
      debugPrint('Error loading favorites: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Muestra el ProgressBar mientras se carga
            )
          : ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                Place place = places[index];
                return ListTile(
                  title: Text(place.name),
                  onTap: () {
                    
                  },
                );
              },
            ),
    );
  }
}
