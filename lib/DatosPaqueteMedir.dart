import 'MedicionPaquete.dart';
import 'package:flutter/material.dart';
import 'Paquete.dart';

//Screen donde introducimos los datos del paquete a medir.
class DatosPaqueteMedir extends StatefulWidget {
  @override
  _DatosPaqueteMedirState createState() {
    return _DatosPaqueteMedirState();
  }
}

class _DatosPaqueteMedirState extends State<DatosPaqueteMedir> {

  // this allows us to access the TextField text
  TextEditingController ControlID = TextEditingController();
  TextEditingController ControlGrosor = TextEditingController();
  TextEditingController ControlLargo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Introduce datos'),backgroundColor: const Color(0xff37323e),
        ),
        body: Container(child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: ControlID,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ID Paquete',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: ControlGrosor,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Grosor',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: ControlLargo,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Largo',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Medir paquete'),textColor: const Color(0xfffcfcfc),
                  color: const Color(0xff37323e),
                  onPressed: () {
                    // Navigate to the second screen using a named route.
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicionPaquete(paquete: Paquete(ControlID.text,int.parse(ControlGrosor.text),int.parse(ControlLargo.text))),
                        ));
                  },
                ),
              )
            ],
          ),
        ),margin: const EdgeInsets.only(top: 20.0),
        )
    );
  }
}