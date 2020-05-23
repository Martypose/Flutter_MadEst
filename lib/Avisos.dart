import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madeirasestanqueiro/Aviso.dart';
import 'DetallesAviso.dart';
import 'Paquete.dart';
import 'DetallesPaquete.dart';

class Avisos extends StatefulWidget {
  @override
  _AvisosState createState() {
    return _AvisosState();
  }
}

class _AvisosState extends State<Avisos> {
  List avisos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Avisos"),
          backgroundColor: const Color(0xff37323e),
        ),
        body: FutureBuilder(
          future: recibirAvisos(),
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
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: constraints.maxWidth),
                            child: DataTable(
                                columns: <DataColumn>[
                                  DataColumn(
                                      label: Text(
                                    "Fecha",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.00),
                                  )),
                                  DataColumn(
                                      numeric: true,
                                      label: Text(
                                        "Especies",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.00),
                                      )),
                                  DataColumn(
                                      numeric: true,
                                      label: Text(
                                        "Localización",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.00),
                                      )),
                                ],
                                rows: avisos
                                    .map((e) => DataRow(cells: <DataCell>[
                                          DataCell(
                                            Text(
                                              e.fecha.toString(),
                                              style: TextStyle(fontSize: 16.00),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetallesAviso(aviso: e),
                                                  ));
                                            },
                                          ),
                                          DataCell(
                                            Text(
                                              e.especies.toString(),
                                              style: TextStyle(fontSize: 16.00),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetallesAviso(aviso: e),
                                                  ));
                                            },
                                          ),
                                          DataCell(
                                            Text(
                                              e.localizacion.toString(),
                                              style: TextStyle(fontSize: 16.00),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetallesAviso(aviso: e),
                                                  ));
                                            },
                                          ),
                                        ]))
                                    .toList()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }

  Future<List<Aviso>> recibirAvisos() async {
    var url = 'http://10.0.2.2:3000/compras/avisos';
    var uri = Uri.parse(url);
    uri = uri.replace(query: 'vista=0');
    var response = await http.get(uri);

    print(response.body);
    //Decode a JSON-encoded string into a Dart object with jsonDecode():
    //The Map object is a simple key/value pair. Keys and values in a map may be of any type.
    // A Map is a dynamic collection. In other words, Maps can grow and shrink at runtime.

    //De stringjson a json, de json a lista, de lista a map, de map a lista.
    avisos = (jsonDecode(response.body) as List)
        .map((i) => Aviso.fromJson(i))
        .toList();

    return avisos;
  }
}
