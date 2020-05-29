import 'package:flutter/material.dart';
import 'Aviso.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


class DetallesAviso extends StatefulWidget {
  final Aviso aviso;

  DetallesAviso({Key key, @required this.aviso}) : super(key: key);

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
                            _calling(widget.aviso.telefono.toString());
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
                            _launchWhatsApp(widget.aviso.telefono.toString());
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
                            borrarAviso(widget.aviso);
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
                            avisoVisto(widget.aviso);
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

  _calling(String telefono) async {
    if (await canLaunch('tel:$telefono')) {
      await launch('tel:$telefono');
    } else {
      throw 'No se ha podido llamar a $telefono';
    }
  }

  _launchWhatsApp(String telefono) async {
    String message = '${widget.aviso.toJson().toString()}';
    var whatsappUrl = "whatsapp://send?text=$message";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }


  Future<void> avisoVisto(Aviso aviso) async {
    var url = 'http://10.0.2.2:3000/compras/avisos/${aviso.id}';
    var response = await http.put(Uri.encodeFull(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        });

    print(response.body);

    if (response.body == 'Actualizado con éxito.') {
      showAlertDialog(context, 'put');
    }
  }

  Future<void> borrarAviso(Aviso aviso) async {
    var url = 'http://10.0.2.2:3000/compras/avisos/${aviso.id}';
    var response = await http.delete(Uri.encodeFull(url),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        });

    print(response.body);

    if (response.body == 'borrado con éxito.') {
      showAlertDialog(context, 'delete');
    }
  }


  showAlertDialog(BuildContext context, String orden) {
    String mensaje;

    switch (orden) {
      case 'delete':
        mensaje = "Se ha borrado el aviso de la BD";
        break;

      case 'put':
        mensaje = "Se ha marcado el aviso como visto, ya no lo verás aquí";
        break;
      default:
        break;
    }
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Atención"),
      content: Text(mensaje
      ),
      actions: [
        okButton,
      ],
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
