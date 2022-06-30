import 'package:flutter/material.dart';

import '../service/settings_service.dart';

// Clase del controlador de las preferencias del usuario
// Se monitoriza el tema elegido por el propio usuario
class SettingsController with ChangeNotifier {

  // Constructor
  SettingsController(this.settingsService);

  // Instancia de la clase del servicio de las preferencias
  final SettingsService settingsService;

  // Atributo para monitorizar el tema preferido del usuario
  late ThemeMode themeMode2;

  // Inicializacion del atributo que monitoriza el tema preferido del usuario
  ThemeMode get themeMode => themeMode2;


  // Actualizacion y persistencia del tema preferido
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == themeMode2) return;
    themeMode2 = newThemeMode;
    notifyListeners();
    await settingsService.updateThemeMode(newThemeMode);
  }

  // Se cargan los ajustes a través del servicio correspondiente
  Future<void> loadSettings() async {
    themeMode2 = await settingsService.themeMode();
    notifyListeners();
  }

}