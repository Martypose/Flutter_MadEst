import 'dart:convert';
import 'package:flutter/material.dart';
import 'Medida.dart';
import 'Paquete.dart';
import 'package:http/http.dart' as http;

//Screen donde introducimos los datos del paquete
class NuevoPaquete extends StatefulWidget {
  @override
  _NuevoPaqueteState createState() {
    return _NuevoPaqueteState();
  }
}

class _NuevoPaqueteState extends State<NuevoPaquete> {


  TextEditingController ControlNPiezas = TextEditingController();
  List<Medida> medidas;
  String datosMedida = 'Nada seleccionado';
  Medida medida;
  var url = 'http://www.maderaexteriores.com/paquetes';
  var calidad = 'Selecciona calidad';
  var punto = 'Selecciona el tipo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Introduce datos'),
          backgroundColor: const Color(0xff37323e),
        ),
        body: FutureBuilder(
          future: recibirMedidas(),
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
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<String>(
                              // ignore: missing_return
                                items:
                                medidas.map((m) {
                                  print(m.esMedible);
                                  return new DropdownMenuItem<String>(
                                    value: m.id,
                                    child: new Text(m.id),
                                  );
                                }).toList(),
                                hint: Text("Medida"),
                                onChanged: (String val) {
                                  setState(() {
                                    for(var i=0; i<medidas.length; i++){
                                      if(medidas[i].id==val){
                                        datosMedida = 'Vas a medir un paquete de '+medidas[i].id;
                                        medida = medidas[i];
                                      }

                                    }


                                  });
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(datosMedida),
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
                            child: ElevatedButton(
                              child: Text('Medir paquete'),
                              onPressed: () {
                                Paquete paquete = Paquete(medida);
                                comprobarValores(medida,paquete);
                                enviarPaquete(paquete);
                                // Navigate to the second screen using a named route.
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              );
            }
          },
        )
    );
  }
  
  Paquete comprobarValores(Medida m, Paquete p){
    print(m.toJson().toString());
    if(ControlNPiezas.text.length>0 && ControlNPiezas.text!=' '){
      p.setNumPiezas(int.parse(ControlNPiezas.text));
      if(m.ancho!=null && m.ancho!=0)
        print('entro en setcubico');
        p.setCubico(((m.ancho*m.grosor*m.largo)/1000000000)*int.parse(ControlNPiezas.text));
        print(p.cubico);

    }
    return p;
    
  }




  Future<void> enviarPaquete(Paquete paquete) async {
    var response = await http.post(Uri.encodeFull(url),
        body: json.encode({ 'paquete': paquete.toJson()}), headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "authorization": "Martin",
        });

    print(paquete.toJson());

    if (response.body == 'exito al guardar en bd') {
      showAlertDialog(context, response.body);
    } else if (response.body == 'id repetido') {
      showAlertDialog(context, response.body);
    } else if (response.body == 'error insert') {
      showAlertDialog(context, response.body);
    }
  }

  showAlertDialog(BuildContext context, String respuesta) {
    String mensaje;

    switch (respuesta) {
      case 'exito al guardar en bd':
        mensaje = 'Paquete guardado con éxito';
        break;
      case 'id repetido':
        mensaje = 'ID repetido, introduce otro nuevo';
        break;
      case 'error insert':
        mensaje = 'Error en el insert';
        break;
    }

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        switch (respuesta) {
          case 'exito al guardar en bd':
            mensaje = 'Paquete guardado con éxito';
            Navigator.of(context).popUntil((route) => route.isFirst);
            break;
          case 'id repetido':
            mensaje = 'Paquete guardado con éxito';
            Navigator.pop(context);
            break;
          case 'error insert':
            Navigator.pop(context);
            break;
        }

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Atención"),
      content: Text(
          mensaje),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<List<Medida>> recibirMedidas() async {
    var url = 'http://www.maderaexteriores.com/medidas';
    var uri = Uri.parse(url);
    var response = await http.get(uri);

    print(response.body);
    //De stringjson a json, de json a lista, de lista a map, de map a lista.
    medidas = (jsonDecode(response.body) as List).map((i) =>
        Medida.fromJson(i)).toList();


    for(var i=medidas.length-1; i>-1; i--){
      if(medidas[i].esMedible==1){
        print(medidas[i].id+' es medible');
        try{
          medidas.remove(medidas[i]);
        }catch(error){
          print('el error es '+ error);
        }
      }
    }
    //medidas.remove(noMedibles);
    print('-----'+medidas.length.toString());

    return medidas;
  }
}
