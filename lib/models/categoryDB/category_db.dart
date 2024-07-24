import 'package:flutter/material.dart';

class CategoryName {
  static const String calles = 'Calles Importantes';
  static const String restaurantes = 'Restaurantes';
  static const String zoologicos = 'Zoológicos y Acuarios';
  static const String cines = 'Cines y Teatros';
  static const String mercados = 'Mercados y Centros Comerciales';
  static const String personajes = 'Lugares y Personajes Históricos';
  static const String entretenimiento = 'Lugares de Entretenimiento';
  static const String religiosos = 'Edificios Religiosos';
  static const String deportivos = 'Campos Deportivos';
  static const String parques = 'Parques';
  static const String lagunas = 'Lagunas y Rios';
  static const String plazas = 'Plazas';
  static const String hoteles = 'Hoteles';
  static const String educacion = 'Colegios y Universidades';
}

class IconsInfo {
  static const List<Icon> icons = [
    Icon(Icons.location_city, semanticLabel: CategoryName.calles),
    Icon(Icons.restaurant, semanticLabel: CategoryName.restaurantes),
    Icon(Icons.pets, semanticLabel: CategoryName.zoologicos),
    Icon(
      Icons.movie,
      semanticLabel: CategoryName.cines,
    ),
    Icon(Icons.shopping_cart, semanticLabel: CategoryName.mercados),
    Icon(Icons.people, semanticLabel: CategoryName.personajes),
    Icon(Icons.local_activity, semanticLabel: CategoryName.entretenimiento),
    Icon(Icons.account_balance, semanticLabel: CategoryName.religiosos),
    Icon(Icons.sports_soccer, semanticLabel: CategoryName.deportivos),
    Icon(Icons.park, semanticLabel: CategoryName.parques),
    Icon(Icons.water, semanticLabel: CategoryName.lagunas),
    Icon(Icons.park, semanticLabel: CategoryName.plazas),
    Icon(Icons.hotel, semanticLabel: CategoryName.hoteles),
    Icon(Icons.school, semanticLabel: CategoryName.educacion),
  ];
}

class CategoryStatic {
  final String name;
  final Icon icon;
  final String imageURL;
  final String id;

  CategoryStatic({
    required this.name,
    required this.icon,
    required this.id,
    required this.imageURL,
  });
}

class CategoriesStatic {
  static final CategoryStatic calles = CategoryStatic(
    name: CategoryName.calles,
    icon: IconsInfo.icons[0],
    id: '1',
    imageURL: 'assets/categorias/calles.jpg',
  );
  static final CategoryStatic restaurantes = CategoryStatic(
    name: CategoryName.restaurantes,
    icon: IconsInfo.icons[1],
    id: '2',
    imageURL: 'assets/categorias/restaurante.jpg',
  );
  static final CategoryStatic zoologicos = CategoryStatic(
    name: CategoryName.zoologicos,
    icon: IconsInfo.icons[2],
    id: '3',
    imageURL: 'assets/categorias/zoologicos.jpg',
  );
  static final CategoryStatic cines = CategoryStatic(
    name: CategoryName.cines,
    icon: IconsInfo.icons[3],
    id: '4',
    imageURL: 'assets/categorias/cines.jpg',
  );
  static final CategoryStatic mercados = CategoryStatic(
    name: CategoryName.mercados,
    icon: IconsInfo.icons[4],
    id: '5',
    imageURL: 'assets/categorias/comercial.jpg',
  );
  static final CategoryStatic personajes = CategoryStatic(
    name: CategoryName.personajes,
    icon: IconsInfo.icons[5],
    id: '6',
    imageURL: 'assets/categorias/personajes.jpg',
  );
  static final CategoryStatic entretenimiento = CategoryStatic(
    name: CategoryName.entretenimiento,
    icon: IconsInfo.icons[6],
    id: '7',
    imageURL: 'assets/categorias/entretenimiento.jpg',
  );
  static final CategoryStatic religiosos = CategoryStatic(
    name: CategoryName.religiosos,
    icon: IconsInfo.icons[7],
    id: '8',
    imageURL: 'assets/categorias/religiosos.jpg',
  );
  static final CategoryStatic deportivos = CategoryStatic(
    name: CategoryName.deportivos,
    icon: IconsInfo.icons[8],
    id: '9',
    imageURL: 'assets/categorias/deportivo.jpg',
  );
  static final CategoryStatic parques = CategoryStatic(
    name: CategoryName.parques,
    icon: IconsInfo.icons[9],
    id: '10',
    imageURL: 'assets/categorias/parques.jpg',
  );
  static final CategoryStatic lagunas = CategoryStatic(
    name: CategoryName.lagunas,
    icon: IconsInfo.icons[10],
    id: '11',
    imageURL: 'assets/categorias/lagunas.jpg',
  );
  static final CategoryStatic plazas = CategoryStatic(
    name: CategoryName.plazas,
    icon: IconsInfo.icons[11],
    id: '12',
    imageURL: 'assets/categorias/plazas.jpg',
  );
  static final CategoryStatic hoteles = CategoryStatic(
    name: CategoryName.hoteles,
    icon: IconsInfo.icons[12],
    id: '13',
    imageURL: 'assets/categorias/hoteles.jpg',
  );
  static final CategoryStatic educacion = CategoryStatic(
    name: CategoryName.educacion,
    icon: IconsInfo.icons[13],
    id: '14',
    imageURL: 'assets/categorias/educacion.jpg',
  );

  static final List<CategoryStatic> categories = [
    calles,
    restaurantes,
    zoologicos,
    cines,
    mercados,
    personajes,
    entretenimiento,
    religiosos,
    deportivos,
    parques,
    lagunas,
    plazas,
    hoteles,
    educacion,
  ];
}
