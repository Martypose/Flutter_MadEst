import 'dart:convert';
import 'package:flutter/material.dart';
import 'Paquete.dart';
import 'package:http/http.dart' as http;

//Screen donde introducimos la medicion del paquete introducido anteriormente.

class MedicionPaquete extends StatefulWidget {
  final Paquete paquete;
  MedicionPaquete({Key key, @required this.paquete}) : super(key: key);

  @override
  _MedicionPaqueteState createState() => _MedicionPaqueteState();
}


class _MedicionPaqueteState extends State<MedicionPaquete>{

  @override

  //Guardamos la útlima pieza introducida
  var ultimapieza;
  //Los últimos números introducidos para mostrar al usuario
  var ultimos = [];
  //Guardo el valor de cada pieza introducida
  var todos = [];
  //Los números posible a introducir
  var numeros = [];
  //Para cada número posible, que cantidad hay de piezas(cuantas veces de ha introducido)
  var cantidad = [];
  var url = 'http://www.maderaexteriores.com/paquetes';

  void initState() {
    super.initState();

    //Nada más creada la screen, rellenamos los números y ponemos a 0 todas las cantidades
    for (var i = 8; i <= 50; i++) {
      numeros.add(i);
      cantidad.add(0);
    }

    ultimapieza = 0;
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

            //Contenedor donde enseño los últimos números añadidos
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
                  //Para cada número creamos un boton con el número como texto
                  for (var numero in numeros)
                    ElevatedButton(
                      onPressed: () {

                        //Al hacer tap actualizamos cantidades, ultimapieza y todos.
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

                //Creo una fila donde pongo dos botones para borrar última pieza y guardar el paquete
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
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
                      child: ElevatedButton(
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
                            print('Habías introducido $cont piezas en el paquete.');
                          });
                          calcularDatosPaquete();
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

  // Método que llamo cuando guardo paquete, hago un POST a mi API REST enviando el objeto paquete que tenemos en JSON
  Future<void> enviarPaquete() async{

    var response = await http.post(Uri.encodeFull(url), body: json.encode({ 'paquete': widget.paquete.toJson() }), headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
      "authorization": "Martin",
    });

    print(widget.paquete.toJson().toString());

    print(response.body);

    if(response.body=='exito al guardar en bd'){
      showAlertDialog(context);
    }

  }

  //Método que ejecuto antes de enviar el POST para actualizar los datos del paquete según lo que hemos hecho
  calcularDatosPaquete() {

    var cubicoT=0.0;
    var cubicoP=0.0;
    //Guardar en el objeto el número de piezas y el cúbico para guardarlo en nuestra BD
    //El numero de piezas es la longitud del array donde guardamos todas las piezas
    widget.paquete.numpiezas = todos.length;

    //Para calcular el cúbico hacemos una suma del cúbico de cada pieza, recorriendo el array todos,pasando a metros
    for(var i=0; i<todos.length; i++){
      cubicoP = (todos[i] / 100) * (widget.paquete.medida.grosor / 1000) *
          (widget.paquete.medida.largo / 1000);
      cubicoT=cubicoT+cubicoP;

    }
    cubicoT = num.parse(cubicoT.toStringAsFixed(3));
    widget.paquete.setCubico(cubicoT) ;
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
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
}





