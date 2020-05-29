import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'Paquete.dart';
import 'package:http/http.dart' as http;
import 'PaquetesEncontrados.dart';

//Screen donde introducimos los datos del paquete
class FiltrarPaquetes extends StatefulWidget {
  @override
  _FiltrarPaquetesState createState() {
    return _FiltrarPaquetesState();
  }
}

class _FiltrarPaquetesState extends State<FiltrarPaquetes> {
  List paquetes;

  // this allows us to access the TextField text
  TextEditingController ControlID = TextEditingController();
  TextEditingController ControlGrosor = TextEditingController();
  TextEditingController ControlLargo = TextEditingController();
  TextEditingController ControlAncho = TextEditingController();

  DateTime fecha;
  String fechaformateada;
  var url = 'http://10.0.2.2:3000/paquetes/buscarPaquetes';
  var calidad = 'Selecciona calidad';
  bool barroteado = false;
  double sliderSeco = 0.0;
  double sliderBarroteado = 0.0;
  double sliderStock = 0.0;
  String labelSeco, labelBarroteado, labelStock;
  bool stock = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Introduce datos'),
          backgroundColor: const Color(0xff37323e),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Center(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Calidad'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton<String>(
                              items: <String>[
                                'limpia',
                                'semilimpia',
                                'normal',
                                'mala'
                              ].map((String calidad) {
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Humedad'),
                        Slider(
                          value: sliderSeco,
                          onChanged: (newSeco) {
                            setState(() {
                              sliderSeco = newSeco;
                              print(sliderSeco);
                              ajustarValoresSiders();
                            });
                          },
                          divisions: 2,
                          label: '$labelSeco',
                        ),
                        Text('Estructura'),
                        Slider(
                          value: sliderBarroteado,
                          onChanged: (newBarroteado) {
                            setState(() {
                              sliderBarroteado = newBarroteado;
                              print(sliderBarroteado);
                              ajustarValoresSiders();
                            });
                          },
                          divisions: 2,
                          label: '$labelBarroteado',
                        ),
                        Text('Inventario'),
                        Slider(
                          value: sliderStock,
                          onChanged: (newStock) {
                            setState(() {
                              sliderStock = newStock;
                              print(sliderStock);
                              ajustarValoresSiders();
                            });
                          },
                          divisions: 3,
                          label: '$labelStock',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(fechaformateada == null
                            ? 'Fecha sin seleccionar'
                            : fechaformateada),
                        Ink(
                          decoration: const ShapeDecoration(
                            color: const Color(0xffE26561),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18.0)),
                                side: BorderSide(
                                    color: const Color(0xff37323e),
                                    width: 3.0)),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.date_range),
                            color: Colors.white,
                            onPressed: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2011),
                                      lastDate: DateTime(2021))
                                  .then((date) {
                                setState(() {
                                  fecha = date;
                                  if (date != null)
                                    fechaformateada =
                                        DateFormat('yyyy-MM-dd').format(fecha);
                                });
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: const Color(0xff37323e),
                      child: Text('BUSCAR'),
                      onPressed: () {
                        enviarConsulta();
                      },
                    ),
                  ),
                ],
              ),
            ),
            margin: const EdgeInsets.only(top: 20.0),
          ),
        ));
  }

  void ajustarValoresSiders() {
    if (sliderSeco < 0.5) {
      labelSeco = 'Sin filtro';
    } else if (sliderSeco > 0.49 && sliderSeco < 1) {
      labelSeco = 'Verde';
    } else if (sliderSeco > 0.50) {
      labelSeco = 'Seco';
    }

    if (sliderBarroteado < 0.5) {
      labelBarroteado = 'Sin filtro';
    } else if (sliderBarroteado > 0.49 && sliderBarroteado < 1) {
      labelBarroteado = 'Barroteado';
    } else if (sliderBarroteado > 0.50) {
      labelBarroteado = 'Macizo';
    }

    if (sliderStock < 0.25) {
      labelStock = 'Sin filtro';
    } else if (sliderStock > 0.25 && sliderStock < 0.50) {
      labelStock = 'Bajado';
    } else if (sliderStock > 0.5 && sliderStock < 0.99) {
      labelStock = 'Stock';
    } else if (sliderStock > 0.99) {
      labelStock = 'Vendido';
    }
  }

  Future<void> enviarConsulta() async {
    var response = await http.post(Uri.encodeFull(url),
        body: json.encode({'consulta': obtenerCondicionesSLQ()}),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        });
    print(obtenerCondicionesSLQ());

    paquetes = (jsonDecode(response.body) as List)
        .map((i) => Paquete.fromJson(i))
        .toList();
    if (paquetes != null && paquetes.length > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaquetesEncontrados(paquetes: paquetes),
          ));
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Paquete guardado"),
      content: Text("Se ha guardado el paquete con éxito en la base de datos."),
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

  String obtenerCondicionesSLQ() {
    String consulta = 'SELECT * FROM paquete WHERE';

    //Filtros medidas
    if (ControlID.text.length > 0) {
      consulta = consulta + ' id=' + ControlID.text + ' AND';
    }

    if (ControlAncho.text.length > 0) {
      consulta = consulta + ' ancho=\'' + ControlAncho.text + '\' AND';
    }

    if (ControlGrosor.text.length > 0) {
      consulta = consulta + ' grosor=' + ControlGrosor.text + ' AND';
    }

    if (ControlLargo.text.length > 0) {
      consulta = consulta + ' largo=' + ControlLargo.text + ' AND';
    }

    //Filtro calidad
    if (calidad != 'Selecciona calidad') {
      consulta = consulta + ' calidad=\'' + calidad + '\' AND';
    }

    //Filtros slider

    if (labelSeco == 'Verde') {
      consulta = consulta + ' seco=false AND';
    } else if (labelSeco == 'Seco') {
      consulta = consulta + ' seco=true AND';
    }

    if (labelStock == 'Stock') {
      consulta = consulta + ' estado=\'stock\' AND';
    } else if (labelStock == 'Vendido') {
      consulta = consulta + ' estado=\'vendido\' AND';
    } else if (labelStock == 'Bajado') {
      consulta = consulta + ' estado=\'bajado\' AND';
    }

    if (labelBarroteado == 'Barroteado') {
      consulta = consulta + ' barroteado=true AND';
    } else if (labelBarroteado == 'Macizo') {
      consulta = consulta + ' barroteado=false AND';
    }

    //Filtro fecha
    if (fechaformateada != null && fechaformateada != 'Fecha sin seleccionar') {
      consulta = consulta + ' fechaCreacion=\'' + fechaformateada + '\' AND';
    }

    //Quitar el Where si no hay filtros

    if (consulta == 'SELECT * FROM paquete WHERE') {
      consulta = 'SELECT * FROM paquete;';
    }

    //Quitar coma final y añadir ;

    String tresUltimas = consulta[consulta.length - 3] +
        consulta[consulta.length - 2] +
        consulta[consulta.length - 1];
    if (tresUltimas == 'AND') {
      print('remplazo');
      consulta =
          consulta.replaceRange(consulta.length - 4, consulta.length, ";");
    }

    //Convertir string en json

    return consulta;
  }
}
