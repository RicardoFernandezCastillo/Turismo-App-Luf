import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<List<String>> getPlacesFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonValue = prefs.getString('favorites');
      if (jsonValue != null) {
        return List<String>.from(jsonDecode(jsonValue));
      }
      return [];
    } catch (e) {
      debugPrint('Error getting favorites: $e');
      return [];
    }
  }

  static Future<void> addToFavoritesID(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> favorites = await getPlacesFavorites();
      if (!favorites.contains(id)) {
        favorites.add(id);
        await prefs.setString('favorites', jsonEncode(favorites));
        log('Favorites updated');
      } else {
        log('Element already exists');
      }
    } catch (error) {
      log('$error');
    }
  }
}