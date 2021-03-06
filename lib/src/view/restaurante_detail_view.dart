import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proyecto_movil/src/view/settings_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:proyecto_movil/src/dto/restaurante.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RestaurantDetailView extends StatelessWidget {
  // Instancia del objeto Restaurant a mostrar en detalle
  final Restaurante restaurante;

  // Constructor que requiere una instancia de Restaurant
  const RestaurantDetailView({Key? key, required this.restaurante})
      : super(key: key);

  // Nombre de la ruta
  static const routeName = '/sample_item';

  /// Ejecuta el launch o muestra un Toast en caso de error
  void launchUrl(BuildContext context, String url) async {
    try {
      await launch(url);
    }
    catch (platformException) {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.launchError,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lista de marcadores para el Google Map
    List<Marker> _markers = [];

    _markers.add(Marker(
        markerId: MarkerId(restaurante.name),
        position: LatLng(
          // Obtener las coordenadas (Lat, Long) del objeto Restaurant
            double.parse(restaurante.location.split(',')[0]),
            double.parse(restaurante.location.split(',')[1])
        ),
        infoWindow: InfoWindow(
          // La ventana informativa sera la direccion para que al hacer clic
          // sobre el marcador nos redirija a una busqueda en Google Maps
            title: restaurante.address
        )
    )
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(restaurante.name),
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
        // el OrientationBuilder determinara si la orientacion es portrait o landscape
        body: OrientationBuilder(
            builder: (context, orientation) {
              return orientationResolver(
                  context, _markers, orientation == Orientation.portrait
              );
            }
        )
    );
  }

  Widget orientationResolver(BuildContext context, List<Marker> _markers, bool isPortrait) {
    if (isPortrait) {
      // Layout para posicion vertical
      return SingleChildScrollView(
          child: Column(
              children: [
                // Muestra la imagen y el detail Widget con el ancho completo
                Image.network("https://d1csarkz8obe9u.cloudfront.net/posterpreviews/restaurant-logo-design-template-b281aeadaa832c28badd72c1f6c5caad_screen.jpg?ts=1595421543"),
                detailWidget(context, _markers, MediaQuery.of(context).size.width)
              ]
          )
      );
    }
    else {
      // Layout para posicion horizontal
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Muestra el detail Widget con la mitad del ancho a la derecha
          SingleChildScrollView(
            child: detailWidget(context, _markers, MediaQuery.of(context).size.width / 2),
          )
        ],
      );
    }
  }

  Widget detailWidget(BuildContext context, List<Marker> _markers, double width) {
    // El entero que se resta en el atributo width es el padding aplicado
    return Column(children: [
      SizedBox(
        width: width - 36,
        // Renderizar el codigo HTML de la descripcion del objeto Restaurant
        child: Html(
            data: restaurante.description.toString(),
            style: {
              "body": Style(
                  textAlign: TextAlign.justify,
                  fontSize: FontSize.large,
                  margin: const EdgeInsets.all(9.0)
              )
            }
        ),
      ),
      SizedBox(
        height: 50,
        width: width - 36,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Boton de llamada en una Row de ancho completo
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(width - 48, 45),
                  maximumSize: Size(width - 48, 45)),
              onPressed: () {
                // Al pulsarlo, copia el numero de telefono al dialer para llamar
                launchUrl(context, 'tel:' + restaurante.telephone);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.phone),
                  Text(" " + AppLocalizations.of(context)!.call)
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 65,
        width: width - 36,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Boton de enviar un email con acceso al correo en una Row de medio ancho
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(width / 2 - 28, 45),
                  maximumSize: Size(width / 2 - 28, 45)),
              onPressed: () {
                // Al pulsarlo, copia la direccion de correo en el campo del destinatario
                launchUrl(context, 'mailto:' + restaurante.email.toString());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.email),
                  Text(
                      " " + AppLocalizations.of(context)!.email,
                      style: const TextStyle(fontSize: 12)
                  )
                ],
              ),
            ),
            // Boton de acceder al sitio web del restaurante en una Row de medio ancho
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(width / 2 - 28, 45),
                  maximumSize: Size(width / 2 - 28, 45)),
              onPressed: () {
                // Al pulsarlo, redirige a la pagina web indicada por URL
                launchUrl(context, restaurante.web.toString());
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.web),
                    Text(" " + AppLocalizations.of(context)!.web)
                  ]
              ),
            ),
          ],
        ),
      ),
      SizedBox(
          width: width - 36,
          child: Column(children: <Widget>[
            Text(
              // Titulo de la seccion Acerca de
                AppLocalizations.of(context)!.about,
                style: const TextStyle(
                    height: 2, fontSize: 20, fontWeight: FontWeight.bold)
            ),
            SizedBox(
                height: 30,
                width: width - 36,
                child:
                Html(
                  // Subtitulo del campo Direccion
                    data: AppLocalizations.of(context)!.address,
                    style: {
                      "body": Style(
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.justify,
                          fontSize: FontSize.larger,
                          margin: const EdgeInsets.all(9.0)
                      )
                    }
                )
            ),
            SizedBox(
                height: 60,
                width: width - 36,
                child: Html(
                  // Valor del campo Direccion
                    data: restaurante.address.toString() + (restaurante.zone.isNotEmpty
                        ? ", " + restaurante.zone + ", "
                        : ", "),
                    style: {
                      "body": Style(
                          textAlign: TextAlign.justify,
                          fontSize: FontSize.large,
                          margin: const EdgeInsets.all(9.0)
                      )
                    }
                )
            ),
          ]
          )
      ),
      SizedBox(
          height: 50,
          width: width - 36,
          child: Html(
            // Subtitulo del campo Etiquetas
              data: AppLocalizations.of(context)!.tags,
              style: {
                "body": Style(
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.justify,
                    fontSize: FontSize.larger,
                    margin: const EdgeInsets.only(bottom: 9.0, left: 9.0, right: 9.0, top: 26.0)
                )
              }
          )
      ),
      SizedBox(
          width: width - 36,
          child: Html(
            // Valor del campo Etiquetas
              data: restaurante.categories, style: {
            "body": Style(
                textAlign: TextAlign.justify,
                fontSize: FontSize.large,
                margin: const EdgeInsets.all(9.0)
            )
          }
          )
      ),
      Text(
        // Titulo de la seccion Redes Sociales
          AppLocalizations.of(context)!.socialMedia,
          style: const TextStyle(height: 2, fontSize: 20, fontWeight: FontWeight.bold)
      ),
      SizedBox(
        height: 65,
        width: width - 36,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Boton de acceder al Facebook del restaurante en una Row de un tercio de ancho
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(width / 3 - 18, 45),
                  maximumSize: Size(width / 3 - 18, 45)),
              onPressed: () {
                // Al pulsarlo, redirige a la pagina de Facebook indicada por URL
                launchUrl(context, restaurante.facebook.toString());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.facebook),
                  Text(
                      " Facebook",
                      style: TextStyle(fontSize: 12)
                  )
                ],
              ),
            ),
            // Boton de acceder al Twitter del restaurante en una Row de un tercio de ancho
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(width / 3 - 18, 45),
                  maximumSize: Size(width / 3 - 18, 45)),
              onPressed: () {
                // Al pulsarlo, redirige via Twitter o navegador a la pagina de Twitter indicada por URL
                launchUrl(context, restaurante.twitter.toString());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(FontAwesomeIcons.twitter),
                  Text(" Twitter", style: TextStyle(fontSize: 12))
                ],
              ),
            ),
            // Boton de acceder al Instagram del restaurante
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(width / 3 - 18, 45),
                  maximumSize: Size(width / 3 - 18, 45)),
              onPressed: () {
                // Al pulsarlo, redirige via Instagram o navegador a la pagina de Instagram indicada por URL
                launchUrl(context, restaurante.instagram.toString());
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(FontAwesomeIcons.instagram),
                    Text(" Instagram", style: TextStyle(fontSize: 12))
                  ]
              ),
            ),
          ],
        ),
      ),
      Text(
        // Titulo de la seccion Ubicacion
          AppLocalizations.of(context)!.location,
          style: const TextStyle(height: 2, fontSize: 20, fontWeight: FontWeight.bold)
      ),
      Column(
        children: <Widget>[
          SizedBox(
              width: width - 48,
              height: 300.0,
              // Widget de Google Maps
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    // Establecer la posicion inicial en las coordenadas del restaurante
                      double.parse(restaurante.location.split(',')[0]),
                      double.parse(restaurante.location.split(',')[1])),
                  zoom: 15,
                ),
                // A??adir el marcador en las coordenadas del restaurante
                markers: Set<Marker>.of(_markers),
              )
          )
        ],
      )
    ]
    );
  }
}