import 'package:flutter/material.dart';
import 'DetallesPaquete.dart';

class PaquetesEncontrados extends StatefulWidget {
  final List paquetes;

  PaquetesEncontrados({Key key, @required this.paquetes}) : super(key: key);

  @override
  _PaquetesEncontradosState createState() {
    return _PaquetesEncontradosState();
  }
}

class _PaquetesEncontradosState extends State<PaquetesEncontrados> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.paquetes.length} resultados"),
          backgroundColor: const Color(0xff37323e),
        ),
        body: LayoutBuilder(
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
                              "ID",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.00),
                            )),
                            DataColumn(
                                numeric: true,
                                label: Text(
                                  "Fecha",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.00),
                                )),
                            DataColumn(
                                numeric: true,
                                label: Text(
                                  "Tipo",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.00),
                                ))
                          ],
                          rows: widget.paquetes
                              .map((e) => DataRow(cells: <DataCell>[
                                    DataCell(
                                      Text(
                                        e.id.toString(),
                                        style: TextStyle(fontSize: 18.00),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetallesPaquete(paquete: e),
                                            ));
                                      },
                                    ),
                                    DataCell(
                                      Text(
                                        e.fecha.toString(),
                                        style: TextStyle(fontSize: 18.00),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetallesPaquete(paquete: e),
                                            ));
                                      },
                                    ),
                                    DataCell(
                                      Text(
                                        e.calidad.toString(),
                                        style: TextStyle(fontSize: 18.00),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetallesPaquete(paquete: e),
                                            ));
                                      },
                                    )
                                  ]))
                              .toList()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
