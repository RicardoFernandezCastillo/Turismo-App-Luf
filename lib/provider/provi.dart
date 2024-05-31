
import 'package:flutter/foundation.dart';
import 'package:luf_turism_app/services/pocket_test.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void getCategories() async{
    var result = PocketBaseService.getCategories();
    //print(result);
    _categories = result as List<Category>;
    notifyListeners();
  }
}