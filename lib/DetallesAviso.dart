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
            child: Container(
                alignment: Alignment.center,
                height: 75.0,
                width: double.infinity,
                color: const Color(0xff37323e),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RaisedButton(
                        onPressed: () {
                          _calling(widget.aviso.telefono.toString());
                        },
                        child: Text('LLamar cliente'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text('Borrar aviso'),
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
    if (await canLaunch(telefono)) {
      await launch(telefono);
    } else {
      throw 'No se ha podido llamar a $telefono';
    }
  }
}
