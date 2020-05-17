import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaquetesBajados extends StatelessWidget {
  const PaquetesBajados({ Key key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paquetes bajados"),backgroundColor: const Color(0xff37323e),
      ),
      body: ListView.separated(
        itemCount: 50,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Paquete numero $index',style: TextStyle(fontSize: 20)),
              contentPadding: const EdgeInsets.only(left: 30.00),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: (){},
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 20,
            thickness: 5,
          );
        },
      ),
    );
  }




  Future<void> recibirPaquetes() async{

    var url = 'http://10.0.2.2:3000/paquetes';
    var response = await http.get(Uri.encodeFull(url));

    print(response.body);

    if(response.body=='exito al guardar en bd'){
    }

  }
}