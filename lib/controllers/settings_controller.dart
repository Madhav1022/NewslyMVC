import 'package:flutter/material.dart';
import '../services/db_provider.dart';

class SettingsController {
  static final ValueNotifier<bool> themeNotifier = ValueNotifier(false);
  static bool get isDarkMode => themeNotifier.value;

  static void loadTheme() {
    themeNotifier.value = false;
  }

  void toggleDarkMode() {
    themeNotifier.value = !themeNotifier.value;
  }

  Future<void> clearCache() async {
    final db = await DBProvider.db.database;
    await db.delete('bookmarks');
  }
}
