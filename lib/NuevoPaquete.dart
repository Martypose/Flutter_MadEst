import 'MedicionPaquete.dart';
import 'package:flutter/material.dart';
import 'Paquete.dart';

//Screen donde introducimos los datos del paquete
class NuevoPaquete extends StatefulWidget {
  @override
  _NuevoPaqueteState createState() {
    return _NuevoPaqueteState();
  }
}

class _NuevoPaqueteState extends State<NuevoPaquete> {

  // this allows us to access the TextField text
  TextEditingController ControlID = TextEditingController();
  TextEditingController ControlGrosor = TextEditingController();
  TextEditingController ControlLargo = TextEditingController();
  TextEditingController ControlAncho = TextEditingController();
  TextEditingController ControlNPiezas = TextEditingController();


  var calidad = 'Selecciona calidad';
  var punto = 'Selecciona el tipo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Introduce datos'),backgroundColor: const Color(0xff37323e),
        ),
        body: SingleChildScrollView( scrollDirection: Axis.vertical, child: Container(child: Center(
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
                  controller: ControlAncho,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ancho',
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
                child: TextField(
                  controller: ControlNPiezas,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Numero de piezas',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                    items: <String>['limpia', 'semilimpia', 'normal', 'mala'].map((String calidad) {
                      return new DropdownMenuItem<String>(
                        value: calidad,
                        child: new Text(calidad),
                      );
                    }).toList(),
                    hint:Text(calidad),
                    onChanged:(String val){
                      setState(() {calidad = val;});
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                    items: <String>['verde','bajado'].map((String punto) {
                      return new DropdownMenuItem<String>(
                        value: punto,
                        child: new Text(punto),
                      );
                    }).toList(),
                    hint:Text('Punto proceso'),
                    onChanged:(String val){
                      setState(() {punto = val;});
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Guardar'),textColor: const Color(0xfffcfcfc),
                  color: const Color(0xff37323e),
                  onPressed: () {
                    if(calidad!='Selecciona calidad'){
                      Paquete paquete = Paquete(ControlID.text,int.parse(ControlGrosor.text),int.parse(ControlLargo.text));
                      paquete.calidad = calidad;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedicionPaquete(paquete: paquete),
                          ));
                    }
                    // Navigate to the second screen using a named route.
                  },
                ),
              ),

            ],
          ),
        ),margin: const EdgeInsets.only(top: 20.0),
        ),)
    );
  }
}