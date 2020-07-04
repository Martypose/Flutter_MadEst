import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'Paquete.dart';
import 'package:http/http.dart' as http;
import 'PaquetesEncontrados.dart';

//Screen donde introducimos filtros para buscar paquetes
class FiltrarPaquetes extends StatefulWidget {
  @override
  _FiltrarPaquetesState createState() {
    return _FiltrarPaquetesState();
  }
}

class _FiltrarPaquetesState extends State<FiltrarPaquetes> {
  List paquetes;

  // Los controladores permiten acceder a los valores introducidos en los TextField
  TextEditingController ControlID = TextEditingController();
  TextEditingController ControlGrosor = TextEditingController();
  TextEditingController ControlLargo = TextEditingController();
  TextEditingController ControlAncho = TextEditingController();

  DateTime fecha;
  String fechaformateada;
  var url = 'http://www.maderaexteriores.com/paquetes/buscarPaquetes';
  var calidad = 'Selecciona calidad';
  bool barroteado = false;
  double sliderSeco = 0.0;
  double sliderBarroteado = 0.0;
  double sliderStock = 0.0;
  String labelSeco = 'Sin filtro';
  String labelBarroteado = 'Sin filtro';
  String labelStock = 'Sin filtro';
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
                                    fechaformateada = DateFormat('yyyy-MM-dd')
                                        .format(fecha);
                                  else
                                    fechaformateada = 'Fecha sin seleccionar';
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

  //Según los valores que van cambiando en los sliders, cambiamos también las etiquestas a mostrar para cada uno
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


  //Enviar la sentencia a nuestra API y BD, forma parte de un objeto json con clave consulta
  Future<void> enviarConsulta() async {

    var response = await http.post(Uri.encodeFull(url),
        body: json.encode({'consulta': obtenerCondicionesSLQ()}),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "authorization": "Martin",
        });
    print(obtenerCondicionesSLQ());

    //Obtenemos los paquetes mediante la respuesta de la request.
    //Decodificamos y creamos objeto paquete por cada uno y los vamos añadiendo al array de paquetes
    paquetes = (jsonDecode(response.body) as List)
        .map((i) => Paquete.fromJson(i))
        .toList();

    //Si obtenemos algun paquete, cambiamos de pantalla y enviamos el array con los paquetes
    if (paquetes != null && paquetes.length > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaquetesEncontrados(paquetes: paquetes),
          ));
    }
  }


  //Método que va editando la consulta a enviar a la API según cambiamos el estado y valores en la screen
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

    return consulta;
  }
}
