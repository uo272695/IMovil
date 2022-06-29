class Restaurante {

  // Atributos
  String name;
  String email;
  String description;
  String address;
  String zone;
  String image;
  String location;
  String buses;
  String telephone;
  String web;
  String tags;
  String facebook;
  String twitter;
  String instagram;

  // Constructor
  Restaurante({
    required this.name,
    required this.email,
    required this.description,
    required this.address,
    required this.zone,
    required this.image,
    required this.location,
    required this.buses,
    required this.telephone,
    required this.web,
    required this.tags,
    required this.facebook,
    required this.twitter,
    required this.instagram,
  });

  // Convertir la lista de datos dinamicos obtenida del JSON en una lista parseada de objetos Restaurante
  static List<Restaurante> parseRestaurants(List<dynamic> data) {
    Set<Restaurante> restaurants = {};
    for (var element in data) {
      // Evitar duplicados
      if(!restaurants.map((e) => e.name).contains(element["titulo"])){
        restaurants.add(Restaurante(
          name: element["Nombre"].toString().replaceAll("&quot;", "\""),
          email: element["Email"],
          description: element["Texto"],
          address: element["Direccion"],
          zone: element["Zona"],
          image: element["imagen"],
          location: element["Coordenadas" "Localidad"],
          buses: element["lineas_bus"],
          telephone: element["Telefono"],
          web: element["Web"],
          tags: element["etiquetas"],
          facebook: element["Facebook"],
          twitter: element["Twitter"],
          instagram: element["Instagram"],));
      }
    }
    return List.from(restaurants);
  }

  // Devuelve las posibles zonas de un restaurante para filtros
  static List<String> getZones() {
    return List<String>.from(["Centro de Asturias", "Occidente de Asturias", "Oriente de Asturias"]);
  }

  // Devuelve las categorias existentes para filtros
  static List<String> getCategories() {
    return List<String>.from(["Restaurante", "Oviedo", "Salas","Gijón", "Avilés", "Bar", "Sidrería",
      "Comarca Vaqueira", "Menú Celiacos","Valle del Nalón", "Valdés", "Comarca de la Sidra", "Colunga", "Ribadedeva","Tineo",
      "Cangas del Narcea", "Pola de Allande", "Pola de Laviana", "Cangas de Onís", "Pola de Siero", "Villaviciosa", "Llanes", "Cudillero",
      "Luarca", "Navia", "Pravia", "Tapia de Casariego", "Ribadeo", "Parque Histórico del Navia", "Allande"]);

  }
}