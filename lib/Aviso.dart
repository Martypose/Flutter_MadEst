import 'dart:convert';
import 'package:intl/intl.dart';

class Paquete {

  int id;
  String nombre;
  String telefono;
  String localizacion;
  String especies;
  String observaciones;
  String fecha;


  Aviso(int id, String nombre, String telefono, String localizacion,
      String observaciones) {
    //Consuigo fecha actual
    var dt = DateTime.now();
    var newFormat = DateFormat("yyyy-MM-dd");
    this.id = id;
    this.fecha = newFormat.format(dt);
    this.telefono = telefono;
    this.localizacion = localizacion;
    this.especies = especies;
    this.observaciones = "stock";
  }


  Paquete.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        telefono = json['telefono'],
        localizacion = json['grosor'],
        especies = json['largo'],
        observaciones = jsonDecode('[' + json['cantidades'] + ']'),
        especies = json['largo']

  ,

  ;


  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'ancho': ancho,
        'grosor': grosor,
        'largo': largo,
        'cantidades': cantidades.join(','),
        'seco': seco,
        'fecha': fecha,
        'estado': estado,
        'barroteado': barroteado,
        'homogeneo': homogeneo,
        'cubico': cubico,
        'numpiezas': numpiezas,
        'calidad': calidad
      };
}