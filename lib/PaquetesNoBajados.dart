import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Medida.dart';


class PaquetesNoBajados extends StatefulWidget {
  @override
  _PaquetesNoBajadosState createState() {
    return _PaquetesNoBajadosState();
  }
}

class _PaquetesNoBajadosState extends State<PaquetesNoBajados> {
  List medidas;
  String medida = 'Nada seleccionado';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Paquetes macizos"),
          backgroundColor: const Color(0xff37323e),
        ),
        body: FutureBuilder(
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
                                items: medidas.map((m) {
                                  return new DropdownMenuItem<String>(
                                    value: m.id,
                                    child: new Text(m.id),
                                  );
                                }).toList(),
                                hint: Text("Medida"),
                                onChanged: (String val) {
                                  setState(() {
                                    for(var i=0; i<medidas.length; i++){
                                      if(medidas[i].id==val)
                                        medida = medidas[i].toJson().toString();
                                    }


                                  });
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(medida),
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