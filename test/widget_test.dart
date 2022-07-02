import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_movil/src/controller/settings_controller.dart';
import 'package:proyecto_movil/src/dto/restaurante.dart';
import 'package:proyecto_movil/src/service/service.dart';
import 'package:proyecto_movil/src/service/settings_service.dart';
import 'package:proyecto_movil/src/view/restaurante_detail_view.dart';
void main() {
  group('main Widget', () {
    testWidgets('Tests para el widget de restaurantes de Asturias', (WidgetTester tester) async {

      // Asegurar que los widgets se hayan inicializado
      WidgetsFlutterBinding.ensureInitialized();

      // Cargar los ajustes y preferencias del sistema
      final settingsController = SettingsController(SettingsService());
      settingsController.loadSettings();

      // Mockear la lista de restaurantes para simular la petición HTTP
      var restaurants = List<Restaurante>.empty(growable: true);
      var restaurant = Restaurante(
        name: "La Allandesa",
        email: "eventos@allandesa.com",
        description: "Restaurante más conocido de Pola de Allande, con amplia carta y comida casera.",
        address: "C. Donato Fernández, 3, 33880 Pola de Allande, Asturias",
        zone: "Occidente de Asturias",
        location: "Lon:43.271643911506786, Lat:-6.610538358327623",
        telephone: "985 36 73 77",
        web: "https://www.hotelesfinder.com/hotel-nueva-allandesa/",
        categories: "Restaurante, Bar, Allande, Pola de Allande",
        facebook: "https://www.facebook.com/allandesa",
        twitter: "",
        instagram: "",
      );
      restaurants.add(restaurant);

      // Asociar ese restaurante a la lista del widget
      Service.sitios = restaurants;

      // Espera encontrar texto en el widget ListView, pues los atributos de Restaurant son string
      expect(find.byType(Text), findsOneWidget);

      // Invocar al widget al primer plano de la UI
      await tester.pump();
      var restaurantDetail = RestaurantDetailView(restaurante: restaurants[0]);

      // Tests para el widget DetailView
      expect(restaurantDetail.restaurante.name, "La Allandesa");
      expect(restaurantDetail.restaurante.email, "eventos@allandesa.com");
      expect(restaurantDetail.restaurante. description, "Restaurante más conocido de Pola de Allande, con amplia carta y comida casera.",);
      expect(restaurantDetail.restaurante.address, "C. Donato Fernández, 3, 33880 Pola de Allande, Asturias");
      expect(restaurantDetail.restaurante.zone, "Occidente de Asturias");
      expect(restaurantDetail.restaurante.location, "Lon:43.271643911506786, Lat:-6.610538358327623");
      expect(restaurantDetail.restaurante.telephone, "985 36 73 77");
      expect(restaurantDetail.restaurante.web, "https://www.hotelesfinder.com/hotel-nueva-allandesa/");
      expect(restaurantDetail.restaurante.categories, "Restaurante, Bar, Allande, Pola de Allande");
      expect(restaurantDetail.restaurante.facebook, "https://www.facebook.com/allandesa");
      expect(restaurantDetail.restaurante.twitter, "");
      expect(restaurantDetail.restaurante.instagram, "");

      // Espera encontrar texto en el widget DetailView, pues los atributos de Restaurant son string
      expect(find.byType(Text), findsOneWidget);

    });
  });
}