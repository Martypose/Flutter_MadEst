import 'MedicionPaquete.dart';
import 'package:flutter/material.dart';
import 'Paquete.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Medida.dart';

//Screen donde introducimos los datos del paquete a medir.
class DatosPaqueteMedir extends StatefulWidget {
  @override
  _DatosPaqueteMedirState createState() {
    return _DatosPaqueteMedirState();
  }
}

class _DatosPaqueteMedirState extends State<DatosPaqueteMedir> {
  List medidas;
  String datosMedida = 'Nada seleccionado';
  Medida medida;

  // this allows us to access the TextField text
  TextEditingController ControlGrosor = TextEditingController();
  TextEditingController ControlLargo = TextEditingController();
  var calidad = 'Selecciona calidad';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Introduce datos'),backgroundColor: const Color(0xff37323e),
        ),
        body:


        FutureBuilder(
          future: recibirMedidas(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Cargando...'),
                ),
              );
            } else {
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<String>(
                                // ignore: missing_return
                                items:
                                medidas.map((m) {
                                  print(m.esMedible);
                                  return new DropdownMenuItem<String>(
                                    value: m.id,
                                    child: new Text(m.id),
                                  );
                                }).toList(),
                                hint: Text("Medida"),
                                onChanged: (String val) {
                                  setState(() {
                                    for(var i=0; i<medidas.length; i++){
                                      if(medidas[i].id==val){
                                        datosMedida = medidas[i].toJson().toString();
                                        medida = medidas[i];
                                      }

                                    }


                                  });
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(datosMedida),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text('Medir paquete'),textColor: const Color(0xfffcfcfc),
                              color: const Color(0xff37323e),
                              onPressed: () {
                                  Paquete paquete = Paquete(medida);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MedicionPaquete(paquete: paquete),
                                      ));

                                // Navigate to the second screen using a named route.
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              );
            }
          },
        )
    );
  }
  Future<List<Medida>> recibirMedidas() async {
    var url = 'http://www.maderaexteriores.com/medidas';
    var uri = Uri.parse(url);
    var response = await http.get(uri);

    print(response.body);
    //De stringjson a json, de json a lista, de lista a map, de map a lista.
    medidas = (jsonDecode(response.body) as List).map((i) =>
        Medida.fromJson(i)).toList();
    return medidas;
  }
  

  
  
  
}

