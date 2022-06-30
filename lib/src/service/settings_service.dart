import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/settings_repository.dart';

// Clase del servicio de las preferencias del usuario
class SettingsService {

  // Carga el tema preferido del usuario
  Future<ThemeMode> themeMode() async => SettingsRepository.getThemeMode(await SharedPreferences.getInstance());

  // Persistencia del tema preferido
  Future<void> updateThemeMode(ThemeMode theme) async {

    // Almacenar en las SharedPreferences el nuevo tema
    SettingsRepository.setThemeMode(theme);
  }

}