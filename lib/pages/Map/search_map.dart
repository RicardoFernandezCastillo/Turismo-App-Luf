import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:luf_turism_app/models/place.dart';
import 'package:luf_turism_app/pages/Menu/place_info.dart';
import 'package:luf_turism_app/services/favorites_service.dart';
import 'package:pocketbase/pocketbase.dart';

class MapClient extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const MapClient(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  State<MapClient> createState() => _MapClientState();
}

class _MapClientState extends State<MapClient> {
  final String imageUrl = 'https://boring-carpenter.pockethost.io/api/files/';
  final MapController mapController = MapController();
  final Location location = Location();
  LatLng userLocation = const LatLng(0, 0);
  List<Place> places = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _getAllPlacesByCategory();
  }

  void _getUserLocation() async {
    try {
      final currentLocation = await location.getLocation();
      setState(() {
        userLocation =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        mapController.move(userLocation, 16.0);
      });
    } catch (e) {
      log('Error obteniendo la ubicación: $e');
    }
  }

  Future<void> _getAllPlacesByCategory() async {
    final pb = PocketBase('https://boring-carpenter.pockethost.io');
    try {
      var records =
          await pb.collection('location').getFullList(sort: '-created');
      setState(() {
        places = records.where((record) {
          return record.data['status'] == 'active' &&
              record.data['category_id'].contains(widget.categoryId);
        }).map((document) {
          return Place(
            id: document.id,
            collectionId: document.collectionId,
            collectionName: document.collectionName,
            name: document.data['name'],
            address: document.data['address'],
            longitude: document.data['longitude'].toDouble(),
            latitude: document.data['latitude'].toDouble(),
            description: document.data['description'],
            status: document.data['status'],
            photos: document.data['photos']
                .map<String>((photo) =>
                    '$imageUrl${document.collectionId}/${document.id}/$photo')
                .toList(),
            cityId: document.data['city_id'],
            categoryId: List<String>.from(document.data['category_id']),
          );
        }).toList();
        var plss = places;
        for (var element in plss) {
          log('element: ${element.name + element.latitude.toString() + element.longitude.toString()}');
        }
      });
    } catch (error) {
      log('Error getting places: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Todos los lugares',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: Colors.green[700],
      ),
      body: FlutterMap(
        mapController: mapController,
        options: const MapOptions(
          initialCenter: LatLng(-17.396843874763828, -66.16765210043515),
          initialZoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
            additionalOptions: const {
              'accessToken':
                  'sk.eyJ1IjoibWF1aHQiLCJhIjoiY2x3bGtlbWpoMTl0YjJpbnJ1dGE0cDNjaiJ9.6QxsM8gdkz2ot48nL6yHMg',
            },
          ),
          MarkerLayer(
            markers: [
              Marker(
                  width: 80.0,
                  height: 80.0,
                  point: userLocation, // Ubicación actual del usuario
                  child: IconButton(
                    icon: const Icon(Icons.location_on),
                    color: Colors.blue,
                    iconSize: 45,
                    onPressed: () {},
                  )),
              ...places.map((place) {
                return Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(
                    place.latitude,
                    place.longitude,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.park),
                    color: const Color.fromARGB(255, 1, 39, 70),
                    iconSize: 45,
                    onPressed: () {
                      place.type = widget.categoryName;
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ItemDetail(place: place, context: context);
                        },
                      );
                    },
                  ),
                );
              })
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              mapController.move(userLocation, 16.0);
              //Centra el mapa en la ubicación del usuario con un zoom de 16.0
            },
            child: const Icon(Icons.location_on),
          ),
          const SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: () {
              mapController.move(
                mapController.camera.center,
                mapController.camera.zoom + 1.0,
              );

              // Hace zoom en el mapa
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: () {
              mapController.move(
                  mapController.camera.center, mapController.camera.zoom - 1.0);
              // Hace zoom out en el mapa
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class ItemDetail extends StatefulWidget {
  final Place place;
  final BuildContext context;

  const ItemDetail({super.key, required this.place, required this.context});

  @override
  ItemDetailState createState() => ItemDetailState();
}

class ItemDetailState extends State<ItemDetail> {
  late AudioPlayer player;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    // Inicializar el reproductor de audio
    player = AudioPlayer();
    // Reproducir audio si hay archivos disponibles
    playAudioIfAvailable();
    // Verificar si el lugar ya está en favoritos
    LocalStorageService.isFavorite(widget.place.id!).then((isFavorite) {
      setState(() {
        widget.place.isFavorite = isFavorite;
      });
    });
  }

  void playAudioIfAvailable() async {
    List<String> audioFiles = widget.place.photos
        .where((element) => element.contains('.mp3'))
        .toList();
    if (audioFiles.isNotEmpty) {
      await player.setSource(UrlSource(audioFiles.first));
      player.resume();
      isPlaying = true;
    }
  }

  @override
  void dispose() {
    // Detener y liberar el reproductor de audio cuando el widget se destruya
    if (isPlaying) {
      player.stop();
      player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 16);

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Card(
        margin: const EdgeInsets.all(3),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.place.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center),
              GestureDetector(
                onTap: () {
                  //cerrar el widget
                  Navigator.pop(context);
                  String message = "Estado desconocido";
                  LocalStorageService.toggleFavorite(widget.place.id!);
                  if (widget.place.isFavorite) {
                    message = 'Eliminado de favoritos';
                  } else {
                    message = 'Agregado a favoritos';
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                //hacer que el icono cambie de color si el lugar esta en favoritos
                child: Icon(
                  size: 30,
                  widget.place.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.place.isFavorite ? Colors.red : Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              CarouselSlider(
                options: CarouselOptions(
                  height: 150.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  initialPage: 0,
                ),
                // Mostrar las fotos del lugar en un carrusel, solo las que sean jpg o png
                items: widget.place.photos.where((photo) {
                  return photo.contains('.jpg') || photo.contains('.png');
                }).map((photoUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Text('dirección: ${widget.place.address}', style: style),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.description, color: Colors.blueGrey),
                  const SizedBox(width: 5),
                  //Text(place.description, style: style),
                  Expanded(
                    child: Text(
                    widget.place.description,
                    style: style,
                    textAlign: TextAlign.justify,
                  )),
                ],
              ),
              const SizedBox(height: 10),
              Text('Tipo: ${widget.place.type}', style: style), 
              const SizedBox(height: 10),
              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  player.stop();
                  player.dispose();

                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlaceInfoPage(place: widget.place)), //),
                  );
                },
                color: const Color.fromARGB(255, 7, 57, 98),
                elevation: 6,
                child: const Text(
                  'Ver más detalles',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Stream<List<RecordModel>> getAllPlacesByCategory5(String categoryId) {
//   final pb = PocketBase('https://boring-carpenter.pockethost.io');

//   // Crear un controlador de stream para manejar los datos en tiempo real
//   final streamController = StreamController<List<RecordModel>>();

//   // Obtener la lista inicial de registros
//   pb.collection('location').getFullList(sort: '-created').then((records) {
//     streamController.add(
//       records.where((record) {
//         return record.data['status'] == 'active' &&
//             record.data['category_id'].contains(categoryId);
//       }).toList(),
//     );
//   }).catchError((error) {
//     streamController.addError(error);
//   });

//   // Suscribirse a los cambios en la colección
//   pb.collection('location').subscribe('*', (e) {
//     // Cuando se produce un cambio, obtener la lista actualizada de registros y agregarla al stream
//     pb.collection('location').getFullList(sort: '-created').then((records) {
//       streamController.add(
//         records.where((record) {
//           return record.data['status'] == 'active' &&
//               record.data['category_id'].contains(categoryId);
//         }).toList(),
//       );
//     }).catchError((error) {
//       streamController.addError(error);
//     });
//   });

//   // Cerrar el StreamController cuando ya no se necesite
//   streamController.onCancel = () {
//     streamController.close();
//   };

//   return streamController.stream;
// }
