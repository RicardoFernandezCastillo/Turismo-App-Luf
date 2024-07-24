import 'package:flutter/material.dart';
import 'package:luf_turism_app/models/categoryDB/category_db.dart';
import 'package:luf_turism_app/pages/Map/search_map.dart';
import 'package:pocketbase/pocketbase.dart';
import 'dart:async';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  CategoriesPageState createState() => CategoriesPageState();
}

class CategoriesPageState extends State<CategoriesPage> {
  static final PocketBase pb =
      PocketBase('https://boring-carpenter.pockethost.io');
  final StreamController<List<dynamic>> _categoriesController =
      StreamController();

  final List<Icon> iconsCategory = IconsInfo.icons;

  List<CategoryStatic> categoriesStatic = CategoriesStatic.categories;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  //revisar ----------------------------------
  void dispose() {
    _categoriesController.close();
    pb.collection('category').unsubscribe('*');
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await pb.collection('category').getFullList();
      _categoriesController.sink.add(categories);
    } catch (e) {
      _categoriesController.sink.addError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(1, 82, 104, 1),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: _categoriesController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found.'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Dos elementos por fila
                childAspectRatio: 3 / 2, // Aspect ratio de los elementos
                crossAxisSpacing: 10, // Espaciado horizontal
                mainAxisSpacing: 10, // Espaciado vertical
              ),
              padding: const EdgeInsets.all(10), // Padding general del GridView
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                RecordModel category = snapshot.data![index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(8),
                  color: const Color.fromARGB(255, 6, 168, 168),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(categoriesStatic.firstWhere(
                                (element) => element.name == category.data['name']).imageURL
                            ),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.9),
                          BlendMode.dstATop,
                        ),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapClient(
                              categoryId: category.id,
                              categoryName: category.data['name'],
                            ),
                          ),
                        );
                      },
                      splashColor: const Color.fromRGBO(0, 122, 129, 1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          iconsCategory.firstWhere(
                            (icon) => icon.semanticLabel == category.data['name'],
                            orElse: () => const Icon(Icons.category, size: 40),
                          ),
                          const SizedBox(
                              height: 10), // Espacio entre icono y texto
                          Text(
                            category.data['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white, // Color del texto
                              fontSize: 20, // Tamaño del texto
                              fontWeight: FontWeight.bold, // Negrita
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
