import 'package:flutter/material.dart';
import 'package:proyecto_movil/src/dto/restaurante.dart';
import 'package:proyecto_movil/src/service/service.dart';

import 'src/app.dart';
import 'src/controller/settings_controller.dart';
import 'src/service/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializacion de la instancia del controlador
  final settingsController = SettingsController(SettingsService());

  // Cargar el tema preferido del usuario antes de mostrar la pantalla
  await settingsController.loadSettings();

  // Devuelve el restaurante por defecto para arrancar la aplicacion
  List<Restaurante> restaurants = await Service.getRestaurants();

  // Ejecucion de la aplicacion con el controlador y un restaurante como parametros
  runApp(MyApp(settingsController: settingsController, rest: restaurants[0]));
}