import 'package:flutter/material.dart';
import 'package:luf_turism_app/models/place.dart';
import 'package:luf_turism_app/pages/Menu/place_info.dart';
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
  bool isLoading = true; // Variable para controlar la carga

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final List<Place> records =
          await PocketBaseService.getPlacesWithFavoriteState();

      setState(() {
        places = records;
        isLoading = false; // La carga ha finalizado
      });
    } catch (error) {
      debugPrint('Error loading favorites: $error');
    }
  }

  Future<void> _removeFromFavorites(Place place) async {
    try {
      setState(() {
        isLoading = true; // Mostrar el indicador de progreso
      });

      await LocalStorageService.removeFromFavoritesID(place.id!);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${place.name} eliminado de favoritos"),
          duration: const Duration(seconds: 2),
        ),
      );

      await _loadFavorites(); // Actualizar la lista de favoritos

      setState(() {
        isLoading = false; // Ocultar el indicador de progreso
      });
    } catch (error) {
      debugPrint('Error removing from favorites: $error');
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
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 2
                          : 4,
                  childAspectRatio:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 0.7
                          : 0.7,
                ),
                itemCount: places.length,
                itemBuilder: (context, index) {
                  Place place = places[index];
                  String? jpgPhoto = place.photos.firstWhere(
                    (photo) => photo.endsWith('.jpg'),
                    orElse: () => '',
                  );
                  String displayAddress = place.address.length > 70
                      ? '${place.address.substring(0, 70)}...'
                      : place.address;
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceInfoPage(place: place),
                        ),
                      );
                    },
                    child: Card(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 10.0),
                              if (jpgPhoto.isNotEmpty)
                                Image.network(
                                  jpgPhoto,
                                  fit: BoxFit.cover,
                                  height: 120.0,
                                ),
                              Flexible(
                                child: ListTile(
                                  title: Text(place.name),
                                  subtitle: Text(
                                    displayAddress,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                  ),
                                  // Eliminar onTap aquí
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 5.0,
                            right: 5.0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 30.0,
                              ),
                              onPressed: () {
                                _removeFromFavorites(place);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
  }
}
