import 'package:flutter/material.dart';
import 'Paquete.dart';

class DetallesPaquete extends StatefulWidget {
  final Paquete paquete;

  DetallesPaquete({Key key, @required this.paquete}) : super(key: key);

  @override
  _DetallesPaqueteState createState() => _DetallesPaqueteState();
}

class _DetallesPaqueteState extends State<DetallesPaquete> {
  @override
  var barroteado,
      seco,
      homogeneo,
      ancho,
      stringPiezas = "";

  void initState() {
    interpretarDatos();
  }
  var url = 'http://10.0.2.2:3000/paquetes';

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos paquete: ${widget.paquete.id}'),
        backgroundColor: const Color(0xff37323e),
      ),
        body: Column(
          children: <Widget>[
            Table(
                border: TableBorder.all(),
                children: [
                  for (var key in widget.paquete
                      .toJson()
                      .keys
                      .toList())
                    if(key != 'cantidades' && key != 'id' &&
                        widget.paquete.toJson()[key] != null)
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text('${key}'.toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.w600),)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text(widget.paquete.toJson()[key]
                              .toString()
                              .toUpperCase())),
                        )
                      ]),
                ]
            ), SizedBox(height: 20),
            if(widget.paquete.cantidades.length > 1)
              Text('PIEZAS: '),
            Flexible(
              child: SingleChildScrollView(child: Table(
                  border: TableBorder.all(),
                  children: [
                    for (var i = 0; i < widget.paquete.cantidades.length; i++)
                      if(widget.paquete.cantidades[i] != 0)
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text('${i + 8}'.toUpperCase(),
                              style: TextStyle(fontWeight: FontWeight.w600),)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text(
                                '${widget.paquete.cantidades[i]}'
                                    .toUpperCase())),
                          )
                        ]),
                  ]
              ),),
            )
          ],
        )
    );
  }


  interpretarDatos() {
    setState(() {
      if (widget.paquete.barroteado == 0) {
        barroteado = 'NO';
      } else {
        barroteado = 'SÍ';
      }
      if (widget.paquete.seco == 0) {
        seco = 'VERDE';
      } else {
        seco = 'SECO';
      }
      if (widget.paquete.ancho == null) {
        ancho = 'Diferentes';
      } else {
        ancho = widget.paquete.ancho;
      }

      if (widget.paquete.homogeneo == 0) {
        var pieza = 8;
        for (var cantidadpieza in widget.paquete.cantidades) {
          if (cantidadpieza > 0)
            stringPiezas = stringPiezas + ' ${pieza} : ${cantidadpieza} ';
          pieza++;
        }
      } else {
        stringPiezas = widget.paquete.numpiezas.toString();
      }
    });
  }





}
