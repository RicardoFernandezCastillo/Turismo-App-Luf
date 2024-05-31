import 'dart:developer';

import 'package:luf_turism_app/models/place.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  // Crea una instancia de PocketBase con la URL de la API
  static PocketBase pb = PocketBase('https://boring-carpenter.pockethost.io');

  // Función para obtener las categorías de la base de datos
  static Future<List<dynamic>> getCategories() async {
    // Obtiene las categorias creadas
    List<dynamic> records = await pb.collection('category').getFullList(
      sort: '-created',
    );

    // Filtra las categorias que no estén activas
    records = records.where((record) => record['status']).toList();

    // // Obtiene los iconos de las categorias
    // records = records.map((record) {
    //   // Obtiene el icono de la categoria
    //   var icon = menuItems
    //       .firstWhere((item) => item['title'].toLowerCase() == record['name'].toLowerCase())['icon'];

    //   // Si no encuentra el icono, le asigna el icono por defecto
    //   return {
    //     ...record,
    //     'icon': icon != null ? icon : faEllipsis,
    //   };
    // }).toList();

    // Retorna las categorias
    return records;
  }

  static Future<List<RecordModel>> getAllCategory() async {
    final records = await pb.collection('category').getFullList(
       sort: '-created',
    );
    // for (var i = 0; i < records.length; i++) {
    //   print(records[i].data["name"]);
    // }
    return records;

  }

  static Future<List<dynamic>> getLocationsByCategory(String categoryId) async {
    String url = 'https://boring-carpenter.pockethost.io/api/files/';

    List<dynamic> records = await pb.collection('location').getFullList(
      sort: '-created',
    );

    records = records.where((record) {
      if (categoryId == null) return record['status'] == 'active';
      // Comprueba si el lugar tiene una categoría y si coincide con la categoría buscada
      return record['status'] == 'active' && record['category_id'].contains(categoryId);
    }).toList();

    records = records.map((record) {
      return {
        ...record,
        // url del backend + id de la coleccion + id del registro + nombre de la imagen
        'image': record['photos'] != null ? url + record['collectionId'] + "/" + record['id'] + "/" + record['photos'][0] : null,
      };
    }).toList();

    return records;
  }

  //Funcion para obtener los lugares favoritos en la base de datos de una lista con los id de los lugares
  static Future<List<Place>> getFavorites(List<String> favorites) async {
    String imageUrl = 'https://boring-carpenter.pockethost.io/api/files/';

    //String url = "https://boring-carpenter.pockethost.io/api/files/";
    // Obtiene las categorias creadas
    List<RecordModel> records = await pb.collection("location").getFullList(filter: "status = 'active'");
    records = records.where((record) {
      return favorites.contains(record.id);
    }).toList();


    List<Place> places = records.map((document) {
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
              type: document.data['type'] ?? '',
              schedule: document.data['schedule'] ?? '',
            );
    }).toList();


    return places;
  }


  static Future<List<RecordModel>> getLocationsByCategory2(String categoryId) async {
    final records = await pb.collection('location').getFullList(
      sort: '-created',
    );

    return records.where((record) {
      log('record: $record');
      return record.data['status'] == 'active' && record.data['category_id'].contains(categoryId);
      
    }).toList();
  }
}


