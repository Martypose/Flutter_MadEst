//Clase Paquete, para manejar los datos relacionados con este.
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:madeirasestanqueiro/Medida.dart';
class Paquete{

  var ID;
  Medida medida;
  String fecha;
  String estado;
  var cubico;
  int numpiezas;
  //Numero de piezas de cada numero, es un array;
  List cantidades;

  Paquete(Medida medida){
    //Consuigo fecha actual
    var dt = DateTime.now();
    var newFormat = DateFormat("yyyy-MM-dd");
    this.medida=medida;
    this.cantidades = [0];
    this.numpiezas = 0;
    this.cubico = 0.0;
    this.fecha = newFormat.format(dt);
    this.estado = "stock";
  }


  setMedida(Medida medida){
    this.medida=medida;
  }

  setCantidades(List c){
    this.cantidades = c;
  }
  setCubico(double d) {
    this.cubico = d;
  }

  setNumPiezas(int numpiezas) {
    this.numpiezas = numpiezas;
  }


  Paquete.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        medida = Medida(json['medida'],json['ancho'],json['grosor'],json['largo'],json['esMedible'],json['barroteado'],json['homogeneo'],json['calidad']),
        cantidades = jsonDecode('[' + json['cantidades'] + ']'),
        fecha = json['fechaCreacion'],
        estado = json['estado'],
        cubico = json['cubico'],
        numpiezas = json['numpiezas'];

  Map<String, dynamic> toJson() =>
      {
        'ID': ID,
        'medida' : medida.id,
        'cantidades': cantidades.join(','),
        'fecha' : fecha,
        'estado' : estado,
        'cubico': cubico,
        'numpiezas' : numpiezas,
      };
}