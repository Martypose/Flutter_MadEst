import 'package:flutter/material.dart';
import 'Aviso.dart';
import 'package:url_launcher/url_launcher.dart';

class DetallesAviso extends StatefulWidget {
  final Aviso aviso;

  DetallesAviso({Key key, @required this.aviso}) : super(key: key);

  @override
  _DetallesAvisoState createState() => _DetallesAvisoState();
}

class _DetallesAvisoState extends State<DetallesAviso> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos aviso: ${widget.aviso.id}'),
        backgroundColor: const Color(0xff37323e),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(border: TableBorder.all(), children: [
                for (var key in widget.aviso.toJson().keys.toList())
                  if (key != 'id' &&
                      key != 'vista' &&
                      widget.aviso.toJson()[key] != null)
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          '${key}'.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(widget.aviso
                                .toJson()[key]
                                .toString()
                                .toUpperCase())),
                      )
                    ]),
              ]),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
                color: const Color(0xff37323e),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.lightGreen, //E26561
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.phone),
                          color: Colors.white,
                          onPressed: () {
                            _calling(widget.aviso.telefono.toString());
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Ink(
                        decoration: const ShapeDecoration(
                          color: const Color(0xffE26561),
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.delete_forever),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Ink(
                        decoration: const ShapeDecoration(
                          color: const Color(0xffE26561),
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  _calling(String telefono) async {
    if (await canLaunch('tel:$telefono')) {
      await launch('tel:$telefono');
    } else {
      throw 'No se ha podido llamar a $telefono';
    }
  }
}
