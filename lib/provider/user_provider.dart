import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:webplat_assignment/global/global.dart';
import '../model/user_model.dart';

class UserProvider extends ChangeNotifier {
  List<User> users = [];
  List<User> filteredUsers = [];
  List<String> recentSearches = [];
  bool isLoading = false;
  String error = '';
  String searchQuery = '';

  static const String _recentSearchesKey = Global.sharedPreferencesKey;

  UserProvider() {
    fetchUsers();
    _loadRecentSearches();
  }

  Future<void> fetchUsers() async {
    isLoading = true;
    error = '';
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    log('host url: ${Global.hostUrl + Global.userList}');

    try {
      final dio = Dio();

      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/users',
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        users = jsonData.map((json) => User.fromJson(json)).toList();
        filteredUsers = List.from(users);
        error = '';
      } else {
        log('Failed to load users. Status code: ${response.statusCode}');
        error = 'Failed to load users. Status code: ${response.statusCode}';
      }
    } catch (e) {
      log('Dio Exception: $e');
      error = 'Error fetching users: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchUsers(String query) {
    searchQuery = query;

    if (query.isEmpty) {
      filteredUsers = users.toList();
    } else {
      filteredUsers = users.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.username.toLowerCase().contains(query.toLowerCase());
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
    filteredUsers = users.toList();
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
    searchUsers(search);
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    await fetchUsers();
  }
}
