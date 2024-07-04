import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _subscribeToCategoryChanges();
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
      final categories = await pb
          .collection('category')
          .getFullList();
      _categoriesController.sink.add(categories);
    } catch (e) {
      _categoriesController.sink.addError(e);
    }
  }

  void _subscribeToCategoryChanges() {
    pb.collection('category').subscribe('*', (e) async {
      // Re-fetch the categories list on any change
      await _fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías',),
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
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                RecordModel category = snapshot.data![index];
                //print(category);
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(category.data['name']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MapClient(categoryId: category.id, categoryName: category.data['name']),
                        ),
                      );
                    },
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
