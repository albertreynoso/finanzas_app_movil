import 'package:flutter/foundation.dart';
import '../data/models/category_model.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categories = [];
  
  List<CategoryModel> get categories => _categories;
  
  List<CategoryModel> getCategoriesByType(String type) {
    return _categories.where((c) => c.type == type).toList();
  }
}