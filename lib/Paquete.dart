//Clase Paquete, para manejar los datos relacionados con este.
import 'dart:convert';
import 'package:intl/intl.dart';
class Paquete{

  var id;
  int grosor;
  String ancho;
  int largo;
  String fecha;
  int seco;
  String estado;
  int barroteado;
  int homogeneo;
  var cubico;
  int numpiezas;
  String calidad;
  //Numero de piezas de cada numero, es un array;
  List cantidades;

  Paquete(String ID, int Grosor, int Largo){
    //Consuigo fecha actual
    var dt = DateTime.now();
    var newFormat = DateFormat("yyyy-MM-dd");

    this.cantidades = [0];
    this.numpiezas = 0;
    this.cubico = 0.0;
    this.id = ID;
    this.fecha = newFormat.format(dt);
    this.grosor = Grosor;
    this.largo = Largo;
    this.seco = 1;
    this.estado = "stock";
    this.barroteado = 0;
    this.homogeneo = 0;
  }


  setAncho(String ancho) {
    this.ancho = ancho;
  }

  setCantidades(List c){
    this.cantidades = c;
  }
  setCubico(double d) {
    this.cubico = d;
  }

  setHomogeneo() {
    this.homogeneo = 1;
  }

  setBarroteado() {
    this.barroteado = 1;
  }

  setNumPiezas(int numpiezas) {
    this.numpiezas = numpiezas;
  }

  setVerde() {
    this.seco = 0;
    this.barroteado = 1;
  }

  Paquete.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        ancho = json['ancho'],
        grosor = json['grosor'],
        largo = json['largo'],
        cantidades = jsonDecode('[' + json['cantidades'] + ']'),
        seco = json['seco'],
        fecha = json['fechaCreacion'],
        estado = json['estado'],
        barroteado = json['barroteado'],
        homogeneo = json['homogeneo'],
        cubico = json['cubico'],
        numpiezas = json['numpiezas'],
        calidad = json['calidad'];


  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'ancho': ancho,
        'grosor': grosor,
        'largo': largo,
        'cantidades': cantidades.join(','),
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