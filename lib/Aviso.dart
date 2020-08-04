import 'package:intl/intl.dart';

class Aviso {

  int id;
  String nombre;
  String telefono;
  String localizacion;
  String especies;
  String observaciones;
  String fecha;
  int vista;


  Aviso(int id, String nombre, String telefono, String localizacion,
      String especies,
      String observaciones) {
    //Consigo fecha actual
    var dt = DateTime.now();
    var newFormat = DateFormat("yyyy-MM-dd");
    this.id = id;
    this.nombre = nombre;
    this.fecha = newFormat.format(dt);
    this.telefono = telefono;
    this.localizacion = localizacion;
    this.especies = especies;
    this.observaciones = observaciones;
    this.vista = 0;
  }


  Aviso.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fecha = json['fecha'],
        nombre = json['nombre'],
        telefono = json['telefono'],
        localizacion = json['localizacion'],
        especies = json['especies'],
        observaciones = json['observaciones'],
        vista = json['vista'];


  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'fecha': fecha,
        'nombre': nombre,
        'telefono': telefono,
        'localizacion': localizacion,
        'especies': especies,
        'observaciones': observaciones,
        'vista': vista,

      };
}