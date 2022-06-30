import 'package:flutter/material.dart';

import '../service/settings_service.dart';

// Clase del controlador de las preferencias del usuario
// Se monitoriza el tema elegido por el propio usuario
class SettingsController with ChangeNotifier {

  // Constructor cuyo parametro es una instancia del servicio
  SettingsController(this._settingsService);

  // Instancia de la clase del servicio de las prefernecias del usuario
  final SettingsService _settingsService;

  // Atributo para monitorizar el tema preferido del usuario
  late ThemeMode _themeMode;

  // Inicializacion del atributo que monitoriza el tema preferido del usuario
  ThemeMode get themeMode => _themeMode;


  // Actualizacion y persistencia del tema preferido
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
  }

  // Se cargan los ajustes a través del servicio correspondiente
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    notifyListeners();
  }

}