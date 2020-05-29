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
            Expanded(
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
            ), Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                  color: const Color(0xff37323e),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if(widget.paquete.estado == 'stock')
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.lightGreen, //E26561
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.euro_symbol),
                              color: Colors.white,
                              onPressed: () {
                                //_calling(widget.aviso.telefono.toString());
                              },
                            ),
                          ),
                        ),
                      if(widget.paquete.estado == 'stock' &&
                          widget.paquete.barroteado == 1)
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Ink(
                            decoration: const ShapeDecoration(
                              color: const Color(0xffE26561),
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_downward),
                              color: Colors.white,
                              onPressed: () {
                                // showAlertDialog(context, 'delete');
                                // borrarAviso(widget.aviso);
                              },
                            ),
                          ),
                        ),

                    ],
                  )),
            ),
          ],
        )
    );
  }





}
