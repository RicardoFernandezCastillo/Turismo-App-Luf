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

  static Future<void> removeFromFavoritesID(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> favorites = await getPlacesFavorites();
      if (favorites.contains(id)) {
        favorites.remove(id);
        await prefs.setString('favorites', jsonEncode(favorites));
        log('Favorites updated');
      } else {
        log('Element does not exist');
      }
    } catch (error) {
      log('$error');
    }
  }

  static Future<void> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('favorites');
      log('Favorites cleared');
    } catch (error) {
      log('$error');
    }
  }

  static Future<bool> isFavorite(String id) async {
    try {
      List<String> favorites = await getPlacesFavorites();
      return favorites.contains(id);
    } catch (error) {
      log('$error');
      return false;
    }
  }

  static Future<void> toggleFavorite(String id) async { // la funcion toggleFavorite se encarga de agregar o quitar un lugar de la lista de favoritos
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> favorites = await getPlacesFavorites();
      if (favorites.contains(id)) {
        favorites.remove(id);
        await prefs.setString('favorites', jsonEncode(favorites));
        log('Favorites updated');
      } else {
        favorites.add(id);
        await prefs.setString('favorites', jsonEncode(favorites));
        log('Favorites updated');
      }
    } catch (error) {
      log('$error');
    }
  }


}