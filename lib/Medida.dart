
class Medida {

  String id;
  var ancho;
  int grosor;
  int barroteado;
  int homogeneo;
  String calidad;
  int largo;
  int esMedible;
  Medida(String id, var ancho, int grosor, int largo, int esMedible,int barroteado, int homogeneo, String calidad) {
    this.id = id;
    this.barroteado = barroteado;
    this.homogeneo = homogeneo;
    this.calidad = calidad;
    this.ancho = ancho;
    this.grosor = grosor;
    this.largo = largo;
    this.esMedible = esMedible;
  }

  Medida.MedidaSinAncho(String id, int grosor, int largo, int esMedible,int barroteado, int homogeneo, String calidad) {
    this.id = id;
    this.barroteado = barroteado;
    this.homogeneo = homogeneo;
    this.calidad = calidad;
    this.grosor = grosor;
    this.largo = largo;
    this.esMedible = esMedible;

  }


  Medida.fromJson(Map<String, dynamic> json)
  {
    if (json['ancho'].toString()!=null) {
      id = json['id'];
      grosor = json['grosor'];
      barroteado = json['barroteado'];
      homogeneo = json['homogeneo'];
      calidad = json['calidad'];
      largo = json['largo'];
      esMedible = json['esMedible'];
    }else{
      id = json['id'];
      ancho = '0';
      barroteado = json['barroteado'];
      homogeneo = json['homogeneo'];
      calidad = json['calidad'];
      grosor = json['grosor'];
      largo = json['largo'];
      esMedible = json['esMedible'];

    }
  }


  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'ancho': ancho,
        'grosor': grosor,
        'largo': largo,
        'esMedible': esMedible,
        'barroteado' : barroteado,
        'homogeneo' : homogeneo,
        'calidad' : calidad
      };
}