import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_movil/src/dto/restaurante.dart';
import 'package:proyecto_movil/src/service/service.dart';
import 'package:proyecto_movil/src/view/restaurante_detail_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../view/settings_view.dart';

/// Interfaz de la ventana que muestra la lista de restaurantes
class RestaurantListView extends StatefulWidget {

  // Constructor por defecto
  const RestaurantListView({
    Key? key,
  }) : super(key: key);

  // Inicializacion del estado de la clase del Widget con estado
  @override
  State<RestaurantListView> createState() => _RestaurantsState();

  // Nombre de la ruta
  static const routeName = '/';
}

/// Clase que define el estado del Widget
class _RestaurantsState extends State<RestaurantListView> {

  // Lista global de objetos Restaurant (varia segun filtros)
  List<Restaurante> list = [];

  // Cache anterior a memoria para almacenar la lista
  List<dynamic> dataCache = [];

  // Cadena de busqueda en el Widget de filtros
  String target = "";

  // Lista de posibles categorias para filtrar
  List<String> filtersList = Restaurante.getZones() + Restaurante.getCategories();

  // Lista de zonas seleccionadas, por defecto todas
    List<String> selectedFiltersList = Restaurante.getZones();


  /// Abre el cuadro de dialogo con las etiquetas para filtrar
  void openFilterDialog(context) async {
    await FilterListDialog.display<String>(
      context,
      themeData: Theme.of(context).brightness == Brightness.light
          ? FilterListThemeData.light(context)
          : FilterListThemeData.dark(context),
      listData: filtersList,
      selectedListData: selectedFiltersList,
      headlineText: AppLocalizations.of(context)!.filters,
      choiceChipLabel: (item) => item,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (item, text) {
        // Busca coincidencias entre las etiquetas de filtro
        return item.toLowerCase().contains(text.toLowerCase());
      },
      onApplyButtonClick: (click) {
        setState(() {
          // Añade el filtro seleccionado a la lista de filtros
          selectedFiltersList = List.from(click!);
        });
        // Re-inicializa la lista con todas las coincidencias tras los filtros
        list.clear();
        for (var restaurant in Service.sitios) {
          for (var filter in selectedFiltersList) {
            if (
            (restaurant.zone.toLowerCase() == filter.toLowerCase()
                || restaurant.categories.toLowerCase().contains(filter.toLowerCase()))
                &&
                !list.map((restaurant) => restaurant.name).contains(restaurant.name)
            ) {
              // Añade si hay coincidencia y no estaba repetido previamente
              list.add(restaurant);
            }
          }
        }
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navegacion a la ventana de ajustes, recuperando el contexto
              // (posicion en la lista en la que se encontraba el usuario)
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: <Widget>[
              Container(
                // MediaQuery devuelve el ancho de la pantalla, tanto portrait como landscape
                width: MediaQuery.of(context).size.width - 96,
                margin: const EdgeInsets.only(bottom: 8, top: 16, left: 24, right: 8),
                // TextField para buscar por nombre o direccion
                child: TextField(
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.placeholder,
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.blue))),
                    onChanged: (value) {
                      target = value;
                      // Carga una nueva lista de objetos Restaurant con los resultados de la busqueda
                      searchRestaurant(target);
                    }),
              ),
              // Boton para aplicar los filtros por distrito o etiqueta
              IconButton(
                icon: const Icon(Icons.filter_alt),
                onPressed: () {
                  // Abre el dialogo de seleccion de filtros
                  openFilterDialog(context);
                },
              ),
            ],
          ),
          Expanded(
            // Crea la ListView de objetos Restaurant
              child: createRestaurantWidget()
          )
        ],
      ),
    );
  }

  createRestaurantWidget() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return FutureBuilder(
          // Cargar desde cache la lista de objetos Restaurant
            future: loadCache(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Construir el ListView con su propio Builder
                return ListView.builder(
                  shrinkWrap: true,
                  restorationId: 'sampleItemListView',
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Definir cada item Restaurant dentro de la iteracion
                    final item = list[index];
                    return ListTile(
                        leading: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 100,
                            minHeight: 550,
                            maxWidth: 104,
                            maxHeight: 551,
                          ),
                        ),
                        title: Text(item.name),
                        subtitle: Text(item.address.toString()),
                        onTap: () {
                          // Navegacion a la ventana de detalle de cada restaurante, llamando
                          // al constructor de dicha clase pasando el item como parametro
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => RestaurantDetailView(restaurante: item)
                              )
                          );
                        }
                    );
                  },
                );
              }
              else if (snapshot.hasError) {
                // En caso de error
                return Text(snapshot.error.toString());
              }
              else {
                return Center(
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                // Abstraccion de carga con un CircularProgressIndicator
                                child: CircularProgressIndicator(),
                              )
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                          )
                        ]
                    )
                );
              }
            }
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Inicializar el estado filtrando el target (si hubiera) entre todos los objetos Restaurant
    list.addAll(Service.sitios);
    searchRestaurant(target);
  }

  /// Carga de la cache
  Future<List<Restaurante>> loadCache() async {
    // Inicializacion de la cache y retorno de la lista de objetos Restaurant
    dataCache = await Service.getRestaurants();
    return Service.getRestaurants();
  }

  void searchRestaurant(String query) {
    List<Restaurante> listBeforeSearch = [];
    List<Restaurante> listAfterSearch = [];
    // Filtrar todos los objetos Restaurant segun la query pasada como parametro
    listBeforeSearch.addAll(Service.sitios);
    if (query.isNotEmpty) {
      for (var restaurant in listBeforeSearch) {
        // La query puede coincidir con el nombre o la direccion del restaurante
        if (restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
            restaurant.address.toString().toLowerCase().contains(query.toLowerCase())) {
          listAfterSearch.add(restaurant);
        }
      }
      // Actualizar el estado de la lista a todos los resultados de la busqueda
      setState(() {
        list.clear();
        list.addAll(listAfterSearch);
      });
    }
    // Actualizar el estado de la lista a todos los objetos Restaurant si no hay query
    else {
      setState(() {
        list.clear();
        list.addAll(listBeforeSearch);
      });
    }
  }

}