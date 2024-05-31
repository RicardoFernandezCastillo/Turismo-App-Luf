import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:luf_turism_app/models/place.dart';
import 'package:luf_turism_app/pages/category_list.dart';
import 'package:pocketbase/pocketbase.dart';

class MapClient extends StatefulWidget {
  final String categoryId;
  const MapClient({super.key, required this.categoryId});

  @override
  State<MapClient> createState() => _MapClientState();
}

class _MapClientState extends State<MapClient> {
  final MapController mapController = MapController();
  final Location location = Location();
  LatLng userLocation = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _getUserLocation();
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
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<RecordModel>>(
        stream: getAllPlacesByCategory5(widget.categoryId),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          List<Place> places = snapshot.data!.map((document) {
            //Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Place(
              id: document.id,
              collectionId: document.collectionId,
              collectionName: document.collectionName,
              name: document.data['name'],
              address: document.data['address'],
              longitude: document.data['longitude'],
              latitude: document.data['latitude'],
              description: document.data['description'],
              status: document.data['status'],
              photos: List<String>.from(document.data['photos']),
              cityId: document.data['city_id'],
              categoryId: List<String>.from(document.data['category_id']),
              type: document.data['type'] ?? '',
              schedule: document.data['schedule']?? '',
            );
          }).toList();

          return FlutterMap(
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
                  ...places.map((parking) {
                    return Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                        parking.latitude,
                        parking.longitude,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.park),
                        color: Colors.blue,
                        iconSize: 45,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return itemDetail(
                                  parking.name,
                                  parking.name,
                                  parking.name,
                                  false,
                                  context,
                                  parking.photos.isNotEmpty
                                      ? parking.photos[0]
                                      : null);
                            },
                          );
                        },
                      ),
                    );
                  })
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              mapController.move(userLocation, 16.0);
              // Centra el mapa en la ubicación del usuario con un zoom de 16.0
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

Widget itemDetail(String name, String description, String direccion,
    bool tieneCobertura, BuildContext context, String? urlImage) {
  const style = TextStyle(fontSize: 16);
  return Padding(
    padding: const EdgeInsets.all(15),
    child: Card(
      margin: const EdgeInsets.all(3),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 20,
                    ),
                    Image.network(
                      urlImage ?? '',
                      width: 220,
                      height: 150,
                    ),
                  ],
                )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: style),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(description, style: style),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.timer,
                          color: Colors.blueGrey,
                        ),
                        Text(
                          'Dato 1',
                          style: style,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.timer_off,
                          color: Colors.blueGrey,
                        ),
                        Text(
                          //Optener la hora de un timestamp
                          'Datos 2',
                          style: style,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.paragliding,
                          color: Colors.blueGrey,
                        ),
                        Text(
                          //Optener la hora de un timestamp
                          'Calle: ${tieneCobertura ? 'SI' : 'NO'}',
                          style: style,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'tipo:',
                      style: style,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.car_crash,
                          color: Colors.blueGrey,
                        ),
                        Icon(Icons.motorcycle, color: Colors.blueGrey),
                        Icon(Icons.train, color: Colors.blueGrey)
                      ],
                    )
                  ],
                ))
              ],
            ),
          ),
          MaterialButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              if (!context.mounted) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CategoriesPage()), //),
              );
            },
            color: Colors.blue,
            elevation: 6,
            child: const Text(
              'Ver mas detalles',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    ),
  );
}

Stream<List<RecordModel>> getAllPlacesByCategory5(String categoryId) {
  final pb = PocketBase('https://boring-carpenter.pockethost.io');

  // Crear un controlador de stream para manejar los datos en tiempo real
  final streamController = StreamController<List<RecordModel>>();

  // Obtener la lista inicial de registros
  pb.collection('location').getFullList(sort: '-created').then((records) {
    streamController.add(
      records.where((record) {
        return record.data['status'] == 'active' &&
            record.data['category_id'].contains(categoryId);
      }).toList(),
    );
  }).catchError((error) {
    streamController.addError(error);
  });

  // Suscribirse a los cambios en la colección
  pb.collection('location').subscribe('*', (e) {

    // Cuando se produce un cambio, obtener la lista actualizada de registros y agregarla al stream
    pb.collection('location').getFullList(sort: '-created').then((records) {
      streamController.add(
        records.where((record) {
          return record.data['status'] == 'active' &&
              record.data['category_id'].contains(categoryId);
        }).toList(),
      );
    }).catchError((error) {
      streamController.addError(error);
    });
  });

  // Cerrar el StreamController cuando ya no se necesite
  streamController.onCancel = () {
    streamController.close();
  };

  return streamController.stream;
}
