//Clase Paquete, para manejar los datos relacionados con este.

class Paquete{

  String ID;
  int Grosor;
  int Largo;
  //Numero de piezas de cada numero, es un array;
  List cantidades;

  Paquete(String ID, int Grosor, int Largo){
    this.ID = ID;
    this.Grosor = Grosor;
    this.Largo = Largo;
  }

  setCantidades(List c){
    this.cantidades = c;
  }
}