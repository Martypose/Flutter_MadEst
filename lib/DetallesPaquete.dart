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
  var url = 'http://10.0.2.2:3000/paquetes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles Paquete"),
        backgroundColor: const Color(0xff37323e),
      ),
      body: Center(
        child: Text('${widget.paquete.toJson()}'),
      ),
    );
  }
}
