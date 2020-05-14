import 'dart:convert';

import 'package:flutter/material.dart';
import 'Paquete.dart';
import 'package:http/http.dart' as http;

//Screen donde introducimos la medicion del poaquete introducido anteriormente.
class MedicionPaquete extends StatefulWidget {
  final Paquete paquete;

  // In the constructor, require a Todo.
  MedicionPaquete({Key key, @required this.paquete}) : super(key: key);

  @override
  _MedicionPaqueteState createState() => _MedicionPaqueteState();
}

class _MedicionPaqueteState extends State<MedicionPaquete> {
  @override
  var ultimapieza;
  var ultimos = [];
  var todos = [];
  var numeros = [];
  var cantidad = [];
  var url = 'http://10.0.2.2:3000/paquetes';

  void initState() {
    for (var i = 8; i <= 50; i++) {
      numeros.add(i);
      cantidad.add(0);
    }
    ultimapieza = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medición paquete"),
        backgroundColor: const Color(0xff37323e),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              width: double.infinity,
              color: Colors.yellow,
              child: Text(
                '$ultimos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              color: Colors.white10,
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(20.0),
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                children: <Widget>[
                  for (var numero in numeros)
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          //print(widget.paquete.ID);
                          ultimapieza = numero;
                          cantidad[numero - 8]++;
                          todos.add(numero);
                          actualizarUltimos();
                          print('Para el numero ' +
                              numeros[numero - 8].toString() +
                              ' tenemos ' +
                              cantidad[numero - 8].toString() +
                              ' piezas');
                        });
                      },
                      child: Text('$numero', style: TextStyle(fontSize: 20)),
                      textColor: const Color(0xfffcfcfc),
                      color: const Color(0xff37323e),
                    )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                alignment: Alignment.center,
                height: 75.0,
                width: double.infinity,
                color: const Color(0xff37323e),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            print('Para el numero ' +
                                todos[todos.length - 1].toString() +
                                ' tenemos ' +
                                (cantidad[todos[todos.length - 1] - 8] - 1)
                                    .toString() +
                                ' piezas');
                            cantidad[todos[todos.length - 1] - 8]--;
                            todos.removeLast();
                            actualizarUltimos();
                          });
                        },
                        child: Text('Borrar última'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            //Guardamos las cantidades en el objeto paquete.
                            widget.paquete.setCantidades(cantidad);
                            //Accedemos a la suma de ellas
                            int cont = 0;
                            for (var i = 0;
                                i < widget.paquete.cantidades.length;
                                i++) {
                              cont = cont + widget.paquete.cantidades[i];
                            }
                            print(
                                'Habías introducido $cont piezas en el paquete.');
                          });
                          enviarPaquete();

                        },
                        child: Text('Guardar paquete'),
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  actualizarUltimos() {
    setState(() {
      ultimos.clear();
      if (todos.length > 8) {
        for (var i = todos.length - 8; i < todos.length; i++) {
          ultimos.add(todos[i]);
        }
      } else {
        for (var number in todos) {
          ultimos.add(number);
        }
      }
    });
  }

  Future<void> enviarPaquete() async{

    jsonEncode({ 'data': { 'apikey': '12345678901234567890' } });
    var response = await http.post(Uri.encodeFull(url), body: json.encode({ 'paquete': widget.paquete.toJson() }), headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
    });

    print(response.body);

  }



}




