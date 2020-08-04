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
          title: Text("Paquetes macizos"),
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
             return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: constraints.maxWidth),
                            child: DataTable(
                                columns: <DataColumn>[
                                  DataColumn(
                                      label: Text(
                                        "ID",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.00),
                                      )),
                                  DataColumn(
                                      numeric: true,
                                      label: Text(
                                        "Fecha",

                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.00),
                                      )),
                                  DataColumn(
                                      numeric: true,
                                      label: Text(
                                        "Tipo",

                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.00),
                                      ))
                                ],
                                rows: paquetes.map((e) => DataRow(cells: <DataCell>[
                                  DataCell(Text(e.ID.toString(),style: TextStyle(fontSize: 18.00),),onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetallesPaquete(paquete: e),
                                        ));
                                  },),
                                  DataCell(Text(e.fecha.toString(),style: TextStyle(fontSize: 18.00),),onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetallesPaquete(paquete: e),
                                        ));
                                  },),DataCell(Text(e.medida.calidad.toString(),style: TextStyle(fontSize: 18.00),),onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetallesPaquete(paquete: e),
                                        ));
                                  },)
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
        )
    );
  }


  Future<List<Paquete>> recibirPaquetes() async {
    var url = 'http://www.maderaexteriores.com/paquetes';
    var uri = Uri.parse(url);
    uri = uri.replace(query: 'barroteado=0');
    var response = await http.get(uri, headers: {
      "authorization": "Martin",
    });

    print(response.body);
    print('fin');
    //De stringjson a json, de json a lista, de lista a map, de map a lista.
    try{
      paquetes = (jsonDecode(response.body) as List).map((i) =>
          Paquete.fromJson(i)).toList();
    }catch(error){
      print(error);
    }


    return paquetes;
  }


}