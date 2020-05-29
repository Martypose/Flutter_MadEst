import 'dart:convert';
import 'package:flutter/material.dart';
import 'Paquete.dart';
import 'package:http/http.dart' as http;

//Screen donde introducimos los datos del paquete
class NuevoPaquete extends StatefulWidget {
  @override
  _NuevoPaqueteState createState() {
    return _NuevoPaqueteState();
  }
}

class _NuevoPaqueteState extends State<NuevoPaquete> {

  // this allows us to access the TextField text
  TextEditingController ControlID = TextEditingController();
  TextEditingController ControlGrosor = TextEditingController();
  TextEditingController ControlLargo = TextEditingController();
  TextEditingController ControlAncho = TextEditingController();
  TextEditingController ControlNPiezas = TextEditingController();

  var url = 'http://10.0.2.2:3000/paquetes';
  var calidad = 'Selecciona calidad';
  var punto = 'Selecciona el tipo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Introduce datos'),
          backgroundColor: const Color(0xff37323e),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical, child: Container(child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: ControlID,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ID Paquete',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: ControlAncho,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ancho',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: ControlGrosor,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Grosor',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: ControlLargo,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Largo',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: ControlNPiezas,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Numero de piezas',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                    items: <String>['limpia', 'semilimpia', 'normal', 'mala']
                        .map((String calidad) {
                      return new DropdownMenuItem<String>(
                        value: calidad,
                        child: new Text(calidad),
                      );
                    }).toList(),
                    hint: Text(calidad),
                    onChanged: (String val) {
                      setState(() {
                        calidad = val;
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                    items: <String>['verde', 'bajado'].map((String punto) {
                      return new DropdownMenuItem<String>(
                        value: punto,
                        child: new Text(punto),
                      );
                    }).toList(),
                    hint: Text(punto),
                    onChanged: (String val) {
                      setState(() {
                        punto = val;
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Guardar'), textColor: const Color(0xfffcfcfc),
                  color: const Color(0xff37323e),
                  onPressed: () {
                    if (calidad != 'Selecciona calidad' &&
                        punto != 'Selecciona el tipo') {
                      Paquete paquete = Paquete(ControlID.text, int.parse(
                          ControlGrosor.text), int.parse(ControlLargo.text));
                      paquete.calidad = calidad;
                      rellenarDatosPaquete(paquete);
                      enviarPaquete(paquete);
                    }
                    // Navigate to the second screen using a named route.
                  },
                ),
              ),

            ],
          ),
        ), margin: const EdgeInsets.only(top: 20.0),
        ),)
    );
  }

  rellenarDatosPaquete(Paquete paquete) {
    //Comprobamos si el ancho es único o son varios, paquete homogeneo o heterogeneo

    if (!ControlAncho.text.contains('-')) {
      paquete.setHomogeneo();
      paquete.setAncho(ControlAncho.text);
      if (ControlNPiezas.text.length > 0) {
        paquete.setNumPiezas(int.parse(ControlNPiezas.text));
        var cubicoT = 0.0;
        cubicoT = ((double.parse(paquete.ancho) / 100 * paquete.largo / 1000 *
            paquete.grosor) / 1000) *
            paquete.numpiezas;
        paquete.setCubico(cubicoT);
      } else {
        paquete.setCubico(0.0);
        print(paquete.cubico);
      }
    } else {
      paquete.setCubico(0.0);
      print(paquete.cubico);
      paquete.setAncho(ControlAncho.text);
    }

    if (punto == 'verde') {
      paquete.setVerde();
    }
  }


  Future<void> enviarPaquete(Paquete paquete) async {
    var response = await http.post(Uri.encodeFull(url),
        body: json.encode({ 'paquete': paquete.toJson()}), headers: {
          "content-type": "application/json",
          "accept": "application/json",
        });

    print(paquete.toJson());

    if (response.body == 'exito al guardar en bd') {
      showAlertDialog(context, response.body);
    } else if (response.body == 'id repetido') {
      showAlertDialog(context, response.body);
    } else if (response.body == 'error insert') {
      showAlertDialog(context, response.body);
    }
  }

  showAlertDialog(BuildContext context, String respuesta) {
    String mensaje;

    switch (respuesta) {
      case 'exito al guardar en bd':
        mensaje = 'Paquete guardado con éxito';
        break;
      case 'id repetido':
        mensaje = 'ID repetido, introduce otro nuevo';
        break;
      case 'error insert':
        mensaje = 'Error en el insert';
        break;
    }



    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        switch (respuesta) {
          case 'exito al guardar en bd':
            mensaje = 'Paquete guardado con éxito';
            Navigator.of(context).popUntil((route) => route.isFirst);
            break;
          case 'id repetido':
            mensaje = 'Paquete guardado con éxito';
            Navigator.pop(context);

            break;
          case 'error insert':
            Navigator.pop(context);
            break;
        }

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Atención"),
      content: Text(
          mensaje),
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
