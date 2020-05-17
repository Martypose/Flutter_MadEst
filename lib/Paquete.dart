//Clase Paquete, para manejar los datos relacionados con este.

import 'package:intl/intl.dart';
class Paquete{

  String ID;
  int Grosor;
  int Largo;
  String fecha;
  bool seco;
  String estado;
  bool barroteado;
  bool homogeneo;
  double cubico;
  int numpiezas;
  String calidad;
  //Numero de piezas de cada numero, es un array;
  List cantidades;

  Paquete(String ID, int Grosor, int Largo){
    //Consuigo fecha actual
    var dt = DateTime.now();
    var newFormat = DateFormat("yyyy-MM-dd");

    this.numpiezas = 0;
    this.cubico = 0.0;
    this.ID = ID;
    this.fecha = newFormat.format(dt);
    this.Grosor = Grosor;
    this.Largo = Largo;
    this.seco = true;
    this.estado = "stock";
    this.barroteado = false;
    this.homogeneo = false;
  }

  setCantidades(List c){
    this.cantidades = c;
  }
  setCubico(double d) {
    this.cubico = d;
  }

  Map<String, dynamic> toJson() =>
      {
        'id': ID,
        'grosor' : Grosor,
        'largo' : Largo,
        'cantidades': cantidades,
        'seco': seco,
        'fecha' : fecha,
        'estado' : estado,
        'barroteado' : barroteado,
        'homogeneo': homogeneo,
        'cubico': cubico,
        'numpiezas' : numpiezas,
        'calidad' : calidad
      };
}