import 'package:flutter/material.dart';
import 'package:madeirasestanqueiro/DatosPaqueteMedir.dart';
import 'PaquetesBajados.dart';
import 'PaquetesNoBajados.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Principal"),backgroundColor: const Color(0xff37323e),
      ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.center,
              color: Colors.white10,
              child: GridView.count(
                crossAxisCount:2,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(20.0),
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: RaisedButton(
                      child: Text('PAQUETES BAJADOS',textAlign: TextAlign.center,style: TextStyle(fontSize: 20)),textColor: const Color(0xffffffff),
                      color: const Color(0xff37323e),
                      onPressed: () {
                        // Navigate to the second screen using a named route.
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaquetesBajados(),
                            ));
                      },
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: RaisedButton(
                      child: Text('MEDIR PAQUETES',textAlign: TextAlign.center,style: TextStyle(fontSize: 20)),textColor: const Color(0xffffffff),
                      color: const Color(0xff37323e),
                      onPressed: () {
                        // Navigate to the second screen using a named route.
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DatosPaqueteMedir(),
                            ));
                      },
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: RaisedButton(
                      child: Text('PAQUETES NO BAJADOS',textAlign: TextAlign.center,style: TextStyle(fontSize: 20)),textColor: const Color(0xffffffff),
                      color: const Color(0xff37323e),
                      onPressed: () {
                        // Navigate to the second screen using a named route.
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaquetesNoBajados(),
                            ));
                      },
                    ),
                  )

                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}