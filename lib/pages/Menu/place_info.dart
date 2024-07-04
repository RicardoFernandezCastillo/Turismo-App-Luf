import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:luf_turism_app/models/place.dart';

class PlaceInfoPage extends StatefulWidget {
  final Place place;
  const PlaceInfoPage({super.key, required this.place});

  @override
  PlaceInfoPageState createState() => PlaceInfoPageState();
}

class PlaceInfoPageState extends State<PlaceInfoPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
      ),
      body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      initialPage: 0,
                    ),
                    items: widget.place.photos
                        .where((photo) =>
                            photo.contains('.jpg') || photo.contains('.png'))
                        .map((photoUrl) => Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ))
                        .toList(),
                  ),
                  Card(
                    margin: const EdgeInsets.all(3),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.place.description,
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Direccion: ${widget.place.address}",
                            style:const TextStyle(fontSize: 20),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
