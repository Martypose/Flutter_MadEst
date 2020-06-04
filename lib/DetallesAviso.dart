import 'package:flutter/material.dart';
import 'Aviso.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


class DetallesAviso extends StatefulWidget {
  final Aviso aviso;

  DetallesAviso({Key key, @required this.aviso}) : super(key: key);

  //En widget.aviso tenemos el objeto aviso en cuestion, podemos acceder a cualquier de sus propiedades

  @override
  _DetallesAvisoState createState() => _DetallesAvisoState();
}

class _DetallesAvisoState extends State<DetallesAviso> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos aviso: ${widget.aviso.id}'),
        backgroundColor: const Color(0xff37323e),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(border: TableBorder.all(), children: [
                for (var key in widget.aviso.toJson().keys.toList())
                  if (key != 'id' &&
                      key != 'vista' &&
                      widget.aviso.toJson()[key] != null)
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          '${key}'.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(widget.aviso
                                .toJson()[key]
                                .toString()
                                .toUpperCase())),
                      )
                    ]),
              ]),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
                color: const Color(0xff37323e),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.lightGreen, //E26561
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.phone),
                          color: Colors.white,
                          onPressed: () {
                            _llamar(widget.aviso.telefono.toString());
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.lightGreen, //E26561
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.share),
                          color: Colors.white,
                          onPressed: () {
                            _lanzarWhatsApp();
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Ink(
                        decoration: const ShapeDecoration(
                          color: const Color(0xffE26561),
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.delete_forever),
                          color: Colors.white,
                          onPressed: () {
                            showAlertDialog(context, 'delete');
                            // borrarAviso(widget.aviso);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Ink(
                        decoration: const ShapeDecoration(
                          color: const Color(0xffE26561),
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          color: Colors.white,
                          onPressed: () {
                            //avisoVisto(widget.aviso);
                            showAlertDialog(context, 'put');
                          },
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  //Método que lanza la aplicación para llamar de nuestro SO con el número por argumento
  _llamar(String telefono) async {
    if (await canLaunch('tel:$telefono')) {
      await launch('tel:$telefono');
    } else {
      throw 'No se ha podido llamar a $telefono';
    }
  }

//Método que lanza la aplicación whatsapp, nos deja seleccionar un contacto para compartir y adjuntamos mensaje con los datos del aviso
  _lanzarWhatsApp() async {
    String message = '${widget.aviso.toJson().toString()}';
    var whatsappUrl = "whatsapp://send?text=$message";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

//Request tipo PUT para actualizar el aviso por argumento en la BD
  Future<void> avisoVisto(Aviso aviso) async {
    var url = 'http://10.0.2.2:3000/compras/avisos/${aviso.id}';
    var response = await http.put(Uri.encodeFull(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "authorization": "Martin",
        });

    print(response.body);

    //Según respuesta, informamos y volvemos atras

    if (response.body == 'Actualizado con éxito.') {
      Navigator.pop(context);
      showAlertDialog(context, '200');
    } else {
      Navigator.pop(context);
      showAlertDialog(context, 'Error');
    }
  }

  //Request tipo DELETE para actualizar el aviso por argumento en la BD
  Future<void> borrarAviso(Aviso aviso) async {
    var url = 'http://10.0.2.2:3000/compras/avisos/${aviso.id}';
    var response = await http.delete(Uri.encodeFull(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "authorization": "Martin",
        });

    print(response.body);

    //Según respuesta, informamos y volvemos atras

    if (response.body == 'borrado con éxito.') {
      Navigator.pop(context);
      showAlertDialog(context, '200');
    } else {
      Navigator.pop(context);
      showAlertDialog(context, 'Error');
    }
  }


  //Método para enseñar dialogo con usuario con la orden por argumento
  //Entiendase orde como tipo de notificación
  showAlertDialog(BuildContext context, String orden) {
    String mensaje;

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        switch (orden) {
          case 'delete':
            borrarAviso(widget.aviso);
            break;
          case 'put' :
            avisoVisto(widget.aviso);
            break;
          case '200' :
            Navigator.of(context).popUntil((route) => route.isFirst);
            break;
          case 'Error' :
            Navigator.of(context).popUntil((route) => route.isFirst);
            break;
          default:
            break;
        }
      },
    );
    Widget noButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    List<Widget> options;

    switch (orden) {
      case 'delete':
        options = [okButton, noButton];
        mensaje = "Seguro que quieres borrar el aviso?";
        break;
      case 'put':
        options = [okButton, noButton];
        mensaje = "Seguro que quieres marcar como visto el aviso?";
        break;
      case '200' :
        options = [okButton];
        mensaje = 'Operación completada con éxito';
        break;
      case 'Error' :
        options = [okButton];
        mensaje = 'No se ha podido completar la operación';
        break;
      default:
        break;
    }
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Atención"),
      content: Text(mensaje
      ),
      actions: options,
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
