import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Paquete.dart';
import 'DetallesPaquete.dart';

class PaquetesBajados extends StatefulWidget {
  @override
  _PaquetesBajadosState createState() {
    return _PaquetesBajadosState();
  }
}

class _PaquetesBajadosState extends State<PaquetesBajados> {
  List paquetes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Paquetes bajados"),
          backgroundColor: const Color(0xff37323e),
        ),
        body: FutureBuilder(
          future: recibirPaquetes(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Cargando...'),
                ),
              );
            } else {
              return ListView.separated(
                itemCount: paquetes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Paquete ID: ${paquetes[index]
                        .id} Fecha: ${paquetes[index].fecha}',
                        style: TextStyle(fontSize: 20)),
                    contentPadding: const EdgeInsets.only(left: 30.00),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetallesPaquete(paquete: paquetes[index]),
                          ));
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 20,
                    thickness: 5,
                  );
                },
              );
            }
          },

        )
    );
  }


  Future<List<Paquete>> recibirPaquetes() async {
    var url = 'http://10.0.2.2:3000/paquetes';
    var uri = Uri.parse(url);
    uri = uri.replace(query: 'barroteado=false');
    var response = await http.get(uri);

    //Decode a JSON-encoded string into a Dart object with jsonDecode():
    //The Map object is a simple key/value pair. Keys and values in a map may be of any type.
    // A Map is a dynamic collection. In other words, Maps can grow and shrink at runtime.

    //De stringjson a json, de json a lista, de lista a map, de map a lista.
    paquetes = (jsonDecode(response.body) as List).map((i) =>
        Paquete.fromJson(i)).toList();
    return paquetes;
  }


}