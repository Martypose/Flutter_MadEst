import 'dart:convert';

import 'package:flutter/material.dart';
import 'Paquete.dart';
import 'package:http/http.dart' as http;


class DetallesPaquete extends StatefulWidget {
  final Paquete paquete;

  DetallesPaquete({Key key, @required this.paquete}) : super(key: key);

  @override
  _DetallesPaqueteState createState() => _DetallesPaqueteState();
}

class _DetallesPaqueteState extends State<DetallesPaquete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Datos paquete: ${widget.paquete.ID}'),
          backgroundColor: const Color(0xff37323e),
        ),
        body: Column(
          children: <Widget>[
            Table(
                border: TableBorder.all(),
                children: [
                  for (var key in widget.paquete
                      .toJson()
                      .keys
                      .toList())
                    if(key != 'cantidades' && key != 'id' &&
                        widget.paquete.toJson()[key] != null)
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text('${key}'.toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.w600),)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text(widget.paquete.toJson()[key]
                              .toString()
                              .toUpperCase())),
                        )
                      ]),
                ]
            ), SizedBox(height: 20),
            if(widget.paquete.cantidades.length > 1)
              Text('PIEZAS: '),
            Expanded(
              child: SingleChildScrollView(child: Table(
                  border: TableBorder.all(),
                  children: [
                    for (var i = 0; i < widget.paquete.cantidades.length; i++)
                      if(widget.paquete.cantidades[i] != 0)
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text('${i + 8}'.toUpperCase(),
                              style: TextStyle(fontWeight: FontWeight.w600),)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text(
                                '${widget.paquete.cantidades[i]}'
                                    .toUpperCase())),
                          )
                        ]),
                  ]
              ),),
            ), Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                  color: const Color(0xff37323e),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if(widget.paquete.estado == 'stock')
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.lightGreen, //E26561
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.euro_symbol),
                              color: Colors.white,
                              onPressed: () {
                                showAlertDialog(context, 'vender');
                              },
                            ),
                          ),
                        ),
                      if(widget.paquete.estado == 'stock' &&
                          widget.paquete.medida.barroteado == 1)
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Ink(
                            decoration: const ShapeDecoration(
                              color: const Color(0xffE26561),
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_downward),
                              color: Colors.white,
                              onPressed: () {
                                showAlertDialog(context, 'bajar');
                              },
                            ),
                          ),
                        ),

                    ],
                  )),
            ),
          ],
        )
    );
  }

  Future<void> actualizarPaquete(Paquete paquete) async {
    var url = 'http://www.maderaexteriores.com/paquetes/${paquete.ID}';
    var response = await http.put(Uri.encodeFull(url),
        body: json.encode({ 'paquete': paquete.toJson()}),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "authorization": "Martin",
        });
    print(response.body);
    if (response.body == 'Actualizado con éxito.') {
      Navigator.pop(context);
      showAlertDialog(context, '200');
    } else {
      Navigator.pop(context);
      showAlertDialog(context, 'Error');
    }
  }

  showAlertDialog(BuildContext context, String orden) {
    String mensaje;

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        switch (orden) {
          case 'vender':
            widget.paquete.estado = 'vendido';
            actualizarPaquete(widget.paquete);
            break;
          case 'bajar' :
            widget.paquete.estado = 'bajado';
            actualizarPaquete(widget.paquete);
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
      case 'vender':
        options = [okButton, noButton];
        mensaje = "Seguro que quieres marcar como vendido el paquete?";
        break;
      case 'bajar':
        options = [okButton, noButton];
        mensaje = "Seguro que quieres marcar como bajado el paquete?";
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
