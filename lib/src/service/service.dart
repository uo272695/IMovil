import 'dart:convert';
import '/src/dto/restaurante.dart';
import 'package:http/http.dart' as http;

class Service{

  //URL al archivo JSON con los datos de los sitios para comer
  static const String URL="https://uo272695.github.io/Data/Donde-Comer.json";

  //Lista de restaurantes en la que se guarda la información del servicio recibido con la petición GET
  static List<Restaurante> sitios = [];

  // Ejecuta la peticion GET para consumir la API REST
  static Future<List<Restaurante>> getRestaurants() async {
    // GET Request
    var response = await http.get(Uri.parse(URL));

    if(response.statusCode != 200) {
      return [];
    }
    // Parsea el JSON al formato definido en la clase DTO Restaurant.dart
    Service.sitios = Restaurante.parseRestaurants(json.decode(response.body));

    return Service.sitios;
  }
}