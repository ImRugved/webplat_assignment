import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:webplat_assignment/global/global.dart';
import '../model/object_model.dart';

class ObjectProvider extends ChangeNotifier {
  List<ObjectItem> objects = [];
  List<ObjectItem> filteredObjects = [];
  List<String> recentSearches = [];
  bool isLoading = false;
  String error = '';
  String searchQuery = '';

  static const String _recentSearchesKey = Global.sharedPreferencesKey;

  ObjectProvider() {
    fetchObjects();
    _loadRecentSearches();
  }

  Future<void> fetchObjects() async {
    isLoading = true;
    error = '';
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    log('host url: ${Global.hostUrl + Global.objectsList}');

    try {
      final dio = Dio();

      final response = await dio.get('https://api.restful-api.dev/objects');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        objects = jsonData.map((json) => ObjectItem.fromJson(json)).toList();
        filteredObjects = List.from(objects);
        error = '';
      } else {
        log('Failed to load objects. Status code: ${response.statusCode}');
        error = 'Failed to load objects. Status code: ${response.statusCode}';
      }
    } catch (e) {
      log('Dio Exception: $e');
      error = 'Error fetching objects: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchObjects(String query) {
    searchQuery = query;

    if (query.isEmpty) {
      filteredObjects = objects.toList();
    } else {
      filteredObjects = objects.where((object) {
        return object.name.toLowerCase().contains(query.toLowerCase()) ||
            (object.data != null &&
                object.formattedData.toLowerCase().contains(
                  query.toLowerCase(),
                ));
      }).toList();
    }

    notifyListeners();
  }

  Future<void> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searchesJson = prefs.getStringList(_recentSearchesKey);
      if (searchesJson != null) {
        recentSearches = searchesJson;
        notifyListeners();
      }
    } catch (e) {
      recentSearches = [];
    }
  }

  Future<void> _saveRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_recentSearchesKey, recentSearches);
    } catch (e) {
      print(e);
    }
  }

  void addToRecentSearches(String query) async {
    if (query.isNotEmpty && !recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      if (recentSearches.length > 10) {
        recentSearches = recentSearches.take(10).toList();
      }
      await _saveRecentSearches();
      notifyListeners();
    }
  }

  void clearSearch() {
    searchQuery = '';
    filteredObjects = objects.toList();
    notifyListeners();
  }

  void removeRecentSearch(String search) async {
    recentSearches.remove(search);
    await _saveRecentSearches();
    notifyListeners();
  }

  void clearRecentSearches() async {
    recentSearches.clear();
    await _saveRecentSearches();
    notifyListeners();
  }

  void selectRecentSearch(String search) {
    searchObjects(search);
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    await fetchObjects();
  }
}
